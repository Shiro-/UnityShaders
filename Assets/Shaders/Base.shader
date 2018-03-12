Shader "reStart/BaseShader"
{
	Properties
	{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Emission ("Emission", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader
	{
		CGPROGRAM
#pragma surface surf Lambert

		struct Input
		{
			float2 MainTex;
		};

		fixed4 _Color;
		fixed4 _Emission;

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
			o.Emission = _Emission.rgb;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
