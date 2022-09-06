//UNITY_SHADER_NO_UPGRADE

Shader "Unlit/WaveShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4x4 _CustomMVP;	

			struct vertIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertOut
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			// Implementation of the vertex shader
			vertOut vert(vertIn v)
			{
				//Displace the original vertex in model space
				// + instead of *
				// float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f) * sin(v.vertex.x + _Time.y);
				// v.vertex += displacement;

				vertOut o;
				// o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

				float4 viewPosition = mul(UNITY_MATRIX_MV, v.vertex);
				// TODO
				viewPosition.y += sin(viewPosition.x);

				// project matrix
				// float4 projectingPosition = mul(UNITY_MATRIX_P, v.vertex);
				o.vertex = mul(UNITY_MATRIX_P, viewPosition);

				o.uv = v.uv;
				return o;
			}
			
			// Implementation of the fragment shader
			fixed4 frag(vertOut v) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, v.uv);
				return col;
			}
			ENDCG
		}
	}
}