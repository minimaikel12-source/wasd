--[[
	Clubs — clubs de 2 jugadores (mentor + aprendiz).
	 • Invitar / Aceptar / Rechazar / Salir (validado en servidor).
	 • Mentor = el más fuerte en cada momento (se calcula, no se fija).
	 • Bonus de entrenamiento para el aprendiz cerca de su mentor.
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Config)
local Datos = require(script.Parent.Datos)
local Red = require(script.Parent.Red)

local Clubs = {}
local pendientes = {} -- [invitado] = { De = player, Expira = os.clock() }
local ultimaInvitacion = {} -- anti-spam [player] = os.clock()

local VERDE = Color3.fromRGB(110, 255, 140)
local ROJO = Color3.fromRGB(255, 100, 100)

function Clubs.Companero(player)
	local perfil = Datos.Perfiles[player]
	if not perfil or not perfil.Club then
		return nil
	end
	local otro = Players:GetPlayerByUserId(perfil.Club.CompaneroId)
	if otro and Datos.Perfiles[otro] and Datos.Perfiles[otro].Club and Datos.Perfiles[otro].Club.Id == perfil.Club.Id then
		return otro
	end
	return nil
end

function Clubs.DiasEnClub(player)
	local perfil = Datos.Perfiles[player]
	if not perfil or not perfil.Club then
		return 0
	end
	return (os.time() - (perfil.Club.Inicio or os.time())) / Config.Mentoria.SegundosPorDia
end

-- Multiplicador para el aprendiz que entrena cerca de su mentor (más fuerte).
function Clubs.MultiplicadorEntreno(player)
	local otro = Clubs.Companero(player)
	if not otro then
		return 1, nil
	end
	local yo, el = Datos.Perfiles[player], Datos.Perfiles[otro]
	if el.Fuerza <= yo.Fuerza then
		return 1, nil
	end
	local a, b = Red.Raiz(player), Red.Raiz(otro)
	if a and b and (a.Position - b.Position).Magnitude <= Config.Mentoria.DistanciaBonus then
		return Config.Mentoria.BonusAprendiz, otro
	end
	return 1, nil
end

local function fijarClub(player, club)
	local perfil = Datos.Perfiles[player]
	if perfil then
		perfil.Club = club
		Datos.Sincronizar(player)
	end
end

local function invitar(player, objetivoId)
	if type(objetivoId) ~= "number" then
		return
	end
	local objetivo = Players:GetPlayerByUserId(objetivoId)
	local yo = Datos.Perfiles[player]
	if not objetivo or objetivo == player or not yo then
		return
	end
	local el = Datos.Perfiles[objetivo]
	if not el then
		return
	end
	if os.clock() - (ultimaInvitacion[player] or 0) < 3 then
		return
	end
	ultimaInvitacion[player] = os.clock()
	if yo.Club then
		return Red.Mensaje(player, "Ya estás en un club. Sal primero para invitar a otro.", ROJO)
	end
	if el.Club then
		return Red.Mensaje(player, objetivo.DisplayName .. " ya está en un club.", ROJO)
	end
	local p = pendientes[objetivo]
	if p and p.Expira > os.clock() then
		return Red.Mensaje(player, objetivo.DisplayName .. " tiene otra invitación pendiente.", ROJO)
	end
	pendientes[objetivo] = { De = player, Expira = os.clock() + Config.Mentoria.TiempoInvitacion }
	Red.Remotes.ClubInvitacion:FireClient(objetivo, {
		DeNombre = player.DisplayName,
		DeId = player.UserId,
		DeFuerza = yo.Fuerza,
		Tiempo = Config.Mentoria.TiempoInvitacion,
	})
	Red.Mensaje(player, "Invitación enviada a " .. objetivo.DisplayName, VERDE)
end

local function responder(player, aceptar)
	local p = pendientes[player]
	pendientes[player] = nil
	if not p or p.Expira < os.clock() then
		return
	end
	local otro = p.De
	if not otro.Parent then
		return Red.Mensaje(player, "Quien te invitó ya no está.", ROJO)
	end
	if not aceptar then
		return Red.Mensaje(otro, player.DisplayName .. " rechazó tu invitación.", ROJO)
	end
	local a, b = Datos.Perfiles[player], Datos.Perfiles[otro]
	if not a or not b or a.Club or b.Club then
		return Red.Mensaje(player, "No se pudo crear el club.", ROJO)
	end
	local id = HttpService:GenerateGUID(false)
	local inicio = os.time()
	fijarClub(player, { Id = id, CompaneroId = otro.UserId, CompaneroNombre = otro.DisplayName, Inicio = inicio })
	fijarClub(otro, { Id = id, CompaneroId = player.UserId, CompaneroNombre = player.DisplayName, Inicio = inicio })
	for _, j in ipairs({ player, otro }) do
		Red.Notificar(j, "Club", { Texto = "¡Club formado! Entrenad juntos." })
		task.spawn(Datos.Guardar, j)
	end
end

function Clubs.Salir(player)
	local perfil = Datos.Perfiles[player]
	if not perfil or not perfil.Club or player:GetAttribute("EnDuelo") then
		return
	end
	local otro = Clubs.Companero(player)
	fijarClub(player, nil)
	Red.Notificar(player, "Club", { Texto = "Has salido del club." })
	task.spawn(Datos.Guardar, player)
	if otro then
		fijarClub(otro, nil)
		Red.Notificar(otro, "Club", { Texto = player.DisplayName .. " ha dejado el club." })
		task.spawn(Datos.Guardar, otro)
	end
	-- Si el compañero está desconectado, al volver comprobará que el club ya no existe.
end

-- Al entrar: comprobar que el club guardado sigue siendo válido en ambos lados.
local function verificarClub(player, perfil)
	local club = perfil.Club
	if not club then
		return
	end
	local otro = Players:GetPlayerByUserId(club.CompaneroId)
	local valido
	if otro and Datos.Perfiles[otro] then
		local suyo = Datos.Perfiles[otro].Club
		valido = suyo ~= nil and suyo.Id == club.Id
	else
		local ok, guardado = Datos.LeerGuardado(club.CompaneroId)
		if not ok then
			return -- no sabemos: no tocamos nada
		end
		valido = type(guardado) == "table" and type(guardado.Club) == "table" and guardado.Club.Id == club.Id
	end
	if not valido and player.Parent then
		fijarClub(player, nil)
		Red.Notificar(player, "Club", { Texto = "Tu club se disolvió mientras no estabas." })
	end
end

-- Estado para la UI (RemoteFunction ObtenerEstado).
function Clubs.Estado(player, Duelo)
	local perfil = Datos.Perfiles[player]
	if not perfil then
		return nil
	end
	local estado = { Fuerza = perfil.Fuerza }
	if perfil.Club then
		local otro = Clubs.Companero(player)
		local dias = Clubs.DiasEnClub(player)
		estado.Club = {
			CompaneroNombre = perfil.Club.CompaneroNombre,
			CompaneroId = perfil.Club.CompaneroId,
			Dias = dias,
			DiasMinimos = Config.Duelo.DiasMinimos,
			EnServidor = otro ~= nil,
			FuerzaCompanero = otro and Datos.Perfiles[otro].Fuerza or nil,
		}
		if Duelo then
			local ok, motivo = Duelo.Elegible(player)
			estado.Club.DueloDisponible = ok
			estado.Club.MotivoDuelo = motivo
		end
	end
	return estado
end

function Clubs.Iniciar()
	table.insert(Datos.AlCargar, verificarClub)
	Red.Remotes.ClubInvitar.OnServerEvent:Connect(invitar)
	Red.Remotes.ClubResponder.OnServerEvent:Connect(function(player, aceptar)
		responder(player, aceptar == true)
	end)
	Red.Remotes.ClubSalir.OnServerEvent:Connect(Clubs.Salir)
	Players.PlayerRemoving:Connect(function(p)
		pendientes[p] = nil
		ultimaInvitacion[p] = nil
	end)
end

return Clubs
