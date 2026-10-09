
cbuffer vsConstants : register(b0)
{
    float4x4 modelViewProj;
    float4x4 modelView;
    float3x3 normalMatrix;
};

struct DirectionalLight
{
    float4 dirEye; //NOTE: 빛 쪽으로 향하는 방향 벡터
    float4 color;
};

struct PointLight
{
    float4 posEye;
    float4 color;
};

// Create Constant Buffer for our Blinn-Phong vertex shader
cbuffer fsConstants : register(b0)
{
    DirectionalLight dirLight;
    PointLight pointLights[2];
};

struct VS_Input {
    float3 pos : POS;
    float2 uv : TEX;
    float3 norm : NORM;
};

struct VS_Output {
    float4 pos : SV_POSITION; // 클립 공간 좌표
    float3 posEye : POSITION; // 카메라 공간 상 좌표
    float3 normalEye : NORMAL; // 카메라 공간 상 법선벡터
    float2 uv : TEXCOORD;
};

Texture2D    mytexture : register(t0);
SamplerState mysampler : register(s0);

VS_Output vs_main(VS_Input input)
{
    VS_Output output;
    output.pos = mul(float4(input.pos, 1.0f), modelViewProj); // 물체 위치
    output.posEye = mul(float4(input.pos, 1.0f), modelView).xyz; // 눈 위치
    output.normalEye = mul(input.norm, normalMatrix); // 물체 법선
    output.uv = input.uv;
    return output;
}

float4 ps_main(VS_Output input) : SV_Target
{
    float3 diffuseColor = mytexture.Sample(mysampler, input.uv).xyz;

    float3 fragToCamDir = normalize(-input.posEye); // 픽셀 -> 카메라 방향 벡터
    
    // Directional Light 햇빛
    float3 dirLightIntensity;
    {
        float ambientStrength = 0.1; // 간접광 강도
        float specularStrength = 0.9; // 정반사 강도
        float specularExponent = 100; // 정반사 지수
        float3 lightDirEye = dirLight.dirEye.xyz; // 빛 쪽 방향 벡터
        float3 lightColor = dirLight.color.xyz; // 빛 색상

        float3 iAmbient = ambientStrength;

        // 난반사 정도 계산
        float diffuseFactor = max(0.0, dot(input.normalEye, lightDirEye)); // 난반사 정도 = 코사인(cos) 값 = 법선 벡터와 빛 뱡향 벡터 내적
        float3 iDiffuse = diffuseFactor;

        // 정반사 정도 계산
        float3 halfwayEye = normalize(fragToCamDir + lightDirEye); // 중간벡터 = 카메라와 빛 벡터의 중간 벡터
        float specularFactor = max(0.0, dot(halfwayEye, input.normalEye)); // 중간벡터와 물체 법선의 내적값
        float3 iSpecular = specularStrength * pow(specularFactor, 2 * specularExponent); // 정반사 정도 = 내적값을 지수만큼 거듭제곱 -> 정반사 강도(specularStrength)만큼 곱함

        dirLightIntensity = (iAmbient + iDiffuse + iSpecular) * lightColor; // (퍼짐강도 + 난반사 정도 + 정반사 정도) * 빛 색상
    }
    // Point Light 점광원 방사형
    float3 pointLightIntensity = float3(0,0,0);
    for(int i=0; i<2; ++i)
    {
        float ambientStrength = 0.1; // 간접광 강도
        float specularStrength = 0.9; // 정반사 강도
        float specularExponent = 100; // 정반시 지수
        float3 lightDirEye = pointLights[i].posEye.xyz - input.posEye; // 빛 쪽 방향 벡터 = 점광원[i].위치 - 물체 위치
        float inverseDistance = 1 / length(lightDirEye); // 거리가 멀면 약하게
        lightDirEye *= inverseDistance; // 단위벡터로 변환
        float3 lightColor = pointLights[i].color.xyz; // 빛 색

        float3 iAmbient = ambientStrength;

        // 난반사 정도 계산
        float diffuseFactor = max(0.0, dot(input.normalEye, lightDirEye)); // 난반사 정도 = 코사인(cos) 값 = 법선 벡터와 빛 뱡향 벡터 내적
        float3 iDiffuse = diffuseFactor;

        // 정반사 정도 계산
        float3 halfwayEye = normalize(fragToCamDir + lightDirEye); // 중간거리 = 카메라와 빛 벡터의 중간 벡터
        float specularFactor = max(0.0, dot(halfwayEye, input.normalEye)); // 중간벡터와 물체 법선의 내적값
        float3 iSpecular = specularStrength * pow(specularFactor, 2 * specularExponent); // 정반사 정도 = 내적값을 지수만큼 거듭제곱 -> 정반사 강도(specularStrength)만큼 곱함

        // 점광원의 개수만큼 더한다
        pointLightIntensity += (iAmbient + iDiffuse + iSpecular) * lightColor * inverseDistance; // pointLightIntensity += (퍼짐강도 + 난반사 정도 + 정반사 정도) * 빛 색상 * 1/거리
    }

    float3 result = (dirLightIntensity + pointLightIntensity) * diffuseColor;

    return float4(result, 1.0);
}
