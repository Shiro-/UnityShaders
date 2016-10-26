/*
Reference to unitycookie/cgcookie for great tutorials on shader development
*/

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//Name of the shader
Shader "PixelSpecular"
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
				float4 positionWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
			};

			//vertex func
			vertexOut vert(vertexIn v)
			{
				vertexOut output;

				output.positionWorld = mul(unity_ObjectToWorld, v.vertex);
				output.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				output.position = mul(UNITY_MATRIX_MVP, v.vertex);

				return output;

			}

			//fragment func
			float4 frag(vertexOut i) : COLOR
			{
				//vectors
				//normal multiplied by world transpose
				float3 normalDirection = i.normalDir;
				//multiply object to world to get vertex pos in world space, subtract from camera to get view direction
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.positionWorld.xyz);
				float3 lightDirection;
				float attenuation = 1.0;

				//calculate our lighting
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = attenuation * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 specularReflection = attenuation * _LightColor0.xyz * _SpecularColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

				return float4(lightFinal * _Color.rgb, 1.0);
			}
			ENDCG
		}
	}
	//Fallback Diffuse
}