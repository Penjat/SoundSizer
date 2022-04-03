#include <metal_stdlib>
#include <RealityKit/RealityKit.h>

using namespace metal;

[[visible]]
void myShader(realitykit::surface_parameters params)
{
    // Retrieve the base color tint from the entity's material.
    half3 baseColorTint = (half3)params.material_constants().base_color_tint();
    
    // Retrieve the entity's texture coordinates.
    float2 uv = params.geometry().uv0();

    // Flip the texture coordinates y-axis. This is only needed for entities
    // loaded from USDZ or .reality files.
    uv.y = 1.0 - uv.y;
    
    // Sample a value from the material's base color texture based on the
    // flipped UV coordinates.
    auto tex = params.textures();
    half3 color = half3(0.2125, 0.7154, 0.0721);
    
    // Multiply the tint by the sampled value from the texture, and
    // assign the result to the shader's base color property.
    color *= baseColorTint;
    params.surface().set_base_color(color);
}
