/*
Reference to unitycookie/cgcookie for great tutorials on shader development
*/

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//Name of the shader
Shader "RimLighting"
{
	//Properties box
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("SpecularColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 10
		_RimColor("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("Rim Power", Range(0.1, 10.0)) = 3.0
	}

		SubShader
		{
			Pass
			{
				Tags
				{
					"LightMode" = "ForwardBase"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				//User Variables
				uniform float4 _Color;
				uniform float4 _SpecularColor;
				uniform float4 _RimColor;
				uniform float _Shininess;
				uniform float _RimPower;

				//Unity Variables
				uniform float4 _LightColor0;

				//Structs
				struct vertexIn
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct vertOut
				{
					float4 position : SV_POSITION;
					float4 positionWorld : TEXCOORD0;
					float3 normalDirection : TEXCOORD1;
				};

				//Vertex function

				ENDCG
			}
		}
	//Fallback Diffuse
}