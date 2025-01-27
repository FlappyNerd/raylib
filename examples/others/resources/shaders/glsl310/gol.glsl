#version 310 es

// Game of Life logic shader

#define GOL_WIDTH 768u

layout (local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(std430, binding = 1) readonly restrict buffer golLayout {
    uint golBuffer[];       // golBuffer[x, y] = golBuffer[x + gl_NumWorkGroups.x * y]
};

layout(std430, binding = 2) writeonly restrict buffer golLayout2 {
    uint golBufferDest[];   // golBufferDest[x, y] = golBufferDest[x + gl_NumWorkGroups.x * y]
};

#define fetchGol(x, y) ((((x) > GOL_WIDTH) || ((y) > GOL_WIDTH)) \
    ? (0u) \
    : golBuffer[(x) + GOL_WIDTH * (y)])

#define setGol(x, y, value) golBufferDest[(x) + GOL_WIDTH*(y)] = value

void main()
{
    uint neighbourCount = 0u;
    uint x = gl_GlobalInvocationID.x;
    uint y = gl_GlobalInvocationID.y;

    neighbourCount += fetchGol(x - 1u, y - 1u); // Top left
    neighbourCount += fetchGol(x, y - 1u);      // Top middle
    neighbourCount += fetchGol(x + 1u, y - 1u); // Top right
    neighbourCount += fetchGol(x - 1u, y);      // Left
    neighbourCount += fetchGol(x + 1u, y);      // Right
    neighbourCount += fetchGol(x - 1u, y + 1u); // Bottom left
    neighbourCount += fetchGol(x, y + 1u);      // Bottom middle   
    neighbourCount += fetchGol(x + 1u, y + 1u); // Bottom right

    if (neighbourCount == 3u) setGol(x, y, 1u);
    else if (neighbourCount == 2u) setGol(x, y, fetchGol(x, y));
    else setGol(x, y, 0u);
}
