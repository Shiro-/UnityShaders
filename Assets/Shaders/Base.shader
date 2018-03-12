Shader "reStart/BaseShader"
{
	Properties
	{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
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

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
