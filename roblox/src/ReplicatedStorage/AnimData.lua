-- GENERADO por roblox/tools/generar.py - NO EDITAR A MANO (edita el generador y vuelve a ejecutarlo).
-- Mismos datos que las KeyframeSequence de ServerStorage/Animaciones; se usan para el respaldo
-- procedural (Motor6D.Transform) mientras no haya IDs publicados en Config.Animaciones.
-- Formato pista: {tiempo, rx, ry, rz, px, py, pz, EasingStyle, EasingDirection}  (grados / studs)
local AnimData = {}

AnimData["Entrenar_Pesas"] = {
	Duracion = 1.3,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 5, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 5, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 5, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 25, 0, -10, 0, 0, 0, "Cubic", "Out"}, {0.55, 175, 0, -12, 0, 0, 0, "Cubic", "Out"}, {0.75, 172, 0, -8, 0, 0, 0, "Linear", "Out"}, {0.9, 176, 0, -12, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 5, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 5, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 5, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 25, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.55, 175, 0, 12, 0, 0, 0, "Cubic", "Out"}, {0.75, 172, 0, 8, 0, 0, 0, "Linear", "Out"}, {0.9, 176, 0, 12, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 0, 0, 0, 0, -0.7, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, 0.15, 0, "Cubic", "Out"}, {0.75, 0, 0, 0, 0, 0.15, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, 0.15, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 8, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.75, 8, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 8, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.3, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Entrenar_Punetazos"] = {
	Duracion = 1.05,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 110, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 110, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 110, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, 110, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, 110, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, 20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, -20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, -20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 55, 0, -5, 0, 0, 0, "Cubic", "Out"}, {0.2, 92, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 55, 0, -5, 0, 0, 0, "Cubic", "Out"}, {0.5, 55, 0, -5, 0, 0, 0, "Cubic", "In"}, {0.58, 55, 0, -5, 0, 0, 0, "Linear", "Out"}, {0.8, 55, 0, -5, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 0, 15, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, 0, -25, 0, 0, 0, 0, "Linear", "Out"}, {0.8, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 125, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 135, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, 125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, -10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -10, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, -25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.34, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -15, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.58, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.8, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 40, 0, 5, 0, 0, 0, "Cubic", "Out"}, {0.2, 40, 0, 5, 0, 0, 0, "Linear", "Out"}, {0.34, 40, 0, 5, 0, 0, 0, "Cubic", "Out"}, {0.5, 15, 0, 15, 0, 0, 0, "Cubic", "In"}, {0.58, 95, 0, -5, 0, 0, 0, "Linear", "Out"}, {0.8, 40, 0, 5, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 0, 0, 0, 0, -0.25, 0, "Cubic", "Out"}, {0.2, 0, 0, 0, 0, -0.25, 0, "Linear", "Out"}, {0.34, 0, 0, 0, 0, -0.25, 0, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, -0.35, 0, "Cubic", "In"}, {0.58, 0, 0, 0, 0, -0.4, -0.3, "Linear", "Out"}, {0.8, 0, 0, 0, 0, -0.25, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 0, -30, 0, 0, 0, 0, "Linear", "Out"}, {0.34, 0, -30, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 0, -40, 0, 0, 0, 0, "Cubic", "In"}, {0.58, -10, 40, 0, 0, 0, 0, "Linear", "Out"}, {0.8, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_PunoPotente"] = {
	Duracion = 0.95,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 40, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, 70, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 70, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -15, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, 55, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 55, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 0, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, -55, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -55, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 75, 0, -10, 0, 0, 0, "Cubic", "In"}, {0.36, -25, 0, -15, 0, 0, 0, "Linear", "Out"}, {0.62, -25, 0, -15, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 0, 30, 0, 0, 0, 0, "Cubic", "In"}, {0.36, 0, -30, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 0, -30, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 125, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, -30, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -30, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -45, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.36, -10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, -35, 0, 35, 0, 0, 0, "Cubic", "In"}, {0.36, 95, 0, -5, 0, 0, 0, "Linear", "Out"}, {0.62, 95, 0, -5, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 0, 0, 0, 0, -0.5, 0.3, "Cubic", "In"}, {0.36, 0, 0, 0, 0, -0.65, -0.9, "Linear", "Out"}, {0.62, 0, 0, 0, 0, -0.6, -0.8, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.28, 12, -55, 0, 0, 0, 0, "Cubic", "In"}, {0.36, -22, 48, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -22, 48, 0, 0, 0, 0, "Cubic", "InOut"}, {0.95, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_PatadaGiratoria"] = {
	Duracion = 1.05,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 80, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.7, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.44, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.56, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.7, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, -50, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.44, -50, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.56, -50, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.7, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 20, 0, -30, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 0, -85, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 0, -85, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 0, -85, 0, 0, 0, "Cubic", "Out"}, {0.7, 20, 0, -40, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 80, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.7, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 10, 0, 80, 0, 0, 0, "Linear", "Out"}, {0.44, 10, 0, 95, 0, 0, 0, "Linear", "Out"}, {0.56, 10, 0, 80, 0, 0, 0, "Cubic", "Out"}, {0.7, 40, 0, 10, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.7, -70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 20, 0, 30, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 0, 85, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 0, 85, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 0, 85, 0, 0, 0, "Cubic", "Out"}, {0.7, 20, 0, 40, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 0, 0, 0, 0, -0.6, 0, "Cubic", "Out"}, {0.32, 0, 120, 0, 0, 0.6, 0, "Linear", "Out"}, {0.44, 0, 240, 0, 0, 0.7, 0, "Linear", "Out"}, {0.56, 0, 360, 0, 0, 0.4, 0, "Cubic", "Out"}, {0.7, 0, 0, 0, 0, -0.6, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.18, 0, -30, 0, 0, 0, 0, "Cubic", "Out"}, {0.32, 0, 25, -10, 0, 0, 0, "Linear", "Out"}, {0.44, 0, 25, -10, 0, 0, 0, "Linear", "Out"}, {0.56, 0, 25, -10, 0, 0, 0, "Cubic", "Out"}, {0.7, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.05, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_Embestida"] = {
	Duracion = 0.9,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, 100, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, 100, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, -55, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, -55, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, -40, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -45, 0, -15, 0, 0, 0, "Cubic", "In"}, {0.3, 70, 0, -10, 0, 0, 0, "Linear", "Out"}, {0.6, 70, 0, -10, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, 30, -20, 0, 0, 0, 0, "Linear", "Out"}, {0.6, 30, -20, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, 80, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, 80, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, 55, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, 65, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, 65, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -85, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, -20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.6, -20, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -45, 0, 15, 0, 0, 0, "Cubic", "In"}, {0.3, 25, 0, 25, 0, 0, 0, "Linear", "Out"}, {0.6, 25, 0, 25, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -15, 0, 0, 0, -0.8, 0.2, "Cubic", "In"}, {0.3, -20, 0, 0, 0, -0.5, -0.6, "Linear", "Out"}, {0.6, -18, 0, 0, 0, -0.5, -0.6, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.22, -40, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.3, -45, 35, 0, 0, 0, 0, "Linear", "Out"}, {0.6, -45, 35, 0, 0, 0, 0, "Cubic", "InOut"}, {0.9, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_OndaExpansiva"] = {
	Duracion = 1.25,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, 15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 15, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, -10, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, 85, 0, -10, 0, 0, 0, "Linear", "Out"}, {0.9, 85, 0, -10, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 0, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, -115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, -115, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 172, 0, -18, 0, 0, 0, "Cubic", "Out"}, {0.44, 172, 0, -18, 0, 0, 0, "Cubic", "In"}, {0.53, 65, 0, -5, 0, 0, 0, "Linear", "Out"}, {0.9, 65, 0, -5, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, 15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, 15, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, -10, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, 85, 0, 10, 0, 0, 0, "Linear", "Out"}, {0.9, 85, 0, 10, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 0, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, -115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, -115, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 172, 0, 18, 0, 0, 0, "Cubic", "Out"}, {0.44, 172, 0, 18, 0, 0, 0, "Cubic", "In"}, {0.53, 65, 0, 5, 0, 0, 0, "Linear", "Out"}, {0.9, 65, 0, 5, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 0, 0, 0, 0, 0.35, 0, "Cubic", "Out"}, {0.44, 0, 0, 0, 0, 0.5, 0, "Cubic", "In"}, {0.53, 0, 0, 0, 0, -1.6, 0, "Linear", "Out"}, {0.9, 0, 0, 0, 0, -1.5, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.38, 22, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.44, 28, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.53, -62, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.9, -62, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.25, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_SaltoSismico"] = {
	Duracion = 1.55,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, 20, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, 20, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 95, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 95, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, -10, 0, -5, 0, 0, 0, "Linear", "Out"}, {1.25, -10, 0, -5, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -105, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, -125, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, -75, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, -75, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -55, 0, -10, 0, 0, 0, "Cubic", "Out"}, {0.5, 165, 0, -5, 0, 0, 0, "Cubic", "Out"}, {0.78, 185, 0, -5, 0, 0, 0, "Cubic", "In"}, {0.95, 10, 0, -65, 0, 0, 0, "Linear", "Out"}, {1.25, 10, 0, -65, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, 25, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, 10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 95, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 95, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, 75, 0, 5, 0, 0, 0, "Linear", "Out"}, {1.25, 75, 0, 5, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -105, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -125, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, -125, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, -100, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, -100, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -55, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.5, 165, 0, 5, 0, 0, 0, "Cubic", "Out"}, {0.78, 185, 0, 5, 0, 0, 0, "Cubic", "In"}, {0.95, 45, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, -1.2, 0, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, 0.5, 0, "Cubic", "Out"}, {0.78, -25, 0, 0, 0, 0.6, 0, "Cubic", "In"}, {0.95, 0, 0, 0, 0, -1.6, 0, "Linear", "Out"}, {1.25, 0, 0, 0, 0, -1.55, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -32, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.78, 22, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.95, -45, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.25, -45, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Hab_FuriaTitan"] = {
	Duracion = 2.1,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 115, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.7, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.85, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, 10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 25, 0, -10, 0, 0, 0, "Cubic", "Out"}, {0.55, 25, 0, -10, 0, 0, 0, "Linear", "Out"}, {0.7, 25, 0, -10, 0, 0, 0, "Linear", "Out"}, {0.85, 25, 0, -10, 0, 0, 0, "Linear", "Out"}, {1.05, -10, 0, -15, 0, 0, 0, "Cubic", "Out"}, {1.25, -10, 0, -15, 0, 0, 0, "Cubic", "In"}, {1.35, 85, 0, -15, 0, 0, 0, "Linear", "Out"}, {1.75, 85, 0, -15, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.7, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.85, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, -20, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, -115, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, -115, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -20, 0, -40, 0, 0, 0, "Cubic", "Out"}, {0.55, -15, 0, -45, 0, 0, 0, "Linear", "Out"}, {0.7, -25, 0, -35, 0, 0, 0, "Linear", "Out"}, {0.85, -18, 0, -42, 0, 0, 0, "Linear", "Out"}, {1.05, 20, 0, -105, 0, 0, 0, "Cubic", "Out"}, {1.25, 175, 0, -20, 0, 0, 0, "Cubic", "In"}, {1.35, 60, 0, -5, 0, 0, 0, "Linear", "Out"}, {1.75, 60, 0, -5, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 38, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 38, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.7, 38, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.85, 38, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, 40, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, -10, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 115, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.7, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.85, 115, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, 10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 25, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.55, 25, 0, 10, 0, 0, 0, "Linear", "Out"}, {0.7, 25, 0, 10, 0, 0, 0, "Linear", "Out"}, {0.85, 25, 0, 10, 0, 0, 0, "Linear", "Out"}, {1.05, -10, 0, 15, 0, 0, 0, "Cubic", "Out"}, {1.25, -10, 0, 15, 0, 0, 0, "Cubic", "In"}, {1.35, 85, 0, 15, 0, 0, 0, "Linear", "Out"}, {1.75, 85, 0, 15, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.7, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.85, -40, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, -20, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, -115, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, -115, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -20, 0, 40, 0, 0, 0, "Cubic", "Out"}, {0.55, -25, 0, 35, 0, 0, 0, "Linear", "Out"}, {0.7, -15, 0, 45, 0, 0, 0, "Linear", "Out"}, {0.85, -22, 0, 42, 0, 0, 0, "Linear", "Out"}, {1.05, 20, 0, 105, 0, 0, 0, "Cubic", "Out"}, {1.25, 175, 0, 20, 0, 0, 0, "Cubic", "In"}, {1.35, 60, 0, 5, 0, 0, 0, "Linear", "Out"}, {1.75, 60, 0, 5, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, -0.6, 0, "Cubic", "Out"}, {0.55, 0, 0, 0, 0, -0.6, 0, "Linear", "Out"}, {0.7, 0, 0, 0, 0, -0.6, 0, "Linear", "Out"}, {0.85, 0, 0, 0, 0, -0.6, 0, "Linear", "Out"}, {1.05, 0, 0, 0, 0, 0.7, 0, "Cubic", "Out"}, {1.25, 0, 0, 0, 0, 0.8, 0, "Cubic", "In"}, {1.35, 0, 0, 0, 0, -1.7, 0, "Linear", "Out"}, {1.75, 0, 0, 0, 0, -1.6, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 18, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.55, 22, 0, 3, 0, 0, 0, "Linear", "Out"}, {0.7, 16, 0, -3, 0, 0, 0, "Linear", "Out"}, {0.85, 20, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.05, 28, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.25, 28, 0, 0, 0, 0, 0, "Cubic", "In"}, {1.35, -65, 0, 0, 0, 0, 0, "Linear", "Out"}, {1.75, -65, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.1, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Desenvainar"] = {
	Duracion = 0.85,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, -15, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, -35, 0, 0, 0, "Cubic", "Out"}, {0.65, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}, {0.85, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, -15, -20, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 5, 15, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, 5, 15, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, 5, 15, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 75, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 25, 0, -35, 0, 0, 0, "Cubic", "Out"}, {0.45, 125, 0, 75, 0, 0, 0, "Cubic", "Out"}, {0.65, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}, {0.85, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 0, 0, 0, -0.2, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, -0.35, 0, "Cubic", "Out"}, {0.65, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}, {0.85, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.25, 0, 28, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, -32, 0, 0, 0, 0, "Cubic", "Out"}, {0.65, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}, {0.85, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Combo1"] = {
	Duracion = 0.5,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 40, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 20, 0, -20, 0, 0, 0, "Cubic", "Out"}, {0.1, 20, 0, -20, 0, 0, 0, "Cubic", "In"}, {0.2, -10, 0, -40, 0, 0, 0, "Linear", "Out"}, {0.32, -10, 0, -40, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -10, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -15, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 45, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.1, 80, 0, 75, 0, 0, 0, "Cubic", "In"}, {0.2, 85, 0, -35, 0, 0, 0, "Linear", "Out"}, {0.32, 85, 0, -35, 0, 0, 0, "Cubic", "Out"}, {0.5, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, -0.3, 0, "Cubic", "Out"}, {0.1, 0, 0, 0, 0, -0.25, 0, "Cubic", "In"}, {0.2, 0, 0, 0, 0, -0.4, -0.4, "Linear", "Out"}, {0.32, 0, 0, 0, 0, -0.4, -0.4, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 0, -45, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -8, 42, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -6, 38, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Combo2"] = {
	Duracion = 0.5,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 40, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, -10, 0, -40, 0, 0, 0, "Cubic", "Out"}, {0.1, -10, 0, -40, 0, 0, 0, "Cubic", "In"}, {0.2, 30, 0, -60, 0, 0, 0, "Linear", "Out"}, {0.32, 30, 0, -60, 0, 0, 0, "Cubic", "Out"}, {0.5, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 0, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 0, 20, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 0, 20, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 95, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -10, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -15, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 85, 0, -35, 0, 0, 0, "Cubic", "Out"}, {0.1, 80, 0, -45, 0, 0, 0, "Cubic", "In"}, {0.2, 80, 0, 85, 0, 0, 0, "Linear", "Out"}, {0.32, 80, 0, 85, 0, 0, 0, "Cubic", "Out"}, {0.5, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, -0.4, -0.4, "Cubic", "Out"}, {0.1, 0, 0, 0, 0, -0.4, -0.4, "Cubic", "In"}, {0.2, 0, 0, 0, 0, -0.45, -0.5, "Linear", "Out"}, {0.32, 0, 0, 0, 0, -0.45, -0.5, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, -6, 38, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 0, 50, 0, 0, 0, 0, "Cubic", "In"}, {0.2, -8, -45, 0, 0, 0, 0, "Linear", "Out"}, {0.32, -6, -40, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Combo3"] = {
	Duracion = 0.75,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 35, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, 10, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, 10, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, -15, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, -40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, -50, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, -50, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 20, 0, -20, 0, 0, 0, "Cubic", "Out"}, {0.2, 172, 0, -5, 0, 0, 0, "Cubic", "Out"}, {0.33, 40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, -5, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, -5, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, 55, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, 55, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, -60, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, -75, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, -75, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 45, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.2, 182, 0, 5, 0, 0, 0, "Cubic", "Out"}, {0.33, 45, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, -0.3, 0, "Cubic", "Out"}, {0.2, 0, 0, 0, 0, 0.45, 0, "Cubic", "Out"}, {0.33, 0, 0, 0, 0, -1.1, -0.6, "Linear", "Out"}, {0.55, 0, 0, 0, 0, -1.05, -0.6, "Cubic", "InOut"}, {0.75, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {0.2, 22, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.33, -42, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.55, -42, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.75, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Pesado"] = {
	Duracion = 1.15,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 25, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, 25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 40, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, 40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 50, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, 50, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -30, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, -30, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -45, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, -45, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -25, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, -25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 20, 0, -20, 0, 0, 0, "Cubic", "Out"}, {0.45, 85, 0, -5, 0, 0, 0, "Cubic", "In"}, {0.52, 85, 0, -5, 0, 0, 0, "Linear", "Out"}, {0.62, -20, 0, -50, 0, 0, 0, "Linear", "Out"}, {0.88, -20, 0, -50, 0, 0, 0, "Cubic", "InOut"}, {1.15, 20, 0, -20, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 35, 0, 0, 0, 0, "Cubic", "In"}, {0.52, 0, 35, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 0, -35, 0, 0, 0, 0, "Linear", "Out"}, {0.88, 0, -35, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, 20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 0, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, 45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -30, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, -30, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, 55, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, 55, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -20, 0, 0, 0, 0, 0, "Cubic", "In"}, {0.52, -20, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -60, 0, 0, 0, 0, 0, "Linear", "Out"}, {0.88, -60, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, -15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 45, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, 85, 0, 0, 0, "Cubic", "In"}, {0.52, 30, 0, 85, 0, 0, 0, "Linear", "Out"}, {0.62, 85, 0, -40, 0, 0, 0, "Linear", "Out"}, {0.88, 85, 0, -40, 0, 0, 0, "Cubic", "InOut"}, {1.15, 45, 0, 10, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, -0.3, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, -0.75, 0.3, "Cubic", "In"}, {0.52, 0, 0, 0, 0, -0.75, 0.35, "Linear", "Out"}, {0.62, 0, 0, 0, 0, -0.95, -1, "Linear", "Out"}, {0.88, 0, 0, 0, 0, -0.9, -0.9, "Cubic", "InOut"}, {1.15, 0, 0, 0, 0, -0.3, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 10, -75, 0, 0, 0, 0, "Cubic", "In"}, {0.52, 12, -80, 0, 0, 0, 0, "Linear", "Out"}, {0.62, -25, 80, 0, 0, 0, 0, "Linear", "Out"}, {0.88, -25, 80, 0, 0, 0, 0, "Cubic", "InOut"}, {1.15, 0, -15, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Bloqueo"] = {
	Duracion = 0.5,
	Bucle = true,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 85, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 85, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 35, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 35, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -40, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 20, 0, -20, 0, 0, 0, "Cubic", "Out"}, {0.12, 100, 0, 15, 0, 0, 0, "Cubic", "Out"}, {0.5, 100, 0, 15, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, 70, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, 70, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, -10, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -20, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, -15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -30, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 45, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.12, 110, 0, -25, 0, 0, 0, "Cubic", "Out"}, {0.5, 110, 0, -25, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, -0.3, 0, "Cubic", "Out"}, {0.12, 0, 0, 0, 0, -0.5, 0.15, "Cubic", "Out"}, {0.5, 0, 0, 0, 0, -0.52, 0.15, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, -15, 0, 0, 0, 0, "Cubic", "Out"}, {0.12, -10, -10, 0, 0, 0, 0, "Cubic", "Out"}, {0.5, -11, -10, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Esquiva"] = {
	Duracion = 0.5,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, 20, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 65, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, 65, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -105, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, -105, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -60, 0, -20, 0, 0, 0, "Cubic", "Out"}, {0.35, -60, 0, -20, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, 30, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, 20, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, 65, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, 65, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -105, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, -105, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -60, 0, 20, 0, 0, 0, "Cubic", "Out"}, {0.35, -60, 0, 20, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -20, 0, 0, 0, -1.2, 0, "Cubic", "Out"}, {0.35, -18, 0, 0, 0, -1.1, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.1, -50, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.35, -50, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {0.5, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Espada_Impacto"] = {
	Duracion = 0.4,
	Bucle = false,
	Pistas = {
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.08, 30, 0, -30, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.08, 25, -10, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.08, -10, 0, 35, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.08, 0, 0, 0, 0, -0.2, 0.4, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.08, 22, 15, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Victoria"] = {
	Duracion = 2.6,
	Bucle = false,
	Pistas = {
		LeftElbow = {Parte = "LeftLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 100, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 110, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 110, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 110, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, -10, 0, 0, 0, "Cubic", "Out"}, {0.85, 10, 0, -70, 0, 0, 0, "Cubic", "Out"}, {1.6, 10, 0, -70, 0, 0, 0, "Cubic", "InOut"}, {2.6, 10, 0, -70, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -20, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 32, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 35, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 32, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 90, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -45, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 30, 0, 10, 0, 0, 0, "Cubic", "Out"}, {0.85, 178, 0, 5, 0, 0, 0, "Cubic", "Out"}, {1.6, 178, 0, 5, 0, 0, 0, "Cubic", "InOut"}, {2.6, 178, 0, 5, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, 0, 0, 0, 0, -0.5, 0, "Cubic", "Out"}, {0.85, 0, 0, 0, 0, 0.2, 0, "Cubic", "Out"}, {1.6, 0, 0, 0, 0, 0.2, 0, "Cubic", "InOut"}, {2.6, 0, 0, 0, 0, 0.2, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.45, -25, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.85, 15, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1.6, 18, 0, 0, 0, 0, 0, "Cubic", "InOut"}, {2.6, 15, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

AnimData["Derrota"] = {
	Duracion = 2.0,
	Bucle = false,
	Pistas = {
		LeftHip = {Parte = "LeftUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, 0, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftKnee = {Parte = "LeftLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, -90, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, -90, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		LeftShoulder = {Parte = "LeftUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 10, 0, -10, 0, 0, 0, "Cubic", "Out"}, {1, 25, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Neck = {Parte = "Head", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, -42, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, -45, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightElbow = {Parte = "RightLowerArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 30, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, 10, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, 10, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightHip = {Parte = "RightUpperLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, 0, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, 0, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightKnee = {Parte = "RightLowerLeg", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {1, -90, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, -90, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		RightShoulder = {Parte = "RightUpperArm", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 25, 0, 10, 0, 0, 0, "Cubic", "Out"}, {1, 25, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, 25, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
		Root = {Parte = "LowerTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, 10, 0, 0, 0, -0.3, 0.3, "Cubic", "Out"}, {1, 0, 0, 0, 0, -1.45, 0, "Bounce", "Out"}, {2, 0, 0, 0, 0, -1.45, 0, "Cubic", "InOut"}},
		Waist = {Parte = "UpperTorso", {0, 0, 0, 0, 0, 0, 0, "Cubic", "Out"}, {0.4, -20, 10, 0, 0, 0, 0, "Cubic", "Out"}, {1, -38, 0, 0, 0, 0, 0, "Bounce", "Out"}, {2, -40, 0, 0, 0, 0, 0, "Cubic", "InOut"}},
	},
}

return AnimData
