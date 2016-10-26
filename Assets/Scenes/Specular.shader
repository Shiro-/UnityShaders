﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//Name of the shader
Shader "Specular"
{
	//Properties box
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("SpecularColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 10
	}

	SubShader
	{
		Pass
		{
			//Information about each pass
			Tags 
			{
				//forward rendering
				"LightMode" = "ForwardBase"
			}
			
			CGPROGRAM

			//pragmas
			#pragma vertex vert
			#pragma fragment frag

			//variables
			uniform float4 _Color;
			uniform float4 _SpecularColor;
			uniform float _Shininess;

			//unity variables
			uniform float4 _LightColor0;

			//structs
			struct vertexIn
			{
				float4 vertex : POSITION;
				//we need the normal direction
				float3 normal : NORMAL;
			};

			struct vertexOut
			{
				float4 position : SV_POSITION;
				//contains vertex color
				float4 color : COLOR;
			};

			//vertex func
			vertexOut vert(vertexIn v)
			{
				vertexOut output;

				output.color = float4(lightFinal * _Color.rgb, 1.0);
				output.position = mul(UNITY_MATRIX_MVP, v.vertex);

				return output;
			}

			//fragment func
			float4 frag(vertexOut i) : COLOR
			{
				return i.color;
			}
			ENDCG
		}
	}
	//Fallback Diffuse
}