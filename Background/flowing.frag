//https://www.shadertoy.com/view/WtdXR8

#version 440

layout(location = 0) in vec2 qt_TexCoord0; //skip vertex shader
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 resolution;
    float customTime;
    vec3 color1;
    vec3 color2;
    float beatMultiplier;
    float uvScale;
    float loopCount;
    float invConst;
    float multipleColors;
    float audio;
};

void main() {
    vec2 fragCoord = qt_TexCoord0 * resolution;
    
    vec2 uv = (uvScale * fragCoord - resolution.xy) / min(resolution.x, resolution.y);
    
    float beat = max(0.5, audio * beatMultiplier);
    if (audio == 0.0) { //meaning no audio at all
        beat = 1.0;
    }
    
    for (float i = 1.0; i < loopCount; i++) { //bunch of layered waves doing what they are good at
        float invI = invConst / i;
        uv.x += invI * cos(i  * uv.y + customTime);
        uv.y += invI * cos(i  * uv.x + customTime);
    }
    
    vec3 baseColor;
    if(multipleColors == 1.) {
        vec3 baseColorA = color1;
        vec3 baseColorB = color2;
        float mixFactor = 0.5 + 0.5 * sin(customTime + uv.y - uv.x);
        baseColor = mix(baseColorA, baseColorB, mixFactor);
    } else {
        baseColor = color1;
    }
    
    //float directionAngle = customTime * 0.2; 
    //float linePattern = cos(directionAngle) * uv.x + sin(directionAngle) * uv.y;
    //vec3 color = baseColor / abs(sin(customTime - uv.y - uv.x));
    vec3 color = baseColor / abs(sin(customTime + uv.y - uv.x)); //this is what shows the color movement 
    //vec3 color = baseColor / abs(sin(customTime - linePattern));
    //vec3 color = vec3(uv.x, uv.y, 1.);
    
    if(beat > 0.0){
        color *= beat;
    }
    
    fragColor = vec4(color, qt_Opacity);
}