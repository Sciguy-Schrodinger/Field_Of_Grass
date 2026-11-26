#version 330 core
layout (location = 0) in vec3 a_position;
layout (location = 1) in vec3 a_normal;

uniform float u_time;
uniform float blade_height = 0.05;
float wind_power_x = 10.0;
float wind_power_y = 5.0;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform mat4 u_invViewProj;

uniform mat4 u_modelMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_projectionMatrix;

out vec3 Normal;
out vec3 FragPos;

vec3 getMouseWorldOnGround(vec2 mousePx, vec2 res, mat4 invVP, float groundY){
  vec2 safeRes = max(res,vec2(1.0));
  vec2 ndc = (mousePx / safeRes) * 2.0 - 1.0;

  vec4 nearW = invVP * vec4(ndc, -1.0, 1.0);
  vec4 farW = invVP * vec4(ndc, 1.0, 1.0);

  vec3 ro = nearW.xyz / nearW.w;
  vec3 rd = (farW.xyz / farW.w) - ro;

  if(abs(nearW.w) < 1e-6 || abs(farW.w) < 1e-6){
   return vec3(0.0, groundY, 0.0);
   }

  rd = normalize(rd);

  if(abs(rd.y) < 1e-4){
  return vec3(ro.x,groundY,ro.z);
  }
  
  float t = clamp((groundY - ro.y) / rd.y,0.0,1000.0);

  return ro + rd * t; 
}

void main(){
    vec4 world = u_modelMatrix * vec4(a_position, 1.0);
    vec3 mouseWorld = getMouseWorldOnGround(u_mouse, u_resolution, u_invViewProj, 0.0);

    vec2 toBlade = world.xz - mouseWorld.xz;
    float dist = length(toBlade); 
    float mousePush = smoothstep(1.5, 0.0, dist) * 12.0;
    vec2 pushDir = normalize(toBlade + 1e-5);

    float height_factor = clamp(a_position.y / blade_height, 0.0, 1.0);
    float bend = height_factor * height_factor;

    float w1 = 6.0 * cos(dot(world.xz, vec2(0.8, 0.6)) * 1.5 + u_time * 1.2);
    float w2 = 4.0 * sin(dot(world.xz, vec2(-0.5, 0.86)) * 2.7 + u_time * 2.1);
    float w3 = 2.5 * sin(dot(world.xz, vec2(0.3, -0.95)) * 5.3 - u_time * 3.7);
    float w4 = 1.5 * cos(dot(world.xz, vec2(-0.9, -0.4)) * 9.45 + u_time * 4.3);

    float total_wind_power_x = w1 + w2 + w3 + w4;
    float total_wind_power_z = 0.7 * w1 - 0.8 * w2 + 0.9 * w3 - 0.6 * w4;
    
    world.x += (total_wind_power_x + pushDir.x * mousePush) * blade_height * bend;
    world.z += (total_wind_power_z + pushDir.y * mousePush) * blade_height * bend;

    
    FragPos = world.xyz;
    Normal = mat3(transpose(inverse(u_modelMatrix))) * a_normal;
    gl_Position = u_projectionMatrix * u_viewMatrix * world;
}