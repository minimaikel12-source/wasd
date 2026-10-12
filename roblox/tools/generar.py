#!/usr/bin/env python3
"""Genera los assets del juego a partir de una única fuente de verdad:

- assets/Animaciones/*.model.json  -> KeyframeSequence R15 (ServerStorage/Animaciones)
- src/ReplicatedStorage/AnimData.lua -> las MISMAS animaciones para el respaldo procedural
- assets/Workspace/Entrenamiento.model.json, Arena.model.json
- assets/Espadas/Espada.model.json

Uso:  python3 roblox/tools/generar.py   (luego `rojo build`)
Ángulos en grados, posiciones en studs. Convenciones R15 (personaje mira a -Z):
  rx + en hombro  = brazo hacia delante/arriba     rx + en cadera = pierna adelante
  rx - en rodilla = doblar rodilla                rx + en codo   = doblar codo
  rz + brazo/pierna DERECHA = abrir hacia fuera   rz - para la IZQUIERDA
  rx - en Waist   = inclinarse hacia delante      ry + en Waist  = girar torso a la izquierda
  Root: (rx,ry,rz,px,py,pz)  py - = agacharse, pz - = desplazarse hacia delante
"""
import json
import math
import os
import random

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ---------------------------------------------------------------- utilidades
def rot(rx, ry, rz):
    """Matriz de CFrame.Angles(rx, ry, rz) (= Rx * Ry * Rz), en filas."""
    a, b, c = math.radians(rx), math.radians(ry), math.radians(rz)
    cx, sx, cy, sy, cz, sz = math.cos(a), math.sin(a), math.cos(b), math.sin(b), math.cos(c), math.sin(c)
    rx_m = [[1, 0, 0], [0, cx, -sx], [0, sx, cx]]
    ry_m = [[cy, 0, sy], [0, 1, 0], [-sy, 0, cy]]
    rz_m = [[cz, -sz, 0], [sz, cz, 0], [0, 0, 1]]

    def mul(p, q):
        return [[sum(p[i][k] * q[k][j] for k in range(3)) for j in range(3)] for i in range(3)]

    m = mul(mul(rx_m, ry_m), rz_m)
    return [[round(v, 5) for v in row] for row in m]


def cf(pos, angles=(0, 0, 0)):
    return {"CFrame": {"position": [round(p, 4) for p in pos], "orientation": rot(*angles)}}


def write_json(rel, data):
    path = os.path.join(ROOT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=1)
        f.write("\n")


# ============================================================== ANIMACIONES
# articulación -> (parte que mueve, Motor6D, parte padre en la jerarquía de Poses)
JOINTS = {
    "Root": ("LowerTorso", "Root", "HumanoidRootPart"),
    "Waist": ("UpperTorso", "Waist", "LowerTorso"),
    "Neck": ("Head", "Neck", "UpperTorso"),
    "LS": ("LeftUpperArm", "LeftShoulder", "UpperTorso"),
    "LE": ("LeftLowerArm", "LeftElbow", "LeftUpperArm"),
    "LW": ("LeftHand", "LeftWrist", "LeftLowerArm"),
    "RS": ("RightUpperArm", "RightShoulder", "UpperTorso"),
    "RE": ("RightLowerArm", "RightElbow", "RightUpperArm"),
    "RW": ("RightHand", "RightWrist", "RightLowerArm"),
    "LH": ("LeftUpperLeg", "LeftHip", "LowerTorso"),
    "LK": ("LeftLowerLeg", "LeftKnee", "LeftUpperLeg"),
    "LA": ("LeftFoot", "LeftAnkle", "LeftLowerLeg"),
    "RH": ("RightUpperLeg", "RightHip", "LowerTorso"),
    "RK": ("RightLowerLeg", "RightKnee", "RightUpperLeg"),
    "RA": ("RightFoot", "RightAnkle", "RightLowerLeg"),
}
PART_TO_JOINT = {v[0]: k for k, v in JOINTS.items()}
PARENT = {"LowerTorso": "HumanoidRootPart"}
PARENT.update({v[0]: v[2] for v in JOINTS.values()})

REST = "REST"


def K(t, ease="Cubic", dir="Out", **joints):
    """Keyframe. Cada articulación: (rx, ry, rz) o (rx, ry, rz, px, py, pz).
    Las articulaciones no indicadas MANTIENEN el valor del keyframe anterior.
    Pasa rest=True para devolver todo a la pose neutra."""
    return {"t": t, "ease": ease, "dir": dir, "joints": joints}


def norm(v):
    v = tuple(v)
    return v + (0,) * (6 - len(v))


ANIMS = {}


def anim(name, length, keys, loop=False, priority="Action"):
    used = set()
    for k in keys:
        used.update(j for j in k["joints"] if j != "rest")
    state = {j: (0, 0, 0, 0, 0, 0) for j in used}
    frames = []
    for k in keys:
        if k["joints"].get("rest"):
            state = {j: (0, 0, 0, 0, 0, 0) for j in used}
        for j, v in k["joints"].items():
            if j != "rest":
                state[j] = norm(v)
        frames.append({"t": k["t"], "ease": k["ease"], "dir": k["dir"], "pose": dict(state)})
    ANIMS[name] = {"length": length, "loop": loop, "priority": priority, "frames": frames, "used": used}


Z = (0, 0, 0)
# Pose base de espada (guardia)
GUARD = dict(Root=(0, 0, 0, 0, -0.3, 0), Waist=(0, -15, 0), RS=(45, 0, 10), RE=(45, 0, 0), LS=(20, 0, -20),
             LE=(40, 0, 0), RH=(-10, 0, 0), RK=(-15, 0, 0), LH=(25, 0, 0), LK=(-25, 0, 0))

# --- Entrenamiento ----------------------------------------------------------
anim("Entrenar_Pesas", 1.3, [
    K(0, rest=True),
    K(0.28, "Cubic", "Out", Root=(0, 0, 0, 0, -0.7, 0), LH=(45, 0, 0), RH=(45, 0, 0), LK=(-70, 0, 0), RK=(-70, 0, 0),
      LS=(25, 0, -10), RS=(25, 0, 10), LE=(125, 0, 0), RE=(125, 0, 0), Waist=(-15, 0, 0), Neck=(10, 0, 0)),
    K(0.55, "Cubic", "Out", Root=(0, 0, 0, 0, 0.15, 0), LH=Z, RH=Z, LK=Z, RK=Z, LS=(175, 0, -12), RS=(175, 0, 12),
      LE=(5, 0, 0), RE=(5, 0, 0), Waist=(8, 0, 0), Neck=(20, 0, 0)),
    K(0.75, "Linear", "Out", LS=(172, 0, -8), RS=(172, 0, 8), Neck=(25, 0, 0)),
    K(0.9, "Cubic", "InOut", LS=(176, 0, -12), RS=(176, 0, 12)),
    K(1.3, "Cubic", "InOut", rest=True),
])

anim("Entrenar_Punetazos", 1.05, [
    K(0, rest=True),
    K(0.12, "Cubic", "Out", Root=(0, 0, 0, 0, -0.25, 0), LS=(55, 0, -5), LE=(110, 0, 0), RS=(40, 0, 5), RE=(125, 0, 0),
      Waist=(0, -15, 0), LH=(20, 0, 0), LK=(-20, 0, 0), RH=(-10, 0, 0), RK=(-15, 0, 0)),
    K(0.2, "Linear", "Out", LS=(92, 0, 0), LE=(0, 0, 0), Waist=(0, -30, 0), Neck=(0, 15, 0)),
    K(0.34, "Cubic", "Out", LS=(55, 0, -5), LE=(110, 0, 0), Waist=(0, -30, 0), Neck=Z),
    K(0.5, "Cubic", "In", RS=(15, 0, 15), RE=(135, 0, 0), Waist=(0, -40, 0), Root=(0, 0, 0, 0, -0.35, 0)),
    K(0.58, "Linear", "Out", RS=(95, 0, -5), RE=(0, 0, 0), Waist=(-10, 40, 0), Neck=(0, -25, 0), Root=(0, 0, 0, 0, -0.4, -0.3),
      RH=(-25, 0, 0)),
    K(0.8, "Cubic", "Out", RS=(40, 0, 5), RE=(125, 0, 0), Waist=(0, -15, 0), Neck=Z, Root=(0, 0, 0, 0, -0.25, 0)),
    K(1.05, "Cubic", "InOut", rest=True),
])

# --- Habilidades ------------------------------------------------------------
anim("Hab_PunoPotente", 0.95, [
    K(0, rest=True),
    K(0.28, "Cubic", "In", Root=(0, 0, 0, 0, -0.5, 0.3), Waist=(12, -55, 0), RS=(-35, 0, 35), RE=(125, 0, 0),
      LS=(75, 0, -10), LE=(40, 0, 0), RH=(30, 0, 0), RK=(-45, 0, 0), LH=(-15, 0, 0), Neck=(0, 30, 0)),
    K(0.36, "Linear", "Out", Root=(0, 0, 0, 0, -0.65, -0.9), Waist=(-22, 48, 0), RS=(95, 0, -5), RE=(0, 0, 0),
      LS=(-25, 0, -15), LE=(70, 0, 0), RH=(-30, 0, 0), RK=(-10, 0, 0), LH=(55, 0, 0), LK=(-55, 0, 0), Neck=(0, -30, 0)),
    K(0.62, "Cubic", "InOut", Root=(0, 0, 0, 0, -0.6, -0.8)),
    K(0.95, "Cubic", "InOut", rest=True),
])

anim("Hab_PatadaGiratoria", 1.05, [
    K(0, rest=True),
    K(0.18, "Cubic", "Out", Root=(0, 0, 0, 0, -0.6, 0), LH=(40, 0, 0), RH=(40, 0, 0), LK=(-70, 0, 0), RK=(-70, 0, 0),
      LS=(20, 0, -30), RS=(20, 0, 30), LE=(80, 0, 0), RE=(80, 0, 0), Waist=(0, -30, 0)),
    K(0.32, "Linear", "Out", Root=(0, 120, 0, 0, 0.6, 0), RH=(10, 0, 80), RK=Z, LH=(10, 0, 0), LK=(-50, 0, 0),
      LS=(0, 0, -85), RS=(0, 0, 85), LE=Z, RE=Z, Waist=(0, 25, -10)),
    K(0.44, "Linear", "Out", Root=(0, 240, 0, 0, 0.7, 0), RH=(10, 0, 95)),
    K(0.56, "Cubic", "Out", Root=(0, 360, 0, 0, 0.4, 0), RH=(10, 0, 80)),
    K(0.7, "Cubic", "Out", Root=(0, 0, 0, 0, -0.6, 0), RH=(40, 0, 10), RK=(-70, 0, 0), LH=(40, 0, 0), LK=(-70, 0, 0),
      LS=(20, 0, -40), RS=(20, 0, 40), Waist=Z),
    K(1.05, "Cubic", "InOut", rest=True),
])

anim("Hab_Embestida", 0.9, [
    K(0, rest=True),
    K(0.22, "Cubic", "In", Root=(-15, 0, 0, 0, -0.8, 0.2), Waist=(-40, 0, 0), LS=(-45, 0, -15), RS=(-45, 0, 15),
      LE=(30, 0, 0), RE=(30, 0, 0), RH=(55, 0, 0), RK=(-85, 0, 0), LH=(-25, 0, 0), LK=(-30, 0, 0), Neck=(25, 0, 0)),
    K(0.3, "Linear", "Out", Root=(-20, 0, 0, 0, -0.5, -0.6), Waist=(-45, 35, 0), RS=(25, 0, 25), RE=(80, 0, 0),
      LS=(70, 0, -10), LE=(100, 0, 0), RH=(65, 0, 0), RK=(-20, 0, 0), LH=(-55, 0, 0), LK=(-40, 0, 0), Neck=(30, -20, 0)),
    K(0.6, "Cubic", "InOut", Root=(-18, 0, 0, 0, -0.5, -0.6)),
    K(0.9, "Cubic", "InOut", rest=True),
])

anim("Hab_OndaExpansiva", 1.25, [
    K(0, rest=True),
    K(0.38, "Cubic", "Out", Root=(0, 0, 0, 0, 0.35, 0), Waist=(22, 0, 0), LS=(172, 0, -18), RS=(172, 0, 18),
      LE=(30, 0, 0), RE=(30, 0, 0), Neck=(30, 0, 0), LH=(-10, 0, 0), RH=(-10, 0, 0)),
    K(0.44, "Cubic", "In", Root=(0, 0, 0, 0, 0.5, 0), Waist=(28, 0, 0)),
    K(0.53, "Linear", "Out", Root=(0, 0, 0, 0, -1.6, 0), Waist=(-62, 0, 0), LS=(65, 0, -5), RS=(65, 0, 5),
      LE=(15, 0, 0), RE=(15, 0, 0), Neck=(-15, 0, 0), LH=(85, 0, -10), RH=(85, 0, 10), LK=(-115, 0, 0),
      RK=(-115, 0, 0)),
    K(0.9, "Cubic", "InOut", Root=(0, 0, 0, 0, -1.5, 0)),
    K(1.25, "Cubic", "InOut", rest=True),
])

anim("Hab_SaltoSismico", 1.55, [
    K(0, rest=True),
    K(0.25, "Cubic", "Out", Root=(0, 0, 0, 0, -1.2, 0), LH=(70, 0, 0), RH=(70, 0, 0), LK=(-105, 0, 0),
      RK=(-105, 0, 0), LS=(-55, 0, -10), RS=(-55, 0, 10), Waist=(-32, 0, 0)),
    K(0.5, "Cubic", "Out", Root=(0, 0, 0, 0, 0.5, 0), LH=(95, 0, 0), RH=(95, 0, 0), LK=(-125, 0, 0),
      RK=(-125, 0, 0), LS=(165, 0, -5), RS=(165, 0, 5), LE=(20, 0, 0), RE=(20, 0, 0), Waist=(15, 0, 0), Neck=(20, 0, 0)),
    K(0.78, "Cubic", "In", Root=(-25, 0, 0, 0, 0.6, 0), LS=(185, 0, -5), RS=(185, 0, 5), Waist=(22, 0, 0)),
    K(0.95, "Linear", "Out", Root=(0, 0, 0, 0, -1.6, 0), RH=(75, 0, 5), RK=(-100, 0, 0), LH=(-10, 0, -5),
      LK=(-75, 0, 0), RS=(45, 0, 0), RE=(10, 0, 0), LS=(10, 0, -65), LE=(20, 0, 0), Waist=(-45, 0, 0), Neck=(25, 0, 0)),
    K(1.25, "Cubic", "InOut", Root=(0, 0, 0, 0, -1.55, 0)),
    K(1.55, "Cubic", "InOut", rest=True),
])

anim("Hab_FuriaTitan", 2.1, [
    K(0, rest=True),
    K(0.4, "Cubic", "Out", Root=(0, 0, 0, 0, -0.6, 0), LS=(-20, 0, -40), RS=(-20, 0, 40), LE=(115, 0, 0),
      RE=(115, 0, 0), Waist=(18, 0, 0), Neck=(38, 0, 0), LH=(25, 0, -10), RH=(25, 0, 10), LK=(-40, 0, 0),
      RK=(-40, 0, 0)),
    K(0.55, "Linear", "Out", LS=(-15, 0, -45), RS=(-25, 0, 35), Waist=(22, 0, 3)),
    K(0.7, "Linear", "Out", LS=(-25, 0, -35), RS=(-15, 0, 45), Waist=(16, 0, -3)),
    K(0.85, "Linear", "Out", LS=(-18, 0, -42), RS=(-22, 0, 42), Waist=(20, 0, 0)),
    K(1.05, "Cubic", "Out", Root=(0, 0, 0, 0, 0.7, 0), LS=(20, 0, -105), RS=(20, 0, 105), LE=(10, 0, 0),
      RE=(10, 0, 0), Waist=(28, 0, 0), Neck=(40, 0, 0), LH=(-10, 0, -15), RH=(-10, 0, 15), LK=(-20, 0, 0),
      RK=(-20, 0, 0)),
    K(1.25, "Cubic", "In", LS=(175, 0, -20), RS=(175, 0, 20), LE=(25, 0, 0), RE=(25, 0, 0), Root=(0, 0, 0, 0, 0.8, 0)),
    K(1.35, "Linear", "Out", Root=(0, 0, 0, 0, -1.7, 0), Waist=(-65, 0, 0), LS=(60, 0, -5), RS=(60, 0, 5),
      LE=(10, 0, 0), RE=(10, 0, 0), Neck=(-10, 0, 0), LH=(85, 0, -15), RH=(85, 0, 15), LK=(-115, 0, 0),
      RK=(-115, 0, 0)),
    K(1.75, "Cubic", "InOut", Root=(0, 0, 0, 0, -1.6, 0)),
    K(2.1, "Cubic", "InOut", rest=True),
])

# --- Espada -----------------------------------------------------------------
anim("Espada_Desenvainar", 0.85, [
    K(0, rest=True),
    K(0.25, "Cubic", "Out", RS=(25, 0, -35), RE=(75, 0, 0), Waist=(0, 28, 0), Neck=(-15, -20, 0),
      Root=(0, 0, 0, 0, -0.2, 0), LS=(0, 0, -15)),
    K(0.45, "Cubic", "Out", RS=(125, 0, 75), RE=(10, 0, 0), Waist=(0, -32, 0), Neck=(5, 15, 0),
      Root=(0, 0, 0, 0, -0.35, 0), LS=(30, 0, -35), LE=(30, 0, 0)),
    K(0.65, "Cubic", "InOut", **GUARD),
    K(0.85, "Cubic", "InOut", **GUARD),
])

anim("Espada_Combo1", 0.5, [
    K(0, "Cubic", "Out", **GUARD),
    K(0.1, "Cubic", "In", RS=(80, 0, 75), RE=(30, 0, 0), Waist=(0, -45, 0), Root=(0, 0, 0, 0, -0.25, 0)),
    K(0.2, "Linear", "Out", RS=(85, 0, -35), RE=(0, 0, 0), Waist=(-8, 42, 0), Root=(0, 0, 0, 0, -0.4, -0.4),
      LS=(-10, 0, -40)),
    K(0.32, "Cubic", "Out", Waist=(-6, 38, 0)),
    K(0.5, "Cubic", "InOut", **GUARD),
])

anim("Espada_Combo2", 0.5, [
    K(0, "Cubic", "Out", Waist=(-6, 38, 0), RS=(85, 0, -35), RE=(0, 0, 0), Root=(0, 0, 0, 0, -0.4, -0.4),
      LS=(-10, 0, -40), LE=(40, 0, 0), RH=(-10, 0, 0), RK=(-15, 0, 0), LH=(25, 0, 0), LK=(-25, 0, 0)),
    K(0.1, "Cubic", "In", RS=(80, 0, -45), RE=(95, 0, 0), Waist=(0, 50, 0)),
    K(0.2, "Linear", "Out", RS=(80, 0, 85), RE=(0, 0, 0), Waist=(-8, -45, 0), Root=(0, 0, 0, 0, -0.45, -0.5),
      LS=(30, 0, -60), Neck=(0, 20, 0)),
    K(0.32, "Cubic", "Out", Waist=(-6, -40, 0)),
    K(0.5, "Cubic", "InOut", Neck=Z, **GUARD),
])

anim("Espada_Combo3", 0.75, [
    K(0, "Cubic", "Out", **GUARD),
    K(0.2, "Cubic", "Out", Root=(0, 0, 0, 0, 0.45, 0), RS=(182, 0, 5), RE=(30, 0, 0), LS=(172, 0, -5),
      LE=(35, 0, 0), Waist=(22, 0, 0), Neck=(20, 0, 0), RH=(30, 0, 0), RK=(-60, 0, 0), LH=(10, 0, 0), LK=(-40, 0, 0)),
    K(0.33, "Linear", "Out", Root=(0, 0, 0, 0, -1.1, -0.6), RS=(45, 0, 0), RE=(0, 0, 0), LS=(40, 0, 0),
      LE=(10, 0, 0), Waist=(-42, 0, 0), Neck=(-5, 0, 0), RH=(55, 0, 0), RK=(-75, 0, 0), LH=(-15, 0, 0),
      LK=(-50, 0, 0)),
    K(0.55, "Cubic", "InOut", Root=(0, 0, 0, 0, -1.05, -0.6)),
    K(0.75, "Cubic", "InOut", Neck=Z, **GUARD),
])

anim("Espada_Pesado", 1.15, [
    K(0, "Cubic", "Out", **GUARD),
    K(0.45, "Cubic", "In", Root=(0, 0, 0, 0, -0.75, 0.3), Waist=(10, -75, 0), RS=(30, 0, 85), RE=(20, 0, 0),
      LS=(85, 0, -5), LE=(25, 0, 0), RH=(-30, 0, 0), RK=(-20, 0, 0), LH=(50, 0, 0), LK=(-45, 0, 0), Neck=(0, 35, 0)),
    K(0.52, "Linear", "Out", Root=(0, 0, 0, 0, -0.75, 0.35), Waist=(12, -80, 0)),
    K(0.62, "Linear", "Out", Root=(0, 0, 0, 0, -0.95, -1.0), Waist=(-25, 80, 0), RS=(85, 0, -40), RE=(0, 0, 0),
      LS=(-20, 0, -50), LE=(40, 0, 0), RH=(55, 0, 0), RK=(-60, 0, 0), LH=(-30, 0, 0), LK=(-25, 0, 0), Neck=(0, -35, 0)),
    K(0.88, "Cubic", "InOut", Root=(0, 0, 0, 0, -0.9, -0.9)),
    K(1.15, "Cubic", "InOut", Neck=Z, **GUARD),
])

anim("Espada_Bloqueo", 0.5, [
    K(0, "Cubic", "Out", **GUARD),
    K(0.12, "Cubic", "Out", Root=(0, 0, 0, 0, -0.5, 0.15), RS=(110, 0, -25), RE=(70, 0, 0), LS=(100, 0, 15),
      LE=(85, 0, 0), Waist=(-10, -10, 0), Neck=(-10, 0, 0), RH=(-20, 0, 0), RK=(-30, 0, 0), LH=(35, 0, 0),
      LK=(-40, 0, 0)),
    K(0.5, "Cubic", "InOut", Root=(0, 0, 0, 0, -0.52, 0.15), Waist=(-11, -10, 0)),
], loop=True)

anim("Espada_Esquiva", 0.5, [
    K(0, rest=True),
    K(0.1, "Cubic", "Out", Root=(-20, 0, 0, 0, -1.2, 0), Waist=(-50, 0, 0), LS=(-60, 0, -20), RS=(-60, 0, 20),
      RE=(20, 0, 0), LE=(20, 0, 0), LH=(65, 0, 0), RH=(65, 0, 0), LK=(-105, 0, 0), RK=(-105, 0, 0), Neck=(30, 0, 0)),
    K(0.35, "Cubic", "InOut", Root=(-18, 0, 0, 0, -1.1, 0)),
    K(0.5, "Cubic", "InOut", rest=True),
])

anim("Espada_Impacto", 0.4, [
    K(0, rest=True),
    K(0.08, "Cubic", "Out", Root=(0, 0, 0, 0, -0.2, 0.4), Waist=(22, 15, 0), Neck=(25, -10, 0), LS=(30, 0, -30),
      RS=(-10, 0, 35)),
    K(0.4, "Cubic", "InOut", rest=True),
])

anim("Victoria", 2.6, [
    K(0, rest=True),
    K(0.45, "Cubic", "Out", Root=(0, 0, 0, 0, -0.5, 0), Waist=(-25, 0, 0), Neck=(-20, 0, 0), RS=(30, 0, 10),
      RE=(90, 0, 0), LS=(30, 0, -10), LE=(100, 0, 0), LH=(30, 0, 0), RH=(30, 0, 0), LK=(-45, 0, 0), RK=(-45, 0, 0)),
    K(0.85, "Cubic", "Out", Root=(0, 0, 0, 0, 0.2, 0), Waist=(15, 0, 0), Neck=(32, 0, 0), RS=(178, 0, 5),
      RE=(0, 0, 0), LS=(10, 0, -70), LE=(110, 0, 0), LH=Z, RH=Z, LK=Z, RK=Z),
    K(1.6, "Cubic", "InOut", Neck=(35, 0, 0), Waist=(18, 0, 0)),
    K(2.6, "Cubic", "InOut", Neck=(32, 0, 0), Waist=(15, 0, 0)),
])

anim("Derrota", 2.0, [
    K(0, rest=True),
    K(0.4, "Cubic", "Out", Root=(10, 0, 0, 0, -0.3, 0.3), Waist=(-20, 10, 0), Neck=(-30, 0, 0), LS=(10, 0, -10),
      RS=(25, 0, 10), RE=(30, 0, 0)),
    K(1.0, "Bounce", "Out", Root=(0, 0, 0, 0, -1.45, 0), LH=(0, 0, 0), LK=(-90, 0, 0), RH=(0, 0, 0), RK=(-90, 0, 0),
      LS=(25, 0, 0), RS=(25, 0, 0), RE=(10, 0, 0), Waist=(-38, 0, 0), Neck=(-42, 0, 0)),
    K(2.0, "Cubic", "InOut", Waist=(-40, 0, 0), Neck=(-45, 0, 0)),
])


def keyframe_sequence(name, a):
    kf_children = []
    for fr in a["frames"]:
        poses = {}

        def ensure(part):
            if part in poses:
                return poses[part]
            joint = PART_TO_JOINT.get(part)
            v = fr["pose"].get(joint) if joint else None
            props = {"Weight": 1 if v is not None else 0, "EasingStyle": fr["ease"], "EasingDirection": fr["dir"]}
            if v is not None:
                props["CFrame"] = cf(v[3:6], v[0:3])
            node = {"name": part, "className": "Pose", "properties": props, "children": []}
            poses[part] = node
            if part != "HumanoidRootPart":
                ensure(PARENT[part])["children"].append(node)
            return node

        for j in sorted(a["used"]):
            ensure(JOINTS[j][0])
        kf_children.append({"name": "Keyframe", "className": "Keyframe", "properties": {"Time": fr["t"]},
                            "children": [poses["HumanoidRootPart"]]})
    return {"className": "KeyframeSequence", "properties": {"Loop": a["loop"], "Priority": a["priority"]},
            "children": kf_children}


def lua_anim_data():
    out = ["-- GENERADO por roblox/tools/generar.py - NO EDITAR A MANO (edita el generador y vuelve a ejecutarlo).",
           "-- Mismos datos que las KeyframeSequence de ServerStorage/Animaciones; se usan para el respaldo",
           "-- procedural (Motor6D.Transform) mientras no haya IDs publicados en Config.Animaciones.",
           "-- Formato pista: {tiempo, rx, ry, rz, px, py, pz, EasingStyle, EasingDirection}  (grados / studs)",
           "local AnimData = {}", ""]
    for name, a in ANIMS.items():
        out.append(f'AnimData["{name}"] = {{')
        out.append(f'\tDuracion = {a["length"]},')
        out.append(f'\tBucle = {"true" if a["loop"] else "false"},')
        out.append("\tPistas = {")
        for j in sorted(a["used"]):
            part, motor, _ = JOINTS[j]
            rows = []
            for fr in a["frames"]:
                v = fr["pose"][j]
                nums = ", ".join(f"{x:g}" for x in v)
                rows.append(f'{{{fr["t"]:g}, {nums}, "{fr["ease"]}", "{fr["dir"]}"}}')
            out.append(f'\t\t{motor} = {{Parte = "{part}", ' + ", ".join(rows) + "},")
        out.append("\t},")
        out.append("}")
        out.append("")
    out.append("return AnimData")
    return "\n".join(out) + "\n"


# ================================================================== MUNDO
def part(name, size, pos, color, material="SmoothPlastic", angles=(0, 0, 0), shape=None, extra=None, children=None,
         attrs=None, cls="Part"):
    props = {"Size": [round(s, 3) for s in size], "CFrame": cf(pos, angles), "Anchored": True,
             "Color": [c / 255 for c in color], "Material": material, "TopSurface": "Smooth", "BottomSurface": "Smooth"}
    if shape:
        props["Shape"] = shape
    if extra:
        props.update(extra)
    node = {"name": name, "className": cls, "properties": props, "children": children or []}
    if attrs:
        node["attributes"] = attrs
    return node


def model(name, children, attrs=None):
    node = {"name": name, "className": "Model", "children": children}
    if attrs:
        node["attributes"] = attrs
    return node


def prompt(action, obj, hold=0.0):
    return {"name": "Prompt", "className": "ProximityPrompt",
            "properties": {"ActionText": action, "ObjectText": obj, "HoldDuration": hold, "MaxActivationDistance": 10,
                           "RequiresLineOfSight": False, "KeyboardKeyCode": "E"}}


def light(cls="PointLight", color=(255, 170, 80), brightness=2, rng=16, extra=None):
    props = {"Color": [c / 255 for c in color], "Brightness": brightness, "Range": rng}
    if extra:
        props.update(extra)
    return {"name": cls, "className": cls, "properties": props}


def sign(text, pos, angles=(0, 0, 0), width=14, color=(255, 200, 60)):
    gui = {"name": "Cartel", "className": "SurfaceGui",
           "properties": {"Face": "Front", "PixelsPerStud": 40, "SizingMode": "PixelsPerStud"},
           "children": [{"name": "Texto", "className": "TextLabel",
                         "properties": {"Size": {"UDim2": [[1, 0], [1, 0]]}, "BackgroundTransparency": 1,
                                        "Text": text, "TextScaled": True, "Font": "LuckiestGuy",
                                        "TextColor3": [c / 255 for c in color],
                                        "TextStrokeTransparency": 0}}]}
    return part("Cartel", (width, 3, 0.4), pos, (40, 30, 25), "Wood", angles, children=[gui])


TRAINING = [
    # nombre, tipo(anim), fuerza requerida, ganancia, color
    ("PesasLigeras", "Pesas", 0, "Pesas ligeras"),
    ("SacoBoxeo", "Saco", 0, "Saco de boxeo"),
    ("PesasPesadas", "Pesas", 150, "Pesas pesadas"),
    ("SacoAcero", "Saco", 800, "Saco de acero"),
    ("RocaTitan", "Pesas", 4000, "Roca del Titán"),
    ("YunqueColosal", "Saco", 15000, "Yunque colosal"),
]


def training_station(key, kind, req, label, x, z):
    kids = [part("Plataforma", (14, 1, 14), (x, 0.5, z), (60, 60, 70), "DiamondPlate")]
    scale = 1 + TRAINING.index(next(t for t in TRAINING if t[0] == key)) * 0.25
    if kind == "Pesas":
        col = (90, 90, 95) if req < 4000 else (110, 95, 80)
        if key == "RocaTitan":
            kids.append(part("Equipo", (6, 5, 6), (x, 3.5, z), (100, 90, 80), "Rock", (10, 25, 5)
                             , children=[prompt("Levantar", label, 0)]))
        else:
            kids.append(part("Barra", (9 * scale * 0.8, 0.4, 0.4), (x, 2.2, z), (200, 200, 205), "Metal",
                             children=[prompt("Levantar", label, 0)]))
            for s in (-1, 1):
                kids.append(part("Disco", (0.8, 2.6 * scale, 2.6 * scale), (x + s * 3.6 * scale * 0.8, 2.2, z), col,
                                 "Metal", shape="Cylinder"))
            kids.append(part("Soporte", (1, 2, 1), (x, 1.5, z + 2), (40, 40, 40), "Metal"))
    else:
        h = 6 * min(scale, 1.8)
        col = (150, 40, 30) if req < 800 else ((120, 125, 135) if req < 15000 else (60, 60, 65))
        mat = "Fabric" if req < 800 else "Metal"
        if key == "YunqueColosal":
            kids.append(part("Equipo", (6, 3, 3.5), (x, 2.5, z), (55, 55, 60), "Metal",
                             children=[prompt("Golpear", label, 0)]))
            kids.append(part("Pie", (3, 2, 2.5), (x, 1.5, z), (40, 40, 45), "Metal"))
        else:
            kids.append(part("Equipo", (3, h, 3), (x, 1 + h / 2 + 1, z), col, mat
                             , children=[prompt("Golpear", label, 0)]))
            kids.append(part("Cadena", (0.3, 2, 0.3), (x, 2 + h + 1, z), (80, 80, 80), "Metal"))
            kids.append(part("Viga", (6, 0.8, 0.8), (x, 3 + h + 1, z), (80, 50, 30), "Wood"))
            for s in (-1, 1):
                kids.append(part("Poste", (0.8, 3 + h + 1, 0.8), (x + s * 3, (3 + h + 1) / 2 + 1, z), (80, 50, 30),
                                 "Wood"))
    req_txt = "LIBRE" if req == 0 else f"{req} FUERZA"
    kids.append(sign(f"{label}\n{req_txt}", (x, 1.5 + 1.5, z + 7.2), (0, 180, 0), 10))
    return model(key, kids, {"Tipo": kind, "Clave": key})


def build_training():
    kids = [part("Suelo", (120, 1, 90), (0, 0.5, -10), (70, 65, 60), "Concrete")]
    for i, (key, kind, req, label) in enumerate(TRAINING):
        x = [-40, -14, 12, -40, -14, 12][i]
        z = -30 if i < 3 else -2
        kids.append(training_station(key, kind, req, label, x, z))
    # Muñecos de práctica para habilidades
    dummies = []
    for i in range(4):
        x, z = 36 + (i % 2) * 10, -30 + (i // 2) * 14
        d = [
            part("Base", (3, 1, 3), (x, 1.5, z), (60, 40, 25), "Wood"),
            part("Poste", (0.6, 3, 0.6), (x, 3.5, z), (90, 60, 35), "Wood"),
            part("Cuerpo", (2.4, 3.2, 1.4), (x, 6.6, z), (190, 160, 110), "Fabric"),
            part("Cabeza", (1.6, 1.6, 1.6), (x, 9.0, z), (200, 170, 120), "Fabric", shape="Ball"),
        ]
        dummies.append(model(f"Muneco{i + 1}", d, {"VidaMax": 500}))
    kids.append({"name": "Munecos", "className": "Folder", "children": dummies})
    kids.append(sign("ZONA DE ENTRENAMIENTO", (-14, 12, -42), (0, 0, 0), 36))
    kids.append(sign("MUÑECOS: prueba tus habilidades", (41, 6, -40), (0, 0, 0), 18, (255, 120, 80)))
    for x in (-58, 58):
        for z in (-50, 30):
            kids.append(part("Antorcha", (1, 8, 1), (x, 4.5, z), (60, 40, 30), "Wood",
                             children=[light("PointLight", (255, 170, 80), 2, 25),
                                       {"name": "Fire", "className": "Fire", "properties": {"Size": 4, "Heat": 8}}]))
    return {"className": "Model", "children": kids}


ARENA_C = (0, 0, 4000)  # centro de la arena, lejos del mapa


def build_arena():
    rnd = random.Random(42)
    cx, cy, cz = ARENA_C
    kids = [part("Suelo", (260, 4, 260), (cx, cy - 2, cz), (55, 55, 60), "Slate")]
    # Círculo central de losas
    tiles = []
    for ring, r in enumerate((0, 14, 28, 40)):
        n = 1 if r == 0 else 8 + ring * 6
        for i in range(n):
            a = 2 * math.pi * i / n
            x, z = cx + r * math.cos(a), cz + r * math.sin(a)
            tiles.append(part("Losa", (11 if r else 14, 0.6 + rnd.random() * 0.3, 11 if r else 14),
                              (x, cy + 0.2 + rnd.random() * 0.15, z),
                              (70 + rnd.randint(-8, 8), 70 + rnd.randint(-8, 8), 78), "Cobblestone",
                              (rnd.uniform(-2, 2), math.degrees(-a), rnd.uniform(-2, 2))))
    kids.append(model("Losas", tiles))
    # Charcos (reflectantes)
    charcos = []
    for _ in range(22):
        a, r = rnd.uniform(0, 2 * math.pi), rnd.uniform(8, 95)
        s = rnd.uniform(5, 14)
        charcos.append(part("Charco", (s, 0.1, s * rnd.uniform(0.5, 1)), (cx + r * math.cos(a), cy + 0.62,
                                                                              cz + r * math.sin(a)),
                            (25, 30, 40), "Glass", (0, rnd.uniform(0, 180), 0)
                            ,                            extra={"Reflectance": 0.45, "Transparency": 0.15, "CanCollide": False,
                                   "CastShadow": False}))
    kids.append(model("Charcos", charcos))
    # Rocas irregulares alrededor y anillo de picos
    rocas = []
    for i in range(70):
        a = 2 * math.pi * i / 70 + rnd.uniform(-0.03, 0.03)
        r = rnd.uniform(62, 75)
        h = rnd.uniform(10, 34)
        w = rnd.uniform(7, 15)
        rocas.append(part("Roca", (w, h, w * rnd.uniform(0.6, 1.2)), (cx + r * math.cos(a), cy + h / 2 - 2,
                                                                      cz + r * math.sin(a)),
                          (45 + rnd.randint(-10, 10), 45 + rnd.randint(-10, 10), 50 + rnd.randint(-10, 10)),
                          rnd.choice(["Slate", "Rock", "Basalt"]),
                          (rnd.uniform(-14, 14), rnd.uniform(0, 360), rnd.uniform(-14, 14))))
    for _ in range(26):
        a, r = rnd.uniform(0, 2 * math.pi), rnd.uniform(44, 58)
        s = rnd.uniform(2, 6)
        rocas.append(part("Piedra", (s, s * 0.7, s * 1.2), (cx + r * math.cos(a), cy + s * 0.25, cz + r * math.sin(a)),
                          (55, 55, 60), rnd.choice(["Slate", "Rock"]),
                          (rnd.uniform(0, 40), rnd.uniform(0, 360), rnd.uniform(0, 40))))
    kids.append(model("Rocas", rocas))
    # Columnas en ruinas + braseros
    cols = []
    for i in range(8):
        a = 2 * math.pi * i / 8 + math.pi / 8
        x, z = cx + 52 * math.cos(a), cz + 52 * math.sin(a)
        h = rnd.choice([26, 18, 9, 30])
        cols.append(part("Columna", (5, h, 5), (x, cy + h / 2, z), (85, 85, 90), "Marble",
                         (rnd.uniform(-4, 4), 0, rnd.uniform(-4, 4))))
        if h > 20:
            cols.append(part("Brasero", (4, 1.5, 4), (x, cy + h + 0.75, z), (40, 35, 30), "CorrodedMetal",
                             children=[light("PointLight", (255, 120, 50), 4, 30, {"Shadows": True}),
                                       {"name": "Fire", "className": "Fire",
                                        "properties": {"Size": 7, "Heat": 12, "Color": [1, 0.45, 0.1],
                                                       "SecondaryColor": [0.6, 0.1, 0]}}]))
    kids.append(model("Columnas", cols))
    # Puntos de aparición y cámaras
    inv = {"Transparency": 1, "CanCollide": False, "CanQuery": False, "CanTouch": False}
    kids.append(part("PuntoA", (2, 1, 2), (cx, cy + 3, cz - 25), (255, 0, 0), extra=inv, angles=(0, 0, 0)))
    kids.append(part("PuntoB", (2, 1, 2), (cx, cy + 3, cz + 25), (0, 0, 255), extra=inv, angles=(0, 180, 0)))
    kids.append(part("Centro", (2, 1, 2), (cx, cy + 3, cz), (255, 255, 255), extra=inv))
    # Muros invisibles
    for (sx, sz, ox, oz) in ((260, 4, 0, 60), (260, 4, 0, -60), (4, 260, 60, 0), (4, 260, -60, 0)):
        kids.append(part("Limite", (sx, 80, sz), (cx + ox, cy + 40, cz + oz), (0, 0, 0),
                         extra={"Transparency": 1, "CanQuery": False, "CastShadow": False}))
    # Pequeño pórtico épico
    kids.append(sign("ARENA DEL JURAMENTO", (cx, cy + 22, cz - 66), (0, 0, 0), 40, (230, 230, 255)))
    return {"className": "Model", "children": kids}


def build_sword():
    # Handle = empuñadura con eje largo en Y; la hoja crece hacia +Y (ver Tool.Grip en Config).
    p = {"Anchored": False, "CanCollide": False, "Massless": True}
    handle = part("Handle", (0.35, 1.3, 0.35), (0, 0, 0), (35, 25, 20), "Fabric", extra=dict(p))
    kids = [handle,
            part("Pomo", (0.55, 0.45, 0.55), (0, -0.85, 0), (200, 170, 60), "Metal", extra=dict(p), shape="Ball"),
            part("Guarda", (1.9, 0.3, 0.45), (0, 0.8, 0), (200, 170, 60), "Metal", extra=dict(p)),
            part("Hoja", (0.18, 4.4, 0.55), (0, 3.15, 0), (210, 220, 235), "Metal",
                 extra=dict(p, Reflectance=0.35)),
            part("Filo", (0.08, 4.2, 0.12), (0, 3.1, 0.3), (150, 210, 255), "Neon", extra=dict(p, Transparency=0.2)),
            part("Punta", (0.18, 0.45, 0.4), (0, 5.55, 0), (210, 220, 235), "Metal", (45, 0, 0), extra=dict(p)),
            {"name": "Desenvainar", "className": "Sound",
             "properties": {"SoundId": "rbxasset://sounds/unsheath.wav", "Volume": 1}},
            {"name": "Tajo", "className": "Sound",
             "properties": {"SoundId": "rbxasset://sounds/swordslash.wav", "Volume": 1}},
            {"name": "Estocada", "className": "Sound",
             "properties": {"SoundId": "rbxasset://sounds/swordlunge.wav", "Volume": 1}}]
    # los sonidos van dentro del Handle
    handle["children"] = kids[6:]
    kids = kids[:6]
    return {"className": "Tool", "properties": {"RequiresHandle": True, "CanBeDropped": False,
                                                "ToolTip": "Espada del Juramento"}, "children": kids}


def main():
    for name, a in ANIMS.items():
        write_json(f"assets/Animaciones/{name}.model.json", keyframe_sequence(name, a))
    with open(os.path.join(ROOT, "src/ReplicatedStorage/AnimData.lua"), "w", encoding="utf-8") as f:
        f.write(lua_anim_data())
    write_json("assets/Workspace/Entrenamiento.model.json", build_training())
    write_json("assets/Workspace/Arena.model.json", build_arena())
    write_json("assets/Espadas/Espada.model.json", build_sword())
    print(f"{len(ANIMS)} animaciones, mundo y espada generados.")


if __name__ == "__main__":
    main()
