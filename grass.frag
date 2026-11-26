#version 330 core
in vec3 Normal;
in vec3 FragPos;
out vec4 FragColor;

void main(){
    FragColor = vec4(0.2, 0.6, 0.2, 1.0);   // flat green
}