--[[
	Main — punto de entrada del servidor.
	Módulos hijos: Datos, Red, Entrenamiento, Habilidades, Clubs, Duelo.
	El cliente SOLO pide acciones por Remotes; todo se valida aquí.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local Datos = require(script.Datos)
local Red = require(script.Red)
local Entrenamiento = require(script.Entrenamiento)
local Habilidades = require(script.Habilidades)
local Clubs = require(script.Clubs)
local Duelo = require(script.Duelo)

Entrenamiento.Multiplicador = Clubs.MultiplicadorEntreno

Datos.Iniciar()
Entrenamiento.Iniciar()
Habilidades.Iniciar()
Clubs.Iniciar()
Duelo.Iniciar()

Red.Remotes.ObtenerEstado.OnServerInvoke = function(player)
	return Clubs.Estado(player, Duelo)
end

-- Comandos de prueba (solo en Studio) ---------------------------------------
if Config.Debug.ComandosEnStudio and RunService:IsStudio() then
	local function alChatear(player, mensaje)
		local cmd, arg = mensaje:match("^/(%a+)%s*(%-?[%d%.]*)")
		if not cmd then
			return
		end
		cmd = cmd:lower()
		local n = tonumber(arg)
		local perfil = Datos.Perfiles[player]
		if not perfil then
			return
		end
		if cmd == "fuerza" and n then
			Datos.FijarFuerza(player, n)
			Red.Mensaje(player, "[Debug] Fuerza = " .. n)
		elseif cmd == "dias" and n and perfil.Club then
			-- Adelanta el reloj del club N días (para los dos miembros)
			local desplazamiento = math.floor(n * Config.Mentoria.SegundosPorDia)
			perfil.Club.Inicio -= desplazamiento
			Datos.Sincronizar(player)
			local otro = Clubs.Companero(player)
			if otro then
				Datos.Perfiles[otro].Club.Inicio = perfil.Club.Inicio
				Datos.Sincronizar(otro)
			end
			Red.Mensaje(player, ("[Debug] Club adelantado %s días"):format(arg))
		elseif cmd == "duelo" then
			if not Duelo.Forzar(player) then
				Red.Mensaje(player, "[Debug] Necesitas un compañero de club en el servidor.")
			end
		end
	end
	-- TextChatService: el cliente registra TextChatCommands y nos manda el texto.
	Red.Remotes.ComandoDebug.OnServerEvent:Connect(function(player, mensaje)
		if type(mensaje) == "string" then
			alChatear(player, mensaje)
		end
	end)
	local function conectar(player)
		-- Chat clásico (LegacyChatService)
		player.Chatted:Connect(function(m)
			if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.LegacyChatService then
				alChatear(player, m)
			end
		end)
	end
	Players.PlayerAdded:Connect(conectar)
	for _, p in ipairs(Players:GetPlayers()) do
		conectar(p)
	end
	print("[Main] Comandos de Studio activos: /fuerza N, /dias N, /duelo")
end

print("[Main] Servidor listo.")
