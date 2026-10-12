--[[
	Entrenamiento — equipos de Workspace/Entrenamiento (ProximityPrompt) y muñecos de práctica.
	Todo se valida aquí: cooldown, distancia, fuerza requerida y bonus de mentor.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Config)
local Datos = require(script.Parent.Datos)
local Red = require(script.Parent.Red)

local Entrenamiento = {}
Entrenamiento.Multiplicador = function(_player)
	return 1, nil
end -- lo sustituye Clubs (bonus de mentor)

local ultimoEntreno = {} -- [player] = os.clock()

local function alActivar(player, equipo, prompt)
	local clave = equipo:GetAttribute("Clave")
	local def = Config.Entrenamiento.Equipos[clave]
	local perfil = Datos.Perfiles[player]
	if not def or not perfil or player:GetAttribute("EnDuelo") then
		return
	end
	local raiz = Red.Raiz(player)
	if not raiz then
		return
	end
	local ahora = os.clock()
	if ahora - (ultimoEntreno[player] or 0) < Config.Entrenamiento.Cooldown then
		return
	end
	local parte = prompt.Parent
	if parte:IsA("BasePart") and (parte.Position - raiz.Position).Magnitude > Config.Entrenamiento.DistanciaMaxima then
		return
	end
	if perfil.Fuerza < def.Requisito then
		Red.Mensaje(player, ("Necesitas %d de Fuerza para este equipo"):format(def.Requisito), Color3.fromRGB(255, 90, 90))
		return
	end
	ultimoEntreno[player] = ahora
	local mult, mentor = Entrenamiento.Multiplicador(player)
	local ganancia = math.floor(def.Fuerza * mult)
	Red.AnimTodos(player.Character, def.Anim)
	Datos.SumarFuerza(player, ganancia)
	Red.Notificar(player, "Ganancia", {
		Cantidad = ganancia,
		Bonus = mult > 1 and mult or nil,
		Mentor = mentor and mentor.Name or nil,
		Cooldown = Config.Entrenamiento.Cooldown,
	})
end

---------------------------------------------------------------- Muñecos
local munecos = {}

local function partePrincipal(muneco)
	return muneco:FindFirstChild("Cuerpo") or muneco.PrimaryPart or muneco:FindFirstChildWhichIsA("BasePart")
end

function Entrenamiento.ObtenerMunecos()
	return munecos
end

function Entrenamiento.PosicionMuneco(muneco)
	local p = partePrincipal(muneco)
	return p and p.Position
end

local function fijarVisible(muneco, visible)
	for _, d in ipairs(muneco:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Transparency = visible and 0 or 0.85
			d.CanCollide = visible
		end
	end
end

-- Devuelve true si el golpe dejó KO al muñeco.
function Entrenamiento.DanarMuneco(muneco, dano, atacante)
	local vida = muneco:GetAttribute("Vida") or 0
	if vida <= 0 then
		return false
	end
	vida = math.max(0, vida - dano)
	muneco:SetAttribute("Vida", vida)
	if vida <= 0 then
		fijarVisible(muneco, false)
		if atacante then
			local premio = Config.Entrenamiento.Munecos.FuerzaPorKO
			Datos.SumarFuerza(atacante, premio)
			Red.Notificar(atacante, "Ganancia", { Cantidad = premio, Texto = "¡KO!" })
		end
		task.delay(Config.Entrenamiento.Munecos.Reaparicion, function()
			muneco:SetAttribute("Vida", muneco:GetAttribute("VidaMax"))
			fijarVisible(muneco, true)
		end)
		return true
	end
	return false
end

function Entrenamiento.Iniciar()
	local zona = Workspace:WaitForChild("Entrenamiento")
	for _, d in ipairs(zona:GetDescendants()) do
		if d:IsA("ProximityPrompt") then
			local equipo = d.Parent
			while equipo and equipo ~= zona and not equipo:GetAttribute("Clave") do
				equipo = equipo.Parent
			end
			if equipo and equipo ~= zona then
				local def = Config.Entrenamiento.Equipos[equipo:GetAttribute("Clave")]
				if def then
					equipo:SetAttribute("Requisito", def.Requisito)
					equipo:SetAttribute("Ganancia", def.Fuerza)
				end
				d.Triggered:Connect(function(player)
					alActivar(player, equipo, d)
				end)
			end
		end
	end
	local carpeta = zona:FindFirstChild("Munecos")
	if carpeta then
		for _, m in ipairs(carpeta:GetChildren()) do
			if m:IsA("Model") then
				m:SetAttribute("VidaMax", m:GetAttribute("VidaMax") or 500)
				m:SetAttribute("Vida", m:GetAttribute("VidaMax"))
				table.insert(munecos, m)
			end
		end
	end
	game:GetService("Players").PlayerRemoving:Connect(function(p)
		ultimoEntreno[p] = nil
	end)
end

return Entrenamiento
