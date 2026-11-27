# Field of Grass Simulatiion

A real-time simulation of a field of grass blowing in the wind! Done in GLSL.

---

A GLSL shader written for glslViewer, a local, console-based OpenGL shader sandbox. This repo is for practicing pure shader logic — lighting, distance fields, noise, color, and animation — without OpenGL boilerplate (no VAOs, VBOs, uniforms upload, or draw calls in C++).

What this is:

A shader sketchpad, 3-D dynamic field of grass with real-time wind. Each .frag, .vert and .obj is a self-contained experiment. Run it with glslViewer, edit, save, see the result instantly.

Local, not online. Runs on your actual GPU via OpenGL, not a browser/WebGL layer. No accounts, no limits, no network.

Transferable. The GLSL here (dot, pow, smoothstep, length) is the same GLSL used in a full C++ OpenGL project — only the plumbing differs.

---

Requirements:

1) glslViewer (tested on 3.5.2)
2) A GPU with OpenGL 3.3+ (tested on AMD Radeon / Mesa 26.0.8, GLSL 4.60)

---

Run:

First run:
create_grass_field.py and chooose GRID_SIZE and SPACING...then run said file to generate a grass_field.obj

Next run:

glslViewer grass.vert grass.frag grass_field.obj

Use -l (--life-coding) flag to keep the window open and reloads the shader every time you save the file.

---

This is the primary mode for these experiments. glslViewer provides:

  u_resolution — window size in pixels (width, height)

  u_time — seconds since start

  u_mouse — mouse position (x, y)

  gl_FragCoord — current pixel coordinate

    gl_FragColor — output color

---
 in/out of field with mouse!
