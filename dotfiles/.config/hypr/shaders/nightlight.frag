#version 300 es
precision mediump float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec3 warm = vec3(color.r * 1.0, color.g * 0.82, color.b * 0.45);
    fragColor = vec4(warm, color.a);
}
