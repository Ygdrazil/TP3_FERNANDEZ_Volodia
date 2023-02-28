varying vec2 vUv;
uniform vec3 uSunPos;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D specularMap;
uniform sampler2D normalMap;
varying vec3 vNormal;
varying vec3 vPositionWorld;


void main() {

    vec3 N = normalize(vNormal);

    vec4 nightColor = texture2D(texture2, vUv);
    vec4 dayColor = texture2D(texture1, vUv);
    float glossCoefficient =  texture2D(specularMap, vUv).x;
    float gloss = 1.0 - glossCoefficient * 0.5;

    // "diffuse" light
    vec3 sunDirection = normalize(uSunPos - vPositionWorld);
    // Le "facteur" de réflection du point
    float lambertian = clamp(dot(sunDirection, N) + 0.5, 0.0 , 1.0);
    // L'ajout de 0.75 est pour compenser le fait que la lumière est proche de l'objet
    float mixAmount = smoothstep(0.0, 1.0, lambertian);
    float nightColorGreyScale = 0.3*nightColor.r + 0.59*nightColor.g + 0.11*nightColor.b;
    // pow(-1.25+2.5*lambertian,2.0),0.0,1.0
    vec4 diffuseLight = mix(nightColor, dayColor, mixAmount) * (lambertian * float(nightColorGreyScale <= 0.3) + 1.0 * float(nightColorGreyScale > 0.3));

    vec3 V = normalize(cameraPosition - vPositionWorld);
    // Phong
    //vec3 R = -sunDirection - 2.0*(dot(-sunDirection, N))*N;
    // float specularLight = clamp(dot(V, R), 0.0, 1.0);

    //Specular light
    // Blinn Phong
    vec3 H = normalize(sunDirection + V);
    float specularLight = clamp(dot(N, H), 0.0, 1.0) * float(lambertian > 0.1);
    // On remap la valeur du gloss pour pouvoir travailler dans un intervalle [0:1]
    float specularExponent = exp2(gloss * 11.0) + 1.0;
    specularLight = pow(specularLight, specularExponent);

    gl_FragColor = vec4(diffuseLight+specularLight * float(glossCoefficient > 0.3) );
}