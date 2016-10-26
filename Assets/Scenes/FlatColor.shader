/*
Reference to unitycookie/cgcookie for great tutorials on shader development
*/

//Name of the shader
Shader "FlatColor" 
{
	//This will create a properties box within unity
	Properties
	{
		//Variables with underscores can be changed through unity
		//Variables without can't
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	//What controls the shader
	SubShader
	{
		//Render pass in real time?
		Pass
		{
			CGPROGRAM

			//pragmas
			#pragma vertex vert
			#pragma fragment frag

			//user defined variables
			uniform float4 _Color;

			//input structs
			struct vertexIn
			{
				float4 vertex : POSITION;
			};

			struct vertexOut
			{
				float4 position : SV_POSITION;
			};

			//vertex func
			//This is what we will be writing to
			vertexOut vert(vertexIn v)
			{
				vertexOut output;
				
				//Process everything we need for vertices
				output.position = mul(UNITY_MATRIX_MVP, v.vertex);

				return output;
			}

			//fragment func
			float4 frag(vertexOut i) : COLOR
			{
				return _Color;
			}

			ENDCG
		}
	}
	//Fallback if the shader doesn't work
	Fallback "Diffuse"
}