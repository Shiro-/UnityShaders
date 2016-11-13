/*
Reference to unitycookie/cgcookie for great tutorials on shader development
*/

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//Name of the shader
Shader "Texture"
{
	//Properties box
	Properties
	{
		_Color("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Diffuse Texture", 2D) = "white" {}
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

				//For textures
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;

				//Unity Variables
				uniform float4 _LightColor0;

				//Structs
				struct vertexIn
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
				};

				struct vertexOut
				{
					float4 position : SV_POSITION;
					float4 tex : TEXCOORD0;
					float4 positionWorld : TEXCOORD1;
					float3 normalDirection : TEXCOORD2;
				};

				//Vertex function
				vertexOut vert(vertexIn v)
				{
					vertexOut o;

					o.positionWorld = mul(unity_ObjectToWorld, v.vertex);
					o.normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					o.position = mul(UNITY_MATRIX_MVP, v.vertex);

					return o;
				}

				//Fragment funciton
				float4 frag(vertexOut i) : COLOR
				{
					float3 normalDir = i.normalDirection;
					float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.positionWorld.xyz);
					float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					float attenuation = 1.0;

					//Lighting
					float3 diffuseReflection = attenuation * _LightColor0.xyz * saturate(dot(normalDir, lightDirection));
					float3 specularReflection = attenuation * _LightColor0.xyz * saturate(dot(normalDir, lightDirection)) * pow(saturate(dot(reflect(-lightDirection, normalDir), viewDirection)), _Shininess);

					//Rim
					float rim = 1.0 - saturate(dot(normalize(viewDirection), normalDir));
					float3 rimLighting = attenuation * _LightColor0.xyz * _RimColor * saturate(dot(normalDir, lightDirection)) * pow(rim, _RimPower);

					float3 lightFinal = rimLighting + diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.rgb;

					return float4(lightFinal * _Color.xyz, 1.0);
				}
				ENDCG
			}

				//Passes are basically render passes
				Pass
				{
					Tags
					{
						"LightMode" = "ForwardAdd"
					}

					Blend One One

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

					struct vertexOut
					{
						float4 position : SV_POSITION;
						float4 positionWorld : TEXCOORD0;
						float3 normalDirection : TEXCOORD1;
					};

					//Vertex function
					vertexOut vert(vertexIn v)
					{
						vertexOut o;

						o.positionWorld = mul(unity_ObjectToWorld, v.vertex);
						o.normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
						o.position = mul(UNITY_MATRIX_MVP, v.vertex);

						return o;
					}

					//Fragment funciton
					float4 frag(vertexOut i) : COLOR
					{
						float3 normalDir = i.normalDirection;
						float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.positionWorld.xyz);
						float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
						float attenuation = 1.0;

						//Lighting
						float3 diffuseReflection = attenuation * _LightColor0.xyz * saturate(dot(normalDir, lightDirection));
						float3 specularReflection = attenuation * _LightColor0.xyz * saturate(dot(normalDir, lightDirection)) * pow(saturate(dot(reflect(-lightDirection, normalDir), viewDirection)), _Shininess);
	
						//Rim
						float rim = 1.0 - saturate(dot(normalize(viewDirection), normalDir));
						float3 rimLighting = attenuation * _LightColor0.xyz * _RimColor * saturate(dot(normalDir, lightDirection)) * pow(rim, _RimPower);

						float3 lightFinal = rimLighting + diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.rgb;

						return float4(lightFinal * _Color.xyz, 1.0);
					}
					ENDCG
				}
		}
	//Fallback Diffuse
}