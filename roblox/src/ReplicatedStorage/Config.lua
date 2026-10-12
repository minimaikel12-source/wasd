--[[
	CONFIG — todos los números ajustables del juego.
	Lo leen el servidor (ServerScriptService/Main) y el cliente (StarterPlayerScripts/Client).
	El servidor SIEMPRE valida con estos valores: cambiar algo en el cliente no da ventaja.
]]

local Config = {}

---------------------------------------------------------------------------
-- DEPURACIÓN / PRUEBAS
---------------------------------------------------------------------------
Config.Debug = {
	-- Comandos de chat SOLO en Studio: "/fuerza 5000", "/dias 7", "/duelo"
	ComandosEnStudio = true,
}

---------------------------------------------------------------------------
-- GUARDADO
---------------------------------------------------------------------------
Config.Guardado = {
	NombreDataStore = "FuerzaClubs_v1",
	IntervaloAutoguardado = 90, -- segundos
	Reintentos = 3,
}

---------------------------------------------------------------------------
-- ENTRENAMIENTO (Workspace/Entrenamiento). La clave = atributo "Clave" del modelo.
---------------------------------------------------------------------------
Config.Entrenamiento = {
	Cooldown = 1.1, -- segundos entre repeticiones (anti-spam, validado en servidor)
	DistanciaMaxima = 14, -- studs desde el equipo
	Equipos = {
		PesasLigeras = { Fuerza = 1, Requisito = 0, Anim = "Entrenar_Pesas" },
		SacoBoxeo = { Fuerza = 2, Requisito = 0, Anim = "Entrenar_Punetazos" },
		PesasPesadas = { Fuerza = 6, Requisito = 150, Anim = "Entrenar_Pesas" },
		SacoAcero = { Fuerza = 20, Requisito = 800, Anim = "Entrenar_Punetazos" },
		RocaTitan = { Fuerza = 75, Requisito = 4000, Anim = "Entrenar_Pesas" },
		YunqueColosal = { Fuerza = 250, Requisito = 15000, Anim = "Entrenar_Punetazos" },
	},
	-- Muñecos de práctica (habilidades)
	Munecos = {
		FuerzaPorKO = 15,
		Reaparicion = 5, -- segundos
	},
}

---------------------------------------------------------------------------
-- HABILIDADES (en orden de desbloqueo)
-- Efecto: tipo de efecto/hitbox que ejecuta el servidor y dibuja el cliente.
---------------------------------------------------------------------------
Config.Habilidades = {
	{
		Nombre = "Puño Potente", Id = "PunoPotente", Tecla = "Q",
		Fuerza = 25, Cooldown = 2, Dano = 60, Alcance = 9, Retraso = 0.33,
		Empuje = 40, Efecto = "Golpe", Anim = "Hab_PunoPotente", Temblor = 0.25,
	},
	{
		Nombre = "Patada Giratoria", Id = "PatadaGiratoria", Tecla = "E",
		Fuerza = 200, Cooldown = 4, Dano = 110, Alcance = 11, Retraso = 0.4,
		Empuje = 60, Efecto = "Giro", Anim = "Hab_PatadaGiratoria", Temblor = 0.35,
	},
	{
		Nombre = "Embestida", Id = "Embestida", Tecla = "R",
		Fuerza = 900, Cooldown = 6, Dano = 180, Alcance = 6, Retraso = 0.3,
		Distancia = 45, DuracionDash = 0.35,
		Empuje = 90, Efecto = "Embestida", Anim = "Hab_Embestida", Temblor = 0.5,
	},
	{
		Nombre = "Onda Expansiva", Id = "OndaExpansiva", Tecla = "F",
		Fuerza = 3000, Cooldown = 9, Dano = 300, Alcance = 30, Retraso = 0.53,
		Empuje = 120, Efecto = "Onda", Anim = "Hab_OndaExpansiva", Temblor = 0.9,
	},
	{
		Nombre = "Salto Sísmico", Id = "SaltoSismico", Tecla = "G",
		Fuerza = 9000, Cooldown = 12, Dano = 500, Alcance = 38, Retraso = 0.95,
		AlturaSalto = 60, Empuje = 160, Efecto = "Sismo", Anim = "Hab_SaltoSismico", Temblor = 1.4,
	},
	{
		Nombre = "Furia del Titán", Id = "FuriaTitan", Tecla = "T",
		Fuerza = 25000, Cooldown = 20, Dano = 900, Alcance = 60, Retraso = 1.35,
		Empuje = 220, Efecto = "Titan", Anim = "Hab_FuriaTitan", Temblor = 2.2,
	},
}
Config.HabilidadesEnDuelo = false -- el duelo es solo de espadas

---------------------------------------------------------------------------
-- CLUBS Y MENTORÍA
---------------------------------------------------------------------------
Config.Mentoria = {
	MaxMiembros = 2,
	TiempoInvitacion = 30, -- segundos para aceptar
	BonusAprendiz = 2, -- multiplicador de fuerza al entrenar cerca del mentor
	DistanciaBonus = 40, -- studs
	DiferenciaParaAviso = 0.10, -- el aviso "Ayuda a X" sale si el aprendiz tiene un 10% menos de fuerza o más
	SegundosPorDia = 86400, -- pon 10 para probar rápido "días" en Studio
}

---------------------------------------------------------------------------
-- DUELO
---------------------------------------------------------------------------
Config.Duelo = {
	DiasMinimos = 7, -- días en el club antes de poder hacer el duelo
	MargenFuerza = 0.10, -- "misma fuerza": diferencia relativa <= 10 %
	FuerzaMinima = 100, -- los dos necesitan al menos esto
	TiempoInvitacion = 45,
	CooldownInvitacion = 120, -- segundos entre invitaciones automáticas
	CuentaAtras = 3,
	DuracionMaxima = 240, -- si nadie gana, gana quien tenga más vida

	Vida = 1000,
	Combo = { 70, 70, 120 }, -- daño de cada golpe del combo (clic)
	ComboVentana = 0.9, -- segundos para encadenar el siguiente golpe
	ComboCooldown = 0.38, -- entre golpes
	ComboRetraso = 0.18, -- momento del impacto
	Pesado = { Dano = 220, Cooldown = 1.6, Retraso = 0.6, RompeBloqueo = true },
	AlcanceEspada = 9, -- profundidad de la hitbox delante del jugador
	AnchoHitbox = 8,
	BloqueoReduccion = 0.8, -- 80 % menos daño bloqueando de frente
	BloqueoVelocidad = 6, -- WalkSpeed mientras bloquea
	Esquiva = { Cooldown = 1.2, Invulnerable = 0.35, Velocidad = 70 },
	Aturdimiento = 0.5, -- al romper un bloqueo

	RecompensaGanador = 500,
	RecompensaPerdedor = 150,
	RetornoTras = 7, -- segundos de pantalla final antes de volver

	-- Agarre de la espada (Tool.Grip). Si ves la hoja mal orientada, cambia GripRot.
	GripPos = { 0, -0.2, 0 },
	GripRot = { 0, 0, 0 }, -- grados
}

Config.Teclas = {
	DueloPesado = { "E", "MouseButton2" },
	DueloBloqueo = "F", -- mantener
	DueloEsquiva = "Q",
}

---------------------------------------------------------------------------
-- ARENA / AMBIENTE (solo se aplica en el cliente de los duelistas)
---------------------------------------------------------------------------
Config.Ambiente = {
	ClockTime = 0.5,
	Brightness = 0.6,
	Ambient = { 25, 28, 38 },
	OutdoorAmbient = { 35, 38, 50 },
	FogColor = { 30, 33, 42 },
	FogStart = 10,
	FogEnd = 260,
	DensidadAtmosfera = 0.55,
	Relampago = { Min = 4, Max = 11 }, -- segundos entre relámpagos
	LluviaRate = 900,
}

---------------------------------------------------------------------------
-- SONIDOS (rellena con IDs de la Creator Store: Toolbox → Audio).
-- Los "rbxasset://" vienen con Roblox y funcionan siempre.
---------------------------------------------------------------------------
Config.Sonidos = {
	MusicaDuelo = "", -- p.ej. "rbxassetid://123456" (música épica)
	Lluvia = "", -- bucle de lluvia
	Trueno = "", -- si está vacío se usa un respaldo grave
	Desbloqueo = "rbxasset://sounds/electronicpingshort.wav",
	Impacto = "rbxasset://sounds/collide.wav",
	Explosion = "rbxasset://sounds/Rocket shot.wav",
	Tajo = "rbxasset://sounds/swordslash.wav",
	Estocada = "rbxasset://sounds/swordlunge.wav",
	Desenvainar = "rbxasset://sounds/unsheath.wav",
}

---------------------------------------------------------------------------
-- ANIMACIONES — pega aquí los IDs tras publicar cada KeyframeSequence de
-- ServerStorage/Animaciones (ver README). Formato: "rbxassetid://123456789".
-- Si está vacío se usa el respaldo procedural (ReplicatedStorage/AnimData).
---------------------------------------------------------------------------
Config.Animaciones = {
	Entrenar_Pesas = "",
	Entrenar_Punetazos = "",
	Hab_PunoPotente = "",
	Hab_PatadaGiratoria = "",
	Hab_Embestida = "",
	Hab_OndaExpansiva = "",
	Hab_SaltoSismico = "",
	Hab_FuriaTitan = "",
	Espada_Desenvainar = "",
	Espada_Combo1 = "",
	Espada_Combo2 = "",
	Espada_Combo3 = "",
	Espada_Pesado = "",
	Espada_Bloqueo = "",
	Espada_Esquiva = "",
	Espada_Impacto = "",
	Victoria = "",
	Derrota = "",
}

-- Utilidades compartidas -------------------------------------------------
function Config.ObtenerHabilidad(id)
	for _, h in ipairs(Config.Habilidades) do
		if h.Id == id then
			return h
		end
	end
	return nil
end

-- ¿Tienen "la misma fuerza"? (diferencia relativa dentro del margen)
function Config.MismaFuerza(a, b)
	local mayor = math.max(a, b)
	if mayor <= 0 then
		return false
	end
	return math.abs(a - b) / mayor <= Config.Duelo.MargenFuerza
end

function Config.Color(t)
	return Color3.fromRGB(t[1], t[2], t[3])
end

return Config
