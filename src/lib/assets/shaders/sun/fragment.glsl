// // uniform float time;

// // uniform float fogDensity;
// // uniform vec3 fogColor;

// // uniform sampler2D texture1;
// // uniform sampler2D texture2;

// // varying vec2 vUv;

// // void main(void) {

// //     vec2 position = -1.0 + 2.0 * vUv;

// //     vec4 noise = texture2D(texture1, vUv);
// //     vec2 T1 = vUv + vec2(1.5, -1.5) * time * 0.02;
// //     vec2 T2 = vUv + vec2(-0.5, 2.0) * time * 0.01;

// //     T1.x += noise.x * 2.0;
// //     T1.y += noise.y * 2.0;
// //     T2.x -= noise.y * 0.2;
// //     T2.y += noise.z * 0.2;

// //     float p = texture2D(texture1, T1 * 2.0).a;

// //     vec4 color = texture2D(texture2, T2 * 2.0);
// //     vec4 temp = color * (vec4(p, p, p, p) * 2.0) + (color * color - 0.1);

// //     if(temp.r > 1.0) {
// //         temp.bg += clamp(temp.r - 2.0, 0.0, 100.0);
// //     }
// //     if(temp.g > 1.0) {
// //         temp.rb += temp.g - 1.0;
// //     }
// //     if(temp.b > 1.0) {
// //         temp.rg += temp.b - 1.0;
// //     }

// //     gl_FragColor = temp;

// //     float depth = gl_FragCoord.z / gl_FragCoord.w;
// //     const float LOG2 = 1.442695;
// //     float fogFactor = exp2(-fogDensity * fogDensity * depth * depth * LOG2);
// //     fogFactor = 1.0 - clamp(fogFactor, 0.0, 1.0);

// //     gl_FragColor = mix(gl_FragColor, vec4(fogColor, gl_FragColor.w), fogFactor);

// // }

varying vec2 vUv;
uniform vec3 uSunPos;
uniform sampler2D texture1;
uniform sampler2D texture2;
varying vec3 vNormal;
varying vec3 vPositionWorld;

void main() {

    vec4 nightColor = texture2D(texture2, vUv);
    vec4 dayColor = texture2D(texture1, vUv);

    vec3 sunDirection = uSunPos - vPositionWorld;

    float cosineAngleSunToNormal = dot(sunDirection, normalize(vNormal));

    float mixAmount = (cosineAngleSunToNormal + 1.0) / 2.0;
    vec4 color = nightColor * (1.0 - mixAmount) + dayColor * mixAmount;

    gl_FragColor = vec4(color.x, color.y, color.z, 1.0);
}