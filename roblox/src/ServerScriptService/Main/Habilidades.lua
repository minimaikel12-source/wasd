--[[
	Habilidades — desbloqueo automático por fuerza y ejecución validada en servidor
	(desbloqueo, cooldown, alcance y daño). Fuera del duelo solo dañan a los muñecos.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Config)
local Datos = require(script.Parent.Datos)
local Red = require(script.Parent.Red)
local Entrenamiento = require(script.Parent.Entrenamiento)

local Habilidades = {}
local cooldowns = {} -- [player] = { [id] = os.clock() de fin }

local function comprobarDesbloqueos(player, avisar)
	local perfil = Datos.Perfiles[player]
	if not perfil then
		return
	end
	local nuevas = {}
	for _, h in ipairs(Config.Habilidades) do
		if perfil.Fuerza >= h.Fuerza and not perfil.Habilidades[h.Id] then
			perfil.Habilidades[h.Id] = true
			table.insert(nuevas, h)
		end
	end
	if #nuevas > 0 then
		Datos.Sincronizar(player)
		if avisar then
			for i, h in ipairs(nuevas) do
				task.delay((i - 1) * 3.2, function()
					if player.Parent then
						Red.Notificar(player, "Desbloqueo", { Id = h.Id, Nombre = h.Nombre, Tecla = h.Tecla })
					end
				end)
			end
		end
	end
end

-- Objetivos en un radio/caja. filtro(pos) -> bool
local function objetivosEn(atacante, filtro)
	local lista = {}
	for _, m in ipairs(Entrenamiento.ObtenerMunecos()) do
		local pos = Entrenamiento.PosicionMuneco(m)
		if pos and (m:GetAttribute("Vida") or 0) > 0 and filtro(pos) then
			table.insert(lista, { Muneco = m, Pos = pos })
		end
	end
	return lista
end

local function enCaja(raizCF, alcance, ancho)
	return function(pos)
		local rel = raizCF:PointToObjectSpace(pos)
		return -rel.Z >= -1.5 and -rel.Z <= alcance + 1.5 and math.abs(rel.X) <= ancho / 2 and math.abs(rel.Y) <= 8
	end
end

local function enRadio(centro, radio)
	return function(pos)
		return (pos - centro).Magnitude <= radio + 2
	end
end

local function aplicar(player, h, lista, origen)
	for _, o in ipairs(lista) do
		Entrenamiento.DanarMuneco(o.Muneco, h.Dano, player)
		Red.Efecto({ Tipo = "Impacto", Pos = o.Pos, Fuerza = h.Temblor, Dir = (o.Pos - origen).Unit })
	end
end

local function ejecutar(player, h)
	local raiz = Red.Raiz(player)
	if not raiz then
		return
	end
	if h.Efecto == "Embestida" then
		-- Muestreamos la trayectoria mientras dura el dash (el cliente mueve su propio personaje).
		local golpeados = {}
		local inicio = os.clock()
		while os.clock() - inicio < h.DuracionDash + 0.1 do
			raiz = Red.Raiz(player)
			if not raiz then
				return
			end
			local lista = objetivosEn(player, enRadio(raiz.Position, h.Alcance))
			local nuevos = {}
			for _, o in ipairs(lista) do
				if not golpeados[o.Muneco] then
					golpeados[o.Muneco] = true
					table.insert(nuevos, o)
				end
			end
			aplicar(player, h, nuevos, raiz.Position)
			task.wait(0.05)
		end
		Red.Efecto({ Tipo = "Embestida", Pos = raiz.Position, Radio = h.Alcance, Origen = player, Fuerza = h.Temblor })
		return
	end
	local cf = raiz.CFrame
	local pos = raiz.Position
	local filtro
	if h.Efecto == "Golpe" then
		filtro = enCaja(cf, h.Alcance, 7)
	else
		filtro = enRadio(pos, h.Alcance)
	end
	-- Posición del suelo para efectos de impacto
	local suelo = pos - Vector3.new(0, 3, 0)
	Red.Efecto({
		Tipo = h.Efecto,
		Pos = h.Efecto == "Golpe" and (cf * CFrame.new(0, 0, -4)).Position or suelo,
		Dir = cf.LookVector,
		Radio = h.Alcance,
		Fuerza = h.Temblor,
		Origen = player,
	})
	aplicar(player, h, objetivosEn(player, filtro), pos)
end

local function alUsar(player, id)
	if type(id) ~= "string" then
		return
	end
	local h = Config.ObtenerHabilidad(id)
	local perfil = Datos.Perfiles[player]
	if not h or not perfil or not perfil.Habilidades[id] then
		return
	end
	if player:GetAttribute("EnDuelo") and not Config.HabilidadesEnDuelo then
		return
	end
	if not Red.Raiz(player) then
		return
	end
	cooldowns[player] = cooldowns[player] or {}
	local ahora = os.clock()
	-- pequeña tolerancia por latencia
	if (cooldowns[player][id] or 0) - 0.15 > ahora then
		return
	end
	cooldowns[player][id] = ahora + h.Cooldown
	Red.AnimOtros(player, h.Anim)
	Red.Efecto({ Tipo = "Carga", Origen = player, Id = id })
	task.delay(h.Retraso, ejecutar, player, h)
end

function Habilidades.Iniciar()
	table.insert(Datos.AlCargar, function(player)
		comprobarDesbloqueos(player, false)
	end)
	table.insert(Datos.AlCambiarFuerza, function(player)
		comprobarDesbloqueos(player, true)
	end)
	Red.Remotes.UsarHabilidad.OnServerEvent:Connect(alUsar)
	Players.PlayerRemoving:Connect(function(p)
		cooldowns[p] = nil
	end)
end

return Habilidades
