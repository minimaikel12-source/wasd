--[[
	Duelo — duelo final de espadas entre mentor y aprendiz.
	Requisitos: días mínimos en el club + misma fuerza (margen de Config) + ambos en el servidor.
	Toda la lógica de combate (cooldowns, hitbox, bloqueo, esquiva, vida) se valida aquí.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Config)
local Datos = require(script.Parent.Datos)
local Red = require(script.Parent.Red)
local Clubs = require(script.Parent.Clubs)

local C = Config.Duelo
local Duelo = {}

local duelos = {} -- [player] = duelo
local invitaciones = {} -- [clubId] = { A, B, Aceptados = {}, Expira, Forzado }
local ultimaInvitacion = {} -- [clubId] = os.clock()

local DURACION_INTRO = 3.5

---------------------------------------------------------------- elegibilidad
function Duelo.Elegible(player)
	local perfil = Datos.Perfiles[player]
	if not perfil or not perfil.Club then
		return false, "No estás en un club."
	end
	if duelos[player] then
		return false, "Ya estás en un duelo."
	end
	local dias = Clubs.DiasEnClub(player)
	if dias < C.DiasMinimos then
		return false, ("Faltan %.1f días de mentoría (%d mínimos)."):format(C.DiasMinimos - dias, C.DiasMinimos)
	end
	local otro = Clubs.Companero(player)
	if not otro then
		return false, "Tu compañero tiene que estar en este servidor."
	end
	local a, b = perfil.Fuerza, Datos.Perfiles[otro].Fuerza
	if math.min(a, b) < C.FuerzaMinima then
		return false, ("Los dos necesitáis al menos %d de Fuerza."):format(C.FuerzaMinima)
	end
	if not Config.MismaFuerza(a, b) then
		return false, ("Aún no tenéis la misma fuerza (%d vs %d, margen %d%%)."):format(a, b, C.MargenFuerza * 100)
	end
	if duelos[otro] then
		return false, "Tu compañero está ocupado."
	end
	return true, nil, otro
end

---------------------------------------------------------------- invitaciones
local function enviarInvitacion(a, b, forzado)
	local club = Datos.Perfiles[a].Club
	if not club then
		return
	end
	local inv = invitaciones[club.Id]
	if inv and inv.Expira > os.clock() then
		return
	end
	invitaciones[club.Id] = { A = a, B = b, Aceptados = {}, Expira = os.clock() + C.TiempoInvitacion, Forzado = forzado }
	ultimaInvitacion[club.Id] = os.clock()
	for _, p in ipairs({ a, b }) do
		local rival = p == a and b or a
		Red.Remotes.DueloInvitacion:FireClient(p, { Rival = rival.DisplayName, Tiempo = C.TiempoInvitacion })
	end
end

function Duelo.Forzar(player)
	local otro = Clubs.Companero(player)
	if otro and not duelos[player] and not duelos[otro] then
		local club = Datos.Perfiles[player].Club
		invitaciones[club.Id] = nil
		enviarInvitacion(player, otro, true)
		return true
	end
	return false
end

local function invitacionDe(player)
	local perfil = Datos.Perfiles[player]
	local inv = perfil and perfil.Club and invitaciones[perfil.Club.Id]
	if inv and inv.Expira > os.clock() and (inv.A == player or inv.B == player) then
		return inv, perfil.Club.Id
	end
	return nil
end

---------------------------------------------------------------- utilidades
local function rivalDe(d, p)
	return p == d.A and d.B or d.A
end

local function fijarMovimiento(d, p, velocidad, salto)
	local _, humanoid = Red.Raiz(p)
	if humanoid then
		humanoid.WalkSpeed = velocidad or d.Original[p].WalkSpeed
		humanoid.JumpPower = salto or d.Original[p].JumpPower
		humanoid.JumpHeight = salto and 0 or d.Original[p].JumpHeight
	end
end

local function darEspada(d, p)
	local plantilla = ServerStorage:FindFirstChild("Espadas") and ServerStorage.Espadas:FindFirstChildWhichIsA("Tool")
	local _, humanoid = Red.Raiz(p)
	if not plantilla or not humanoid then
		warn("[Duelo] Falta ServerStorage/Espadas/<Tool>")
		return
	end
	local espada = plantilla:Clone()
	espada.Name = "EspadaDuelo"
	local handle = espada:FindFirstChild("Handle")
	for _, parte in ipairs(espada:GetDescendants()) do
		if parte:IsA("BasePart") then
			parte.Anchored = false
			parte.CanCollide = false
			parte.Massless = true
			if parte ~= handle then
				local w = Instance.new("WeldConstraint")
				w.Part0, w.Part1 = handle, parte
				w.Parent = parte
			end
		end
	end
	espada.Grip = CFrame.new(C.GripPos[1], C.GripPos[2], C.GripPos[3])
		* CFrame.Angles(math.rad(C.GripRot[1]), math.rad(C.GripRot[2]), math.rad(C.GripRot[3]))
	espada.Parent = p.Backpack
	humanoid:EquipTool(espada)
	-- No se puede guardar la espada durante el duelo
	espada.Unequipped:Connect(function()
		if duelos[p] == d and not d.Terminado then
			task.defer(function()
				local _, h = Red.Raiz(p)
				if h and espada.Parent == p.Backpack then
					h:EquipTool(espada)
				end
			end)
		end
	end)
	d.Espadas[p] = espada
end

local function limpiar(d, p)
	if d.Espadas[p] then
		d.Espadas[p]:Destroy()
	end
	for _, nombre in ipairs({ "EnDuelo", "DueloRival", "DueloVida", "DueloVidaMax" }) do
		p:SetAttribute(nombre, nil)
	end
	if p.Character and p.Character == d.Personajes[p] then
		fijarMovimiento(d, p)
		Red.DetenerAnim(p.Character)
		p.Character:PivotTo(d.Retorno[p])
	end
	Red.Remotes.DueloEstado:FireClient(p, { Fase = "Salir" })
end

---------------------------------------------------------------- final
local function terminar(d, ganador)
	if d.Terminado then
		return
	end
	d.Terminado = true
	d.Fase = "Fin"
	for _, con in ipairs(d.Conexiones) do
		con:Disconnect()
	end
	local presentes = {}
	for _, p in ipairs({ d.A, d.B }) do
		if p.Parent then
			table.insert(presentes, p)
		end
	end
	for _, p in ipairs(presentes) do
		local gane = p == ganador
		local recompensa = ganador == nil and C.RecompensaPerdedor or (gane and C.RecompensaGanador or C.RecompensaPerdedor)
		fijarMovimiento(d, p, 0, 0)
		Red.Remotes.DueloEstado:FireClient(p, {
			Fase = "Fin",
			Ganador = ganador and ganador.DisplayName or nil,
			Gane = gane,
			Empate = ganador == nil,
			Recompensa = recompensa,
			GanadorJugador = ganador,
		})
		if p.Character then
			Red.AnimTodos(p.Character, gane and "Victoria" or "Derrota", { Mantener = true })
		end
		Datos.SumarFuerza(p, recompensa)
		if gane then
			Datos.Perfiles[p].DuelosGanados += 1
			Datos.Sincronizar(p)
		end
	end
	task.delay(C.RetornoTras, function()
		for _, p in ipairs(presentes) do
			if p.Parent then
				limpiar(d, p)
				task.spawn(Datos.Guardar, p)
			end
		end
		if duelos[d.A] == d then
			duelos[d.A] = nil
		end
		if duelos[d.B] == d then
			duelos[d.B] = nil
		end
	end)
end

---------------------------------------------------------------- inicio
local function iniciar(a, b)
	local arena = Workspace:FindFirstChild("Arena")
	if not arena or not arena:FindFirstChild("PuntoA") or not arena:FindFirstChild("PuntoB") then
		warn("[Duelo] Falta Workspace/Arena con PuntoA y PuntoB")
		return
	end
	if not Red.Raiz(a) or not Red.Raiz(b) then
		return
	end
	local d = {
		A = a, B = b, Fase = "Intro", Terminado = false,
		Vida = { [a] = C.Vida, [b] = C.Vida },
		Estado = {}, Retorno = {}, Original = {}, Espadas = {}, Personajes = {}, Conexiones = {},
	}
	for _, p in ipairs({ a, b }) do
		local raiz, humanoid = Red.Raiz(p)
		duelos[p] = d
		d.Estado[p] = {
			Bloqueando = false, Invulnerable = 0, Aturdido = 0,
			CdLigero = 0, CdPesado = 0, CdEsquiva = 0, ComboIdx = 0, UltimoLigero = 0,
		}
		d.Retorno[p] = raiz.CFrame
		d.Personajes[p] = p.Character
		d.Original[p] = { WalkSpeed = humanoid.WalkSpeed, JumpPower = humanoid.JumpPower, JumpHeight = humanoid.JumpHeight }
		local punto = p == a and arena.PuntoA or arena.PuntoB
		p.Character:PivotTo(punto.CFrame + Vector3.new(0, 2, 0))
		fijarMovimiento(d, p, 0, 0)
		p:SetAttribute("EnDuelo", true)
		p:SetAttribute("DueloRival", rivalDe(d, p).DisplayName)
		p:SetAttribute("DueloVidaMax", C.Vida)
		p:SetAttribute("DueloVida", C.Vida)
		table.insert(d.Conexiones, humanoid.Died:Connect(function()
			terminar(d, rivalDe(d, p))
		end))
	end
	for _, p in ipairs({ a, b }) do
		Red.Remotes.DueloEstado:FireClient(p, {
			Fase = "Intro",
			Rival = rivalDe(d, p),
			Centro = arena:FindFirstChild("Centro") and arena.Centro.Position or arena.PuntoA.Position,
			Duracion = DURACION_INTRO,
		})
	end
	task.wait(1.6)
	for _, p in ipairs({ a, b }) do
		if not d.Terminado then
			darEspada(d, p)
			if p.Character then
				Red.AnimTodos(p.Character, "Espada_Desenvainar")
			end
		end
	end
	task.wait(DURACION_INTRO - 1.6)
	if d.Terminado then
		return
	end
	d.Fase = "Cuenta"
	for _, p in ipairs({ a, b }) do
		Red.Remotes.DueloEstado:FireClient(p, { Fase = "Cuenta", Segundos = C.CuentaAtras })
	end
	task.wait(C.CuentaAtras)
	if d.Terminado then
		return
	end
	d.Fase = "Lucha"
	for _, p in ipairs({ a, b }) do
		fijarMovimiento(d, p)
		Red.Remotes.DueloEstado:FireClient(p, { Fase = "Lucha" })
	end
	task.delay(C.DuracionMaxima, function()
		if not d.Terminado then
			local va, vb = d.Vida[a], d.Vida[b]
			if va == vb then
				terminar(d, nil)
			else
				terminar(d, va > vb and a or b)
			end
		end
	end)
end

---------------------------------------------------------------- combate
local function golpear(d, atacante, dano, pesado)
	if d.Terminado or d.Fase ~= "Lucha" then
		return
	end
	local ahora = os.clock()
	if d.Estado[atacante].Aturdido > ahora then
		return
	end
	local rival = rivalDe(d, atacante)
	local ra, rr = Red.Raiz(atacante), Red.Raiz(rival)
	if not ra or not rr then
		return
	end
	Red.Efecto({ Tipo = "Tajo", Origen = atacante, Pesado = pesado })
	-- Hitbox validada en servidor: caja delante del atacante
	local rel = ra.CFrame:PointToObjectSpace(rr.Position)
	local profundidad = -rel.Z
	if profundidad < -1 or profundidad > C.AlcanceEspada + 1.5 or math.abs(rel.X) > C.AnchoHitbox / 2 or math.abs(rel.Y) > 6 then
		return
	end
	local se = d.Estado[rival]
	if se.Invulnerable > ahora then
		Red.Efecto({ Tipo = "Texto", Pos = rr.Position + Vector3.new(0, 3, 0), Texto = "¡ESQUIVADO!" })
		return
	end
	local deFrente = rr.CFrame.LookVector:Dot((ra.Position - rr.Position).Unit) > 0.2
	local bloqueado = se.Bloqueando and deFrente
	if bloqueado and pesado and C.Pesado.RompeBloqueo then
		bloqueado = false
		se.Bloqueando = false
		se.Aturdido = ahora + C.Aturdimiento
		fijarMovimiento(d, rival)
		Red.Efecto({ Tipo = "Texto", Pos = rr.Position + Vector3.new(0, 3, 0), Texto = "¡GUARDIA ROTA!" })
	end
	if bloqueado then
		dano = dano * (1 - C.BloqueoReduccion)
	end
	d.Vida[rival] = math.max(0, d.Vida[rival] - math.floor(dano))
	rival:SetAttribute("DueloVida", d.Vida[rival])
	Red.Efecto({
		Tipo = "GolpeEspada",
		Pos = rr.Position,
		Dir = (rr.Position - ra.Position).Unit,
		Bloqueado = bloqueado,
		Pesado = pesado,
		Fuerza = pesado and 0.9 or 0.35,
		Dano = math.floor(dano),
	})
	if not bloqueado then
		Red.AnimTodos(rival.Character, "Espada_Impacto")
		local dir = (rr.Position - ra.Position) * Vector3.new(1, 0, 1)
		dir = dir.Magnitude > 0 and dir.Unit or ra.CFrame.LookVector
		Red.Empujar(rival, dir * (pesado and 65 or 28) + Vector3.new(0, pesado and 25 or 8, 0))
	end
	if d.Vida[rival] <= 0 then
		terminar(d, atacante)
	end
end

local function accion(player, tipo)
	local d = duelos[player]
	if not d or d.Fase ~= "Lucha" or d.Terminado or type(tipo) ~= "string" then
		return
	end
	local st = d.Estado[player]
	local ahora = os.clock()
	if st.Aturdido > ahora and tipo ~= "BloqueoOff" then
		return
	end
	if tipo == "Ligero" then
		if st.Bloqueando or ahora < st.CdLigero then
			return
		end
		st.CdLigero = ahora + C.ComboCooldown
		st.ComboIdx = (ahora - st.UltimoLigero <= C.ComboVentana) and (st.ComboIdx % #C.Combo + 1) or 1
		st.UltimoLigero = ahora
		Red.AnimOtros(player, "Espada_Combo" .. st.ComboIdx)
		task.delay(C.ComboRetraso, golpear, d, player, C.Combo[st.ComboIdx], false)
	elseif tipo == "Pesado" then
		if st.Bloqueando or ahora < st.CdPesado then
			return
		end
		st.CdPesado = ahora + C.Pesado.Cooldown
		st.CdLigero = ahora + C.Pesado.Retraso
		Red.AnimOtros(player, "Espada_Pesado")
		Red.Efecto({ Tipo = "CargaPesado", Origen = player })
		task.delay(C.Pesado.Retraso, golpear, d, player, C.Pesado.Dano, true)
	elseif tipo == "BloqueoOn" then
		st.Bloqueando = true
		fijarMovimiento(d, player, C.BloqueoVelocidad)
		Red.AnimOtros(player, "Espada_Bloqueo")
	elseif tipo == "BloqueoOff" then
		if st.Bloqueando then
			st.Bloqueando = false
			fijarMovimiento(d, player)
		end
		Red.AnimOtros(player, "Espada_Bloqueo", { Detener = true })
	elseif tipo == "Esquiva" then
		if ahora < st.CdEsquiva then
			return
		end
		st.CdEsquiva = ahora + C.Esquiva.Cooldown
		st.Invulnerable = ahora + C.Esquiva.Invulnerable
		Red.AnimOtros(player, "Espada_Esquiva")
	end
end

---------------------------------------------------------------- arranque
function Duelo.EnDuelo(player)
	return duelos[player] ~= nil
end

function Duelo.Iniciar()
	Red.Remotes.DueloAccion.OnServerEvent:Connect(accion)

	Red.Remotes.DueloResponder.OnServerEvent:Connect(function(player, aceptar)
		local inv, clubId = invitacionDe(player)
		if not inv then
			return
		end
		local otro = inv.A == player and inv.B or inv.A
		if aceptar ~= true then
			invitaciones[clubId] = nil
			Red.Mensaje(player, "Has rechazado el duelo.")
			if otro.Parent then
				Red.Mensaje(otro, player.DisplayName .. " ha rechazado el duelo.", Color3.fromRGB(255, 120, 120))
			end
			return
		end
		inv.Aceptados[player] = true
		if inv.Aceptados[otro] then
			invitaciones[clubId] = nil
			if otro.Parent and (inv.Forzado or Duelo.Elegible(player)) then
				task.spawn(iniciar, inv.A, inv.B)
			else
				Red.Mensaje(player, "El duelo ya no está disponible.")
			end
		else
			Red.Mensaje(player, "Esperando a que " .. otro.DisplayName .. " acepte...")
		end
	end)

	-- Petición manual desde el panel del club
	local ultimaPeticion = {}
	Red.Remotes.DueloSolicitar.OnServerEvent:Connect(function(player)
		if os.clock() - (ultimaPeticion[player] or 0) < 5 then
			return
		end
		ultimaPeticion[player] = os.clock()
		local ok, motivo, otro = Duelo.Elegible(player)
		if ok then
			enviarInvitacion(player, otro)
		else
			Red.Mensaje(player, motivo, Color3.fromRGB(255, 200, 90))
		end
	end)

	-- Abandono = derrota
	Players.PlayerRemoving:Connect(function(p)
		local d = duelos[p]
		if d then
			terminar(d, rivalDe(d, p))
		end
		ultimaPeticion[p] = nil
	end)

	-- Invitaciones automáticas cuando se cumplen las condiciones
	task.spawn(function()
		while true do
			task.wait(5)
			local vistos = {}
			for p, perfil in pairs(Datos.Perfiles) do
				local club = perfil.Club
				if club and not vistos[club.Id] then
					vistos[club.Id] = true
					local ok, _, otro = Duelo.Elegible(p)
					if ok and os.clock() - (ultimaInvitacion[club.Id] or -math.huge) >= C.CooldownInvitacion then
						enviarInvitacion(p, otro)
					end
				end
			end
		end
	end)
end

return Duelo
