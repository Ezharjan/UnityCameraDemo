Shader "Theta/Sphere1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaBlendTex ("Alpha Blend (RGBA)", 2D) = "white" {}
		_OffsetU ("Offset U", Range(-0.5, 0.5)) = 0 
		_OffsetV ("Offset V", Range(-0.5, 0.5)) = 0
		_ScaleU ("Scale U", Range(0.8, 1.2)) = 1
		_ScaleV ("Scale V", Range(0.8, 1.2)) = 1
		_ScaleCenterU ("Scale Center U", Range(0.0, 1.0)) = 0 
		_ScaleCenterV ("Scale Center V", Range(0.0, 1.0)) = 0
	}
	SubShader {
		Tags { "RenderType" = "Transparent" "Queue" = "Background" }
		Pass {
			Name "BASE"
			
			Blend SrcAlpha OneMinusSrcAlpha
			Lighting Off
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaBlendTex;
			uniform float _OffsetU;
			uniform float _OffsetV;
			uniform float _ScaleU;
			uniform float _ScaleV;
			uniform float _ScaleCenterU;
			uniform float _ScaleCenterV;

			float4 frag(v2f_img i) : COLOR {
				float2 uvCenter = float2(_ScaleCenterU, _ScaleCenterV);
				float2 uvOffset = float2(_OffsetU, _OffsetV);
				float2 uvScale = float2(_ScaleU, _ScaleV);
				float2 uv =  (i.uv - uvCenter) * uvScale + uvCenter + uvOffset;
				float4 tex = tex2D(_MainTex, uv);
				tex.a *= pow(1.0 - tex2D(_AlphaBlendTex, i.uv).a, 2);
				return tex;
			}
			ENDCG
		}
	}
}