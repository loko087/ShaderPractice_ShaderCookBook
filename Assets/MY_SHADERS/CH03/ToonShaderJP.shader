Shader "Custom/ToonShaderJP" {
	Properties {
		//_Color ("Color", Color) = (1,1,1,1)
		//_RampTex ("Ramp Texture",2D) = "white" {} if you want to use ramping uncomment this
		_CellShadingLevels ("Cell Shading Levels",Float) = 1
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		//_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		//sampler2D _RampTex;
		float _CellShadingLevels;


		struct Input {
			float2 uv_MainTex;
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

		void surf (Input IN, inout SurfaceOutput o) {

			o.Albedo = tex2D(_MainTex,IN.uv_MainTex).rgb;

			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = c.a;
		}

		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten) {

			//We first calculate the dot product between the normal of the point that we are drawing with the light direction
			half NdotL = dot(s.Normal, lightDir);

			//This section allows us to set the lighting based on the "steps" of the ramp texture 
			//NdotL = tex2D(_RampTex,fixed2(NdotL,0.5)); //Uncomment if using texture for ramp
			half cel = floor(_CellShadingLevels * NdotL) / (_CellShadingLevels - 0.5);


			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (cel * atten * 1); // We multiply the color of the material, the light color with the dot product, the attenuation and a factor of 1.
			c.a = s.Alpha;
			return c;
		}



		ENDCG
	}
	FallBack "Diffuse"
}
