Shader "Custom/PackerShaderA" {
	Properties {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)

		_ColorA("Terrain Color A", Color) = (1,1,1,1)
		_ColorB("Terrain Color B", Color) = (1,1,1,1)
		_RTexture("Red Channel Texture",2D) = "" {}
		_GTexture("Green Channel Texture",2D) = "" {}
		_BTexture("Blue Channel Texture",2D) = "" {}
		_ATexture("Alpha Channel Texture",2D) = "" {}
		_BlendTexture("Red Channel Texture",2D) = "" {}


		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		//Lets map the properties into our subshader
		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;

		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTexture;


		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTexture;
		};





		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {

			//Get the pixel data from the blend texture
			//We need a float 4 here because the texture
			//will return X,Y,Z and W
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);

			//Get the data from the textures we want to blend
			float4 rTextData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gTextData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bTextData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aTextData = tex2D(_ATexture, IN.uv_ATexture);

			//Now we need to construct a new RGBA value and add all
			//the different blended texture back together
			float4 finalColor;
			finalColor = lerp(rTextData, gTextData, blendData.g);
			finalColor = lerp(finalColor, bTextData, blendData.b);
			finalColor = lerp(finalColor, aTextData, blendData.a);
			finalColor.a = 1.0;

			//Add on our terrain tinting colors
			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);

			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a; 

			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
