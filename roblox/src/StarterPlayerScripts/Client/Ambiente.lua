--[[
	Ambiente — atmósfera del duelo SOLO en este cliente:
	noche cerrada, niebla densa, nubes negras, lluvia sobre la cámara, salpicaduras,
	relámpagos con destello + trueno y música épica. Al salir se restaura todo.
]]

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local Efectos = require(script.Parent.Efectos)

local A = Config.Ambiente
local Ambiente = {}

local activo = false
local guardado -- propiedades originales de Lighting
local ocultos = {} -- efectos/cielos originales que desactivamos
local creados = {} -- instancias que creamos
local conexiones = {}

local PROPS = { "ClockTime", "Brightness", "Ambient", "OutdoorAmbient", "FogColor", "FogStart", "FogEnd",
	"ExposureCompensation", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "GlobalShadows" }

local function crear(clase, props, padre)
	local i = Instance.new(clase)
	for k, v in pairs(props) do
		i[k] = v
	end
	i.Parent = padre
	table.insert(creados, i)
	return i
end

local function sonidoLocal(id, volumen, bucle, velocidad)
	if not id or id == "" then
		return nil
	end
	return crear("Sound", { SoundId = id, Volume = volumen, Looped = bucle, PlaybackSpeed = velocidad or 1 }, Workspace.CurrentCamera)
end

local function trueno(retraso)
	task.delay(retraso, function()
		if not activo then
			return
		end
		local s
		if Config.Sonidos.Trueno ~= "" then
			s = Instance.new("Sound")
			s.SoundId = Config.Sonidos.Trueno
			s.Volume = 2
		else
			-- respaldo: explosión grave y lenta
			s = Instance.new("Sound")
			s.SoundId = Config.Sonidos.Explosion
			s.Volume = 1.6
			s.PlaybackSpeed = 0.28
		end
		s.Parent = Workspace.CurrentCamera
		s:Play()
		game:GetService("Debris"):AddItem(s, 8)
		Efectos.Temblor(0.25, 1.2)
	end)
end

local function relampago()
	local cam = Workspace.CurrentCamera
	local base = cam.CFrame.Position
	local destino = base + Vector3.new(math.random(-160, 160), -10, math.random(-160, 160))
	Efectos.Rayo(destino, Color3.fromRGB(220, 230, 255))
	-- destello de luz global
	local brillo = Lighting.Brightness
	Lighting.Brightness = 4
	Lighting.Ambient = Color3.fromRGB(150, 160, 200)
	Efectos.FlashPantalla(Color3.fromRGB(200, 210, 255), 0.5)
	task.delay(0.08, function()
		if activo then
			Lighting.Brightness = brillo
			Lighting.Ambient = Config.Color(A.Ambient)
		end
	end)
	task.delay(0.16, function() -- doble parpadeo
		if activo then
			Lighting.Brightness = 2.5
			task.wait(0.06)
			if activo then
				Lighting.Brightness = brillo
			end
		end
	end)
	trueno(0.4 + math.random() * 1.2)
end

local function crearLluvia()
	local caja = crear("Part", {
		Name = "Lluvia", Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false,
		Transparency = 1, Size = Vector3.new(140, 1, 140),
	}, Efectos.Carpeta)
	crear("ParticleEmitter", {
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Color = ColorSequence.new(Color3.fromRGB(170, 185, 210)),
		LightEmission = 0.3,
		Transparency = NumberSequence.new(0.35),
		Size = NumberSequence.new(0.12),
		Squash = NumberSequence.new(3),
		Orientation = Enum.ParticleOrientation.VelocityParallel,
		Lifetime = NumberRange.new(0.9, 1.1),
		Speed = NumberRange.new(90, 110),
		Acceleration = Vector3.new(4, 0, 2),
		EmissionDirection = Enum.NormalId.Bottom,
		SpreadAngle = Vector2.new(3, 3),
		Rate = A.LluviaRate,
	}, caja)
	-- salpicaduras en el suelo alrededor del jugador
	local suelo = crear("Part", {
		Name = "Salpicaduras", Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false,
		Transparency = 1, Size = Vector3.new(60, 0.2, 60),
	}, Efectos.Carpeta)
	crear("ParticleEmitter", {
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Color = ColorSequence.new(Color3.fromRGB(190, 200, 220)),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) }),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.35) }),
		Lifetime = NumberRange.new(0.15, 0.25),
		Speed = NumberRange.new(4, 7),
		SpreadAngle = Vector2.new(60, 60),
		EmissionDirection = Enum.NormalId.Top,
		Acceleration = Vector3.new(0, -30, 0),
		Rate = 250,
	}, suelo)
	table.insert(conexiones, RunService.RenderStepped:Connect(function()
		local p = Workspace.CurrentCamera.CFrame.Position
		caja.CFrame = CFrame.new(p + Vector3.new(0, 60, 0))
		local personaje = game:GetService("Players").LocalPlayer.Character
		local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
		if raiz then
			suelo.CFrame = CFrame.new(raiz.Position.X, raiz.Position.Y - 2.9, raiz.Position.Z)
		end
	end))
end

function Ambiente.Activar()
	if activo then
		return
	end
	activo = true
	guardado = {}
	for _, prop in ipairs(PROPS) do
		guardado[prop] = Lighting[prop]
	end
	-- Desactivar cielos/atmósferas/efectos existentes (se restauran luego)
	for _, hijo in ipairs(Lighting:GetChildren()) do
		if hijo:IsA("Sky") or hijo:IsA("Atmosphere") then
			table.insert(ocultos, { Instancia = hijo, Padre = hijo.Parent })
			hijo.Parent = nil
		elseif hijo:IsA("PostEffect") and hijo.Enabled then
			table.insert(ocultos, { Instancia = hijo, Enabled = true })
			hijo.Enabled = false
		end
	end
	local nubesOriginales = Workspace.Terrain:FindFirstChildOfClass("Clouds")
	if nubesOriginales then
		table.insert(ocultos, { Instancia = nubesOriginales, Padre = Workspace.Terrain })
		nubesOriginales.Parent = nil
	end

	Lighting.ClockTime = A.ClockTime
	Lighting.Brightness = A.Brightness
	Lighting.Ambient = Config.Color(A.Ambient)
	Lighting.OutdoorAmbient = Config.Color(A.OutdoorAmbient)
	Lighting.FogColor = Config.Color(A.FogColor)
	Lighting.FogStart = A.FogStart
	Lighting.FogEnd = A.FogEnd
	Lighting.ExposureCompensation = -0.3
	Lighting.EnvironmentDiffuseScale = 0.3
	Lighting.EnvironmentSpecularScale = 1
	Lighting.GlobalShadows = true

	crear("Sky", { CelestialBodiesShown = false, StarCount = 0 }, Lighting)
	crear("Atmosphere", {
		Density = A.DensidadAtmosfera, Offset = 0.1, Haze = 3, Glare = 0,
		Color = Color3.fromRGB(60, 65, 80), Decay = Color3.fromRGB(25, 25, 35),
	}, Lighting)
	crear("ColorCorrectionEffect", { Contrast = 0.2, Saturation = -0.45, TintColor = Color3.fromRGB(200, 210, 235) }, Lighting)
	crear("BloomEffect", { Intensity = 0.8, Size = 30, Threshold = 1.2 }, Lighting)
	crear("Clouds", { Cover = 0.95, Density = 0.9, Color = Color3.fromRGB(40, 42, 50) }, Workspace.Terrain)

	crearLluvia()

	local lluvia = sonidoLocal(Config.Sonidos.Lluvia, 0.6, true)
	if lluvia then
		lluvia:Play()
	end
	local musica = sonidoLocal(Config.Sonidos.MusicaDuelo, 0.8, true)
	if musica then
		musica:Play()
	end

	task.spawn(function()
		task.wait(1)
		while activo do
			relampago()
			task.wait(math.random(A.Relampago.Min * 10, A.Relampago.Max * 10) / 10)
		end
	end)
end

function Ambiente.Desactivar()
	if not activo then
		return
	end
	activo = false
	for _, c in ipairs(conexiones) do
		c:Disconnect()
	end
	conexiones = {}
	for _, i in ipairs(creados) do
		i:Destroy()
	end
	creados = {}
	for prop, valor in pairs(guardado) do
		Lighting[prop] = valor
	end
	for _, o in ipairs(ocultos) do
		if o.Padre then
			o.Instancia.Parent = o.Padre
		elseif o.Enabled ~= nil then
			o.Instancia.Enabled = o.Enabled
		end
	end
	ocultos = {}
end

function Ambiente.Activo()
	return activo
end

return Ambiente
