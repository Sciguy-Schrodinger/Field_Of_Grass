import math
import random

# --------------------------------------------------
# Settings
# --------------------------------------------------

INPUT_FILE = "grass.obj"
OUTPUT_FILE = "grass_field.obj"

GRID_SIZE = 100
SPACING = 0.5

# --------------------------------------------------
# Load the original OBJ
# --------------------------------------------------

vertices = []
normals = []
faces = []

with open(INPUT_FILE, "r") as file:
    for line in file:

        parts = line.strip().split()

        if not parts:
            continue

        # Read vertex positions
        if parts[0] == "v":
            vertices.append(
                tuple(map(float, parts[1:4]))
            )

        # Read vertex normals
        elif parts[0] == "vn":
            normals.append(
                tuple(map(float, parts[1:4]))
            )

        # Read triangular faces
        elif parts[0] == "f":

            face = []

            for vertex in parts[1:]:

                indices = vertex.split("/")

                vertex_index = int(indices[0]) - 1
                normal_index = int(indices[2]) - 1

                face.append(
                    (vertex_index, normal_index)
                )

            faces.append(face)

# --------------------------------------------------
# Generate the field
# --------------------------------------------------

with open(OUTPUT_FILE, "w") as file:

    file.write("# Procedurally generated grass field\n")

    for x in range(GRID_SIZE):
        for z in range(GRID_SIZE):

            # Random position inside this grid cell
            offset_x = (
                x * SPACING
                + random.uniform(-0.25, 0.25)
            )

            offset_z = (
                z * SPACING
                + random.uniform(-0.25, 0.25)
            )

            # Random rotation around the Y axis
            angle = random.uniform(0.0, 2.0 * math.pi)

            cos_angle = math.cos(angle)
            sin_angle = math.sin(angle)

            # Slight variation in size
            scale = random.uniform(0.8, 1.2)

            # Current OBJ index offsets
            vertex_offset = len(vertices) * (
                x * GRID_SIZE + z
            )

            normal_offset = len(normals) * (
                x * GRID_SIZE + z
            )

            # Transform and write vertices
            for vx, vy, vz in vertices:

                rx = (
                    vx * cos_angle
                    + vz * sin_angle
                )

                rz = (
                    -vx * sin_angle
                    + vz * cos_angle
                )

                rx = rx * scale + offset_x
                ry = vy * scale
                rz = rz * scale + offset_z

                file.write(
                    f"v {rx} {ry} {rz}\n"
                )

            # Transform and write normals
            for nx, ny, nz in normals:

                rx = (
                    nx * cos_angle
                    + nz * sin_angle
                )

                rz = (
                    -nx * sin_angle
                    + nz * cos_angle
                )

                file.write(
                    f"vn {rx} {ny} {rz}\n"
                )

            # Write faces using the new indices
            for face in faces:

                face_string = []

                for vi, ni in face:

                    new_vi = vertex_offset + vi + 1
                    new_ni = normal_offset + ni + 1

                    face_string.append(
                        f"{new_vi}//{new_ni}"
                    )

                file.write(
                    "f " + " ".join(face_string) + "\n"
                )

print("Grass field generated!")
