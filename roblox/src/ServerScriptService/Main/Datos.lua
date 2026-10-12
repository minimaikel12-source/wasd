--[[
	Datos — perfiles de jugador, leaderstats y guardado con DataStoreService.
	Guarda: Fuerza, habilidades desbloqueadas, club (id, compañero, fecha de inicio), duelos ganados.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Config)

local Datos = {}
Datos.Perfiles = {} -- [Player] = perfil
Datos.AlCargar = {} -- callbacks(player, perfil)
Datos.AlCambiarFuerza = {} -- callbacks(player, nueva, anterior)

local store
do
	local ok, resultado = pcall(function()
		return DataStoreService:GetDataStore(Config.Guardado.NombreDataStore)
	end)
	if ok then
		store = resultado
	else
		warn("[Datos] DataStore no disponible (¿Studio sin 'Enable Studio Access to API Services'?):", resultado)
	end
end

local function clave(userId)
	return "Jugador_" .. tostring(userId)
end

local function perfilPorDefecto()
	return {
		Fuerza = 0,
		Habilidades = {},
		Club = nil, -- { Id, CompaneroId, CompaneroNombre, Inicio }
		DuelosGanados = 0,
	}
end

local function conReintentos(fn)
	local ultimoError
	for intento = 1, Config.Guardado.Reintentos do
		local ok, resultado = pcall(fn)
		if ok then
			return true, resultado
		end
		ultimoError = resultado
		task.wait(intento)
	end
	return false, ultimoError
end

-- Lee el registro guardado de cualquier usuario (sirve para comprobar al compañero de club).
function Datos.LeerGuardado(userId)
	if not store then
		return false, nil
	end
	return conReintentos(function()
		return store:GetAsync(clave(userId))
	end)
end

function Datos.Sincronizar(player)
	local perfil = Datos.Perfiles[player]
	if not perfil then
		return
	end
	local ls = player:FindFirstChild("leaderstats")
	if ls and ls:FindFirstChild("Fuerza") then
		ls.Fuerza.Value = perfil.Fuerza
	end
	player:SetAttribute("Fuerza", perfil.Fuerza)
	local lista = {}
	for id in pairs(perfil.Habilidades) do
		table.insert(lista, id)
	end
	player:SetAttribute("Habilidades", HttpService:JSONEncode(lista))
	local club = perfil.Club
	player:SetAttribute("ClubCompaneroId", club and club.CompaneroId or 0)
	player:SetAttribute("ClubCompaneroNombre", club and club.CompaneroNombre or "")
	player:SetAttribute("ClubInicio", club and club.Inicio or 0)
	player:SetAttribute("DuelosGanados", perfil.DuelosGanados)
end

function Datos.SumarFuerza(player, cantidad)
	local perfil = Datos.Perfiles[player]
	if not perfil or cantidad == 0 then
		return
	end
	local anterior = perfil.Fuerza
	perfil.Fuerza = math.max(0, math.floor(anterior + cantidad))
	Datos.Sincronizar(player)
	for _, cb in ipairs(Datos.AlCambiarFuerza) do
		task.spawn(cb, player, perfil.Fuerza, anterior)
	end
end

function Datos.FijarFuerza(player, valor)
	local perfil = Datos.Perfiles[player]
	if perfil then
		Datos.SumarFuerza(player, valor - perfil.Fuerza)
	end
end

function Datos.Guardar(player)
	local perfil = Datos.Perfiles[player]
	if not perfil or not store then
		return
	end
	if not perfil.Cargado then
		-- La carga falló: NO sobrescribimos para no borrar el progreso real.
		warn("[Datos] No se guarda a", player.Name, "porque su carga falló.")
		return
	end
	local copia = {
		Fuerza = perfil.Fuerza,
		Habilidades = perfil.Habilidades,
		Club = perfil.Club,
		DuelosGanados = perfil.DuelosGanados,
		Version = 1,
	}
	local ok, err = conReintentos(function()
		store:SetAsync(clave(player.UserId), copia, { player.UserId })
	end)
	if not ok then
		warn("[Datos] Error guardando a", player.Name, err)
	end
end

local function crearLeaderstats(player)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local fuerza = Instance.new("IntValue")
	fuerza.Name = "Fuerza"
	fuerza.Parent = ls
	ls.Parent = player
end

local function alEntrar(player)
	crearLeaderstats(player)
	local perfil = perfilPorDefecto()
	perfil.Cargado = store == nil -- sin DataStore (Studio) jugamos en memoria
	if store then
		local ok, guardado = conReintentos(function()
			return store:GetAsync(clave(player.UserId))
		end)
		if ok then
			perfil.Cargado = true
			if type(guardado) == "table" then
				perfil.Fuerza = tonumber(guardado.Fuerza) or 0
				perfil.Habilidades = type(guardado.Habilidades) == "table" and guardado.Habilidades or {}
				perfil.Club = type(guardado.Club) == "table" and guardado.Club or nil
				perfil.DuelosGanados = tonumber(guardado.DuelosGanados) or 0
			end
		else
			warn("[Datos] No se pudo cargar a", player.Name, guardado)
		end
	end
	if not player.Parent then
		return
	end
	Datos.Perfiles[player] = perfil
	Datos.Sincronizar(player)
	player:SetAttribute("DatosCargados", true)
	for _, cb in ipairs(Datos.AlCargar) do
		task.spawn(cb, player, perfil)
	end
end

function Datos.Iniciar()
	Players.PlayerAdded:Connect(alEntrar)
	for _, p in ipairs(Players:GetPlayers()) do
		task.spawn(alEntrar, p)
	end
	Players.PlayerRemoving:Connect(function(player)
		Datos.Guardar(player)
		Datos.Perfiles[player] = nil
	end)
	-- Autoguardado
	task.spawn(function()
		while true do
			task.wait(Config.Guardado.IntervaloAutoguardado)
			for player in pairs(Datos.Perfiles) do
				task.spawn(Datos.Guardar, player)
			end
		end
	end)
	-- Al cerrar el servidor
	game:BindToClose(function()
		local pendientes = 0
		for player in pairs(Datos.Perfiles) do
			pendientes += 1
			task.spawn(function()
				Datos.Guardar(player)
				pendientes -= 1
			end)
		end
		local limite = os.clock() + 25
		while pendientes > 0 and os.clock() < limite do
			task.wait(0.1)
		end
	end)
end

return Datos
