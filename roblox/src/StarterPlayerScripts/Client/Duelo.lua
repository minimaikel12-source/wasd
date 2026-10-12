--[[
	Duelo (cliente) — fases que manda el servidor por Remotes.DueloEstado:
	  Intro  → ambiente de tormenta + cámara cinematográfica
	  Cuenta → 3, 2, 1
	  Lucha  → controles de espada (el servidor valida todo)
	  Fin    → cámara orbitando al ganador + pantalla de victoria/derrota
	  Salir  → restaurar ambiente, cámara e interfaz
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local AnimPlayer = require(ReplicatedStorage:WaitForChild("AnimPlayer"))
local UI = require(script.Parent.UI)
local Efectos = require(script.Parent.Efectos)
local Ambiente = require(script.Parent.Ambiente)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local C = Config.Duelo
local jugador = Players.LocalPlayer
local Duelo = {}

local fase = nil
local rival = nil
local conexiones = {}
local cerrarResultado
local camaraCine -- conexión RenderStepped de la cámara
local bloqueoAnim
local comboIdx, ultimoLigero, cdLigero, cdPesado, cdEsquiva = 0, 0, 0, 0, 0

local function camara()
	return Workspace.CurrentCamera
end

local function pararCamaraCine()
	if camaraCine then
		camaraCine:Disconnect()
		camaraCine = nil
	end
	camara().CameraType = Enum.CameraType.Custom
	local h = jugador.Character and jugador.Character:FindFirstChildOfClass("Humanoid")
	if h then
		camara().CameraSubject = h
	end
end

-- Recorrido de cámara por una lista de {CFrame, duración}
local function recorrido(planos)
	pararCamaraCine()
	local cam = camara()
	cam.CameraType = Enum.CameraType.Scriptable
	local inicio = os.clock()
	camaraCine = RunService.RenderStepped:Connect(function()
		local t = os.clock() - inicio
		for _, plano in ipairs(planos) do
			if t <= plano.Duracion then
				local alpha = TweenService:GetValue(t / plano.Duracion, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				cam.CFrame = plano.Desde:Lerp(plano.Hasta, alpha)
				cam.FieldOfView = plano.FOV or 60
				return
			end
			t -= plano.Duracion
		end
	end)
end

local function raizDe(p)
	return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

local function vidaCambiada()
	UI.Vida(true, jugador:GetAttribute("DueloVida") or 0, jugador:GetAttribute("DueloVidaMax") or C.Vida)
	if rival then
		UI.Vida(false, rival:GetAttribute("DueloVida") or 0, rival:GetAttribute("DueloVidaMax") or C.Vida)
	end
end

---------------------------------------------------------------- fases
local function intro(datos)
	rival = datos.Rival
	fase = "Intro"
	comboIdx, ultimoLigero, cdLigero, cdPesado, cdEsquiva = 0, 0, 0, 0, 0
	Ambiente.Activar()
	UI.MostrarPrincipal(false)
	UI.Cine(true)
	pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, false)
	UI.MostrarHUDDuelo(true, jugador.DisplayName, rival and rival.DisplayName or "Rival")
	table.insert(conexiones, jugador:GetAttributeChangedSignal("DueloVida"):Connect(vidaCambiada))
	if rival then
		table.insert(conexiones, rival:GetAttributeChangedSignal("DueloVida"):Connect(vidaCambiada))
	end
	vidaCambiada()

	local centro = datos.Centro
	local yoPos = (raizDe(jugador) and raizDe(jugador).Position) or centro
	local rivalPos = (raizDe(rival) and raizDe(rival).Position) or centro
	local d = datos.Duracion
	recorrido({
		{ -- gran plano aéreo girando sobre la arena
			Desde = CFrame.lookAt(centro + Vector3.new(-110, 70, -110), centro),
			Hasta = CFrame.lookAt(centro + Vector3.new(110, 45, -90), centro),
			Duracion = d * 0.45, FOV = 70,
		},
		{ -- primer plano del rival
			Desde = CFrame.lookAt(rivalPos + (yoPos - rivalPos).Unit * 9 + Vector3.new(3, 2, 0), rivalPos + Vector3.new(0, 1.5, 0)),
			Hasta = CFrame.lookAt(rivalPos + (yoPos - rivalPos).Unit * 6 + Vector3.new(1.5, 1.5, 0), rivalPos + Vector3.new(0, 1.8, 0)),
			Duracion = d * 0.3, FOV = 45,
		},
		{ -- por encima de tu hombro
			Desde = CFrame.lookAt(yoPos + Vector3.new(2, 3, 0) - (rivalPos - yoPos).Unit * 8, rivalPos),
			Hasta = CFrame.lookAt(yoPos + Vector3.new(2, 4, 0) - (rivalPos - yoPos).Unit * 12, rivalPos),
			Duracion = d * 0.25 + 1, FOV = 60,
		},
	})
end

local function cuenta(datos)
	fase = "Cuenta"
	pararCamaraCine()
	UI.Cine(false)
	for i = datos.Segundos, 1, -1 do
		UI.TextoGrande(tostring(i), Color3.new(1, 1, 1), 0.7)
		Efectos.Sonido(Config.Sonidos.Impacto, nil, 1, 0.6 + (datos.Segundos - i) * 0.1)
		task.wait(1)
		if fase ~= "Cuenta" then
			return
		end
	end
end

local function lucha()
	fase = "Lucha"
	UI.TextoGrande("¡LUCHA!", Color3.fromRGB(255, 70, 60), 0.9)
	Efectos.Temblor(0.6, 0.6)
	Efectos.Sonido(Config.Sonidos.Explosion, nil, 1.2, 0.7)
end

local function fin(datos)
	fase = "Fin"
	if bloqueoAnim then
		bloqueoAnim.Detener()
		bloqueoAnim = nil
	end
	UI.Cine(true)
	-- cámara lenta orbitando al ganador (o a ti si hay empate)
	local foco = datos.GanadorJugador or jugador
	local inicio = os.clock()
	pararCamaraCine()
	camara().CameraType = Enum.CameraType.Scriptable
	camaraCine = RunService.RenderStepped:Connect(function()
		local raiz = raizDe(foco)
		if not raiz then
			return
		end
		local t = os.clock() - inicio
		local a = t * 0.35
		local dist = 14 - math.min(t, 4) * 1.2
		local pos = raiz.Position + Vector3.new(math.cos(a) * dist, 3 + math.sin(t * 0.5), math.sin(a) * dist)
		camara().CFrame = CFrame.lookAt(pos, raiz.Position + Vector3.new(0, 1.5, 0))
		camara().FieldOfView = 50
	end)
	task.delay(1.2, function()
		if fase == "Fin" then
			cerrarResultado = UI.Resultado(datos.Gane, datos.Empate, datos.Recompensa, datos.Ganador)
		end
	end)
end

local function salir()
	fase = nil
	rival = nil
	for _, c in ipairs(conexiones) do
		c:Disconnect()
	end
	conexiones = {}
	pararCamaraCine()
	camara().FieldOfView = 70
	Ambiente.Desactivar()
	UI.Cine(false)
	UI.MostrarHUDDuelo(false)
	UI.MostrarPrincipal(true)
	if cerrarResultado then
		cerrarResultado()
		cerrarResultado = nil
	end
	pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, true)
end

---------------------------------------------------------------- controles
local function enviar(accion)
	Remotes.DueloAccion:FireServer(accion)
end

local function personaje()
	return jugador.Character
end

local function ligero()
	local ahora = os.clock()
	if ahora < cdLigero or bloqueoAnim then
		return
	end
	cdLigero = ahora + C.ComboCooldown
	comboIdx = (ahora - ultimoLigero <= C.ComboVentana) and (comboIdx % #C.Combo + 1) or 1
	ultimoLigero = ahora
	AnimPlayer.Reproducir(personaje(), "Espada_Combo" .. comboIdx)
	enviar("Ligero")
end

local function pesado()
	local ahora = os.clock()
	if ahora < cdPesado or bloqueoAnim then
		return
	end
	cdPesado = ahora + C.Pesado.Cooldown
	cdLigero = ahora + C.Pesado.Retraso
	AnimPlayer.Reproducir(personaje(), "Espada_Pesado")
	enviar("Pesado")
end

local function esquivar()
	local ahora = os.clock()
	if ahora < cdEsquiva then
		return
	end
	cdEsquiva = ahora + C.Esquiva.Cooldown
	local h = personaje() and personaje():FindFirstChildOfClass("Humanoid")
	local raiz = raizDe(jugador)
	if not h or not raiz then
		return
	end
	local dir = h.MoveDirection.Magnitude > 0.1 and h.MoveDirection.Unit or -raiz.CFrame.LookVector
	AnimPlayer.Reproducir(personaje(), "Espada_Esquiva")
	Efectos.Dash(dir, C.Esquiva.Velocidad, 0.22)
	enviar("Esquiva")
end

local function coincide(entrada, tecla)
	if type(tecla) == "table" then
		for _, t in ipairs(tecla) do
			if coincide(entrada, t) then
				return true
			end
		end
		return false
	end
	return entrada.KeyCode.Name == tecla or entrada.UserInputType.Name == tecla
end

function Duelo.Iniciar()
	Remotes.DueloEstado.OnClientEvent:Connect(function(datos)
		if datos.Fase == "Intro" then
			intro(datos)
		elseif datos.Fase == "Cuenta" then
			task.spawn(cuenta, datos)
		elseif datos.Fase == "Lucha" then
			lucha()
		elseif datos.Fase == "Fin" then
			fin(datos)
		elseif datos.Fase == "Salir" then
			salir()
		end
	end)

	Remotes.DueloInvitacion.OnClientEvent:Connect(function(datos)
		UI.Pregunta("⚔ DUELO FINAL", ("¡Tú y %s tenéis la misma fuerza! ¿Aceptas el duelo en la Arena del Juramento?"):format(datos.Rival),
			datos.Tiempo, Color3.fromRGB(255, 80, 80), function(si)
				Remotes.DueloResponder:FireServer(si)
			end)
	end)

	UserInputService.InputBegan:Connect(function(entrada, procesado)
		if fase ~= "Lucha" or procesado then
			return
		end
		if entrada.UserInputType == Enum.UserInputType.MouseButton1 or entrada.UserInputType == Enum.UserInputType.Touch then
			ligero()
		elseif coincide(entrada, Config.Teclas.DueloPesado) then
			pesado()
		elseif coincide(entrada, Config.Teclas.DueloBloqueo) then
			if not bloqueoAnim then
				bloqueoAnim = AnimPlayer.Reproducir(personaje(), "Espada_Bloqueo") or { Detener = function() end }
				enviar("BloqueoOn")
			end
		elseif coincide(entrada, Config.Teclas.DueloEsquiva) then
			esquivar()
		end
	end)
	UserInputService.InputEnded:Connect(function(entrada)
		if coincide(entrada, Config.Teclas.DueloBloqueo) and bloqueoAnim then
			bloqueoAnim.Detener()
			bloqueoAnim = nil
			enviar("BloqueoOff")
		end
	end)
end

function Duelo.EnDuelo()
	return fase ~= nil
end

return Duelo
