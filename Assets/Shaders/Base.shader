Shader "reStart/BaseShader"
{
	Properties
	{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Emission ("Emission", Color) = (1.0, 1.0, 1.0, 1.0)
		_Normal ("Normal", Color) = (1.0, 1.0, 1.0, 1.0)
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
		fixed4 _Normal;

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
			o.Emission = _Emission.rgb;
			o.Normal = _Normal;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
