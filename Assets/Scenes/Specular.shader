/*
Reference to unitycookie for great tutorials on shader development
*/

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
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

				//vectors
				//normal multiplied by world transpose
				float3 normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				//multiply object to world to get vertex pos in world space, subtract from camera to get view direction
				float3 viewDir = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - mul(unity_ObjectToWorld, v.vertex).xyz)); 
				float3 lightDir;
				float attenuation = 1.0;

				//calculate our lighting
				lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = attenuation * _LightColor0.xyz * max(0.0, dot(normalDir, lightDir));
				float3 specularReflection = attenuation * _SpecularColor.rgb * max(0.0, dot(normalDir, lightDir)) * pow(max(0.0, dot(reflect(-lightDir, normalDir), viewDir)), _Shininess);
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

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