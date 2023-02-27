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
// uniform vec3 position;

void main() {

    vUv = uv;
    vNormal = normal;
    //vPosition = position;
    vPositionWorld = vec3(modelMatrix * vec4(position, 1.0));
    vec4 sunPosWorld = modelMatrix * vec4(sunPos, 1.0);
    vSunPos = vec3(sunPosWorld);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}