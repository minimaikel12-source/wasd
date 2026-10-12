--[[
	Client — punto de entrada del cliente.
	Módulos hijos: UI, Efectos, Ambiente, Mentoria, Duelo.
	El cliente solo PIDE acciones; el servidor valida y decide.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local AnimPlayer = require(ReplicatedStorage:WaitForChild("AnimPlayer"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local UI = require(script:WaitForChild("UI"))
local Efectos = require(script:WaitForChild("Efectos"))
require(script:WaitForChild("Ambiente"))
local Mentoria = require(script:WaitForChild("Mentoria"))
local Duelo = require(script:WaitForChild("Duelo"))

local jugador = Players.LocalPlayer
local desbloqueadas = {}

---------------------------------------------------------------- estado / stats
local function actualizarFuerza()
	UI.ActualizarFuerza(jugador:GetAttribute("Fuerza") or 0)
end

local function actualizarHabilidades()
	local ok, lista = pcall(HttpService.JSONDecode, HttpService, jugador:GetAttribute("Habilidades") or "[]")
	desbloqueadas = {}
	if ok and type(lista) == "table" then
		for _, id in ipairs(lista) do
			desbloqueadas[id] = true
		end
	end
	UI.ActualizarHabilidades(desbloqueadas)
end

jugador:GetAttributeChangedSignal("Fuerza"):Connect(actualizarFuerza)
jugador:GetAttributeChangedSignal("Habilidades"):Connect(actualizarHabilidades)
actualizarFuerza()
actualizarHabilidades()

---------------------------------------------------------------- acciones de UI
UI.Acciones.Invitar = function(userId)
	Remotes.ClubInvitar:FireServer(userId)
end
UI.Acciones.Salir = function()
	Remotes.ClubSalir:FireServer()
end
UI.Acciones.Retar = function()
	Remotes.DueloSolicitar:FireServer()
end
UI.Acciones.PedirEstado = function()
	local ok, estado = pcall(Remotes.ObtenerEstado.InvokeServer, Remotes.ObtenerEstado)
	return ok and estado or nil
end

---------------------------------------------------------------- notificaciones
Remotes.Notificar.OnClientEvent:Connect(function(d)
	if d.Tipo == "Ganancia" then
		UI.Ganancia(d.Cantidad, d.Bonus, d.Texto)
	elseif d.Tipo == "Mensaje" then
		UI.Mensaje(d.Texto, d.Color)
	elseif d.Tipo == "Desbloqueo" then
		UI.Desbloqueo(d.Nombre, d.Tecla)
		Efectos.Temblor(0.8, 1)
	elseif d.Tipo == "Club" then
		UI.Mensaje(d.Texto, Color3.fromRGB(140, 190, 255))
		UI.RefrescarClub()
	end
end)

Remotes.ClubInvitacion.OnClientEvent:Connect(function(d)
	UI.Pregunta("👥 INVITACIÓN A CLUB", ("%s (Fuerza %d) te invita a su club."):format(d.DeNombre, d.DeFuerza), d.Tiempo,
		Color3.fromRGB(110, 170, 255), function(si)
			Remotes.ClubResponder:FireServer(si)
		end)
end)

Remotes.Efecto.OnClientEvent:Connect(Efectos.Procesar)
Remotes.Empuje.OnClientEvent:Connect(function(vel)
	if typeof(vel) == "Vector3" then
		Efectos.Empuje(vel)
	end
end)

---------------------------------------------------------------- animaciones remotas
local manejadores = setmetatable({}, { __mode = "k" }) -- [personaje] = { [nombre] = controlador }

Remotes.Anim.OnClientEvent:Connect(function(personaje, nombre, opciones)
	if not personaje then
		return
	end
	opciones = opciones or {}
	manejadores[personaje] = manejadores[personaje] or {}
	if opciones.Detener then
		if nombre then
			local c = manejadores[personaje][nombre]
			if c then
				c.Detener()
				manejadores[personaje][nombre] = nil
			end
		else
			AnimPlayer.DetenerTodo(personaje)
			manejadores[personaje] = {}
		end
		return
	end
	-- Con ID publicado, la animación de OTRO jugador ya nos llega replicada desde su Animator.
	if personaje ~= jugador.Character and AnimPlayer.TieneID(nombre) then
		return
	end
	manejadores[personaje][nombre] = AnimPlayer.Reproducir(personaje, nombre, opciones)
end)

---------------------------------------------------------------- habilidades
local cooldownLocal = {}

local function usarHabilidad(h)
	if Duelo.EnDuelo() and not Config.HabilidadesEnDuelo then
		return
	end
	if not desbloqueadas[h.Id] then
		UI.Mensaje(("%s se desbloquea con %d de Fuerza"):format(h.Nombre, h.Fuerza), Color3.fromRGB(255, 180, 90))
		return
	end
	local ahora = os.clock()
	if (cooldownLocal[h.Id] or 0) > ahora then
		return
	end
	local personaje = jugador.Character
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
	if not raiz or not humanoid or humanoid.Health <= 0 then
		return
	end
	cooldownLocal[h.Id] = ahora + h.Cooldown
	UI.Cooldown(h.Id, h.Cooldown)
	AnimPlayer.Reproducir(personaje, h.Anim)
	Remotes.UsarHabilidad:FireServer(h.Id)

	-- Movimiento propio (el cliente es dueño de su física)
	if h.Efecto == "Embestida" then
		task.delay(h.Retraso - 0.05, function()
			local r = personaje:FindFirstChild("HumanoidRootPart")
			if r then
				Efectos.Dash(r.CFrame.LookVector, h.Distancia / h.DuracionDash, h.DuracionDash)
			end
		end)
	elseif h.Efecto == "Sismo" then
		task.delay(0.25, function()
			Efectos.Dash(raiz.CFrame.LookVector * 0.35 + Vector3.new(0, 1, 0), h.AlturaSalto, 0.3)
		end)
		task.delay(h.Retraso - 0.22, function()
			Efectos.Dash(Vector3.new(0, -1, 0), 160, 0.2)
		end)
	elseif h.Efecto == "Titan" then
		task.delay(1.0, function()
			Efectos.Dash(Vector3.new(0, 1, 0), 30, 0.25)
		end)
	end
end

local porTecla = {}
for _, h in ipairs(Config.Habilidades) do
	porTecla[h.Tecla] = h
end

-- Si hay un ProximityPrompt visible con esa tecla (p.ej. E en las pesas), manda el prompt.
local promptsVisibles = {}
local ProximityPromptService = game:GetService("ProximityPromptService")
ProximityPromptService.PromptShown:Connect(function(p)
	promptsVisibles[p] = true
end)
ProximityPromptService.PromptHidden:Connect(function(p)
	promptsVisibles[p] = nil
end)

UserInputService.InputBegan:Connect(function(entrada, procesado)
	if procesado or Duelo.EnDuelo() then
		return
	end
	for p in pairs(promptsVisibles) do
		if p.KeyboardKeyCode == entrada.KeyCode then
			return
		end
	end
	local h = porTecla[entrada.KeyCode.Name]
	if h then
		usarHabilidad(h)
	end
end)

---------------------------------------------------------------- barras de vida de los muñecos
local function barraMuneco(m)
	local cuerpo = m:WaitForChild("Cuerpo", 10)
	if not cuerpo then
		return
	end
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromOffset(120, 14)
	bb.StudsOffset = Vector3.new(0, 4.2, 0)
	bb.Adornee = cuerpo
	bb.MaxDistance = 80
	local fondo = Instance.new("Frame")
	fondo.Size = UDim2.fromScale(1, 1)
	fondo.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
	fondo.Parent = bb
	local relleno = Instance.new("Frame")
	relleno.Size = UDim2.fromScale(1, 1)
	relleno.BackgroundColor3 = Color3.fromRGB(230, 70, 60)
	relleno.BorderSizePixel = 0
	relleno.Parent = fondo
	bb.Parent = cuerpo
	local function act()
		local v, max = m:GetAttribute("Vida") or 0, m:GetAttribute("VidaMax") or 1
		relleno.Size = UDim2.fromScale(math.clamp(v / max, 0, 1), 1)
		bb.Enabled = v > 0
	end
	m:GetAttributeChangedSignal("Vida"):Connect(act)
	act()
end
task.spawn(function()
	local zona = Workspace:WaitForChild("Entrenamiento", 30)
	local carpeta = zona and zona:WaitForChild("Munecos", 10)
	if carpeta then
		for _, m in ipairs(carpeta:GetChildren()) do
			task.spawn(barraMuneco, m)
		end
	end
end)

---------------------------------------------------------------- comandos de prueba (Studio)
if Config.Debug.ComandosEnStudio and RunService:IsStudio() then
	local TextChatService = game:GetService("TextChatService")
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		for _, nombre in ipairs({ "fuerza", "dias", "duelo" }) do
			local cmd = Instance.new("TextChatCommand")
			cmd.Name = "Debug_" .. nombre
			cmd.PrimaryAlias = "/" .. nombre
			cmd.Triggered:Connect(function(_, texto)
				Remotes.ComandoDebug:FireServer(texto)
			end)
			cmd.Parent = TextChatService
		end
	end
end

Mentoria.Iniciar()
Duelo.Iniciar()
