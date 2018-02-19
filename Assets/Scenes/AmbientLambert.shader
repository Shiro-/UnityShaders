// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
Reference to unitycookie/cgcookie for great tutorials on shader development
*/

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//Name of the shader
Shader "AmbientLambert"
{
	//Properties box
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
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

				float3 normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDir;
				float3 attenuation = 1.0;
				
				//calculate the light
				lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = attenuation * _LightColor0.xyz * max(0.0, dot(normalDir, lightDir));
				//Adding in the ambient effect
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

				output.color = float4(lightFinal * _Color.rgb, 1.0);
				output.position = UnityObjectToClipPos(v.vertex);
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