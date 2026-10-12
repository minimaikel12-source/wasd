--[[
	AnimPlayer — reproduce una animación por nombre.
	 • Si Config.Animaciones[nombre] tiene ID → AnimationTrack normal (se replica sola).
	 • Si no → respaldo procedural: interpola los mismos keyframes (AnimData) sobre
	   Motor6D.Transform en RunService.Stepped (después del Animator), así que
	   funciona YA sin publicar nada. Solo rig R15.
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local AnimData = require(ReplicatedStorage:WaitForChild("AnimData"))

local AnimPlayer = {}

local FADE_IN, FADE_OUT = 0.1, 0.18
local activos = {} -- [character] = { reproduccion, ... }
local cacheTracks = setmetatable({}, { __mode = "k" }) -- [animator] = { [nombre] = track }
local conexion

local function cframeDe(k)
	return CFrame.new(k[5], k[6], k[7]) * CFrame.Angles(math.rad(k[2]), math.rad(k[3]), math.rad(k[4]))
end

local function aliviar(alpha, estilo, direccion)
	if estilo == "Constant" then
		return 0
	end
	local ok, valor = pcall(function()
		return TweenService:GetValue(alpha, Enum.EasingStyle[estilo], Enum.EasingDirection[direccion])
	end)
	return ok and valor or alpha
end

local function evaluarPista(pista, t)
	local n = #pista
	if t <= pista[1][1] then
		return cframeDe(pista[1])
	end
	for i = 1, n - 1 do
		local a, b = pista[i], pista[i + 1]
		if t < b[1] then
			local alpha = (t - a[1]) / math.max(b[1] - a[1], 1e-4)
			return cframeDe(a):Lerp(cframeDe(b), aliviar(alpha, a[8], a[9]))
		end
	end
	return cframeDe(pista[n])
end

local function paso()
	local ahora = os.clock()
	for personaje, lista in pairs(activos) do
		if not personaje.Parent then
			activos[personaje] = nil
			continue
		end
		for i = #lista, 1, -1 do
			local r = lista[i]
			local datos = r.Datos
			local t = (ahora - r.Inicio) * r.Velocidad
			local peso = math.clamp((ahora - r.Inicio) / FADE_IN, 0, 1)
			if r.Parando then
				peso = math.min(peso, 1 - math.clamp((ahora - r.Parando) / FADE_OUT, 0, 1))
				t = r.TParada
			elseif t >= datos.Duracion then
				if datos.Bucle then
					t = t % datos.Duracion
				elseif r.Mantener then
					t = datos.Duracion
				else
					r.Parando, r.TParada = ahora, datos.Duracion
					t = datos.Duracion
				end
			end
			if r.Parando and ahora - r.Parando >= FADE_OUT then
				table.remove(lista, i)
				continue
			end
			r.TActual = t
			for motorNombre, pista in pairs(datos.Pistas) do
				local motor = r.Motores[motorNombre]
				if motor == nil then
					local parte = personaje:FindFirstChild(pista.Parte)
					motor = parte and parte:FindFirstChild(motorNombre) or false
					r.Motores[motorNombre] = motor
				end
				if motor and motor.Parent then
					local objetivo = evaluarPista(pista, t)
					motor.Transform = peso >= 1 and objetivo or motor.Transform:Lerp(objetivo, peso)
				end
			end
		end
		if #lista == 0 then
			activos[personaje] = nil
		end
	end
	if next(activos) == nil and conexion then
		conexion:Disconnect()
		conexion = nil
	end
end

function AnimPlayer.TieneID(nombre)
	local id = Config.Animaciones[nombre]
	return id ~= nil and id ~= ""
end

local function reproducirTrack(personaje, nombre, opciones)
	local humanoid = personaje:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		return nil
	end
	cacheTracks[animator] = cacheTracks[animator] or {}
	local track = cacheTracks[animator][nombre]
	if not track then
		local anim = Instance.new("Animation")
		anim.AnimationId = Config.Animaciones[nombre]
		local ok, resultado = pcall(function()
			return animator:LoadAnimation(anim)
		end)
		if not ok then
			warn("[AnimPlayer] No se pudo cargar", nombre, resultado)
			return nil
		end
		track = resultado
		track.Priority = Enum.AnimationPriority.Action
		cacheTracks[animator][nombre] = track
	end
	track:Play(FADE_IN, 1, opciones.Velocidad or 1)
	if opciones.Mantener then
		task.delay(math.max(track.Length - 0.05, 0.1) / (opciones.Velocidad or 1), function()
			if track.IsPlaying then
				track:AdjustSpeed(0)
			end
		end)
	end
	return {
		Detener = function()
			track:Stop(FADE_OUT)
		end,
	}
end

-- Reproduce `nombre` en `personaje`. opciones = { Velocidad, Mantener, SoloProcedural }
function AnimPlayer.Reproducir(personaje, nombre, opciones)
	opciones = opciones or {}
	if not personaje then
		return nil
	end
	if not opciones.SoloProcedural and AnimPlayer.TieneID(nombre) then
		local c = reproducirTrack(personaje, nombre, opciones)
		if c then
			return c
		end
	end
	local datos = AnimData[nombre]
	local humanoid = personaje:FindFirstChildOfClass("Humanoid")
	if not datos or not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		return nil
	end
	local r = {
		Datos = datos,
		Nombre = nombre,
		Inicio = os.clock(),
		Velocidad = opciones.Velocidad or 1,
		Mantener = opciones.Mantener,
		Motores = {},
	}
	activos[personaje] = activos[personaje] or {}
	table.insert(activos[personaje], r)
	if not conexion then
		conexion = RunService.Stepped:Connect(paso)
	end
	return {
		Detener = function()
			if not r.Parando then
				r.Parando, r.TParada = os.clock(), r.TActual or 0
			end
		end,
	}
end

function AnimPlayer.DetenerTodo(personaje)
	local lista = activos[personaje]
	if lista then
		for _, r in ipairs(lista) do
			if not r.Parando then
				r.Parando, r.TParada = os.clock(), r.TActual or 0
			end
		end
	end
	local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	if animator and cacheTracks[animator] then
		for _, track in pairs(cacheTracks[animator]) do
			track:Stop(FADE_OUT)
		end
	end
end

return AnimPlayer
