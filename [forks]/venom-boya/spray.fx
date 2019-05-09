
float4 gSprayColor = float4(255,255,255,255);



float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;



texture gTexture0           < string textureState="0,Texture"; >;


sampler texsampler = sampler_state
{
    Texture = (gTexture0);
};


struct VertexShaderInput
{
    float3 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoords : TEXCOORD0;
};

struct PixelShaderInput
{
    float4 Position  : POSITION;
    float4 Diffuse : COLOR0;
    float2 TexCoords : TEXCOORD0;
};



PixelShaderInput VertexShaderFunction(VertexShaderInput In)
{
    PixelShaderInput Out = (PixelShaderInput)0;
	
	// Copy everything and send it over to pixel shader
	float4 posWorld = mul(float4(In.Position,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    Out.Position = mul(posWorldView, gProjection);
	Out.TexCoords = In.TexCoords;
	
	// Colorize diffuse
    Out.Diffuse = saturate(gSprayColor);
	
    return Out;
}


float4 PixelShaderFunction(PixelShaderInput In) : COLOR0
{
	// Get nitrous texture
	float4 texel = tex2D(texsampler, In.TexCoords);
	
	// Apply new color to texture
	float4 finalColor = texel * In.Diffuse;
		
	// Decrease brightness
	finalColor *= 0.23;
	
    return finalColor;
}



technique nitro
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}


technique fallback
{
    pass P0
    {
    }
}
