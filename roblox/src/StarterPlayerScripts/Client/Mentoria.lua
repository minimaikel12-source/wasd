--[[
	Mentoria — si estás en un club, tu compañero está en este servidor y eres claramente
	más fuerte, te sale el objetivo "Ayuda a [nombre] a volverse fuerte" con:
	 • un marcador sobre el aprendiz (visible a través de paredes)
	 • una flecha 3D flotante que apunta hacia él
	Es solo un aviso: se puede cerrar con la X (vuelve si cambia el compañero o reapareces).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local UI = require(script.Parent.UI)

local jugador = Players.LocalPlayer
local Mentoria = {}

local cerradoPara = nil -- UserId del aprendiz cuyo aviso se cerró
local marcador, flecha
local aprendizActual

local function crearMarcador()
	local bb = Instance.new("BillboardGui")
	bb.Name = "MarcadorAprendiz"
	bb.AlwaysOnTop = true
	bb.Size = UDim2.fromOffset(160, 60)
	bb.StudsOffset = Vector3.new(0, 4.5, 0)
	bb.LightInfluence = 0
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.LuckiestGuy
	l.TextScaled = true
	l.TextColor3 = Color3.fromRGB(255, 205, 70)
	l.TextStrokeTransparency = 0
	l.Text = "APRENDIZ\n▼"
	l.Parent = bb
	return bb
end

local function crearFlecha()
	local m = Instance.new("Model")
	m.Name = "FlechaMentor"
	local function p(tam, cf, clase)
		local x = Instance.new(clase or "Part")
		x.Anchored, x.CanCollide, x.CanQuery, x.CanTouch, x.CastShadow = true, false, false, false, false
		x.Material = Enum.Material.Neon
		x.Color = Color3.fromRGB(255, 205, 70)
		x.Size = tam
		x:SetAttribute("Offset", cf)
		x.Parent = m
		return x
	end
	-- cuerpo + dos cuñas formando la punta (apunta a -Z)
	p(Vector3.new(0.5, 0.25, 2), CFrame.new(0, 0, 0.6))
	p(Vector3.new(0.25, 0.9, 1.1), CFrame.new(-0.45, 0, -0.85) * CFrame.Angles(0, 0, math.rad(90)), "WedgePart")
	p(Vector3.new(0.25, 0.9, 1.1), CFrame.new(0.45, 0, -0.85) * CFrame.Angles(0, 0, math.rad(-90)), "WedgePart")
	m.Parent = Workspace
	return m
end

local function colocarFlecha(cf)
	for _, x in ipairs(flecha:GetChildren()) do
		x.CFrame = cf * x:GetAttribute("Offset")
	end
end

local function ocultar()
	UI.AvisoMentor(false)
	if marcador then
		marcador.Parent = nil
	end
	if flecha then
		flecha.Parent = nil
	end
	aprendizActual = nil
end

local function aprendiz()
	if jugador:GetAttribute("EnDuelo") then
		return nil
	end
	local id = jugador:GetAttribute("ClubCompaneroId") or 0
	if id == 0 then
		return nil
	end
	local otro = Players:GetPlayerByUserId(id)
	if not otro or (otro:GetAttribute("ClubCompaneroId") or 0) ~= jugador.UserId then
		return nil
	end
	local yo, el = jugador:GetAttribute("Fuerza") or 0, otro:GetAttribute("Fuerza") or 0
	if yo <= 0 or (yo - el) / yo < Config.Mentoria.DiferenciaParaAviso then
		return nil
	end
	return otro
end

function Mentoria.Iniciar()
	UI.AlCerrarAviso = function()
		local otro = aprendiz()
		cerradoPara = otro and otro.UserId
		ocultar()
	end
	jugador.CharacterAdded:Connect(function()
		cerradoPara = nil -- el aviso vuelve tras reaparecer (no es obligatorio, solo recordatorio)
	end)
	marcador = crearMarcador()
	flecha = crearFlecha()
	flecha.Parent = nil

	local acumulado = 0
	RunService.Heartbeat:Connect(function(dt)
		acumulado += dt
		local otro = aprendizActual
		if acumulado >= 0.5 then
			acumulado = 0
			otro = aprendiz()
			if not otro or otro.UserId == cerradoPara then
				ocultar()
				return
			end
			aprendizActual = otro
		end
		if not otro then
			return
		end
		local miRaiz = jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart")
		local suRaiz = otro.Character and otro.Character:FindFirstChild("HumanoidRootPart")
		if not miRaiz or not suRaiz then
			return
		end
		local distancia = (suRaiz.Position - miRaiz.Position).Magnitude
		UI.AvisoMentor(true, otro.DisplayName, math.floor(distancia))
		if marcador.Parent ~= otro.Character then
			marcador.Adornee = otro.Character:FindFirstChild("Head") or suRaiz
			marcador.Parent = otro.Character
		end
		if distancia > Config.Mentoria.DistanciaBonus then
			flecha.Parent = Workspace
			local dir = (suRaiz.Position - miRaiz.Position) * Vector3.new(1, 0, 1)
			if dir.Magnitude > 0.1 then
				local origen = miRaiz.Position + dir.Unit * 4 + Vector3.new(0, 1.5 + math.sin(os.clock() * 4) * 0.25, 0)
				colocarFlecha(CFrame.lookAt(origen, origen + dir.Unit))
			end
		else
			flecha.Parent = nil -- ya estáis juntos: bonus activo
		end
	end)
end

return Mentoria
