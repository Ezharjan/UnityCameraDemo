﻿Shader "Theta/Equirectangular2" {
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
		Tags { "RenderType" = "Transparent" "Queue" = "Background+1" }
		UsePass "Theta/Equirectangular1/BASE"
	}
}