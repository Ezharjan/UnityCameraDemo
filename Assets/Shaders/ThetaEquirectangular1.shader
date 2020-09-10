// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Theta/Equirectangular1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaBlendTex ("Alpha Blend (RGBA)", 2D) = "white" {}
		_OffsetU ("Offset U", Range(-0.5, 0.5)) = 0 
		_OffsetV ("Offset V", Range(-0.5, 0.5)) = 0
		_ScaleU ("Scale U", Range(0.8, 1.5)) = 1
		_ScaleV ("Scale V", Range(0.8, 1.5)) = 1
		_ScaleCenterU ("Scale Center U", Range(0.0, 1.0)) = 0 
		_ScaleCenterV ("Scale Center V", Range(0.0, 1.0)) = 0
		_Aspect ("Aspect", Float) = 1.777777777
		_SnapMaxThreshold ("Snap Max Threshold", Range(0.4, 0.5)) = 0.45
		_SnapMinThreshold ("Snap Min Threshold", Range(0.0, 0.5)) = 0.1
	}
	SubShader {
		Tags { "RenderType" = "Transparent" "Queue" = "Background" }
		Pass {
			Name "BASE"
			
			Blend SrcAlpha OneMinusSrcAlpha
			Lighting Off
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define PI 3.1415925358979

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaBlendTex;
			uniform float _OffsetU;
			uniform float _OffsetV;
			uniform float _ScaleU;
			uniform float _ScaleV;
			uniform float _ScaleCenterU;
			uniform float _ScaleCenterV;
			uniform float _Aspect;
			uniform float _SnapMaxThreshold;
			uniform float _SnapMinThreshold;
			
			struct v2f {
                float4 position : SV_POSITION;
                float2 uv       : TEXCOORD0;
            };

            v2f vert(appdata_base v) {
            	float4 modelBase = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
            	float4 modelVert = mul(unity_ObjectToWorld, v.vertex);
            	
            	float x = modelVert.x;
            	float y = modelVert.y;
            	float z = modelVert.z;
            	
            	float r = sqrt(x*x + y*y + z*z);
            	x /= 2 * r;
            	y /= 2 * r;
            	z /= 2 * r;
            	
            	float latitude  = atan2(0.5, -y);
            	float longitude = atan2(x, z);  
            	
            	float ex = longitude / (2 * PI);
            	float ey = (latitude - PI / 2) / PI * 2;
            	float ez = 0;
            	
            	if (ex < -_SnapMaxThreshold && ey >  _SnapMinThreshold) ex = -0.5; 
            	if (ex >  _SnapMaxThreshold && ey < -_SnapMinThreshold) ex =  0.5; 
            	if (ey < -_SnapMaxThreshold && ex >  _SnapMinThreshold) ey = -0.5; 
            	if (ey >  _SnapMaxThreshold && ex < -_SnapMinThreshold) ey =  0.5; 
            	
            	ex *= _Aspect;
            	
            	modelVert = float4(float3(ex, ey, ez) * 2 * r, 1);

                v2f o;
                o.position = mul(UNITY_MATRIX_VP, modelVert);
                o.uv       = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
                return o;
            }	

			float4 frag(v2f i) : COLOR {
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