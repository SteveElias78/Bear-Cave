#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform float uTime;
uniform float uSweepDir;   // -1=left, 0=still, +1=right
uniform float uSweepMag;   // 0.0 to 1.0 intensity

void main() {
    vec2 uv = vertTexCoord.st;
    vec4 baseColor = texture2D(texture, uv);
    float redIntensity = baseColor.r - max(baseColor.g, baseColor.b);

    if (redIntensity > 0.18) {
        // i'm making the wave direction follow the actual sweep direction
        // when she sweeps right, waves lean right; left they lean left
        float sweepBias = uSweepDir * uSweepMag * 0.008;
        float waveX = sin(uv.y * 22.0 + uTime * 2.5 + uSweepDir * uTime * 1.2) * 0.006 + sweepBias;
        float waveY = cos(uv.x * 22.0 + uTime * 2.2) * 0.005;

        vec2 distortedUV = uv + vec2(waveX, waveY);
        vec4 liquidColor = texture2D(texture, distortedUV);
        liquidColor.r = min(liquidColor.r + 0.06, 1.0);

        float blend = smoothstep(0.18, 0.38, redIntensity);
        gl_FragColor = mix(baseColor, liquidColor, blend);
    } else {
        gl_FragColor = baseColor;
    }
}
