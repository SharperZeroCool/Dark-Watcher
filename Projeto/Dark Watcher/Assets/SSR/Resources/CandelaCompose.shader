// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/CandelaCompose" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 4 math
 //        d3d9 : 5 math
 //       gles3 : 206 math, 8 texture, 12 branch
 //       metal : 3 math
 //      opengl : 206 math, 8 texture, 12 branch
 // Stats for Fragment shader:
 //       d3d11 : 155 math, 5 texture, 8 branch
 //        d3d9 : 212 math, 9 texture, 16 branch
 //       metal : 206 math, 8 texture, 12 branch
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 19760
Program "vp" {
SubProgram "opengl " {
// Stats: 206 math, 8 textures, 12 branches
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (mat4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0) * tmpvar_1).xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec3 _WorldSpaceCameraPos;
uniform sampler2D _MainTex;
uniform sampler2D _SSRtexture;
uniform vec4 _ScreenFadeControls;
uniform float _UseEdgeTexture;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform sampler2D _EdgeFadeTexture;
uniform float _SSRRcomposeMode;
uniform float _reflectionMultiply;
uniform sampler2D _CameraDepthTexture;
uniform float _FlipReflectionsMSAA;
uniform float _fadePower;
uniform float _fresfade;
uniform float _fresrange;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraGBufferTexture1;
uniform mat4 _ViewProjectInverse;
uniform float _convolutionSamples;
uniform float _swidth;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  float roughness_1;
  vec4 SSRColor_2;
  vec2 inUV_3;
  vec4 col_4;
  float screenFade_5;
  vec4 specular_6;
  vec4 worldnorm_7;
  vec2 uvtmp_8;
  uvtmp_8 = xlv_TEXCOORD0;
  if ((_FlipReflectionsMSAA > 0.0)) {
    uvtmp_8.y = (1.0 - xlv_TEXCOORD0.y);
  };
  vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 tmpvar_10;
  tmpvar_10.xy = ((uvtmp_8 * 2.0) - 1.0);
  tmpvar_10.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  vec4 tmpvar_12;
  tmpvar_12 = (_ViewProjectInverse * tmpvar_11);
  vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = -(normalize((
    (tmpvar_12 / tmpvar_12.w)
  .xyz - _WorldSpaceCameraPos)));
  float tmpvar_14;
  tmpvar_14 = clamp (dot (normalize(
    normalize(((texture2D (_CameraNormalsTexture, uvtmp_8) * 2.0) - 1.0))
  ), tmpvar_13), 0.0, 1.0);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraNormalsTexture, uvtmp_8);
  worldnorm_7 = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, xlv_TEXCOORD0);
  specular_6 = tmpvar_16;
  if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
    specular_6 = tmpvar_15.wwww;
  } else {
    worldnorm_7 = tmpvar_16;
  };
  specular_6.w = pow (specular_6.w, 0.6666667);
  worldnorm_7.w = pow (worldnorm_7.w, 4.1);
  screenFade_5 = 1.0;
  if ((_UseEdgeTexture > 0.0)) {
    screenFade_5 = texture2D (_EdgeFadeTexture, xlv_TEXCOORD0).x;
  } else {
    vec2 x_17;
    x_17 = ((xlv_TEXCOORD0 * 2.0) - 1.0);
    screenFade_5 = (1.0 - pow (clamp (
      ((pow (sqrt(
        dot (x_17, x_17)
      ), _ScreenFadeControls.y) - _ScreenFadeControls.z) * _ScreenFadeControls.w)
    , 0.0, 1.0), 0.9));
  };
  float tmpvar_18;
  tmpvar_18 = pow (screenFade_5, 4.2);
  screenFade_5 = tmpvar_18;
  col_4 = vec4(0.0, 0.0, 0.0, 0.0);
  inUV_3 = xlv_TEXCOORD0;
  SSRColor_2 = vec4(0.0, 0.0, 0.0, 0.0);
  float tmpvar_19;
  tmpvar_19 = max ((specular_6.w * pow (
    (1.0 - pow (tmpvar_14, (8.0 * mix (1.0, 0.4, _fadePower))))
  , 
    (200.0 * (1.0 - specular_6.w))
  )), 0.05);
  roughness_1 = tmpvar_19;
  float tmpvar_20;
  tmpvar_20 = pow ((1.0 - pow (tmpvar_14, 
    (10.5 - _fresfade)
  )), exp((
    (_fresrange * 10.0)
   * 
    (1.0 - (tmpvar_19 * 0.2))
  )));
  if ((_convolutionSamples > 3.0)) {
    for (int i_1_21; i_1_21 < int(_convolutionSamples); i_1_21++) {
      int sn_22;
      sn_22 = int(_convolutionSamples);
      int n_23;
      n_23 = i_1_21;
      float invBi_24;
      float bitSeq_25;
      bitSeq_25 = 0.0;
      invBi_24 = 0.3333333;
      while (true) {
        if ((n_23 <= 0)) {
          break;
        };
        bitSeq_25 = (bitSeq_25 + (float(
          int((float(mod (float(n_23), 3.0))))
        ) * invBi_24));
        n_23 = (n_23 / 3);
        invBi_24 = (invBi_24 * 0.3333333);
      };
      vec2 tmpvar_26;
      tmpvar_26.x = (float(i_1_21) * (1.0/(float(sn_22))));
      tmpvar_26.y = bitSeq_25;
      float R_27;
      R_27 = (1.0 - roughness_1);
      vec3 H_28;
      float tmpvar_29;
      tmpvar_29 = (R_27 * R_27);
      float tmpvar_30;
      tmpvar_30 = ((2.0 / (tmpvar_29 * tmpvar_29)) - 2.0);
      float tmpvar_31;
      tmpvar_31 = (6.283185 * tmpvar_26.x);
      float tmpvar_32;
      tmpvar_32 = pow (max (bitSeq_25, 0.001), (1.0/((tmpvar_30 + 1.0))));
      float tmpvar_33;
      tmpvar_33 = sqrt((1.0 - (tmpvar_32 * tmpvar_32)));
      H_28.x = (tmpvar_33 * cos(tmpvar_31));
      H_28.y = (tmpvar_33 * sin(tmpvar_31));
      H_28.z = tmpvar_32;
      vec4 tmpvar_34;
      tmpvar_34.xyz = H_28;
      tmpvar_34.w = (((
        (tmpvar_30 + 2.0)
       / 6.283185) * clamp (
        pow (tmpvar_32, tmpvar_30)
      , 0.0, 1.0)) * tmpvar_32);
      int ts_35;
      ts_35 = int(_swidth);
      vec4 tmpvar_36;
      tmpvar_36.z = 0.0;
      tmpvar_36.xy = (inUV_3 + H_28.xy);
      tmpvar_36.w = (((0.5 * 
        log2((float((ts_35 * ts_35)) / float(int(_convolutionSamples))))
      ) + 2.0) - (0.5 * log2(tmpvar_34.w)));
      SSRColor_2.xyz = (SSRColor_2.xyz + texture2DLod (_SSRtexture, tmpvar_36.xy, tmpvar_36.w).xyz);
    };
    SSRColor_2.xyz = (SSRColor_2.xyz / _convolutionSamples);
  } else {
    SSRColor_2.xyz = texture2DLod (_SSRtexture, xlv_TEXCOORD0, 0.0).xyz;
  };
  if ((_SSRRcomposeMode > 0.0)) {
    if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
      vec4 tmpvar_37;
      tmpvar_37.w = 1.0;
      tmpvar_37.xyz = (SSRColor_2.xyz * (specular_6.xyz + (
        (1.0 - specular_6.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_14)
         - 6.983162) * tmpvar_14) * clamp ((0.5 - tmpvar_19), 0.0, 1.0)))
      )));
      col_4 = (((
        (tmpvar_37 * tmpvar_20)
       * worldnorm_7.w) * _reflectionMultiply) + (tmpvar_9 * (1.0 - 
        ((tmpvar_20 * _reflectionMultiply) * worldnorm_7.w)
      )));
    } else {
      vec4 tmpvar_38;
      tmpvar_38.w = 1.0;
      tmpvar_38.xyz = (SSRColor_2.xyz * (specular_6.xyz + (
        (1.0 - specular_6.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_14)
         - 6.983162) * tmpvar_14) * clamp ((0.5 - tmpvar_19), 0.0, 1.0)))
      )));
      vec4 tmpvar_39;
      tmpvar_39.w = 0.0;
      tmpvar_39.xyz = (worldnorm_7.xyz + 0.03);
      col_4 = (((
        ((tmpvar_38 * tmpvar_20) * clamp (pow (tmpvar_39, vec4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), vec4(0.5, 0.5, 0.5, 0.5), vec4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_7.w) * _reflectionMultiply) + (tmpvar_9 * (1.0 - 
        ((tmpvar_20 * _reflectionMultiply) * worldnorm_7.w)
      )));
    };
  } else {
    if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
      vec4 tmpvar_40;
      tmpvar_40.w = 1.0;
      tmpvar_40.xyz = (SSRColor_2.xyz * (specular_6.xyz + (
        (1.0 - specular_6.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_14)
         - 6.983162) * tmpvar_14) * clamp ((0.5 - tmpvar_19), 0.0, 1.0)))
      )));
      col_4 = (((
        (tmpvar_40 * tmpvar_20)
       * worldnorm_7.w) * _reflectionMultiply) + tmpvar_9);
    } else {
      vec4 tmpvar_41;
      tmpvar_41.w = 1.0;
      tmpvar_41.xyz = (SSRColor_2.xyz * (specular_6.xyz + (
        (1.0 - specular_6.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_14)
         - 6.983162) * tmpvar_14) * clamp ((0.5 - tmpvar_19), 0.0, 1.0)))
      )));
      vec4 tmpvar_42;
      tmpvar_42.w = 0.0;
      tmpvar_42.xyz = (worldnorm_7.xyz + 0.03);
      col_4 = (((
        ((tmpvar_41 * tmpvar_20) * clamp (pow (tmpvar_42, vec4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), vec4(0.5, 0.5, 0.5, 0.5), vec4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_7.w) * _reflectionMultiply) + tmpvar_9);
    };
  };
  if ((_ScreenFadeControls.x > 0.0)) {
    col_4 = vec4(tmpvar_18);
  };
  gl_FragData[0] = mix (tmpvar_9, col_4, vec4(tmpvar_18));
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 5 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_3_0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov o1.xy, v1

"
}
SubProgram "d3d11 " {
// Stats: 4 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedgcclnnbgpijgpddakojponflfpghdgniabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}
SubProgram "gles3 " {
// Stats: 206 math, 8 textures, 12 branches
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec2 inUV_2;
  inUV_2 = tmpvar_1;
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = inUV_2;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (mat4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0) * tmpvar_3).xy;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _MainTex;
uniform sampler2D _SSRtexture;
uniform highp vec4 _ScreenFadeControls;
uniform highp float _UseEdgeTexture;
uniform highp float _IsInForwardRender;
uniform highp float _IsInLegacyDeffered;
uniform sampler2D _EdgeFadeTexture;
uniform highp float _SSRRcomposeMode;
uniform highp float _reflectionMultiply;
uniform sampler2D _CameraDepthTexture;
uniform highp float _FlipReflectionsMSAA;
uniform highp float _fadePower;
uniform highp float _fresfade;
uniform highp float _fresrange;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraGBufferTexture1;
uniform highp mat4 _ViewProjectInverse;
uniform highp float _convolutionSamples;
uniform highp float _swidth;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp float roughness_2;
  highp vec4 SSRColor_3;
  highp vec2 inUV_4;
  highp vec4 col_5;
  highp float screenFade_6;
  highp vec4 specular_7;
  highp vec4 worldnorm2_8;
  highp vec4 worldnorm_9;
  highp float ZD_10;
  highp vec4 Mainworldnormal_11;
  highp vec4 original_12;
  highp vec2 uvtmp_13;
  uvtmp_13 = xlv_TEXCOORD0;
  if ((_FlipReflectionsMSAA > 0.0)) {
    uvtmp_13.y = (1.0 - xlv_TEXCOORD0.y);
  };
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture (_MainTex, xlv_TEXCOORD0);
  original_12 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = ((texture (_CameraNormalsTexture, uvtmp_13) * 2.0) - 1.0);
  Mainworldnormal_11 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = normalize(Mainworldnormal_11);
  Mainworldnormal_11 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture (_CameraDepthTexture, xlv_TEXCOORD0).x;
  ZD_10 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18.xy = ((uvtmp_13 * 2.0) - 1.0);
  tmpvar_18.z = ZD_10;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_18;
  highp vec4 tmpvar_20;
  tmpvar_20 = (_ViewProjectInverse * tmpvar_19);
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = -(normalize((
    (tmpvar_20 / tmpvar_20.w)
  .xyz - _WorldSpaceCameraPos)));
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize(tmpvar_16), tmpvar_21), 0.0, 1.0);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture (_CameraNormalsTexture, uvtmp_13);
  worldnorm_9 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture (_CameraGBufferTexture1, xlv_TEXCOORD0);
  worldnorm2_8 = tmpvar_24;
  specular_7 = worldnorm2_8;
  if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
    specular_7 = worldnorm_9.wwww;
  } else {
    worldnorm_9 = worldnorm2_8;
  };
  specular_7.w = pow (specular_7.w, 0.6666667);
  worldnorm_9.w = pow (worldnorm_9.w, 4.1);
  screenFade_6 = 1.0;
  if ((_UseEdgeTexture > 0.0)) {
    lowp float tmpvar_25;
    tmpvar_25 = texture (_EdgeFadeTexture, xlv_TEXCOORD0).x;
    screenFade_6 = tmpvar_25;
  } else {
    highp vec2 x_26;
    x_26 = ((xlv_TEXCOORD0 * 2.0) - 1.0);
    screenFade_6 = (1.0 - pow (clamp (
      ((pow (sqrt(
        dot (x_26, x_26)
      ), _ScreenFadeControls.y) - _ScreenFadeControls.z) * _ScreenFadeControls.w)
    , 0.0, 1.0), 0.9));
  };
  highp float tmpvar_27;
  tmpvar_27 = pow (screenFade_6, 4.2);
  screenFade_6 = tmpvar_27;
  col_5 = vec4(0.0, 0.0, 0.0, 0.0);
  inUV_4 = xlv_TEXCOORD0;
  SSRColor_3 = vec4(0.0, 0.0, 0.0, 0.0);
  highp float tmpvar_28;
  tmpvar_28 = max ((specular_7.w * pow (
    (1.0 - pow (tmpvar_22, (8.0 * mix (1.0, 0.4, _fadePower))))
  , 
    (200.0 * (1.0 - specular_7.w))
  )), 0.05);
  roughness_2 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = pow ((1.0 - pow (tmpvar_22, 
    (10.5 - _fresfade)
  )), exp((
    (_fresrange * 10.0)
   * 
    (1.0 - (tmpvar_28 * 0.2))
  )));
  if ((_convolutionSamples > 3.0)) {
    for (int i_1_30; i_1_30 < int(_convolutionSamples); i_1_30++) {
      int sn_31;
      sn_31 = int(_convolutionSamples);
      int n_32;
      n_32 = i_1_30;
      highp float invBi_33;
      highp float bitSeq_34;
      bitSeq_34 = 0.0;
      invBi_33 = 0.3333333;
      while (true) {
        if ((n_32 <= 0)) {
          break;
        };
        bitSeq_34 = (bitSeq_34 + (float(
          int((float(mod (float(n_32), 3.0))))
        ) * invBi_33));
        n_32 = (n_32 / 3);
        invBi_33 = (invBi_33 * 0.3333333);
      };
      highp vec2 tmpvar_35;
      tmpvar_35.x = (float(i_1_30) * (1.0/(float(sn_31))));
      tmpvar_35.y = bitSeq_34;
      highp float R_36;
      R_36 = (1.0 - roughness_2);
      highp vec3 H_37;
      highp float tmpvar_38;
      tmpvar_38 = (R_36 * R_36);
      highp float tmpvar_39;
      tmpvar_39 = ((2.0 / (tmpvar_38 * tmpvar_38)) - 2.0);
      highp float tmpvar_40;
      tmpvar_40 = (6.283185 * tmpvar_35.x);
      highp float tmpvar_41;
      tmpvar_41 = pow (max (bitSeq_34, 0.001), (1.0/((tmpvar_39 + 1.0))));
      highp float tmpvar_42;
      tmpvar_42 = sqrt((1.0 - (tmpvar_41 * tmpvar_41)));
      H_37.x = (tmpvar_42 * cos(tmpvar_40));
      H_37.y = (tmpvar_42 * sin(tmpvar_40));
      H_37.z = tmpvar_41;
      highp vec4 tmpvar_43;
      tmpvar_43.xyz = H_37;
      tmpvar_43.w = (((
        (tmpvar_39 + 2.0)
       / 6.283185) * clamp (
        pow (tmpvar_41, tmpvar_39)
      , 0.0, 1.0)) * tmpvar_41);
      int ts_44;
      ts_44 = int(_swidth);
      highp vec4 tmpvar_45;
      tmpvar_45.z = 0.0;
      tmpvar_45.xy = (inUV_4 + H_37.xy);
      tmpvar_45.w = (((0.5 * 
        log2((float((ts_44 * ts_44)) / float(int(_convolutionSamples))))
      ) + 2.0) - (0.5 * log2(tmpvar_43.w)));
      lowp vec4 tmpvar_46;
      tmpvar_46 = textureLod (_SSRtexture, tmpvar_45.xy, tmpvar_45.w);
      SSRColor_3.xyz = (SSRColor_3.xyz + tmpvar_46.xyz);
    };
    SSRColor_3.xyz = (SSRColor_3.xyz / _convolutionSamples);
  } else {
    lowp vec3 tmpvar_47;
    tmpvar_47 = textureLod (_SSRtexture, xlv_TEXCOORD0, 0.0).xyz;
    SSRColor_3.xyz = tmpvar_47;
  };
  if ((_SSRRcomposeMode > 0.0)) {
    if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
      highp vec4 tmpvar_48;
      tmpvar_48.w = 1.0;
      tmpvar_48.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      col_5 = (((
        (tmpvar_48 * tmpvar_29)
       * worldnorm_9.w) * _reflectionMultiply) + (original_12 * (1.0 - 
        ((tmpvar_29 * _reflectionMultiply) * worldnorm_9.w)
      )));
    } else {
      highp vec4 tmpvar_49;
      tmpvar_49.w = 1.0;
      tmpvar_49.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      highp vec4 tmpvar_50;
      tmpvar_50.w = 0.0;
      tmpvar_50.xyz = (worldnorm_9.xyz + 0.03);
      col_5 = (((
        ((tmpvar_49 * tmpvar_29) * clamp (pow (tmpvar_50, vec4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), vec4(0.5, 0.5, 0.5, 0.5), vec4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_9.w) * _reflectionMultiply) + (original_12 * (1.0 - 
        ((tmpvar_29 * _reflectionMultiply) * worldnorm_9.w)
      )));
    };
  } else {
    if ((bool(_IsInForwardRender) || (_IsInLegacyDeffered > 0.0))) {
      highp vec4 tmpvar_51;
      tmpvar_51.w = 1.0;
      tmpvar_51.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      col_5 = (((
        (tmpvar_51 * tmpvar_29)
       * worldnorm_9.w) * _reflectionMultiply) + original_12);
    } else {
      highp vec4 tmpvar_52;
      tmpvar_52.w = 1.0;
      tmpvar_52.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      highp vec4 tmpvar_53;
      tmpvar_53.w = 0.0;
      tmpvar_53.xyz = (worldnorm_9.xyz + 0.03);
      col_5 = (((
        ((tmpvar_52 * tmpvar_29) * clamp (pow (tmpvar_53, vec4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), vec4(0.5, 0.5, 0.5, 0.5), vec4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_9.w) * _reflectionMultiply) + original_12);
    };
  };
  if ((_ScreenFadeControls.x > 0.0)) {
    col_5 = vec4(tmpvar_27);
  };
  highp vec4 tmpvar_54;
  tmpvar_54 = mix (original_12, col_5, vec4(tmpvar_27));
  tmpvar_1 = tmpvar_54;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "metal " {
// Stats: 3 math
Bind "vertex" ATTR0
Bind "texcoord" ATTR1
ConstBuffer "$Globals" 64
Matrix 0 [glstate_matrix_mvp]
"metal_vs
#include <metal_stdlib>
using namespace metal;
struct xlatMtlShaderInput {
  float4 _glesVertex [[attribute(0)]];
  float4 _glesMultiTexCoord0 [[attribute(1)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float2 xlv_TEXCOORD0;
};
struct xlatMtlShaderUniform {
  float4x4 glstate_matrix_mvp;
};
vertex xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  half2 tmpvar_1;
  tmpvar_1 = half2(_mtl_i._glesMultiTexCoord0.xy);
  float2 inUV_2;
  inUV_2 = float2(tmpvar_1);
  float4 tmpvar_3;
  tmpvar_3.zw = float2(0.0, 0.0);
  tmpvar_3.xy = inUV_2;
  _mtl_o.gl_Position = (_mtl_u.glstate_matrix_mvp * _mtl_i._glesVertex);
  _mtl_o.xlv_TEXCOORD0 = (float4x4(float4(1.0, 0.0, 0.0, 0.0), float4(0.0, 1.0, 0.0, 0.0), float4(0.0, 0.0, 1.0, 0.0), float4(0.0, 0.0, 0.0, 1.0)) * tmpvar_3).xy;
  return _mtl_o;
}

"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 212 math, 9 textures, 16 branches
Matrix 0 [_ViewProjectInverse]
Float 11 [_FlipReflectionsMSAA]
Float 7 [_IsInForwardRender]
Float 8 [_IsInLegacyDeffered]
Float 9 [_SSRRcomposeMode]
Vector 5 [_ScreenFadeControls]
Float 6 [_UseEdgeTexture]
Vector 4 [_WorldSpaceCameraPos]
Float 15 [_convolutionSamples]
Float 12 [_fadePower]
Float 13 [_fresfade]
Float 14 [_fresrange]
Float 10 [_reflectionMultiply]
Float 16 [_swidth]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SSRtexture] 2D 1
SetTexture 2 [_EdgeFadeTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture1] 2D 5
"ps_3_0
def c17, 1, 2, -1, 0
def c18, -0.600000024, 1, 8, 200
def c19, 0.0500000007, 10.5, 10, 1.44269502
def c20, 0.200000003, 1, 3, 0.318309873
def c21, 3, 0.333333343, -3, -0.333333343
def c22, 2, -2, -1, 0.5
def c23, 6.28318548, -3.14159274, -5.55473089, -6.98316193
def c24, 0.0299999993, 0.161290318, 0, 0
def c25, 0, 0.333333343, -0.00100000005, -9.96578407
def c26, 0.666666687, 4.0999999, 0.899999976, 4.19999981
defi i0, 255, 0, 0, 0
dcl_texcoord v0.xy
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
add r0.x, c17.x, -v0.y
cmp r0.y, -c11.x, v0.y, r0.x
texld r1, v0, s0
mov r0.x, v0.x
texld r2, r0, s4
mad r3, r2, c17.y, c17.z
dp4 r0.z, r3, r3
rsq r0.z, r0.z
mul r3.xyz, r0.z, r3
texld r4, v0, s3
mad r0.xy, r0, c17.y, c17.z
mad r0.zw, r4.x, c17.xyxw, c17.xywx
dp4 r4.x, c0, r0
dp4 r4.y, c1, r0
dp4 r4.z, c2, r0
dp4 r0.x, c3, r0
rcp r0.x, r0.x
mad r0.xyz, r4, r0.x, -c4
nrm r4.xyz, r0
dp3_sat r0.x, r3, -r4
texld r3, v0, s5
abs r0.y, c7.x
cmp r0.y, -r0.y, c17.w, c17.x
mov r4.xw, c17
cmp r0.z, -c8.x, r4.w, r4.x
add r0.y, r0.z, r0.y
cmp r4.xyz, -r0.y, r3, r2.w
cmp r2, -r0.y, r3, r2
log r0.z, r2.w
mul r0.zw, r0.z, c26.xyxy
exp r0.z, r0.z
exp r0.w, r0.w
if_lt -c6.x, r4.w
texld r3, v0, s2
else
mad r3.yz, v0.xxyw, c17.y, c17.z
dp2add r2.w, r3.yzzw, r3.yzzw, c17.w
rsq r2.w, r2.w
rcp r2.w, r2.w
pow r3.y, r2.w, c5.y
add r2.w, r3.y, -c5.z
mul_sat r2.w, r2.w, c5.w
pow r3.y, r2.w, c26.z
add r3.x, -r3.y, c17.x
endif
pow r2.w, r3.x, c26.w
mov r3.xy, c18
mad r3.x, c12.x, r3.x, r3.y
mul r3.x, r3.x, c18.z
log r3.y, r0.x
mul r3.x, r3.y, r3.x
exp r3.x, r3.x
add r3.x, -r3.x, c17.x
add r3.z, -r0.z, c17.x
mul r3.z, r3.z, c18.w
pow r5.x, r3.x, r3.z
mul r0.z, r0.z, r5.x
max r3.x, r0.z, c19.x
mov r5.yz, c19
add r0.z, r5.y, -c13.x
mul r0.z, r3.y, r0.z
exp r0.z, r0.z
add r0.z, -r0.z, c17.x
mul r3.y, r5.z, c14.x
mad r3.z, r3.x, -c20.x, c20.y
mul r3.y, r3.z, r3.y
mul r3.y, r3.y, c19.w
exp r3.y, r3.y
pow r5.x, r0.z, r3.y
mov r6.x, c15.x
if_lt c20.z, r6.x
frc r0.z, c15.x
add r3.y, -r0.z, c15.x
cmp r0.z, -r0.z, c17.w, c17.x
cmp r0.z, c15.x, r4.w, r0.z
add r0.z, r0.z, r3.y
rcp r3.y, r0.z
add r3.z, -r3.x, c17.x
mul r3.z, r3.z, r3.z
mul r3.z, r3.z, r3.z
rcp r3.z, r3.z
mad r5.yz, r3.z, c22.x, c22
rcp r3.w, r5.z
mul r3.z, r3.z, c20.w
frc r5.z, c16.x
add r5.w, -r5.z, c16.x
cmp r5.z, -r5.z, c17.w, c17.x
cmp r5.z, c16.x, r4.w, r5.z
add r5.z, r5.z, r5.w
mul r5.z, r5.z, r5.z
mul r5.z, r3.y, r5.z
log r5.z, r5.z
mad r5.z, r5.z, c22.w, c22.x
mov r6.z, c17.w
mov r7.xyz, c17.w
mov r5.w, c17.w
rep i0
mov r7.w, r0.z
break_ge r5.w, r7.w
mov r8.x, r5.w
mov r8.y, c25.y
mov r7.w, c17.w
rep i0
cmp r8.w, -r8.x, c17.x, c17.w
break_ne r8.w, -r8.w
cmp r9.xy, r8.x, c21, c21.zwzw
mul r8.w, r8.x, r9.y
frc r8.w, r8.w
mul r8.w, r8.w, r9.x
frc r9.x, r8.w
add r9.y, r8.w, -r9.x
cmp r9.x, -r9.x, c17.w, c17.x
cmp r8.w, r8.w, c17.w, r9.x
add r8.w, r8.w, r9.y
mad r7.w, r8.w, r8.y, r7.w
mul r8.yz, r8.xyxw, c25.y
frc r8.w, r8.z
add r8.z, r8.z, -r8.w
cmp r8.w, -r8.w, c17.w, c17.x
cmp r8.w, r8.x, c17.w, r8.w
add r8.x, r8.w, r8.z
endrep
add r8.x, r7.w, c25.z
log r8.y, r7.w
cmp r8.x, r8.x, r8.y, c25.w
mul r8.x, r3.w, r8.x
exp r8.y, r8.x
mad r8.z, r8.y, -r8.y, c17.x
rsq r8.z, r8.z
rcp r8.z, r8.z
mad r8.w, r5.w, r3.y, c22.w
frc r8.w, r8.w
mad r8.w, r8.w, c23.x, c23.y
sincos r9.xy, r8.w
mul r8.x, r5.y, r8.x
exp_sat r8.x, r8.x
mul r8.x, r3.z, r8.x
mul r8.x, r8.y, r8.x
mad r6.xy, r8.z, r9, v0
log r8.x, r8.x
mad r6.w, r8.x, -c22.w, r5.z
texldl r8, r6, s1
add r7.xyz, r7, r8
add r5.w, r5.w, c17.x
endrep
rcp r0.z, c15.x
mul r6.xyz, r0.z, r7
else
mul r7, c17.xxww, v0.xyxx
texldl r6, r7, s1
endif
if_lt -c9.x, r4.w
mad r0.z, r0.x, c23.z, c23.w
mul r0.z, r0.x, r0.z
add r3.y, -r3.x, c22.w
mul r0.z, r0.z, r3.y
exp r0.z, r0.z
cmp r0.z, r3.y, r0.z, c17.x
lrp r3.yzw, r0.z, c17.x, r4.xxyz
mul r7.xyz, r3.yzww, r6
mov r7.w, c17.x
mul r7, r5.x, r7
mul r8, r0.w, r7
mul r0.z, r5.x, c10.x
mad r0.z, r0.z, -r0.w, c17.x
mul r9, r0.z, r1
mad r8, r8, c10.x, r9
add r3.yzw, r2.xxyz, c24.x
log r10.x, r3.y
log r10.y, r3.z
log r10.z, r3.w
mul r3.yzw, r10.xxyz, c24.y
exp r10.x, r3.y
exp r10.y, r3.z
exp r10.z, r3.w
mov r10.w, c17.w
max_sat r11, r10, c22.w
mul r7, r7, r11
mul r7, r0.w, r7
mad r7, r7, c10.x, r9
cmp r7, -r0.y, r7, r8
else
mad r0.z, r0.x, c23.z, c23.w
mul r0.x, r0.x, r0.z
add r0.z, -r3.x, c22.w
mul r0.x, r0.z, r0.x
exp r0.x, r0.x
cmp r0.x, r0.z, r0.x, c17.x
lrp r3.xyz, r0.x, c17.x, r4
mul r3.xyz, r3, r6
mov r3.w, c17.x
mul r3, r5.x, r3
mul r4, r0.w, r3
mad r4, r4, c10.x, r1
add r2.xyz, r2, c24.x
log r5.x, r2.x
log r5.y, r2.y
log r5.z, r2.z
mul r2.xyz, r5, c24.y
exp r5.x, r2.x
exp r5.y, r2.y
exp r5.z, r2.z
mov r5.w, c17.w
max_sat r6, r5, c22.w
mul r3, r3, r6
mul r3, r0.w, r3
mad r3, r3, c10.x, r1
cmp r7, -r0.y, r3, r4
endif
cmp r0, -c5.x, r7, r2.w
add r0, -r1, r0
mad_pp oC0, r2.w, r0, r1

"
}
SubProgram "d3d11 " {
// Stats: 155 math, 5 textures, 8 branches
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_CameraNormalsTexture] 2D 4
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_CameraGBufferTexture1] 2D 5
SetTexture 4 [_EdgeFadeTexture] 2D 2
SetTexture 5 [_SSRtexture] 2D 1
ConstBuffer "$Globals" 320
Matrix 176 [_ViewProjectInverse]
Vector 96 [_ScreenFadeControls]
Float 112 [_UseEdgeTexture]
Float 116 [_IsInForwardRender]
Float 120 [_IsInLegacyDeffered]
Float 128 [_SSRRcomposeMode]
Float 132 [_reflectionMultiply]
Float 136 [_FlipReflectionsMSAA]
Float 140 [_fadePower]
Float 144 [_fresfade]
Float 148 [_fresrange]
Float 240 [_convolutionSamples]
Float 244 [_swidth]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedfipnahbbeioeonibcadgjlgjdfaeojkaabaaaaaababiaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfabhaaaa
eaaaaaaaneafaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacakaaaaaadbaaaaaldcaabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacgikcaaaaaaaaaaaaiaaaaaaaaaaaaai
ecaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaaj
ccaabaaaabaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaabkbabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadgaaaaafbcaabaaaabaaaaaaakbabaaaabaaaaaaefaaaaajpcaabaaa
adaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaap
pcaabaaaaeaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpbbaaaaahbcaabaaa
aaaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaahncaabaaaaaaaaaaaagaabaaaaaaaaaaaagajbaaa
aeaaaaaaefaaaaajpcaabaaaaeaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaadcaaaaapdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaadiaaaaaipcaabaaaafaaaaaafgafbaaaabaaaaaaegiocaaaaaaaaaaa
amaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaaagaabaaa
abaaaaaaegaobaaaafaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaa
anaaaaaaagaabaaaaeaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaaabaaaaaa
egaobaaaabaaaaaaegiocaaaaaaaaaaaaoaaaaaaaoaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
bacaaaaibcaabaaaaaaaaaaaigadbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
afaaaaaadjaaaaalecaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabkiacaaaaaaaaaaaahaaaaaadbaaaaaldcaabaaaaeaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacgikcaaaaaaaaaaaahaaaaaadmaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaaeaaaaaadhaaaaajncaabaaa
aeaaaaaakgakbaaaaaaaaaaapgapbaaaadaaaaaaagajbaaaabaaaaaadhaaaaaj
pcaabaaaabaaaaaakgakbaaaaaaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
cpaaaaaficaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaakdcaabaaaadaaaaaa
pgapbaaaaaaaaaaaaceaaaaaklkkckdpddddideaaaaaaaaaaaaaaaaabjaaaaaf
dcaabaaaadaaaaaaegaabaaaadaaaaaabpaaaeadbkaabaaaaeaaaaaaefaaaaaj
pcaabaaaafaaaaaaegbabaaaabaaaaaaeghobaaaaeaaaaaaaagabaaaacaaaaaa
bcaaaaabdcaaaaapmcaabaaaadaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaaaeaaceaaaaaaaaaaaaaaaaaaaaaaaaaialpaaaaialp
apaaaaahicaabaaaaaaaaaaaogakbaaaadaaaaaaogakbaaaadaaaaaaelaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaaaaaaaaaaa
agaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaadicaaaai
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaggggggdpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
aaaaaaaibcaabaaaafaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
bfaaaaabcpaaaaaficaabaaaaaaaaaaaakaabaaaafaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaggggigeabjaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakicaabaaaabaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaajkjjbjlpabeaaaaaaaaaiadpdiaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaebcpaaaaafecaabaaaadaaaaaaakaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaackaabaaaadaaaaaabjaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaadaaaaaaakaabaia
ebaaaaaaadaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaadaaaaaadkaabaaa
adaaaaaaabeaaaaaaaaaeiedcpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaadaaaaaabjaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaakaabaaaadaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
abeaaaaamnmmemdnaaaaaaajbcaabaaaadaaaaaaakiacaiaebaaaaaaaaaaaaaa
ajaaaaaaabeaaaaaaaaaciebdiaaaaahbcaabaaaadaaaaaackaabaaaadaaaaaa
akaabaaaadaaaaaabjaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaaaaaaaaai
bcaabaaaadaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpdiaaaaai
ecaabaaaadaaaaaabkiacaaaaaaaaaaaajaaaaaaabeaaaaaaaaacaebdcaaaaak
icaabaaaadaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaamnmmemdoabeaaaaa
aaaaiadpdiaaaaahecaabaaaadaaaaaadkaabaaaadaaaaaackaabaaaadaaaaaa
diaaaaahecaabaaaadaaaaaackaabaaaadaaaaaaabeaaaaadlkklidpbjaaaaaf
ecaabaaaadaaaaaackaabaaaadaaaaaacpaaaaafbcaabaaaadaaaaaaakaabaaa
adaaaaaadiaaaaahbcaabaaaadaaaaaaakaabaaaadaaaaaackaabaaaadaaaaaa
bjaaaaafbcaabaaaadaaaaaaakaabaaaadaaaaaadbaaaaaiecaabaaaadaaaaaa
abeaaaaaaaaaeaeaakiacaaaaaaaaaaaapaaaaaabpaaaeadckaabaaaadaaaaaa
edaaaaagecaabaaaadaaaaaaakiacaaaaaaaaaaaapaaaaaaaoaaaaakicaabaaa
adaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpckaabaaaadaaaaaa
aaaaaaaiccaabaaaaeaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
diaaaaahccaabaaaaeaaaaaabkaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaah
ccaabaaaaeaaaaaabkaabaaaaeaaaaaabkaabaaaaeaaaaaaaoaaaaahccaabaaa
aeaaaaaaabeaaaaaaaaaaaeabkaabaaaaeaaaaaaaaaaaaakdcaabaaaafaaaaaa
fgafbaaaaeaaaaaaaceaaaaaaaaaaamaaaaaialpaaaaaaaaaaaaaaaaaoaaaaak
ccaabaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkaabaaa
afaaaaaadiaaaaahccaabaaaaeaaaaaabkaabaaaaeaaaaaaabeaaaaaidpjccdo
blaaaaagmcaabaaaafaaaaaaagiecaaaaaaaaaaaapaaaaaacgaaaaaiaanaaaaa
icaabaaaafaaaaaadkaabaaaafaaaaaadkaabaaaafaaaaaaclaaaaaficaabaaa
afaaaaaadkaabaaaafaaaaaaaoaaaaahecaabaaaadaaaaaadkaabaaaafaaaaaa
ckaabaaaadaaaaaacpaaaaafecaabaaaadaaaaaackaabaaaadaaaaaadcaaaaaj
ecaabaaaadaaaaaackaabaaaadaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaaea
dgaaaaaihcaabaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
dgaaaaaficaabaaaafaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaa
agaaaaaadkaabaaaafaaaaaackaabaaaafaaaaaaadaaaeaddkaabaaaagaaaaaa
claaaaaficaabaaaagaaaaaadkaabaaaafaaaaaadiaaaaahicaabaaaagaaaaaa
dkaabaaaadaaaaaadkaabaaaagaaaaaadgaaaaafbcaabaaaahaaaaaadkaabaaa
afaaaaaadgaaaaaigcaabaaaahaaaaaaaceaaaaaaaaaaaaaaaaaaaaaklkkkkdo
aaaaaaaadaaaaaabcbaaaaahicaabaaaahaaaaaaabeaaaaaaaaaaaaaakaabaaa
ahaaaaaaadaaaeaddkaabaaaahaaaaaaabaaaaahicaabaaaahaaaaaaakaabaaa
ahaaaaaaabeaaaaaaaaaaaiaceaaaaaibcaabaaaaiaaaaaaakaabaaaahaaaaaa
akaabaiaebaaaaaaahaaaaaaeoaaaaajbcaabaaaaiaaaaaabcaabaaaajaaaaaa
akaabaaaaiaaaaaaabeaaaaaadaaaaaaciaaaaafccaabaaaaiaaaaaaakaabaaa
ajaaaaaadhaaaaajicaabaaaahaaaaaadkaabaaaahaaaaaabkaabaaaaiaaaaaa
akaabaaaajaaaaaaclaaaaaficaabaaaahaaaaaadkaabaaaahaaaaaadcaaaaaj
ccaabaaaahaaaaaadkaabaaaahaaaaaackaabaaaahaaaaaabkaabaaaahaaaaaa
fhaaaaahicaabaaaahaaaaaaakaabaaaahaaaaaaabeaaaaaadaaaaaaciaaaaaf
ccaabaaaaiaaaaaaakaabaaaaiaaaaaaabaaaaahicaabaaaahaaaaaadkaabaaa
ahaaaaaaabeaaaaaaaaaaaiadhaaaaajbcaabaaaahaaaaaadkaabaaaahaaaaaa
bkaabaaaaiaaaaaaakaabaaaaiaaaaaadiaaaaahecaabaaaahaaaaaackaabaaa
ahaaaaaaabeaaaaaklkkkkdobgaaaaabdiaaaaahicaabaaaagaaaaaadkaabaaa
agaaaaaaabeaaaaanlapmjeadeaaaaahbcaabaaaahaaaaaabkaabaaaahaaaaaa
abeaaaaagpbciddkcpaaaaafbcaabaaaahaaaaaaakaabaaaahaaaaaadiaaaaah
bcaabaaaahaaaaaabkaabaaaafaaaaaaakaabaaaahaaaaaabjaaaaafecaabaaa
ahaaaaaaakaabaaaahaaaaaadcaaaaakicaabaaaahaaaaaackaabaiaebaaaaaa
ahaaaaaackaabaaaahaaaaaaabeaaaaaaaaaiadpelaaaaaficaabaaaahaaaaaa
dkaabaaaahaaaaaaenaaaaahbcaabaaaaiaaaaaabcaabaaaajaaaaaadkaabaaa
agaaaaaadiaaaaahbcaabaaaajaaaaaadkaabaaaahaaaaaaakaabaaaajaaaaaa
diaaaaahccaabaaaajaaaaaadkaabaaaahaaaaaaakaabaaaaiaaaaaadiaaaaah
icaabaaaagaaaaaaakaabaaaafaaaaaaakaabaaaahaaaaaabjaaaaaficaabaaa
agaaaaaadkaabaaaagaaaaaaddaaaaahicaabaaaagaaaaaadkaabaaaagaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaagaaaaaabkaabaaaaeaaaaaadkaabaaa
agaaaaaadiaaaaahicaabaaaagaaaaaackaabaaaahaaaaaadkaabaaaagaaaaaa
aaaaaaahfcaabaaaahaaaaaaagabbaaaajaaaaaaagbbbaaaabaaaaaacpaaaaaf
icaabaaaagaaaaaadkaabaaaagaaaaaadcaaaaakicaabaaaagaaaaaadkaabaia
ebaaaaaaagaaaaaaabeaaaaaaaaaaadpckaabaaaadaaaaaaeiaaaaalpcaabaaa
aiaaaaaaigaabaaaahaaaaaaeghobaaaafaaaaaaaagabaaaabaaaaaadkaabaaa
agaaaaaaaaaaaaahhcaabaaaagaaaaaaegacbaaaagaaaaaaegacbaaaaiaaaaaa
boaaaaahicaabaaaafaaaaaadkaabaaaafaaaaaaabeaaaaaabaaaaaabgaaaaab
aoaaaaaihcaabaaaafaaaaaaegacbaaaagaaaaaaagiacaaaaaaaaaaaapaaaaaa
bcaaaaabeiaaaaalpcaabaaaafaaaaaaegbabaaaabaaaaaaeghobaaaafaaaaaa
aagabaaaabaaaaaaabeaaaaaaaaaaaaabfaaaaabbpaaaeadbkaabaaaaaaaaaaa
aaaaaaalhcaabaaaagaaaaaaigadbaiaebaaaaaaaeaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaadcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaflmalbmaabeaaaaabahgnpmadiaaaaahccaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaaaaaaaaaiecaabaaaadaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaaadpdeaaaaahecaabaaaadaaaaaackaabaaaadaaaaaa
abeaaaaaaaaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaa
adaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaajhcaabaaa
agaaaaaaegacbaaaagaaaaaafgafbaaaaaaaaaaaigadbaaaaeaaaaaadiaaaaah
hcaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaaagaaaaaadgaaaaaficaabaaa
agaaaaaaabeaaaaaaaaaiadpdiaaaaahpcaabaaaagaaaaaaagaabaaaadaaaaaa
egaobaaaagaaaaaadiaaaaahpcaabaaaahaaaaaafgafbaaaadaaaaaaegaobaaa
agaaaaaadiaaaaaiccaabaaaaaaaaaaaakaabaaaadaaaaaabkiacaaaaaaaaaaa
aiaaaaaadcaaaaakccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaabkaabaaa
adaaaaaaabeaaaaaaaaaiadpdiaaaaahpcaabaaaaiaaaaaafgafbaaaaaaaaaaa
egaobaaaacaaaaaadcaaaaakpcaabaaaahaaaaaaegaobaaaahaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegaobaaaaiaaaaaaaaaaaaakhcaabaaaajaaaaaaegacbaaa
abaaaaaaaceaaaaaipmcpfdmipmcpfdmipmcpfdmaaaaaaaacpaaaaafhcaabaaa
ajaaaaaaegacbaaaajaaaaaadgaaaaaficaabaaaajaaaaaaabeaaaaaaaaaiapp
diaaaaakpcaabaaaajaaaaaaegaobaaaajaaaaaaaceaaaaaekcjcfdoekcjcfdo
ekcjcfdoekcjcfdobjaaaaafpcaabaaaajaaaaaaegaobaaaajaaaaaadeaaaaak
pcaabaaaajaaaaaaegaobaaaajaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaadpddaaaaakpcaabaaaajaaaaaaegaobaaaajaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdiaaaaahpcaabaaaagaaaaaaegaobaaaagaaaaaa
egaobaaaajaaaaaadiaaaaahpcaabaaaagaaaaaafgafbaaaadaaaaaaegaobaaa
agaaaaaadcaaaaakpcaabaaaagaaaaaaegaobaaaagaaaaaafgifcaaaaaaaaaaa
aiaaaaaaegaobaaaaiaaaaaadhaaaaajpcaabaaaagaaaaaakgakbaaaaaaaaaaa
egaobaaaahaaaaaaegaobaaaagaaaaaabcaaaaabaaaaaaalhcaabaaaahaaaaaa
igadbaiaebaaaaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
dcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaflmalbmaabeaaaaa
bahgnpmadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaadp
deaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaajhcaabaaaaeaaaaaaegacbaaaahaaaaaa
agaabaaaaaaaaaaaigadbaaaaeaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaafaaaaaadgaaaaaficaabaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaahpcaabaaaaeaaaaaaagaabaaaadaaaaaaegaobaaaaeaaaaaadiaaaaah
pcaabaaaafaaaaaafgafbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
afaaaaaaegaobaaaafaaaaaafgifcaaaaaaaaaaaaiaaaaaaegaobaaaacaaaaaa
aaaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaaipmcpfdmipmcpfdm
ipmcpfdmaaaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiappdiaaaaakpcaabaaaabaaaaaaegaobaaa
abaaaaaaaceaaaaaekcjcfdoekcjcfdoekcjcfdoekcjcfdobjaaaaafpcaabaaa
abaaaaaaegaobaaaabaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpddaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaa
abaaaaaafgafbaaaadaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaafgifcaaaaaaaaaaaaiaaaaaaegaobaaaacaaaaaadhaaaaaj
pcaabaaaagaaaaaakgakbaaaaaaaaaaaegaobaaaafaaaaaaegaobaaaabaaaaaa
bfaaaaabdbaaaaaibcaabaaaaaaaaaaaabeaaaaaaaaaaaaaakiacaaaaaaaaaaa
agaaaaaadhaaaaajpcaabaaaabaaaaaaagaabaaaaaaaaaaapgapbaaaaaaaaaaa
egaobaaaagaaaaaaaaaaaaaipcaabaaaabaaaaaaegaobaiaebaaaaaaacaaaaaa
egaobaaaabaaaaaadcaaaaajpccabaaaaaaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaacaaaaaadoaaaaab"
}
SubProgram "gles3 " {
"!!GLES3"
}
SubProgram "metal " {
// Stats: 206 math, 8 textures, 12 branches
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SSRtexture] 2D 1
SetTexture 2 [_EdgeFadeTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture1] 2D 5
ConstBuffer "$Globals" 152
Matrix 80 [_ViewProjectInverse]
Vector 0 [_WorldSpaceCameraPos] 3
Vector 16 [_ScreenFadeControls]
Float 32 [_UseEdgeTexture]
Float 36 [_IsInForwardRender]
Float 40 [_IsInLegacyDeffered]
Float 44 [_SSRRcomposeMode]
Float 48 [_reflectionMultiply]
Float 52 [_FlipReflectionsMSAA]
Float 56 [_fadePower]
Float 60 [_fresfade]
Float 64 [_fresrange]
Float 144 [_convolutionSamples]
Float 148 [_swidth]
"metal_fs
#include <metal_stdlib>
using namespace metal;
struct xlatMtlShaderInput {
  float2 xlv_TEXCOORD0;
};
struct xlatMtlShaderOutput {
  half4 _glesFragData_0 [[color(0)]];
};
struct xlatMtlShaderUniform {
  float3 _WorldSpaceCameraPos;
  float4 _ScreenFadeControls;
  float _UseEdgeTexture;
  float _IsInForwardRender;
  float _IsInLegacyDeffered;
  float _SSRRcomposeMode;
  float _reflectionMultiply;
  float _FlipReflectionsMSAA;
  float _fadePower;
  float _fresfade;
  float _fresrange;
  float4x4 _ViewProjectInverse;
  float _convolutionSamples;
  float _swidth;
};
fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<half> _MainTex [[texture(0)]], sampler _mtlsmp__MainTex [[sampler(0)]]
  ,   texture2d<half> _SSRtexture [[texture(1)]], sampler _mtlsmp__SSRtexture [[sampler(1)]]
  ,   texture2d<half> _EdgeFadeTexture [[texture(2)]], sampler _mtlsmp__EdgeFadeTexture [[sampler(2)]]
  ,   texture2d<half> _CameraDepthTexture [[texture(3)]], sampler _mtlsmp__CameraDepthTexture [[sampler(3)]]
  ,   texture2d<half> _CameraNormalsTexture [[texture(4)]], sampler _mtlsmp__CameraNormalsTexture [[sampler(4)]]
  ,   texture2d<half> _CameraGBufferTexture1 [[texture(5)]], sampler _mtlsmp__CameraGBufferTexture1 [[sampler(5)]])
{
  xlatMtlShaderOutput _mtl_o;
  half4 tmpvar_1;
  float roughness_2;
  float4 SSRColor_3;
  float2 inUV_4;
  float4 col_5;
  float screenFade_6;
  float4 specular_7;
  float4 worldnorm2_8;
  float4 worldnorm_9;
  float ZD_10;
  float4 Mainworldnormal_11;
  float4 original_12;
  float2 uvtmp_13;
  uvtmp_13 = _mtl_i.xlv_TEXCOORD0;
  if ((_mtl_u._FlipReflectionsMSAA > 0.0)) {
    uvtmp_13.y = (1.0 - _mtl_i.xlv_TEXCOORD0.y);
  };
  half4 tmpvar_14;
  tmpvar_14 = _MainTex.sample(_mtlsmp__MainTex, (float2)(_mtl_i.xlv_TEXCOORD0));
  original_12 = float4(tmpvar_14);
  half4 tmpvar_15;
  tmpvar_15 = ((_CameraNormalsTexture.sample(_mtlsmp__CameraNormalsTexture, (float2)(uvtmp_13)) * (half)2.0) - (half)1.0);
  Mainworldnormal_11 = float4(tmpvar_15);
  float4 tmpvar_16;
  tmpvar_16 = normalize(Mainworldnormal_11);
  Mainworldnormal_11 = tmpvar_16;
  half tmpvar_17;
  tmpvar_17 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(_mtl_i.xlv_TEXCOORD0)).x;
  ZD_10 = float(tmpvar_17);
  float3 tmpvar_18;
  tmpvar_18.xy = ((uvtmp_13 * 2.0) - 1.0);
  tmpvar_18.z = ZD_10;
  float4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_18;
  float4 tmpvar_20;
  tmpvar_20 = (_mtl_u._ViewProjectInverse * tmpvar_19);
  float4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = -(normalize((
    (tmpvar_20 / tmpvar_20.w)
  .xyz - _mtl_u._WorldSpaceCameraPos)));
  float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize(tmpvar_16), tmpvar_21), 0.0, 1.0);
  half4 tmpvar_23;
  tmpvar_23 = _CameraNormalsTexture.sample(_mtlsmp__CameraNormalsTexture, (float2)(uvtmp_13));
  worldnorm_9 = float4(tmpvar_23);
  half4 tmpvar_24;
  tmpvar_24 = _CameraGBufferTexture1.sample(_mtlsmp__CameraGBufferTexture1, (float2)(_mtl_i.xlv_TEXCOORD0));
  worldnorm2_8 = float4(tmpvar_24);
  specular_7 = worldnorm2_8;
  if ((bool(_mtl_u._IsInForwardRender) || (_mtl_u._IsInLegacyDeffered > 0.0))) {
    specular_7 = worldnorm_9.wwww;
  } else {
    worldnorm_9 = worldnorm2_8;
  };
  specular_7.w = pow (specular_7.w, 0.6666667);
  worldnorm_9.w = pow (worldnorm_9.w, 4.1);
  screenFade_6 = 1.0;
  if ((_mtl_u._UseEdgeTexture > 0.0)) {
    half tmpvar_25;
    tmpvar_25 = _EdgeFadeTexture.sample(_mtlsmp__EdgeFadeTexture, (float2)(_mtl_i.xlv_TEXCOORD0)).x;
    screenFade_6 = float(tmpvar_25);
  } else {
    float2 x_26;
    x_26 = ((_mtl_i.xlv_TEXCOORD0 * 2.0) - 1.0);
    screenFade_6 = (1.0 - pow (clamp (
      ((pow (sqrt(
        dot (x_26, x_26)
      ), _mtl_u._ScreenFadeControls.y) - _mtl_u._ScreenFadeControls.z) * _mtl_u._ScreenFadeControls.w)
    , 0.0, 1.0), 0.9));
  };
  float tmpvar_27;
  tmpvar_27 = pow (screenFade_6, 4.2);
  screenFade_6 = tmpvar_27;
  col_5 = float4(0.0, 0.0, 0.0, 0.0);
  inUV_4 = _mtl_i.xlv_TEXCOORD0;
  SSRColor_3 = float4(0.0, 0.0, 0.0, 0.0);
  float tmpvar_28;
  tmpvar_28 = max ((specular_7.w * pow (
    (1.0 - pow (tmpvar_22, (8.0 * mix (1.0, 0.4, _mtl_u._fadePower))))
  , 
    (200.0 * (1.0 - specular_7.w))
  )), 0.05);
  roughness_2 = tmpvar_28;
  float tmpvar_29;
  tmpvar_29 = pow ((1.0 - pow (tmpvar_22, 
    (10.5 - _mtl_u._fresfade)
  )), exp((
    (_mtl_u._fresrange * 10.0)
   * 
    (1.0 - (tmpvar_28 * 0.2))
  )));
  if ((_mtl_u._convolutionSamples > 3.0)) {
    for (int i_1_30; i_1_30 < int(_mtl_u._convolutionSamples); i_1_30++) {
      int sn_31;
      sn_31 = int(_mtl_u._convolutionSamples);
      int n_32;
      n_32 = i_1_30;
      float invBi_33;
      float bitSeq_34;
      bitSeq_34 = 0.0;
      invBi_33 = 0.3333333;
      while (true) {
        if ((n_32 <= 0)) {
          break;
        };
        bitSeq_34 = (bitSeq_34 + (float(
          int((float(fmod (float(n_32), 3.0))))
        ) * invBi_33));
        n_32 = (n_32 / 3);
        invBi_33 = (invBi_33 * 0.3333333);
      };
      float2 tmpvar_35;
      tmpvar_35.x = (float(i_1_30) * (1.0/(float(sn_31))));
      tmpvar_35.y = bitSeq_34;
      float R_36;
      R_36 = (1.0 - roughness_2);
      float3 H_37;
      float tmpvar_38;
      tmpvar_38 = (R_36 * R_36);
      float tmpvar_39;
      tmpvar_39 = ((2.0 / (tmpvar_38 * tmpvar_38)) - 2.0);
      float tmpvar_40;
      tmpvar_40 = (6.283185 * tmpvar_35.x);
      float tmpvar_41;
      tmpvar_41 = pow (max (bitSeq_34, 0.001), (1.0/((tmpvar_39 + 1.0))));
      float tmpvar_42;
      tmpvar_42 = sqrt((1.0 - (tmpvar_41 * tmpvar_41)));
      H_37.x = (tmpvar_42 * cos(tmpvar_40));
      H_37.y = (tmpvar_42 * sin(tmpvar_40));
      H_37.z = tmpvar_41;
      float4 tmpvar_43;
      tmpvar_43.xyz = H_37;
      tmpvar_43.w = (((
        (tmpvar_39 + 2.0)
       / 6.283185) * clamp (
        pow (tmpvar_41, tmpvar_39)
      , 0.0, 1.0)) * tmpvar_41);
      int ts_44;
      ts_44 = int(_mtl_u._swidth);
      float4 tmpvar_45;
      tmpvar_45.z = 0.0;
      tmpvar_45.xy = (inUV_4 + H_37.xy);
      tmpvar_45.w = (((0.5 * 
        log2((float((ts_44 * ts_44)) / float(int(_mtl_u._convolutionSamples))))
      ) + 2.0) - (0.5 * log2(tmpvar_43.w)));
      half4 tmpvar_46;
      tmpvar_46 = _SSRtexture.sample(_mtlsmp__SSRtexture, (float2)(tmpvar_45.xy), level(tmpvar_45.w));
      SSRColor_3.xyz = (SSRColor_3.xyz + (float3)tmpvar_46.xyz);
    };
    SSRColor_3.xyz = (SSRColor_3.xyz / _mtl_u._convolutionSamples);
  } else {
    half3 tmpvar_47;
    tmpvar_47 = _SSRtexture.sample(_mtlsmp__SSRtexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0)).xyz;
    SSRColor_3.xyz = float3(tmpvar_47);
  };
  if ((_mtl_u._SSRRcomposeMode > 0.0)) {
    if ((bool(_mtl_u._IsInForwardRender) || (_mtl_u._IsInLegacyDeffered > 0.0))) {
      float4 tmpvar_48;
      tmpvar_48.w = 1.0;
      tmpvar_48.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      col_5 = (((
        (tmpvar_48 * tmpvar_29)
       * worldnorm_9.w) * _mtl_u._reflectionMultiply) + (original_12 * (1.0 - 
        ((tmpvar_29 * _mtl_u._reflectionMultiply) * worldnorm_9.w)
      )));
    } else {
      float4 tmpvar_49;
      tmpvar_49.w = 1.0;
      tmpvar_49.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      float4 tmpvar_50;
      tmpvar_50.w = 0.0;
      tmpvar_50.xyz = (worldnorm_9.xyz + 0.03);
      col_5 = (((
        ((tmpvar_49 * tmpvar_29) * clamp (pow (tmpvar_50, float4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), float4(0.5, 0.5, 0.5, 0.5), float4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_9.w) * _mtl_u._reflectionMultiply) + (original_12 * (1.0 - 
        ((tmpvar_29 * _mtl_u._reflectionMultiply) * worldnorm_9.w)
      )));
    };
  } else {
    if ((bool(_mtl_u._IsInForwardRender) || (_mtl_u._IsInLegacyDeffered > 0.0))) {
      float4 tmpvar_51;
      tmpvar_51.w = 1.0;
      tmpvar_51.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      col_5 = (((
        (tmpvar_51 * tmpvar_29)
       * worldnorm_9.w) * _mtl_u._reflectionMultiply) + original_12);
    } else {
      float4 tmpvar_52;
      tmpvar_52.w = 1.0;
      tmpvar_52.xyz = (SSRColor_3.xyz * (specular_7.xyz + (
        (1.0 - specular_7.xyz)
       * 
        exp2((((
          (-5.554731 * tmpvar_22)
         - 6.983162) * tmpvar_22) * clamp ((0.5 - tmpvar_28), 0.0, 1.0)))
      )));
      float4 tmpvar_53;
      tmpvar_53.w = 0.0;
      tmpvar_53.xyz = (worldnorm_9.xyz + 0.03);
      col_5 = (((
        ((tmpvar_52 * tmpvar_29) * clamp (pow (tmpvar_53, float4(0.1612903, 0.1612903, 0.1612903, 0.1612903)), float4(0.5, 0.5, 0.5, 0.5), float4(1.0, 1.0, 1.0, 1.0)))
       * worldnorm_9.w) * _mtl_u._reflectionMultiply) + original_12);
    };
  };
  if ((_mtl_u._ScreenFadeControls.x > 0.0)) {
    col_5 = float4(tmpvar_27);
  };
  float4 tmpvar_54;
  tmpvar_54 = mix (original_12, col_5, float4(tmpvar_27));
  tmpvar_1 = half4(tmpvar_54);
  _mtl_o._glesFragData_0 = tmpvar_1;
  return _mtl_o;
}

"
}
}
 }
}
Fallback Off
}