--[[
	Efectos — todo lo visual/sonoro local: screen shake, ondas expansivas, cráteres,
	escombros, chispas, tajos de espada, textos flotantes, empujes y dashes.
	Lo dispara el servidor con Remotes.Efecto (lo ven todos) o el propio cliente.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local jugador = Players.LocalPlayer
local Efectos = {}

local carpeta = Instance.new("Folder")
carpeta.Name = "EfectosLocales"
carpeta.Parent = Workspace

---------------------------------------------------------------- utilidades
local function tween(obj, t, props, estilo, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(t, estilo or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function parte(props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	for k, v in pairs(props) do
		p[k] = v
	end
	p.Parent = carpeta
	return p
end

function Efectos.Sonido(id, pos, volumen, velocidad)
	if not id or id == "" then
		return
	end
	local ancla = parte({ Transparency = 1, Size = Vector3.one, Position = pos or Workspace.CurrentCamera.CFrame.Position })
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = volumen or 1
	s.PlaybackSpeed = velocidad or 1
	s.RollOffMaxDistance = 400
	s.Parent = ancla
	s:Play()
	Debris:AddItem(ancla, 6)
	return s
end

local function suelo(pos)
	local params = RaycastParams.new()
	local excluir = { carpeta }
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character then
			table.insert(excluir, p.Character)
		end
	end
	params.FilterDescendantsInstances = excluir
	params.FilterType = Enum.RaycastFilterType.Exclude
	local r = Workspace:Raycast(pos + Vector3.new(0, 6, 0), Vector3.new(0, -40, 0), params)
	if r then
		return r.Position, r.Instance.Color, r.Instance.Material
	end
	return pos, Color3.fromRGB(90, 90, 90), Enum.Material.Slate
end

local function emisor(pos, props, cantidad, vida)
	local p = parte({ Transparency = 1, Size = Vector3.one, Position = pos })
	local e = Instance.new("ParticleEmitter")
	e.Enabled = false
	e.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	for k, v in pairs(props) do
		e[k] = v
	end
	e.Parent = p
	e:Emit(cantidad)
	Debris:AddItem(p, vida or 3)
	return e
end

local function chispas(pos, color, cantidad, velocidad)
	emisor(pos, {
		Color = ColorSequence.new(color),
		LightEmission = 1,
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0) }),
		Lifetime = NumberRange.new(0.25, 0.6),
		Speed = NumberRange.new(velocidad * 0.5, velocidad),
		SpreadAngle = Vector2.new(180, 180),
		Drag = 4,
	}, cantidad)
end

local function polvo(pos, radio, cantidad)
	emisor(pos, {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Color = ColorSequence.new(Color3.fromRGB(140, 125, 110)),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) }),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, radio * 0.15), NumberSequenceKeypoint.new(1, radio * 0.45) }),
		Lifetime = NumberRange.new(1.2, 2.2),
		Speed = NumberRange.new(radio * 0.6, radio * 1.4),
		SpreadAngle = Vector2.new(180, 10),
		EmissionDirection = Enum.NormalId.Top,
		Acceleration = Vector3.new(0, 4, 0),
		Drag = 3,
		RotSpeed = NumberRange.new(-60, 60),
		Rotation = NumberRange.new(0, 360),
	}, cantidad, 4)
end

local function destello(pos, color, tam, t)
	local b = parte({ Shape = Enum.PartType.Ball, Material = Enum.Material.Neon, Color = color, Size = Vector3.one * 2, Position = pos, Transparency = 0.1 })
	local luz = Instance.new("PointLight")
	luz.Color, luz.Brightness, luz.Range = color, 8, tam * 2
	luz.Parent = b
	tween(b, t, { Size = Vector3.one * tam, Transparency = 1 })
	tween(luz, t, { Brightness = 0 })
	Debris:AddItem(b, t + 0.1)
end

local function anillo(pos, radio, color, t, grosor, inclinado)
	local cil = parte({ Shape = Enum.PartType.Cylinder, Material = Enum.Material.Neon, Color = color, Transparency = 0.15 })
	cil.Size = Vector3.new(grosor or 0.6, 2, 2)
	cil.CFrame = CFrame.new(pos) * (inclinado or CFrame.Angles(0, 0, math.rad(90)))
	tween(cil, t, { Size = Vector3.new(0.2, radio * 2, radio * 2), Transparency = 1 })
	Debris:AddItem(cil, t + 0.1)
end

local function crater(pos, radio, color, material, cantidad)
	for i = 1, cantidad do
		local a = (i / cantidad) * math.pi * 2 + math.random() * 0.3
		local r = radio * (0.55 + math.random() * 0.35)
		local tam = Vector3.new(2 + math.random() * radio * 0.18, 1.5 + math.random() * radio * 0.12, 2 + math.random() * radio * 0.18)
		local destino = CFrame.new(pos + Vector3.new(math.cos(a) * r, tam.Y * 0.2, math.sin(a) * r))
			* CFrame.Angles(math.rad(math.random(-35, 35)), a, math.rad(math.random(20, 50)))
		local roca = parte({ Size = tam, Color = color, Material = material, CanCollide = false })
		roca.CFrame = destino - Vector3.new(0, tam.Y, 0)
		tween(roca, 0.12, { CFrame = destino }, Enum.EasingStyle.Back)
		task.delay(3 + math.random(), function()
			tween(roca, 1, { CFrame = destino - Vector3.new(0, tam.Y + 1, 0), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			Debris:AddItem(roca, 1.1)
		end)
	end
	-- grieta central
	local grieta = parte({ Shape = Enum.PartType.Cylinder, Color = Color3.fromRGB(20, 15, 15), Material = Enum.Material.Slate })
	grieta.Size = Vector3.new(0.3, radio * 1.1, radio * 1.1)
	grieta.CFrame = CFrame.new(pos + Vector3.new(0, 0.05, 0)) * CFrame.Angles(0, 0, math.rad(90))
	task.delay(4, function()
		tween(grieta, 1, { Transparency = 1 })
		Debris:AddItem(grieta, 1.1)
	end)
end

local function escombros(pos, cantidad, fuerza, color, material)
	for _ = 1, cantidad do
		local p = Instance.new("Part")
		p.Size = Vector3.one * (0.6 + math.random() * 1.4)
		p.Color, p.Material = color, material
		p.CanCollide = true
		p.CanQuery = false
		p.CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0)) * CFrame.Angles(math.random() * 6, math.random() * 6, 0)
		p.Parent = carpeta
		local dir = Vector3.new(math.random() - 0.5, 0.8 + math.random(), math.random() - 0.5).Unit
		p.AssemblyLinearVelocity = dir * fuerza * (0.5 + math.random() * 0.7)
		p.AssemblyAngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
		Debris:AddItem(p, 3 + math.random())
	end
end

local function rayo(destino, color)
	local inicio = destino + Vector3.new(math.random(-20, 20), 140, math.random(-20, 20))
	local puntos, n = { inicio }, 9
	for i = 1, n - 1 do
		local alpha = i / n
		table.insert(puntos, inicio:Lerp(destino, alpha) + Vector3.new(math.random(-6, 6), 0, math.random(-6, 6)))
	end
	table.insert(puntos, destino)
	for i = 1, #puntos - 1 do
		local a, b = puntos[i], puntos[i + 1]
		local seg = parte({ Material = Enum.Material.Neon, Color = color })
		seg.Size = Vector3.new(0.8, 0.8, (b - a).Magnitude)
		seg.CFrame = CFrame.lookAt((a + b) / 2, b)
		tween(seg, 0.35, { Transparency = 1, Size = Vector3.new(0.1, 0.1, seg.Size.Z) })
		Debris:AddItem(seg, 0.4)
	end
end

local function textoFlotante(pos, texto, color, tam)
	local ancla = parte({ Transparency = 1, Size = Vector3.one, Position = pos })
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromOffset(260, 70)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.Parent = ancla
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.LuckiestGuy
	l.Text = texto
	l.TextColor3 = color
	l.TextStrokeTransparency = 0
	l.TextScaled = true
	l.Parent = bb
	local escala = Instance.new("UIScale")
	escala.Scale = 0.2
	escala.Parent = l
	tween(escala, 0.25, { Scale = tam or 1 }, Enum.EasingStyle.Back)
	tween(ancla, 1.2, { Position = pos + Vector3.new(0, 4, 0) })
	task.delay(0.7, function()
		tween(l, 0.5, { TextTransparency = 1, TextStrokeTransparency = 1 })
	end)
	Debris:AddItem(ancla, 1.3)
end
Efectos.TextoFlotante = textoFlotante

---------------------------------------------------------------- screen shake
local temblores = {}
RunService:BindToRenderStep("TemblorCamara", Enum.RenderPriority.Camera.Value + 1, function()
	local ahora = os.clock()
	local total = 0
	for i = #temblores, 1, -1 do
		local t = temblores[i]
		local alpha = (ahora - t.Inicio) / t.Duracion
		if alpha >= 1 then
			table.remove(temblores, i)
		else
			total += t.Intensidad * (1 - alpha) ^ 2
		end
	end
	if total > 0.001 then
		local cam = Workspace.CurrentCamera
		local n = ahora * 28
		local rx = (math.noise(n, 0.3) * 2) * total
		local ry = (math.noise(0.7, n) * 2) * total
		local rz = (math.noise(n, n * 0.5) * 1) * total
		cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(rx * 3), math.rad(ry * 3), math.rad(rz * 2))
	end
end)

function Efectos.Temblor(intensidad, duracion)
	if intensidad <= 0 then
		return
	end
	table.insert(temblores, { Intensidad = intensidad, Duracion = duracion or 0.5, Inicio = os.clock() })
end

local function temblorPorDistancia(pos, fuerza, radio)
	local cam = Workspace.CurrentCamera
	local dist = (cam.Focus.Position - pos).Magnitude
	local alcance = (radio or 10) * 3 + 50
	local f = math.clamp(1 - dist / alcance, 0, 1)
	Efectos.Temblor(fuerza * f, 0.35 + fuerza * 0.4)
end

local function flashPantalla(color, intensidad)
	local cc = Instance.new("ColorCorrectionEffect")
	cc.TintColor = color
	cc.Brightness = intensidad
	cc.Parent = game:GetService("Lighting")
	tween(cc, 0.45, { Brightness = 0, TintColor = Color3.new(1, 1, 1) })
	Debris:AddItem(cc, 0.5)
end

---------------------------------------------------------------- física local
local function velocidadTemporal(vel, duracion)
	local personaje = jugador.Character
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	if not raiz then
		return
	end
	local att = raiz:FindFirstChild("RootAttachment") or Instance.new("Attachment", raiz)
	local lv = Instance.new("LinearVelocity")
	lv.Attachment0 = att
	lv.MaxForce = math.huge
	lv.VectorVelocity = vel
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Parent = raiz
	Debris:AddItem(lv, duracion)
end

function Efectos.Empuje(vel)
	velocidadTemporal(vel, 0.15)
end

function Efectos.Dash(direccion, velocidad, duracion)
	velocidadTemporal(direccion * velocidad, duracion)
end

---------------------------------------------------------------- tipos de efecto
local COLORES = {
	PunoPotente = Color3.fromRGB(255, 200, 80),
	PatadaGiratoria = Color3.fromRGB(120, 220, 255),
	Embestida = Color3.fromRGB(255, 120, 60),
	OndaExpansiva = Color3.fromRGB(160, 120, 255),
	SaltoSismico = Color3.fromRGB(255, 90, 40),
	FuriaTitan = Color3.fromRGB(255, 40, 40),
}

local manejadores = {}

function manejadores.Carga(d)
	local personaje = d.Origen and d.Origen.Character
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	if not raiz then
		return
	end
	local color = COLORES[d.Id] or Color3.new(1, 1, 1)
	emisor(raiz.Position, {
		Color = ColorSequence.new(color),
		LightEmission = 1,
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0) }),
		Lifetime = NumberRange.new(0.4, 0.8),
		Speed = NumberRange.new(-14, -8), -- hacia dentro: concentrando poder
		SpreadAngle = Vector2.new(180, 180),
		Shape = Enum.ParticleEmitterShape.Sphere,
		ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
	}, 40, 1.5)
	if d.Id == "FuriaTitan" or d.Id == "SaltoSismico" then
		temblorPorDistancia(raiz.Position, 0.4, 20)
	end
end

function manejadores.Golpe(d)
	destello(d.Pos, COLORES.PunoPotente, 9, 0.3)
	anillo(d.Pos, 7, COLORES.PunoPotente, 0.35, 0.5, CFrame.lookAt(Vector3.zero, d.Dir) * CFrame.Angles(0, math.rad(90), 0))
	chispas(d.Pos, COLORES.PunoPotente, 30, 50)
	Efectos.Sonido(Config.Sonidos.Impacto, d.Pos, 1.4, 0.7)
	temblorPorDistancia(d.Pos, d.Fuerza, d.Radio)
end

function manejadores.Giro(d)
	local pos = suelo(d.Pos)
	anillo(pos + Vector3.new(0, 1.5, 0), d.Radio, COLORES.PatadaGiratoria, 0.4, 0.6)
	polvo(pos, d.Radio, 20)
	Efectos.Sonido(Config.Sonidos.Estocada, pos, 1.3, 0.8)
	temblorPorDistancia(pos, d.Fuerza, d.Radio)
end

function manejadores.Embestida(d)
	local pos = suelo(d.Pos)
	destello(d.Pos, COLORES.Embestida, 14, 0.35)
	anillo(pos + Vector3.new(0, 1, 0), d.Radio * 2, COLORES.Embestida, 0.4)
	polvo(pos, 12, 25)
	Efectos.Sonido(Config.Sonidos.Impacto, pos, 2, 0.5)
	temblorPorDistancia(pos, d.Fuerza, 15)
end

function manejadores.Onda(d)
	local pos, color, material = suelo(d.Pos)
	destello(pos, COLORES.OndaExpansiva, 18, 0.4)
	anillo(pos + Vector3.new(0, 1, 0), d.Radio, COLORES.OndaExpansiva, 0.6, 1)
	task.delay(0.1, anillo, pos + Vector3.new(0, 0.5, 0), d.Radio * 1.2, Color3.new(1, 1, 1), 0.7, 0.5)
	crater(pos, 9, color, material, 14)
	polvo(pos, d.Radio, 45)
	escombros(pos, 10, 55, color, material)
	flashPantalla(COLORES.OndaExpansiva, 0.25)
	Efectos.Sonido(Config.Sonidos.Explosion, pos, 2, 0.6)
	temblorPorDistancia(pos, d.Fuerza, d.Radio)
end

function manejadores.Sismo(d)
	local pos, color, material = suelo(d.Pos)
	destello(pos, COLORES.SaltoSismico, 26, 0.45)
	for i = 0, 2 do
		task.delay(i * 0.12, anillo, pos + Vector3.new(0, 1, 0), d.Radio * (0.6 + i * 0.3), COLORES.SaltoSismico, 0.7, 1.2)
	end
	crater(pos, 16, color, material, 24)
	polvo(pos, d.Radio, 70)
	escombros(pos, 22, 85, color, material)
	flashPantalla(Color3.fromRGB(255, 150, 100), 0.35)
	Efectos.Sonido(Config.Sonidos.Explosion, pos, 3, 0.4)
	Efectos.Sonido(Config.Sonidos.Impacto, pos, 3, 0.3)
	temblorPorDistancia(pos, d.Fuerza, d.Radio)
end

function manejadores.Titan(d)
	local pos, color, material = suelo(d.Pos)
	flashPantalla(Color3.fromRGB(255, 80, 60), 0.6)
	for i = 0, 3 do
		task.delay(i * 0.18, function()
			anillo(pos + Vector3.new(0, 1 + i, 0), d.Radio * (0.4 + i * 0.25), i % 2 == 0 and COLORES.FuriaTitan or Color3.new(1, 0.85, 0.6), 0.8, 1.6)
			temblorPorDistancia(pos, d.Fuerza * 0.6, d.Radio)
		end)
	end
	for i = 1, 8 do
		task.delay(0.05 * i, function()
			local a = math.random() * math.pi * 2
			local p = suelo(pos + Vector3.new(math.cos(a), 0, math.sin(a)) * math.random(8, d.Radio))
			rayo(p, Color3.fromRGB(255, 220, 220))
			destello(p, COLORES.FuriaTitan, 10, 0.3)
			crater(p, 5, color, material, 7)
		end)
	end
	destello(pos, COLORES.FuriaTitan, 40, 0.6)
	crater(pos, 22, color, material, 30)
	polvo(pos, d.Radio, 90)
	escombros(pos, 30, 110, color, material)
	Efectos.Sonido(Config.Sonidos.Explosion, pos, 4, 0.3)
	temblorPorDistancia(pos, d.Fuerza, d.Radio)
end

function manejadores.Impacto(d)
	chispas(d.Pos, Color3.fromRGB(255, 230, 150), 15, 30)
	textoFlotante(d.Pos + Vector3.new(0, 2, 0), "¡POW!", Color3.fromRGB(255, 220, 90), 0.8)
end

function manejadores.Tajo(d)
	local personaje = d.Origen and d.Origen.Character
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	if not raiz then
		return
	end
	local color = d.Pesado and Color3.fromRGB(255, 120, 60) or Color3.fromRGB(180, 220, 255)
	local radio = d.Pesado and 9 or 7
	-- Arco de tajo: segmentos neón en semicírculo delante del atacante
	for i = -4, 4 do
		local a = math.rad(i * 18)
		local cf = raiz.CFrame * CFrame.Angles(0, a, 0) * CFrame.new(0, 0.5, -radio * 0.6)
		local seg = parte({ Material = Enum.Material.Neon, Color = color, Transparency = 0.25, Size = Vector3.new(0.15, 0.5, radio * 0.25), CFrame = cf * CFrame.Angles(0, math.rad(90), 0) })
		tween(seg, 0.22, { Transparency = 1, Size = Vector3.new(0.05, 0.1, seg.Size.Z) })
		Debris:AddItem(seg, 0.25)
	end
	Efectos.Sonido(d.Pesado and Config.Sonidos.Estocada or Config.Sonidos.Tajo, raiz.Position, 1, d.Pesado and 0.7 or 1 + math.random() * 0.15)
end

function manejadores.CargaPesado(d)
	local personaje = d.Origen and d.Origen.Character
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	if raiz then
		emisor(raiz.Position, {
			Color = ColorSequence.new(Color3.fromRGB(255, 120, 60)),
			LightEmission = 1,
			Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0) }),
			Lifetime = NumberRange.new(0.3, 0.6),
			Speed = NumberRange.new(-12, -6),
			SpreadAngle = Vector2.new(180, 180),
			Shape = Enum.ParticleEmitterShape.Sphere,
		}, 25, 1)
	end
end

function manejadores.GolpeEspada(d)
	if d.Bloqueado then
		chispas(d.Pos, Color3.fromRGB(255, 230, 120), 35, 40)
		textoFlotante(d.Pos + Vector3.new(0, 3, 0), "BLOQUEADO -" .. d.Dano, Color3.fromRGB(200, 220, 255), 0.7)
		Efectos.Sonido(Config.Sonidos.Impacto, d.Pos, 1.2, 1.6)
	else
		chispas(d.Pos, Color3.fromRGB(255, 70, 60), d.Pesado and 45 or 20, d.Pesado and 55 or 35)
		destello(d.Pos, Color3.fromRGB(255, 200, 200), d.Pesado and 8 or 4, 0.2)
		textoFlotante(d.Pos + Vector3.new(0, 3, 0), "-" .. d.Dano, d.Pesado and Color3.fromRGB(255, 120, 40) or Color3.fromRGB(255, 80, 80), d.Pesado and 1.2 or 0.9)
		Efectos.Sonido(Config.Sonidos.Impacto, d.Pos, 1.5, d.Pesado and 0.6 or 0.9)
	end
	temblorPorDistancia(d.Pos, d.Fuerza, 6)
end

function manejadores.Texto(d)
	textoFlotante(d.Pos, d.Texto, Color3.fromRGB(255, 255, 255), 1.1)
end

function Efectos.Procesar(d)
	local fn = manejadores[d.Tipo]
	if fn then
		task.spawn(fn, d)
	end
end

-- Exportadas para Ambiente (relámpagos de la arena)
Efectos.Rayo = rayo
Efectos.FlashPantalla = flashPantalla
Efectos.Tween = tween
Efectos.Carpeta = carpeta

return Efectos
