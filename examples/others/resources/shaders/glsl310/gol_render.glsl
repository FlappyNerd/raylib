#version 310 es
precision highp float;

// Game of Life rendering shader
// Just renders the content of the ssbo at binding 1 to screen

#define GOL_WIDTH 768u

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;

// Output fragment color
out vec4 finalColor;

// Input game of life grid.
layout(std430, binding = 1) readonly buffer golLayout
{
    uint golBuffer[];
};

// Output resolution
uniform vec2 resolution;

void main()
{
    uvec2 coords = uvec2(fragTexCoord*resolution);

    if ((golBuffer[coords.x + coords.y*uvec2(resolution).x]) == 1u) finalColor = vec4(1.0);
    else finalColor = vec4(0.0, 0.0, 0.0, 1.0);
}
