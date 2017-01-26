Shader "Custom/NormalShader" {
	Properties {
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		
		//Initialized to bump so Unity knows that this is a normal map
		_NormalTex ("Normal Map", 2D) = "bump" {}

	// We can also intensity to the normal map
		_NormalMapIntensity ("Normal Intensity", Range(0,3)) = 1

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _NormalTex;
		fixed4 _MainTint;
		float _NormalMapIntensity;

		struct Input
		{
			float2 uv_NormalTex;
		};
		

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Get the normal data out of the normal map texture using the built in function
			//float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			
			//If we are applying intensity
			fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			n.x *= _NormalMapIntensity;
			n.y *= _NormalMapIntensity;

			//Apply the new normal to the lighting model
			//o.Normal = normalMap.rgb;

			//Apply the intensity to the lighting model
			o.Normal = normalize(n);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
