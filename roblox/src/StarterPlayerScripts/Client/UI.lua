--[[
	UI — toda la interfaz, creada por código:
	panel de Fuerza, barra de habilidades, avisos, desbloqueo épico, panel de Club,
	invitaciones, aviso de mentor, HUD del duelo, cuenta atrás y pantalla final.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local jugador = Players.LocalPlayer
local UI = {}

local FUENTE = Enum.Font.LuckiestGuy
local FUENTE2 = Enum.Font.GothamBold
local ORO = Color3.fromRGB(255, 205, 70)

---------------------------------------------------------------- helpers
local function nuevo(clase, props, hijos)
	local i = Instance.new(clase)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			i[k] = v
		end
	end
	for _, h in ipairs(hijos or {}) do
		h.Parent = i
	end
	if props and props.Parent then
		i.Parent = props.Parent
	end
	return i
end

local function esquinas(r)
	return nuevo("UICorner", { CornerRadius = UDim.new(0, r or 10) })
end

local function borde(color, grosor)
	return nuevo("UIStroke", { Color = color or Color3.new(0, 0, 0), Thickness = grosor or 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end

local function tween(obj, t, props, estilo, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(t, estilo or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function texto(props)
	local base = {
		BackgroundTransparency = 1, Font = FUENTE, TextColor3 = Color3.new(1, 1, 1),
		TextStrokeTransparency = 0.3, TextScaled = true,
	}
	for k, v in pairs(props) do
		base[k] = v
	end
	return nuevo("TextLabel", base)
end

local function boton(props, alPulsar)
	local base = {
		Font = FUENTE, TextColor3 = Color3.new(1, 1, 1), TextScaled = true, AutoButtonColor = true,
		BackgroundColor3 = Color3.fromRGB(60, 140, 255),
	}
	for k, v in pairs(props) do
		base[k] = v
	end
	local b = nuevo("TextButton", base, { esquinas(8), borde(Color3.fromRGB(10, 10, 20), 2),
		nuevo("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }) })
	b.Activated:Connect(alPulsar)
	return b
end

local gui = nuevo("ScreenGui", {
	Name = "JuegoUI", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = jugador:WaitForChild("PlayerGui"),
})
local guiTop = nuevo("ScreenGui", {
	Name = "JuegoUI_Top", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 10,
	Parent = jugador.PlayerGui,
})
UI.Gui = gui

---------------------------------------------------------------- panel de fuerza
local panelFuerza = nuevo("Frame", {
	Name = "PanelFuerza", Size = UDim2.fromOffset(260, 92), Position = UDim2.fromOffset(16, 60),
	BackgroundColor3 = Color3.fromRGB(20, 20, 30), BackgroundTransparency = 0.25, Parent = gui,
}, { esquinas(12), borde(ORO, 2) })
texto({ Text = "FUERZA", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(10, 6), TextColor3 = ORO, TextXAlignment = Enum.TextXAlignment.Left, Parent = panelFuerza })
local valorFuerza = texto({ Text = "0", Size = UDim2.new(1, -20, 0, 34), Position = UDim2.fromOffset(10, 24), TextXAlignment = Enum.TextXAlignment.Left, Parent = panelFuerza })
local barraFondo = nuevo("Frame", { Size = UDim2.new(1, -20, 0, 10), Position = UDim2.fromOffset(10, 62), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Parent = panelFuerza }, { esquinas(5) })
local barra = nuevo("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = ORO, Parent = barraFondo }, { esquinas(5) })
local siguienteTxt = texto({ Text = "", Size = UDim2.new(1, -20, 0, 14), Position = UDim2.fromOffset(10, 74), Font = FUENTE2, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Color3.fromRGB(200, 200, 210), Parent = panelFuerza })

function UI.ActualizarFuerza(valor)
	local anterior = tonumber((valorFuerza.Text:gsub("%D", ""))) or 0
	valorFuerza.Text = tostring(valor)
	if valor > anterior then
		local s = valorFuerza:FindFirstChildOfClass("UIScale") or nuevo("UIScale", { Parent = valorFuerza })
		s.Scale = 1.15
		tween(s, 0.25, { Scale = 1 }, Enum.EasingStyle.Back)
	end
	local previa, siguiente = 0, nil
	for _, h in ipairs(Config.Habilidades) do
		if valor < h.Fuerza then
			siguiente = h
			break
		end
		previa = h.Fuerza
	end
	if siguiente then
		local alpha = math.clamp((valor - previa) / math.max(siguiente.Fuerza - previa, 1), 0, 1)
		tween(barra, 0.2, { Size = UDim2.fromScale(alpha, 1) })
		siguienteTxt.Text = ("Siguiente: %s (%d/%d)"):format(siguiente.Nombre, valor, siguiente.Fuerza)
	else
		barra.Size = UDim2.fromScale(1, 1)
		siguienteTxt.Text = "¡Todas las habilidades desbloqueadas!"
	end
end

---------------------------------------------------------------- barra de habilidades
local hotbar = nuevo("Frame", {
	Name = "Habilidades", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16),
	Size = UDim2.fromOffset(#Config.Habilidades * 86, 86), BackgroundTransparency = 1, Parent = gui,
}, { nuevo("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center }) })
local slots = {}
for i, h in ipairs(Config.Habilidades) do
	local slot = nuevo("Frame", { Name = h.Id, LayoutOrder = i, Size = UDim2.fromOffset(80, 80), BackgroundColor3 = Color3.fromRGB(25, 25, 35), BackgroundTransparency = 0.15, Parent = hotbar }, { esquinas(10), borde(Color3.fromRGB(90, 90, 110), 2) })
	texto({ Text = h.Tecla, Size = UDim2.fromOffset(24, 22), Position = UDim2.fromOffset(4, 2), TextColor3 = ORO, Parent = slot })
	texto({ Text = h.Nombre, Size = UDim2.new(1, -8, 0, 32), Position = UDim2.fromOffset(4, 28), Font = FUENTE2, Parent = slot })
	local cd = nuevo("Frame", { Name = "CD", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.35, ZIndex = 3, Parent = slot }, { esquinas(10) })
	local bloqueo = nuevo("Frame", { Name = "Bloqueo", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(10, 10, 15), BackgroundTransparency = 0.2, ZIndex = 4, Parent = slot }, { esquinas(10) })
	texto({ Text = "🔒\n" .. h.Fuerza, Size = UDim2.fromScale(1, 0.8), Position = UDim2.fromScale(0, 0.1), TextColor3 = Color3.fromRGB(170, 170, 180), ZIndex = 5, Parent = bloqueo })
	slots[h.Id] = { Slot = slot, CD = cd, Bloqueo = bloqueo }
end

function UI.ActualizarHabilidades(desbloqueadas)
	for id, s in pairs(slots) do
		s.Bloqueo.Visible = not desbloqueadas[id]
	end
end

function UI.Cooldown(id, duracion)
	local s = slots[id]
	if not s then
		return
	end
	s.CD.Size = UDim2.fromScale(1, 1)
	tween(s.CD, duracion, { Size = UDim2.fromScale(1, 0) }, Enum.EasingStyle.Linear)
	local st = s.Slot:FindFirstChildOfClass("UIStroke")
	st.Color = Color3.new(1, 1, 1)
	tween(st, 0.4, { Color = Color3.fromRGB(90, 90, 110) })
end

function UI.MostrarHotbar(visible)
	hotbar.Visible = visible
end

---------------------------------------------------------------- mensajes
local listaMensajes = nuevo("Frame", {
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 120), Size = UDim2.fromOffset(520, 200),
	BackgroundTransparency = 1, Parent = guiTop,
}, { nuevo("UIListLayout", { Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center }) })

function UI.Mensaje(t, color)
	local f = nuevo("Frame", { Size = UDim2.fromOffset(500, 34), BackgroundColor3 = Color3.fromRGB(15, 15, 25), BackgroundTransparency = 0.2, Parent = listaMensajes }, { esquinas(8), borde(color or Color3.new(1, 1, 1), 1.5) })
	local l = texto({ Text = t, Size = UDim2.new(1, -16, 1, -8), Position = UDim2.fromOffset(8, 4), Font = FUENTE2, TextColor3 = color or Color3.new(1, 1, 1), Parent = f })
	task.delay(3.5, function()
		tween(f, 0.4, { BackgroundTransparency = 1 })
		tween(l, 0.4, { TextTransparency = 1, TextStrokeTransparency = 1 })
		task.wait(0.45)
		f:Destroy()
	end)
end

function UI.Ganancia(cantidad, bonus, textoExtra)
	local l = texto({
		Text = (textoExtra and (textoExtra .. " ") or "") .. "+" .. cantidad .. " FUERZA" .. (bonus and ("  x" .. bonus .. " MENTOR") or ""),
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5 + (math.random() - 0.5) * 0.1, 0, 0.62, 0),
		Size = UDim2.fromOffset(420, 40), TextColor3 = bonus and Color3.fromRGB(120, 255, 160) or ORO, Parent = gui,
	})
	tween(l, 1.1, { Position = l.Position - UDim2.fromScale(0, 0.12) })
	task.delay(0.6, function()
		tween(l, 0.5, { TextTransparency = 1, TextStrokeTransparency = 1 })
	end)
	game:GetService("Debris"):AddItem(l, 1.2)
end

---------------------------------------------------------------- desbloqueo épico
function UI.Desbloqueo(nombre, tecla)
	local fondo = nuevo("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, ZIndex = 20, Parent = guiTop })
	local flash = nuevo("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, ZIndex = 25, Parent = fondo })
	local rayos = nuevo("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.45), Size = UDim2.fromOffset(900, 900),
		BackgroundTransparency = 1, Image = "rbxasset://textures/particles/sparkles_main.dds",
		ImageColor3 = ORO, ImageTransparency = 0.3, ZIndex = 21, Parent = fondo,
	})
	local titulo = texto({ Text = "¡HABILIDAD DESBLOQUEADA!", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.33), Size = UDim2.fromScale(0.8, 0.08), TextColor3 = Color3.new(1, 1, 1), ZIndex = 22, Parent = fondo })
	local nombreL = texto({ Text = nombre:upper(), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.46), Size = UDim2.fromScale(0.9, 0.16), TextColor3 = ORO, ZIndex = 22, Parent = fondo })
	nuevo("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 150)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 150)) }), Parent = nombreL })
	nuevo("UIStroke", { Thickness = 4, Color = Color3.fromRGB(60, 20, 0), Parent = nombreL })
	local sub = texto({ Text = "Pulsa [" .. tecla .. "] para usarla", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.58), Size = UDim2.fromScale(0.5, 0.05), Font = FUENTE2, ZIndex = 22, TextTransparency = 1, Parent = fondo })
	local escala = nuevo("UIScale", { Scale = 3, Parent = nombreL })
	nombreL.Rotation = -8
	tween(fondo, 0.2, { BackgroundTransparency = 0.45 })
	tween(flash, 0.5, { BackgroundTransparency = 1 })
	tween(escala, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
	tween(nombreL, 0.45, { Rotation = 0 }, Enum.EasingStyle.Back)
	tween(sub, 0.4, { TextTransparency = 0 })
	local girando = true
	task.spawn(function()
		while girando do
			rayos.Rotation += 1.5
			task.wait()
		end
	end)
	local s = Instance.new("Sound")
	s.SoundId = Config.Sonidos.Desbloqueo
	s.Volume = 1.5
	s.Parent = guiTop
	s:Play()
	local s2 = Instance.new("Sound")
	s2.SoundId = Config.Sonidos.Explosion
	s2.PlaybackSpeed = 0.5
	s2.Parent = guiTop
	s2:Play()
	task.delay(2.8, function()
		tween(fondo, 0.4, { BackgroundTransparency = 1 })
		for _, l in ipairs({ titulo, nombreL, sub }) do
			tween(l, 0.4, { TextTransparency = 1, TextStrokeTransparency = 1 })
		end
		tween(rayos, 0.4, { ImageTransparency = 1 })
		task.wait(0.45)
		girando = false
		fondo:Destroy()
		s:Destroy()
		s2:Destroy()
	end)
end

---------------------------------------------------------------- pregunta (invitaciones)
-- callback(true|false). Se cierra sola al agotar el tiempo (= rechazar).
function UI.Pregunta(titulo, cuerpo, tiempo, colorAcento, callback)
	local f = nuevo("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.3), Size = UDim2.fromOffset(420, 180),
		BackgroundColor3 = Color3.fromRGB(20, 20, 30), Parent = guiTop,
	}, { esquinas(14), borde(colorAcento, 3) })
	texto({ Text = titulo, Size = UDim2.new(1, -20, 0, 36), Position = UDim2.fromOffset(10, 10), TextColor3 = colorAcento, Parent = f })
	texto({ Text = cuerpo, Size = UDim2.new(1, -20, 0, 50), Position = UDim2.fromOffset(10, 50), Font = FUENTE2, TextWrapped = true, Parent = f })
	local tiempoBarra = nuevo("Frame", { Size = UDim2.new(1, -20, 0, 6), Position = UDim2.fromOffset(10, 106), BackgroundColor3 = colorAcento, Parent = f }, { esquinas(3) })
	local respondido = false
	local function responder(si)
		if respondido then
			return
		end
		respondido = true
		f:Destroy()
		callback(si)
	end
	boton({ Text = "ACEPTAR", Size = UDim2.new(0.5, -15, 0, 48), Position = UDim2.fromOffset(10, 120), BackgroundColor3 = Color3.fromRGB(60, 190, 90) }, function()
		responder(true)
	end).Parent = f
	boton({ Text = "RECHAZAR", Size = UDim2.new(0.5, -15, 0, 48), Position = UDim2.new(0.5, 5, 0, 120), BackgroundColor3 = Color3.fromRGB(200, 60, 60) }, function()
		responder(false)
	end).Parent = f
	local s = nuevo("UIScale", { Scale = 0.3, Parent = f })
	tween(s, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
	tween(tiempoBarra, tiempo, { Size = UDim2.new(0, 0, 0, 6) }, Enum.EasingStyle.Linear)
	task.delay(tiempo, function()
		responder(false)
	end)
end

---------------------------------------------------------------- aviso de mentor
local aviso = nuevo("Frame", {
	Name = "AvisoMentor", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 56), Size = UDim2.fromOffset(480, 62),
	BackgroundColor3 = Color3.fromRGB(30, 25, 10), BackgroundTransparency = 0.15, Visible = false, Parent = gui,
}, { esquinas(12), borde(ORO, 2) })
local avisoTxt = texto({ Text = "", Size = UDim2.new(1, -60, 0, 30), Position = UDim2.fromOffset(12, 4), TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = ORO, Parent = aviso })
local avisoSub = texto({ Text = "", Size = UDim2.new(1, -60, 0, 20), Position = UDim2.fromOffset(12, 36), Font = FUENTE2, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Color3.fromRGB(230, 220, 190), Parent = aviso })
UI.AlCerrarAviso = nil
boton({ Text = "X", Size = UDim2.fromOffset(36, 36), Position = UDim2.new(1, -46, 0, 13), BackgroundColor3 = Color3.fromRGB(90, 70, 40) }, function()
	aviso.Visible = false
	if UI.AlCerrarAviso then
		UI.AlCerrarAviso()
	end
end).Parent = aviso

function UI.AvisoMentor(visible, nombre, distancia)
	aviso.Visible = visible
	if visible then
		avisoTxt.Text = "🎯 Ayuda a " .. nombre .. " a volverse fuerte"
		avisoSub.Text = ("Entrenad cerca (<%d studs): ¡x%d de fuerza para tu aprendiz!%s"):format(
			Config.Mentoria.DistanciaBonus, Config.Mentoria.BonusAprendiz, distancia and ("  ·  a %d studs"):format(distancia) or "")
	end
end

---------------------------------------------------------------- panel de club
local panelClub = nuevo("Frame", {
	Name = "PanelClub", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.5, 0), Size = UDim2.fromOffset(340, 400),
	BackgroundColor3 = Color3.fromRGB(18, 18, 28), BackgroundTransparency = 0.05, Visible = false, Parent = gui,
}, { esquinas(14), borde(Color3.fromRGB(110, 170, 255), 2) })
texto({ Text = "CLUB", Size = UDim2.new(1, -20, 0, 36), Position = UDim2.fromOffset(10, 8), TextColor3 = Color3.fromRGB(140, 190, 255), Parent = panelClub })
local contenido = nuevo("Frame", { Size = UDim2.new(1, -20, 1, -56), Position = UDim2.fromOffset(10, 48), BackgroundTransparency = 1, Parent = panelClub })

UI.Acciones = {} -- Invitar(userId), Salir(), Retar(), PedirEstado() -> estado

local function limpiarContenido()
	for _, h in ipairs(contenido:GetChildren()) do
		h:Destroy()
	end
end

local confirmarSalir = false
function UI.RefrescarClub()
	if not panelClub.Visible or not UI.Acciones.PedirEstado then
		return
	end
	local estado = UI.Acciones.PedirEstado()
	limpiarContenido()
	if not estado then
		texto({ Text = "Cargando...", Size = UDim2.new(1, 0, 0, 30), Font = FUENTE2, Parent = contenido })
		return
	end
	if not estado.Club then
		texto({ Text = "Invita a un amigo a tu club (mentor + aprendiz).", Size = UDim2.new(1, 0, 0, 40), Font = FUENTE2, TextWrapped = true, Parent = contenido })
		local lista = nuevo("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -50), Position = UDim2.fromOffset(0, 48), BackgroundTransparency = 1,
			CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6, Parent = contenido,
		}, { nuevo("UIListLayout", { Padding = UDim.new(0, 6) }) })
		local alguno = false
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= jugador then
				alguno = true
				local fila = nuevo("Frame", { Size = UDim2.new(1, -8, 0, 44), BackgroundColor3 = Color3.fromRGB(35, 35, 50), Parent = lista }, { esquinas(8) })
				local enClub = (p:GetAttribute("ClubCompaneroId") or 0) ~= 0
				texto({ Text = p.DisplayName .. "  ·  " .. tostring(p:GetAttribute("Fuerza") or 0), Size = UDim2.new(0.62, -8, 1, -12), Position = UDim2.fromOffset(8, 6), Font = FUENTE2, TextXAlignment = Enum.TextXAlignment.Left, Parent = fila })
				local b = boton({ Text = enClub and "EN CLUB" or "INVITAR", Size = UDim2.new(0.38, -8, 1, -10), Position = UDim2.new(0.62, 0, 0, 5), BackgroundColor3 = enClub and Color3.fromRGB(80, 80, 90) or Color3.fromRGB(60, 140, 255) }, function()
					if not enClub and UI.Acciones.Invitar then
						UI.Acciones.Invitar(p.UserId)
					end
				end)
				b.Parent = fila
			end
		end
		if not alguno then
			texto({ Text = "No hay más jugadores en el servidor. ¡Invita a un amigo al juego!", Size = UDim2.new(1, -8, 0, 60), Font = FUENTE2, TextWrapped = true, TextColor3 = Color3.fromRGB(180, 180, 190), Parent = lista })
		end
		return
	end
	local c = estado.Club
	local yo = estado.Fuerza
	local otro = c.FuerzaCompanero
	local rol = otro and (otro < yo and "Eres el MENTOR" or (otro > yo and "Eres el APRENDIZ" or "Mismo nivel")) or "Compañero desconectado"
	local lineas = {
		{ "Compañero: " .. c.CompaneroNombre, Color3.new(1, 1, 1) },
		{ c.EnServidor and "🟢 En este servidor" or "⚪ No está en este servidor", c.EnServidor and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(170, 170, 180) },
		{ rol, ORO },
		{ ("Fuerza: tú %d  ·  %s %s"):format(yo, c.CompaneroNombre, otro and tostring(otro) or "?"), Color3.new(1, 1, 1) },
		{ ("Días de mentoría: %.1f / %d"):format(c.Dias, c.DiasMinimos), Color3.fromRGB(200, 210, 255) },
	}
	for i, l in ipairs(lineas) do
		texto({ Text = l[1], Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, (i - 1) * 28), Font = FUENTE2, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = l[2], Parent = contenido })
	end
	local y = #lineas * 28 + 8
	texto({
		Text = c.DueloDisponible and "⚔ ¡DUELO FINAL DISPONIBLE!" or ("Duelo: " .. (c.MotivoDuelo or "")),
		Size = UDim2.new(1, 0, 0, 54), Position = UDim2.fromOffset(0, y), Font = c.DueloDisponible and FUENTE or FUENTE2,
		TextWrapped = true, TextColor3 = c.DueloDisponible and Color3.fromRGB(255, 90, 90) or Color3.fromRGB(190, 190, 200), Parent = contenido,
	})
	boton({ Text = "⚔ RETAR A DUELO", Size = UDim2.new(1, 0, 0, 46), Position = UDim2.fromOffset(0, y + 62), BackgroundColor3 = c.DueloDisponible and Color3.fromRGB(190, 40, 40) or Color3.fromRGB(80, 60, 60) }, function()
		if UI.Acciones.Retar then
			UI.Acciones.Retar()
		end
	end).Parent = contenido
	local salir = boton({ Text = confirmarSalir and "¿SEGURO? PULSA OTRA VEZ" or "SALIR DEL CLUB", Size = UDim2.new(1, 0, 0, 38), Position = UDim2.fromOffset(0, y + 116), BackgroundColor3 = Color3.fromRGB(70, 70, 80) }, function()
		if confirmarSalir then
			confirmarSalir = false
			if UI.Acciones.Salir then
				UI.Acciones.Salir()
			end
			task.delay(0.5, UI.RefrescarClub)
		else
			confirmarSalir = true
			UI.RefrescarClub()
			task.delay(3, function()
				confirmarSalir = false
			end)
		end
	end)
	salir.Parent = contenido
end

local botonClub = boton({
	Name = "BotonClub", Text = "👥 CLUB", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 60),
	Size = UDim2.fromOffset(130, 46), BackgroundColor3 = Color3.fromRGB(60, 120, 230), Parent = gui,
}, function()
	panelClub.Visible = not panelClub.Visible
	UI.RefrescarClub()
end)
botonClub.Parent = gui
task.spawn(function()
	while true do
		task.wait(2)
		if panelClub.Visible then
			UI.RefrescarClub()
		end
	end
end)

---------------------------------------------------------------- duelo
local hudDuelo = nuevo("Frame", { Name = "HUDDuelo", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = gui })
local function barraVida(lado)
	local f = nuevo("Frame", {
		AnchorPoint = Vector2.new(lado == 1 and 0 or 1, 0), Position = lado == 1 and UDim2.new(0, 30, 0, 50) or UDim2.new(1, -30, 0, 50),
		Size = UDim2.new(0.4, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(30, 10, 10), Parent = hudDuelo,
	}, { esquinas(6), borde(Color3.new(0, 0, 0), 3) })
	local atraso = nuevo("Frame", { AnchorPoint = Vector2.new(lado == 1 and 0 or 1, 0), Position = UDim2.fromScale(lado == 1 and 0 or 1, 0), Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(255, 240, 200), Parent = f }, { esquinas(6) })
	local relleno = nuevo("Frame", { AnchorPoint = Vector2.new(lado == 1 and 0 or 1, 0), Position = UDim2.fromScale(lado == 1 and 0 or 1, 0), Size = UDim2.fromScale(1, 1), BackgroundColor3 = lado == 1 and Color3.fromRGB(70, 200, 90) or Color3.fromRGB(220, 60, 60), Parent = f }, { esquinas(6) })
	local nombre = texto({ Text = "", Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, -28), TextXAlignment = lado == 1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right, Parent = f })
	local num = texto({ Text = "", Size = UDim2.new(1, -12, 1, -6), Position = UDim2.fromOffset(6, 3), Font = FUENTE2, TextXAlignment = lado == 1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right, ZIndex = 3, Parent = f })
	return { Relleno = relleno, Atraso = atraso, Nombre = nombre, Num = num }
end
local vidaYo, vidaRival = barraVida(1), barraVida(2)
texto({ Text = "VS", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 44), Size = UDim2.fromOffset(80, 42), TextColor3 = Color3.fromRGB(255, 70, 70), Parent = hudDuelo })
texto({
	Text = "Clic: combo  ·  E / Clic dcho: ataque pesado  ·  F (mantener): bloquear  ·  Q: esquivar",
	AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16), Size = UDim2.new(0.7, 0, 0, 22),
	Font = FUENTE2, TextColor3 = Color3.fromRGB(210, 210, 220), Parent = hudDuelo,
})

function UI.MostrarHUDDuelo(visible, nombreYo, nombreRival)
	hudDuelo.Visible = visible
	if nombreYo then
		vidaYo.Nombre.Text = nombreYo
		vidaRival.Nombre.Text = nombreRival
	end
end

function UI.Vida(esYo, vida, max)
	local b = esYo and vidaYo or vidaRival
	local alpha = math.clamp(vida / math.max(max, 1), 0, 1)
	b.Relleno.Size = UDim2.fromScale(alpha, 1)
	tween(b.Atraso, 0.6, { Size = UDim2.fromScale(alpha, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	b.Num.Text = ("%d / %d"):format(vida, max)
end

-- Barras de cine
local barraArriba = nuevo("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 15, Parent = guiTop })
local barraAbajo = nuevo("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 15, Parent = guiTop })
function UI.Cine(activo)
	local alto = activo and UDim2.fromScale(1, 0.12) or UDim2.fromScale(1, 0)
	tween(barraArriba, 0.6, { Size = alto })
	tween(barraAbajo, 0.6, { Size = alto })
end

function UI.TextoGrande(t, color, duracion)
	local l = texto({ Text = t, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.42), Size = UDim2.fromScale(0.7, 0.2), TextColor3 = color or Color3.new(1, 1, 1), ZIndex = 18, Parent = guiTop })
	nuevo("UIStroke", { Thickness = 5, Color = Color3.new(0, 0, 0), Parent = l })
	local s = nuevo("UIScale", { Scale = 2.5, Parent = l })
	tween(s, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
	task.delay(duracion or 0.8, function()
		tween(l, 0.25, { TextTransparency = 1 })
		tween(s, 0.25, { Scale = 0.6 })
		task.wait(0.3)
		l:Destroy()
	end)
end

function UI.Resultado(gane, empate, recompensa, ganador)
	local color = empate and Color3.fromRGB(200, 200, 220) or (gane and ORO or Color3.fromRGB(200, 50, 50))
	local fondo = nuevo("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = gane and Color3.fromRGB(40, 30, 0) or Color3.fromRGB(30, 0, 0), BackgroundTransparency = 1, ZIndex = 16, Parent = guiTop })
	tween(fondo, 1, { BackgroundTransparency = 0.45 })
	local titulo = texto({ Text = empate and "EMPATE" or (gane and "VICTORIA" or "DERROTA"), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.4), Size = UDim2.fromScale(0.8, 0.22), TextColor3 = color, ZIndex = 17, Parent = fondo })
	nuevo("UIStroke", { Thickness = 6, Color = Color3.new(0, 0, 0), Parent = titulo })
	local s = nuevo("UIScale", { Scale = 4, Parent = titulo })
	tween(s, 0.6, { Scale = 1 }, Enum.EasingStyle.Bounce)
	local sub = texto({
		Text = (ganador and not gane and (ganador .. " gana el duelo  ·  ") or "") .. "+" .. recompensa .. " FUERZA",
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.56), Size = UDim2.fromScale(0.6, 0.06), Font = FUENTE2, TextTransparency = 1, ZIndex = 17, Parent = fondo,
	})
	task.delay(0.6, function()
		tween(sub, 0.5, { TextTransparency = 0 })
	end)
	return function()
		tween(fondo, 0.5, { BackgroundTransparency = 1 })
		tween(titulo, 0.5, { TextTransparency = 1, TextStrokeTransparency = 1 })
		tween(sub, 0.5, { TextTransparency = 1 })
		task.delay(0.55, function()
			fondo:Destroy()
		end)
	end
end

function UI.MostrarPrincipal(visible)
	panelFuerza.Visible = visible
	botonClub.Visible = visible
	if not visible then
		panelClub.Visible = false
		aviso.Visible = false
	end
	hotbar.Visible = visible
end

return UI
