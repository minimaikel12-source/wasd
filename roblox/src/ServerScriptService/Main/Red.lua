--[[
	Red — atajos para los RemoteEvents de ReplicatedStorage/Remotes.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = {}
Red.Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Notificación de interfaz: Tipo = "Ganancia" | "Mensaje" | "Desbloqueo" | ...
function Red.Notificar(player, tipo, datos)
	datos = datos or {}
	datos.Tipo = tipo
	Red.Remotes.Notificar:FireClient(player, datos)
end

function Red.Mensaje(player, texto, color)
	Red.Notificar(player, "Mensaje", { Texto = texto, Color = color })
end

-- Animación iniciada por el servidor: la ven todos (incluido el dueño).
function Red.AnimTodos(personaje, nombre, opciones)
	Red.Remotes.Anim:FireAllClients(personaje, nombre, opciones or {})
end

-- Animación que el propio cliente ya reprodujo (predicción): solo al resto.
function Red.AnimOtros(player, nombre, opciones)
	local personaje = player.Character
	for _, otro in ipairs(Players:GetPlayers()) do
		if otro ~= player then
			Red.Remotes.Anim:FireClient(otro, personaje, nombre, opciones or {})
		end
	end
end

function Red.DetenerAnim(personaje)
	Red.Remotes.Anim:FireAllClients(personaje, nil, { Detener = true })
end

function Red.Efecto(datos)
	Red.Remotes.Efecto:FireAllClients(datos)
end

-- Empuje: el cliente dueño del personaje aplica la física (tiene la propiedad de red).
function Red.Empujar(player, velocidad)
	Red.Remotes.Empuje:FireClient(player, velocidad)
end

function Red.Raiz(player)
	local personaje = player and player.Character
	local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
	local raiz = personaje and personaje:FindFirstChild("HumanoidRootPart")
	if humanoid and raiz and humanoid.Health > 0 then
		return raiz, humanoid
	end
	return nil
end

return Red
