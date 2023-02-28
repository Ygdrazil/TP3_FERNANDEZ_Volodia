// uniform vec2 uvScale;
// varying vec2 vUv;

// void main() {

//     vUv = uvScale * uv;
//     vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
//     gl_Position = projectionMatrix * mvPosition;

// }

varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPositionWorld;
uniform vec3 sunPos;
varying vec3 vSunPos;
uniform mat4 uMatrixWorld;

void main() {

    vUv = uv;
    vNormal = normal;

    vSunPos = (modelMatrix * vec4(sunPos, 1.0)).xyz;

    vNormal = mat3(modelMatrix) * normal;

    vPositionWorld = (modelMatrix * vec4(position, 1.0)).xyz;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}