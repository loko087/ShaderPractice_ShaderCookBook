Shader "Custom/AnisotropicSpecularJP" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Color",Color) =(1,1,1,1)
		_SpecularPower ("Specular Power",Range(0,1)) = 0.5
		_Specular ("Specular Amount",Range(0,1)) = 0.5
		_AnisoDir ("Anisotropic Direction",2D) = "white" {}
		_AnisoOffset ("Anisotropic Offset",Range(-1,1)) = -0.2

		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		//_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Anisotropic

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _AnisoDir;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};

		float4 _MainTint;
		float4 _SpecularColor;
		float _Specular;
		float _SpecularPower;
		float _AnisoOffset;

		//This is the way that we get the information from the normal map 2D texture that we are assigning in the inspector
		// we get the per pixel information so we can pass it to the surf function.
		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection;
			half Specular;
			fixed Gloss;
			fixed Alpha;

		};



		//half _Glossiness;
		//half _Metallic;
		//fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceAnisoOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

			//The next 2 lines allows us to pass the information of our 2D tex, into the  SurfaceAnisoOutput for the lighting function
			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir,IN.uv_AnisoDir));
			o.AnisoDirection = anisoTex;

			o.Specular = _Specular;
			o.Gloss = _SpecularPower;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
//			o.Metallic = _Metallic;
//			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}


		fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten) 
		{

			fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			float NdotL = saturate(dot(s.Normal,lightDir));

			fixed HdotA = dot(normalize(s.Normal + s.AnisoDirection),halfVector);

			float aniso = max(0,sin(radians((HdotA + _AnisoOffset)*180)));

			float spec = saturate(pow(aniso,s.Gloss * 128) * s.Specular);

			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * atten;
			c.a = s.Alpha;
			return c;



		}
		ENDCG
	}
	FallBack "Diffuse"
}
