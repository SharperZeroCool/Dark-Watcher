// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/CandelaSSRRv2" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 4 math
 //        d3d9 : 5 math
 //       gles3 : 137 math, 12 texture, 30 branch
 //       metal : 1 math
 //      opengl : 137 math, 12 texture, 30 branch
 // Stats for Fragment shader:
 //       d3d11 : 106 math, 2 texture, 40 branch
 //        d3d9 : 152 math, 22 texture, 44 branch
 //       metal : 137 math, 12 texture, 30 branch
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 46945
Program "vp" {
SubProgram "opengl " {
// Stats: 137 math, 12 textures, 30 branches
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec4 _ScreenParams;
uniform vec4 _ZBufferParams;
uniform sampler2D _depthTexCustom;
uniform sampler2D _MainTex;
uniform float _maxDepthCull;
uniform float _maxFineStep;
uniform float _maxStep;
uniform float _stepGlobalScale;
uniform float _bias;
uniform mat4 _ProjMatrix;
uniform mat4 _ProjectionInv;
uniform mat4 _ViewMatrix;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
uniform float _SSRRcomposeMode;
uniform float _FlipReflectionsMSAA;
uniform float _skyEnabled;
uniform sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture2;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform float _FullDeferred;
uniform mat4 _CameraMV;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  float dofiemdklsf_2;
  float zudifkd_3;
  vec3 ssped44s_4;
  vec4 lerrre33dcs_5;
  vec4 fasdei434fkkf_6;
  vec4 tmpvar_7;
  tmpvar_7 = texture2DLod (_MainTex, xlv_TEXCOORD0, 0.0);
  float tmpvar_8;
  if ((_skyEnabled > 0.5)) {
    tmpvar_8 = -165.6667;
  } else {
    tmpvar_8 = _ZBufferParams.x;
  };
  zudifkd_3 = tmpvar_8;
  float tmpvar_9;
  if ((_skyEnabled > 0.5)) {
    tmpvar_9 = 166.6667;
  } else {
    tmpvar_9 = _ZBufferParams.y;
  };
  dofiemdklsf_2 = tmpvar_9;
  if ((tmpvar_7.w == 0.0)) {
    fasdei434fkkf_6 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    float vardoifles_10;
    vardoifles_10 = 0.0;
    if ((_IsInForwardRender > 0.0)) {
      vardoifles_10 = texture2DLod (_depthTexCustom, xlv_TEXCOORD0, 0.0).x;
    } else {
      vardoifles_10 = texture2DLod (_CameraDepthTexture, xlv_TEXCOORD0, 0.0).x;
    };
    float tmpvar_11;
    tmpvar_11 = (1.0/(((tmpvar_8 * vardoifles_10) + tmpvar_9)));
    if ((tmpvar_11 > _maxDepthCull)) {
      fasdei434fkkf_6 = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
      vec4 paAccurateColor_12;
      vec4 origtmp_13;
      int s_14;
      vec4 oiedofdefe_15;
      float varyutdffe_16;
      int i_33_17;
      bool qwweuiidu_18;
      vec4 cjusduyfeef_19;
      int maxCount_29_20;
      vec3 nndndduiefa_21;
      vec3 ooppdsddd_22;
      vec3 xxdkufex_23;
      vec4 wqoidf_24;
      vec4 vatieuf_25;
      vec3 vuy7s_26;
      vec4 v12iiose_27;
      v12iiose_27.w = 1.0;
      v12iiose_27.xy = ((xlv_TEXCOORD0 * 2.0) - 1.0);
      v12iiose_27.z = vardoifles_10;
      vec4 tmpvar_28;
      tmpvar_28 = (_ProjectionInv * v12iiose_27);
      vec4 tmpvar_29;
      tmpvar_29 = (tmpvar_28 / tmpvar_28.w);
      vuy7s_26.xy = v12iiose_27.xy;
      vuy7s_26.z = vardoifles_10;
      vatieuf_25.w = 0.0;
      if ((_IsInForwardRender > 0.0)) {
        vatieuf_25.xyz = ((texture2DLod (_CameraNormalsTexture, xlv_TEXCOORD0, 0.0).xyz * 2.0) - 1.0);
      } else {
        if ((_IsInLegacyDeffered > 0.0)) {
          vec3 n_30;
          vec3 tmpvar_31;
          tmpvar_31 = ((texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0).xyz * vec3(3.5554, 3.5554, 0.0)) + vec3(-1.7777, -1.7777, 1.0));
          float tmpvar_32;
          tmpvar_32 = (2.0 / dot (tmpvar_31, tmpvar_31));
          n_30.xy = (tmpvar_32 * tmpvar_31.xy);
          n_30.z = (tmpvar_32 - 1.0);
          mat3 tmpvar_33;
          tmpvar_33[0] = _CameraMV[0].xyz;
          tmpvar_33[1] = _CameraMV[1].xyz;
          tmpvar_33[2] = _CameraMV[2].xyz;
          vatieuf_25.xyz = (tmpvar_33 * n_30);
        } else {
          if ((_FullDeferred > 0.0)) {
            vatieuf_25.xyz = ((texture2D (_CameraGBufferTexture2, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
          };
        };
      };
      vec3 tmpvar_34;
      tmpvar_34 = normalize(tmpvar_29.xyz);
      vec3 tmpvar_35;
      tmpvar_35 = normalize((_ViewMatrix * vatieuf_25).xyz);
      wqoidf_24.w = 1.0;
      wqoidf_24.xyz = (tmpvar_29.xyz + normalize((tmpvar_34 - 
        (2.0 * (dot (tmpvar_35, tmpvar_34) * tmpvar_35))
      )));
      vec4 tmpvar_36;
      tmpvar_36 = (_ProjMatrix * wqoidf_24);
      vec3 tmpvar_37;
      tmpvar_37 = normalize(((tmpvar_36.xyz / tmpvar_36.w) - vuy7s_26));
      ssped44s_4.z = tmpvar_37.z;
      ssped44s_4.xy = (tmpvar_37.xy * 0.5);
      xxdkufex_23.xy = tmpvar_1;
      xxdkufex_23.z = vardoifles_10;
      float tmpvar_38;
      tmpvar_38 = (2.0 / _ScreenParams.x);
      float tmpvar_39;
      tmpvar_39 = sqrt(dot (ssped44s_4.xy, ssped44s_4.xy));
      vec3 tmpvar_40;
      tmpvar_40 = (ssped44s_4 * ((tmpvar_38 * _stepGlobalScale) / tmpvar_39));
      ooppdsddd_22 = tmpvar_40;
      maxCount_29_20 = int(_maxStep);
      qwweuiidu_18 = bool(0);
      nndndduiefa_21 = (xxdkufex_23 + tmpvar_40);
      i_33_17 = 0;
      s_14 = 0;
      while (true) {
        if ((s_14 >= 120)) {
          break;
        };
        if ((i_33_17 >= maxCount_29_20)) {
          break;
        };
        if ((_IsInForwardRender > 0.0)) {
          varyutdffe_16 = (1.0/(((zudifkd_3 * texture2DLod (_depthTexCustom, nndndduiefa_21.xy, 0.0).x) + dofiemdklsf_2)));
        } else {
          varyutdffe_16 = (1.0/(((zudifkd_3 * texture2DLod (_CameraDepthTexture, nndndduiefa_21.xy, 0.0).x) + dofiemdklsf_2)));
        };
        float tmpvar_41;
        tmpvar_41 = (1.0/(((zudifkd_3 * nndndduiefa_21.z) + dofiemdklsf_2)));
        if ((varyutdffe_16 < (tmpvar_41 - 1e-06))) {
          oiedofdefe_15.w = 1.0;
          oiedofdefe_15.xyz = nndndduiefa_21;
          cjusduyfeef_19 = oiedofdefe_15;
          qwweuiidu_18 = bool(1);
          break;
        };
        nndndduiefa_21 = (nndndduiefa_21 + ooppdsddd_22);
        i_33_17++;
        s_14++;
      };
      if ((qwweuiidu_18 == bool(0))) {
        vec4 efuiydfeef_42;
        efuiydfeef_42.w = 0.0;
        efuiydfeef_42.xyz = nndndduiefa_21;
        cjusduyfeef_19 = efuiydfeef_42;
        qwweuiidu_18 = bool(1);
      };
      lerrre33dcs_5 = cjusduyfeef_19;
      float tmpvar_43;
      tmpvar_43 = abs((cjusduyfeef_19.x - 0.5));
      origtmp_13 = tmpvar_7;
      if ((_FlipReflectionsMSAA > 0.0)) {
        vec2 tmpouv_44;
        tmpouv_44.x = tmpvar_1.x;
        tmpouv_44.y = (1.0 - xlv_TEXCOORD0.y);
        origtmp_13 = texture2DLod (_MainTex, tmpouv_44, 0.0);
      };
      paAccurateColor_12 = vec4(0.0, 0.0, 0.0, 0.0);
      if ((_SSRRcomposeMode > 0.0)) {
        vec4 tmpvar_45;
        tmpvar_45.w = 0.0;
        tmpvar_45.xyz = origtmp_13.xyz;
        paAccurateColor_12 = tmpvar_45;
      };
      if ((tmpvar_43 > 0.5)) {
        fasdei434fkkf_6 = paAccurateColor_12;
      } else {
        float tmpvar_46;
        tmpvar_46 = abs((cjusduyfeef_19.y - 0.5));
        if ((tmpvar_46 > 0.5)) {
          fasdei434fkkf_6 = paAccurateColor_12;
        } else {
          if ((((1.0/(
            ((_ZBufferParams.x * cjusduyfeef_19.z) + _ZBufferParams.y)
          )) > _maxDepthCull) && (_skyEnabled < 0.5))) {
            fasdei434fkkf_6 = paAccurateColor_12;
          } else {
            if ((cjusduyfeef_19.z < 0.1)) {
              fasdei434fkkf_6 = paAccurateColor_12;
            } else {
              if ((cjusduyfeef_19.w == 1.0)) {
                int j_47;
                vec4 cmcnjkhdwe_48;
                float bbdkjfe_49;
                vec3 oldPos_50_50;
                int i_49_51;
                bool iueidkjkjff_52;
                vec4 tmpvar_47_53;
                int maxCount_45_54;
                vec3 fjeiudiuiuiuse_55;
                vec3 samplePos_43_56;
                vec3 tmpvar_57;
                tmpvar_57 = (cjusduyfeef_19.xyz - tmpvar_40);
                vec3 tmpvar_58;
                tmpvar_58 = (ssped44s_4 * (tmpvar_38 / tmpvar_39));
                fjeiudiuiuiuse_55 = tmpvar_58;
                maxCount_45_54 = int(_maxFineStep);
                iueidkjkjff_52 = bool(0);
                oldPos_50_50 = tmpvar_57;
                samplePos_43_56 = (tmpvar_57 + tmpvar_58);
                i_49_51 = 0;
                j_47 = 0;
                while (true) {
                  if ((j_47 >= 40)) {
                    break;
                  };
                  if ((i_49_51 >= maxCount_45_54)) {
                    break;
                  };
                  if ((_IsInForwardRender > 0.0)) {
                    bbdkjfe_49 = (1.0/(((zudifkd_3 * texture2DLod (_depthTexCustom, samplePos_43_56.xy, 0.0).x) + dofiemdklsf_2)));
                  } else {
                    bbdkjfe_49 = (1.0/(((zudifkd_3 * texture2DLod (_CameraDepthTexture, samplePos_43_56.xy, 0.0).x) + dofiemdklsf_2)));
                  };
                  float tmpvar_59;
                  tmpvar_59 = (1.0/(((zudifkd_3 * samplePos_43_56.z) + dofiemdklsf_2)));
                  if ((bbdkjfe_49 < tmpvar_59)) {
                    if (((tmpvar_59 - bbdkjfe_49) < _bias)) {
                      cmcnjkhdwe_48.w = 1.0;
                      cmcnjkhdwe_48.xyz = samplePos_43_56;
                      tmpvar_47_53 = cmcnjkhdwe_48;
                      iueidkjkjff_52 = bool(1);
                      break;
                    };
                    vec3 tmpvar_60;
                    tmpvar_60 = (fjeiudiuiuiuse_55 * 0.5);
                    fjeiudiuiuiuse_55 = tmpvar_60;
                    samplePos_43_56 = (oldPos_50_50 + tmpvar_60);
                  } else {
                    oldPos_50_50 = samplePos_43_56;
                    samplePos_43_56 = (samplePos_43_56 + fjeiudiuiuiuse_55);
                  };
                  i_49_51++;
                  j_47++;
                };
                if ((iueidkjkjff_52 == bool(0))) {
                  vec4 tmpvar_55_61;
                  tmpvar_55_61.w = 0.0;
                  tmpvar_55_61.xyz = samplePos_43_56;
                  tmpvar_47_53 = tmpvar_55_61;
                  iueidkjkjff_52 = bool(1);
                };
                lerrre33dcs_5 = tmpvar_47_53;
              };
              if ((lerrre33dcs_5.w < 0.01)) {
                fasdei434fkkf_6 = paAccurateColor_12;
              } else {
                vec4 tmpvar_57_62;
                if ((_FlipReflectionsMSAA > 0.0)) {
                  lerrre33dcs_5.y = (1.0 - lerrre33dcs_5.y);
                };
                tmpvar_57_62.xyz = texture2DLod (_MainTex, lerrre33dcs_5.xy, 0.0).xyz;
                tmpvar_57_62.w = 1.0;
                fasdei434fkkf_6 = tmpvar_57_62;
              };
            };
          };
        };
      };
    };
  };
  gl_FragData[0] = fasdei434fkkf_6;
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
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
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
// Stats: 137 math, 12 textures, 30 branches
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  mediump vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  tmpvar_1 = tmpvar_2;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform sampler2D _depthTexCustom;
uniform sampler2D _MainTex;
uniform highp float _maxDepthCull;
uniform highp float _maxFineStep;
uniform highp float _maxStep;
uniform highp float _stepGlobalScale;
uniform highp float _bias;
uniform highp mat4 _ProjMatrix;
uniform highp mat4 _ProjectionInv;
uniform highp mat4 _ViewMatrix;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
uniform highp float _SSRRcomposeMode;
uniform highp float _FlipReflectionsMSAA;
uniform highp float _skyEnabled;
uniform sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture2;
uniform highp float _IsInForwardRender;
uniform highp float _IsInLegacyDeffered;
uniform highp float _FullDeferred;
uniform highp mat4 _CameraMV;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp float dofiemdklsf_2;
  highp float zudifkd_3;
  highp vec3 ssped44s_4;
  highp vec4 lerrre33dcs_5;
  highp vec4 fasdei434fkkf_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureLod (_MainTex, xlv_TEXCOORD0, 0.0);
  highp vec4 tmpvar_8;
  tmpvar_8 = tmpvar_7;
  highp float tmpvar_9;
  if ((_skyEnabled > 0.5)) {
    tmpvar_9 = -165.6667;
  } else {
    tmpvar_9 = _ZBufferParams.x;
  };
  zudifkd_3 = tmpvar_9;
  highp float tmpvar_10;
  if ((_skyEnabled > 0.5)) {
    tmpvar_10 = 166.6667;
  } else {
    tmpvar_10 = _ZBufferParams.y;
  };
  dofiemdklsf_2 = tmpvar_10;
  if ((tmpvar_8.w == 0.0)) {
    fasdei434fkkf_6 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    highp float vardoifles_11;
    vardoifles_11 = 0.0;
    if ((_IsInForwardRender > 0.0)) {
      lowp vec4 tmpvar_12;
      tmpvar_12 = textureLod (_depthTexCustom, xlv_TEXCOORD0, 0.0);
      highp float tmpvar_13;
      tmpvar_13 = tmpvar_12.x;
      vardoifles_11 = tmpvar_13;
    } else {
      lowp vec4 tmpvar_14;
      tmpvar_14 = textureLod (_CameraDepthTexture, xlv_TEXCOORD0, 0.0);
      highp float tmpvar_15;
      tmpvar_15 = tmpvar_14.x;
      vardoifles_11 = tmpvar_15;
    };
    highp float tmpvar_16;
    tmpvar_16 = (1.0/(((tmpvar_9 * vardoifles_11) + tmpvar_10)));
    if ((tmpvar_16 > _maxDepthCull)) {
      fasdei434fkkf_6 = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
      highp vec4 paAccurateColor_17;
      highp vec4 origtmp_18;
      int s_19;
      highp vec4 oiedofdefe_20;
      highp float varyutdffe_21;
      int i_33_22;
      bool qwweuiidu_23;
      highp vec4 cjusduyfeef_24;
      int maxCount_29_25;
      highp vec3 nndndduiefa_26;
      highp vec3 ooppdsddd_27;
      highp vec3 xxdkufex_28;
      highp vec4 wqoidf_29;
      highp vec4 vatieuf_30;
      highp vec3 vuy7s_31;
      highp vec4 v12iiose_32;
      v12iiose_32.w = 1.0;
      v12iiose_32.xy = ((xlv_TEXCOORD0 * 2.0) - 1.0);
      v12iiose_32.z = vardoifles_11;
      highp vec4 tmpvar_33;
      tmpvar_33 = (_ProjectionInv * v12iiose_32);
      highp vec4 tmpvar_34;
      tmpvar_34 = (tmpvar_33 / tmpvar_33.w);
      vuy7s_31.xy = v12iiose_32.xy;
      vuy7s_31.z = vardoifles_11;
      vatieuf_30.w = 0.0;
      if ((_IsInForwardRender > 0.0)) {
        lowp vec3 tmpvar_35;
        tmpvar_35 = ((textureLod (_CameraNormalsTexture, xlv_TEXCOORD0, 0.0).xyz * 2.0) - 1.0);
        vatieuf_30.xyz = tmpvar_35;
      } else {
        if ((_IsInLegacyDeffered > 0.0)) {
          highp vec4 dn_36;
          lowp vec4 tmpvar_37;
          tmpvar_37 = texture (_CameraDepthNormalsTexture, xlv_TEXCOORD0);
          dn_36 = tmpvar_37;
          highp vec3 n_38;
          highp vec3 tmpvar_39;
          tmpvar_39 = ((dn_36.xyz * vec3(3.5554, 3.5554, 0.0)) + vec3(-1.7777, -1.7777, 1.0));
          highp float tmpvar_40;
          tmpvar_40 = (2.0 / dot (tmpvar_39, tmpvar_39));
          n_38.xy = (tmpvar_40 * tmpvar_39.xy);
          n_38.z = (tmpvar_40 - 1.0);
          highp mat3 tmpvar_41;
          tmpvar_41[0] = _CameraMV[0].xyz;
          tmpvar_41[1] = _CameraMV[1].xyz;
          tmpvar_41[2] = _CameraMV[2].xyz;
          vatieuf_30.xyz = (tmpvar_41 * n_38);
        } else {
          if ((_FullDeferred > 0.0)) {
            lowp vec3 tmpvar_42;
            tmpvar_42 = ((texture (_CameraGBufferTexture2, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
            vatieuf_30.xyz = tmpvar_42;
          };
        };
      };
      highp vec3 tmpvar_43;
      tmpvar_43 = normalize(tmpvar_34.xyz);
      highp vec3 tmpvar_44;
      tmpvar_44 = normalize((_ViewMatrix * vatieuf_30).xyz);
      wqoidf_29.w = 1.0;
      wqoidf_29.xyz = (tmpvar_34.xyz + normalize((tmpvar_43 - 
        (2.0 * (dot (tmpvar_44, tmpvar_43) * tmpvar_44))
      )));
      highp vec4 tmpvar_45;
      tmpvar_45 = (_ProjMatrix * wqoidf_29);
      highp vec3 tmpvar_46;
      tmpvar_46 = normalize(((tmpvar_45.xyz / tmpvar_45.w) - vuy7s_31));
      ssped44s_4.z = tmpvar_46.z;
      ssped44s_4.xy = (tmpvar_46.xy * 0.5);
      xxdkufex_28.xy = xlv_TEXCOORD0;
      xxdkufex_28.z = vardoifles_11;
      highp float tmpvar_47;
      tmpvar_47 = (2.0 / _ScreenParams.x);
      highp float tmpvar_48;
      tmpvar_48 = sqrt(dot (ssped44s_4.xy, ssped44s_4.xy));
      highp vec3 tmpvar_49;
      tmpvar_49 = (ssped44s_4 * ((tmpvar_47 * _stepGlobalScale) / tmpvar_48));
      ooppdsddd_27 = tmpvar_49;
      maxCount_29_25 = int(_maxStep);
      qwweuiidu_23 = bool(0);
      nndndduiefa_26 = (xxdkufex_28 + tmpvar_49);
      i_33_22 = 0;
      s_19 = 0;
      while (true) {
        if ((s_19 >= 120)) {
          break;
        };
        if ((i_33_22 >= maxCount_29_25)) {
          break;
        };
        if ((_IsInForwardRender > 0.0)) {
          lowp vec4 tmpvar_50;
          tmpvar_50 = textureLod (_depthTexCustom, nndndduiefa_26.xy, 0.0);
          varyutdffe_21 = (1.0/(((zudifkd_3 * tmpvar_50.x) + dofiemdklsf_2)));
        } else {
          lowp vec4 tmpvar_51;
          tmpvar_51 = textureLod (_CameraDepthTexture, nndndduiefa_26.xy, 0.0);
          varyutdffe_21 = (1.0/(((zudifkd_3 * tmpvar_51.x) + dofiemdklsf_2)));
        };
        highp float tmpvar_52;
        tmpvar_52 = (1.0/(((zudifkd_3 * nndndduiefa_26.z) + dofiemdklsf_2)));
        if ((varyutdffe_21 < (tmpvar_52 - 1e-06))) {
          oiedofdefe_20.w = 1.0;
          oiedofdefe_20.xyz = nndndduiefa_26;
          cjusduyfeef_24 = oiedofdefe_20;
          qwweuiidu_23 = bool(1);
          break;
        };
        nndndduiefa_26 = (nndndduiefa_26 + ooppdsddd_27);
        i_33_22++;
        s_19++;
      };
      if ((qwweuiidu_23 == bool(0))) {
        highp vec4 efuiydfeef_53;
        efuiydfeef_53.w = 0.0;
        efuiydfeef_53.xyz = nndndduiefa_26;
        cjusduyfeef_24 = efuiydfeef_53;
        qwweuiidu_23 = bool(1);
      };
      lerrre33dcs_5 = cjusduyfeef_24;
      highp float tmpvar_54;
      tmpvar_54 = abs((cjusduyfeef_24.x - 0.5));
      origtmp_18 = tmpvar_8;
      if ((_FlipReflectionsMSAA > 0.0)) {
        highp vec2 tmpouv_55;
        tmpouv_55.x = xlv_TEXCOORD0.x;
        tmpouv_55.y = (1.0 - xlv_TEXCOORD0.y);
        lowp vec4 tmpvar_56;
        tmpvar_56 = textureLod (_MainTex, tmpouv_55, 0.0);
        highp vec4 tmpvar_57;
        tmpvar_57 = tmpvar_56;
        origtmp_18 = tmpvar_57;
      };
      paAccurateColor_17 = vec4(0.0, 0.0, 0.0, 0.0);
      if ((_SSRRcomposeMode > 0.0)) {
        highp vec4 tmpvar_58;
        tmpvar_58.w = 0.0;
        tmpvar_58.xyz = origtmp_18.xyz;
        paAccurateColor_17 = tmpvar_58;
      };
      if ((tmpvar_54 > 0.5)) {
        fasdei434fkkf_6 = paAccurateColor_17;
      } else {
        highp float tmpvar_59;
        tmpvar_59 = abs((cjusduyfeef_24.y - 0.5));
        if ((tmpvar_59 > 0.5)) {
          fasdei434fkkf_6 = paAccurateColor_17;
        } else {
          if ((((1.0/(
            ((_ZBufferParams.x * cjusduyfeef_24.z) + _ZBufferParams.y)
          )) > _maxDepthCull) && (_skyEnabled < 0.5))) {
            fasdei434fkkf_6 = paAccurateColor_17;
          } else {
            if ((cjusduyfeef_24.z < 0.1)) {
              fasdei434fkkf_6 = paAccurateColor_17;
            } else {
              if ((cjusduyfeef_24.w == 1.0)) {
                int j_60;
                highp vec4 cmcnjkhdwe_61;
                highp float bbdkjfe_62;
                highp vec3 oldPos_50_63;
                int i_49_64;
                bool iueidkjkjff_65;
                highp vec4 tmpvar_47_66;
                int maxCount_45_67;
                highp vec3 fjeiudiuiuiuse_68;
                highp vec3 samplePos_43_69;
                highp vec3 tmpvar_70;
                tmpvar_70 = (cjusduyfeef_24.xyz - tmpvar_49);
                highp vec3 tmpvar_71;
                tmpvar_71 = (ssped44s_4 * (tmpvar_47 / tmpvar_48));
                fjeiudiuiuiuse_68 = tmpvar_71;
                maxCount_45_67 = int(_maxFineStep);
                iueidkjkjff_65 = bool(0);
                oldPos_50_63 = tmpvar_70;
                samplePos_43_69 = (tmpvar_70 + tmpvar_71);
                i_49_64 = 0;
                j_60 = 0;
                while (true) {
                  if ((j_60 >= 40)) {
                    break;
                  };
                  if ((i_49_64 >= maxCount_45_67)) {
                    break;
                  };
                  if ((_IsInForwardRender > 0.0)) {
                    lowp vec4 tmpvar_72;
                    tmpvar_72 = textureLod (_depthTexCustom, samplePos_43_69.xy, 0.0);
                    bbdkjfe_62 = (1.0/(((zudifkd_3 * tmpvar_72.x) + dofiemdklsf_2)));
                  } else {
                    lowp vec4 tmpvar_73;
                    tmpvar_73 = textureLod (_CameraDepthTexture, samplePos_43_69.xy, 0.0);
                    bbdkjfe_62 = (1.0/(((zudifkd_3 * tmpvar_73.x) + dofiemdklsf_2)));
                  };
                  highp float tmpvar_74;
                  tmpvar_74 = (1.0/(((zudifkd_3 * samplePos_43_69.z) + dofiemdklsf_2)));
                  if ((bbdkjfe_62 < tmpvar_74)) {
                    if (((tmpvar_74 - bbdkjfe_62) < _bias)) {
                      cmcnjkhdwe_61.w = 1.0;
                      cmcnjkhdwe_61.xyz = samplePos_43_69;
                      tmpvar_47_66 = cmcnjkhdwe_61;
                      iueidkjkjff_65 = bool(1);
                      break;
                    };
                    highp vec3 tmpvar_75;
                    tmpvar_75 = (fjeiudiuiuiuse_68 * 0.5);
                    fjeiudiuiuiuse_68 = tmpvar_75;
                    samplePos_43_69 = (oldPos_50_63 + tmpvar_75);
                  } else {
                    oldPos_50_63 = samplePos_43_69;
                    samplePos_43_69 = (samplePos_43_69 + fjeiudiuiuiuse_68);
                  };
                  i_49_64++;
                  j_60++;
                };
                if ((iueidkjkjff_65 == bool(0))) {
                  highp vec4 tmpvar_55_76;
                  tmpvar_55_76.w = 0.0;
                  tmpvar_55_76.xyz = samplePos_43_69;
                  tmpvar_47_66 = tmpvar_55_76;
                  iueidkjkjff_65 = bool(1);
                };
                lerrre33dcs_5 = tmpvar_47_66;
              };
              if ((lerrre33dcs_5.w < 0.01)) {
                fasdei434fkkf_6 = paAccurateColor_17;
              } else {
                highp vec4 tmpvar_57_77;
                if ((_FlipReflectionsMSAA > 0.0)) {
                  lerrre33dcs_5.y = (1.0 - lerrre33dcs_5.y);
                };
                lowp vec3 tmpvar_78;
                tmpvar_78 = textureLod (_MainTex, lerrre33dcs_5.xy, 0.0).xyz;
                tmpvar_57_77.xyz = tmpvar_78;
                tmpvar_57_77.w = 1.0;
                fasdei434fkkf_6 = tmpvar_57_77;
              };
            };
          };
        };
      };
    };
  };
  tmpvar_1 = fasdei434fkkf_6;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "metal " {
// Stats: 1 math
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
  float2 tmpvar_2;
  tmpvar_2 = float2(tmpvar_1);
  _mtl_o.gl_Position = (_mtl_u.glstate_matrix_mvp * _mtl_i._glesVertex);
  _mtl_o.xlv_TEXCOORD0 = tmpvar_2;
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
// Stats: 152 math, 22 textures, 44 branches
Matrix 11 [_CameraMV] 3
Matrix 0 [_ProjMatrix]
Matrix 4 [_ProjectionInv]
Matrix 8 [_ViewMatrix] 3
Float 22 [_FlipReflectionsMSAA]
Float 26 [_FullDeferred]
Float 24 [_IsInForwardRender]
Float 25 [_IsInLegacyDeffered]
Float 21 [_SSRRcomposeMode]
Vector 14 [_ScreenParams]
Vector 15 [_ZBufferParams]
Float 20 [_bias]
Float 16 [_maxDepthCull]
Float 17 [_maxFineStep]
Float 18 [_maxStep]
Float 23 [_skyEnabled]
Float 19 [_stepGlobalScale]
SetTexture 0 [_depthTexCustom] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_CameraNormalsTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
"ps_3_0
def c27, -165.666656, 166.666656, 0, -9.99999997e-007
def c28, 3.55539989, 0, -1.77769995, 1
def c29, 0.100000001, 0, -0.00999999978, 0.00999999978
def c30, 1, 0, 0.5, -2
def c31, 2, 0, -1, 1
defi i0, 120, 0, 0, 0
defi i1, 40, 0, 0, 0
dcl_texcoord v0.xy
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
mul r0, c30.xxyy, v0.xyxx
texldl r1, r0, s1
if_eq r1.w, c30.y
mov_pp oC0, c30.y
else
mov r2.yz, c30
add r2.x, r2.z, -c23.x
mov r3.xy, c15
cmp r2.xw, r2.x, r3.xyzy, c27.xyzy
if_lt -c24.x, r2.y
texldl r3, r0, s0
mov r3.z, r3.x
else
texldl r4, r0, s3
mov r3.z, r4.x
endif
mad r4.x, r2.x, r3.z, r2.w
rcp r4.x, r4.x
if_lt c16.x, r4.x
mov_pp oC0, c30.y
else
mad r3.xyw, v0.xyzx, c31.xxzy, c31.zzzw
dp4 r4.x, c4, r3
dp4 r4.y, c5, r3
dp4 r4.z, c6, r3
dp4 r3.w, c7, r3
rcp r3.w, r3.w
mul r4.xyz, r3.w, r4
if_lt -c24.x, r2.y
texldl r0, r0, s2
mad r0.xyz, r0, -c30.w, -c30.x
else
if_lt -c25.x, r2.y
texld r5, v0, s4
mad r5.xyz, r5, c28.xxyw, c28.zzww
dp3 r0.w, r5, r5
rcp r0.w, r0.w
add r3.w, r0.w, r0.w
mul r5.xy, r5, r3.w
mad r5.z, r0.w, -c30.w, -c30.x
dp3 r0.x, c11, r5
dp3 r0.y, c12, r5
dp3 r0.z, c13, r5
else
if_lt -c26.x, r2.y
texld r5, v0, s5
mad r0.xyz, r5, -c30.w, -c30.x
else
mov r0.xyz, c30.y
endif
endif
endif
nrm r5.xyz, r4
dp3 r6.x, c8, r0
dp3 r6.y, c9, r0
dp3 r6.z, c10, r0
nrm r0.xyz, r6
dp3 r0.w, r0, r5
mul r0.xyz, r0, r0.w
mad r0.xyz, r0, c30.w, r5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r0.xyz, r0, r0.w, r4
mov r0.w, c30.x
dp4 r4.x, c0, r0
dp4 r4.y, c1, r0
dp4 r4.z, c2, r0
dp4 r0.x, c3, r0
rcp r0.x, r0.x
mad r0.xyz, r4, r0.x, -r3
nrm r4.xyz, r0
mul r0.xy, r4, c30.z
rcp r0.z, c14.x
add r0.z, r0.z, r0.z
dp2add r0.x, r0, r0, c30.y
rsq r0.x, r0.x
mul r0.y, r0.z, c19.x
mul r0.y, r0.x, r0.y
mul r4.xyz, r4, c30.zzxw
frc r0.w, c18.x
add r3.w, -r0.w, c18.x
cmp r0.w, -r0.w, c30.y, c30.x
cmp r0.w, c18.x, r2.y, r0.w
add r0.w, r0.w, r3.w
mov r3.xy, v0
mad r3.xyz, r4, r0.y, r3
mov r5, c30.y
mov r6.xyz, r3
mov r3.w, c30.y
mov r4.w, c30.y
rep i0
if_ge r4.w, r0.w
break_ne c30.x, -c30.x
endif
if_lt -c24.x, r2.y
mul r7, r6.xyxx, c30.xxyy
texldl r7, r7, s0
mad r7.x, r2.x, r7.x, r2.w
rcp r7.x, r7.x
else
mul r8, r6.xyxx, c30.xxyy
texldl r8, r8, s3
mad r7.y, r2.x, r8.x, r2.w
rcp r7.x, r7.y
endif
mad r7.y, r2.x, r6.z, r2.w
rcp r7.y, r7.y
add r7.y, r7.y, c27.w
if_lt r7.x, r7.y
mad r5.xyw, r6.xyzx, c30.xxzy, c30.yyzx
mov r5.z, r6.z
mov r3.w, c30.x
break_ne c30.x, -c30.x
endif
mad r6.xyz, r4, r0.y, r6
add r4.w, r4.w, c30.x
mov r5, c30.y
mov r3.w, c30.y
endrep
mov r6.w, c30.y
cmp r3, -r3.w, r6, r5
add r0.w, r3.x, -c30.z
if_lt -c22.x, r2.y
mad r5, v0.xyxx, c31.wzyy, c31.ywyy
texldl r1, r5, s1
endif
cmp r1.xyz, -c21.x, r2.y, r1
mov r1.w, c30.y
if_lt c30.z, r0_abs.w
mov_pp oC0, r1
else
add r0.w, r3.y, -c30.z
if_lt c30.z, r0_abs.w
mov_pp oC0, r1
else
mad r0.w, c15.x, r3.z, c15.y
rcp r0.w, r0.w
add r0.w, -r0.w, c16.x
add r2.z, -r2.z, c23.x
cmp r2.z, r2.z, c30.y, c30.x
cmp r0.w, r0.w, c30.y, r2.z
if_ne r0.w, -r0.w
mov_pp oC0, r1
else
if_lt r3.z, c29.x
mov_pp oC0, r1
else
if_ge r3.w, c30.x
mad r5.xyz, r4, -r0.y, r3
mul r0.x, r0.x, r0.z
mul r0.yzw, r0.x, r4.xxyz
frc r1.w, c17.x
add r2.z, -r1.w, c17.x
cmp r1.w, -r1.w, c30.y, c30.x
cmp r1.w, c17.x, r2.y, r1.w
add r1.w, r1.w, r2.z
mad r4.xyz, r4, r0.x, r5
mov r6.xyz, r0.yzww
mov r7.xyz, c30.y
mov r8.xyz, r5
mov r9.xyz, r4
mov r0.x, c30.y
mov r2.z, c30.y
rep i1
if_ge r2.z, r1.w
break_ne c30.x, -c30.x
endif
if_lt -c24.x, r2.y
mul r10, r9.xyxx, c30.xxyy
texldl r10, r10, s0
mad r4.w, r2.x, r10.x, r2.w
rcp r4.w, r4.w
else
mul r10, r9.xyxx, c30.xxyy
texldl r10, r10, s3
mad r5.w, r2.x, r10.x, r2.w
rcp r4.w, r5.w
endif
mad r5.w, r2.x, r9.z, r2.w
rcp r5.w, r5.w
if_lt r4.w, r5.w
add r4.w, -r4.w, r5.w
if_lt r4.w, c20.x
mad r7.xyz, r9.xyxw, c30.xxyw, c30.yyxw
mov r0.x, c30.x
break_ne c30.x, -c30.x
endif
mul r10.xyz, r6, c30.z
mad r9.xyz, r6, c30.z, r8
mov r6.xyz, r10
else
add r10.xyz, r6, r9
mov r8.xyz, r9
mov r9.xyz, r10
endif
add r2.z, r2.z, c30.x
mov r7.xyz, c30.y
mov r0.x, c30.y
endrep
mov r9.z, c30.y
cmp r3.xyw, -r0.x, r9.xyzz, r7.xyzz
endif
add r0.x, r3.w, c29.z
cmp_pp oC0.w, r0.x, c30.x, c30.y
if_lt r3.w, c29.w
mov_pp oC0.xyz, r1
else
add r0.x, -r3.y, c30.x
cmp r3.y, -c22.x, r3.y, r0.x
mov r3.z, c30.y
texldl r0, r3.xyzz, s1
mov_pp oC0.xyz, r0
endif
endif
endif
endif
endif
endif
endif

"
}
SubProgram "d3d11 " {
// Stats: 106 math, 2 textures, 40 branches
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_depthTexCustom] 2D 0
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_CameraNormalsTexture] 2D 2
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
ConstBuffer "$Globals" 448
Matrix 128 [_ProjMatrix]
Matrix 192 [_ProjectionInv]
Matrix 256 [_ViewMatrix]
Matrix 384 [_CameraMV]
Float 100 [_maxDepthCull]
Float 104 [_maxFineStep]
Float 108 [_maxStep]
Float 112 [_stepGlobalScale]
Float 116 [_bias]
Float 336 [_SSRRcomposeMode]
Float 340 [_FlipReflectionsMSAA]
Float 344 [_skyEnabled]
Float 368 [_IsInForwardRender]
Float 372 [_IsInLegacyDeffered]
Float 376 [_FullDeferred]
ConstBuffer "UnityPerCamera" 144
Vector 96 [_ScreenParams]
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecednkpdnomdhgbpcbbegebkgnfdgbccgbfpabaaaaaajibhaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcnibgaaaa
eaaaaaaalgafaaaafjaaaaaeegiocaaaaaaaaaaablaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacamaaaaaaeiaaaaalpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaabeaaaaaaaaaaaaabiaaaaah
bcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabpaaaeadakaabaaa
abaaaaaadgaaaaaipccabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabcaaaaabdbaaaaaibcaabaaaabaaaaaaabeaaaaaaaaaaadpckiacaaa
aaaaaaaabfaaaaaadhaaaaandcaabaaaabaaaaaaagaabaaaabaaaaaaaceaaaaa
kkkkcfmdkkkkcgedaaaaaaaaaaaaaaaaegiacaaaabaaaaaaahaaaaaadbaaaaai
ecaabaaaabaaaaaaabeaaaaaaaaaaaaaakiacaaaaaaaaaaabhaaaaaabpaaaead
ckaabaaaabaaaaaaeiaaaaalpcaabaaaacaaaaaaegbabaaaabaaaaaajghmbaaa
abaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaabcaaaaabeiaaaaalpcaabaaa
acaaaaaaegbabaaaabaaaaaajghmbaaaacaaaaaaaagabaaaadaaaaaaabeaaaaa
aaaaaaaabfaaaaabdcaaaaajicaabaaaabaaaaaaakaabaaaabaaaaaackaabaaa
acaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaaiicaabaaaabaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaabaaaaaabpaaaeaddkaabaaaabaaaaaa
dgaaaaaipccabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
bcaaaaabdcaaaaapdcaabaaaadaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
diaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaaaaaaaaaanaaaaaa
dcaaaaakpcaabaaaadaaaaaaegiocaaaaaaaaaaaamaaaaaaagaabaaaadaaaaaa
egaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaaaaaaaaaaoaaaaaa
kgakbaaaacaaaaaaegaobaaaadaaaaaaaaaaaaaipcaabaaaadaaaaaaegaobaaa
adaaaaaaegiocaaaaaaaaaaaapaaaaaaaoaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaadaaaaaabpaaaeadckaabaaaabaaaaaaeiaaaaalpcaabaaa
aeaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaaadcaaaaaphcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
bcaaaaabdbaaaaaiicaabaaaabaaaaaaabeaaaaaaaaaaaaabkiacaaaaaaaaaaa
bhaaaaaabpaaaeaddkaabaaaabaaaaaaefaaaaajpcaabaaaafaaaaaaegbabaaa
abaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaphcaabaaaafaaaaaa
egacbaaaafaaaaaaaceaaaaakmilgdeakmilgdeaaaaaaaaaaaaaaaaaaceaaaaa
kmilodlpkmilodlpaaaaiadpaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
afaaaaaaegacbaaaafaaaaaaaoaaaaahicaabaaaabaaaaaaabeaaaaaaaaaaaea
dkaabaaaabaaaaaadiaaaaahdcaabaaaafaaaaaaegaabaaaafaaaaaapgapbaaa
abaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaialp
diaaaaaiocaabaaaafaaaaaafgafbaaaafaaaaaaagijcaaaaaaaaaaabjaaaaaa
dcaaaaakhcaabaaaafaaaaaaegiccaaaaaaaaaaabiaaaaaaagaabaaaafaaaaaa
jgahbaaaafaaaaaadcaaaaakhcaabaaaaeaaaaaaegiccaaaaaaaaaaabkaaaaaa
pgapbaaaabaaaaaaegacbaaaafaaaaaabcaaaaabdbaaaaaiicaabaaaabaaaaaa
abeaaaaaaaaaaaaackiacaaaaaaaaaaabhaaaaaabpaaaeaddkaabaaaabaaaaaa
efaaaaajpcaabaaaafaaaaaaegbabaaaabaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadcaaaaaphcaabaaaaeaaaaaaegacbaaaafaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
bfaaaaabbfaaaaabbfaaaaabbaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihcaabaaa
agaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaabbaaaaaadcaaaaaklcaabaaa
aeaaaaaaegiicaaaaaaaaaaabaaaaaaaagaabaaaaeaaaaaaegaibaaaagaaaaaa
dcaaaaakhcaabaaaaeaaaaaaegiccaaaaaaaaaaabcaaaaaakgakbaaaaeaaaaaa
egadbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaaeaaaaaaegacbaaa
aeaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaaeaaaaaaegacbaaaafaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaa
aeaaaaaapgapbaaaabaaaaaadcaaaaanhcaabaaaaeaaaaaaegacbaiaebaaaaaa
aeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaegacbaaaafaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaaeaaaaaaegacbaaaaeaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaa
aeaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaipcaabaaaaeaaaaaa
fgafbaaaadaaaaaaegiocaaaaaaaaaaaajaaaaaadcaaaaakpcaabaaaaeaaaaaa
egiocaaaaaaaaaaaaiaaaaaaagaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaak
pcaabaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaakgakbaaaadaaaaaaegaobaaa
aeaaaaaaaaaaaaaipcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaaaaaaaaa
alaaaaaaaoaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaadaaaaaa
dcaaaaapdcaabaaaacaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaaaaaaaai
hcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaakdcaabaaaaeaaaaaaegaabaaaadaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaoaaaaaiicaabaaaabaaaaaaabeaaaaa
aaaaaaeaakiacaaaabaaaaaaagaaaaaaapaaaaahicaabaaaacaaaaaaegaabaaa
aeaaaaaaegaabaaaaeaaaaaaelaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaa
diaaaaaiicaabaaaadaaaaaadkaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaa
aoaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaadkaabaaaacaaaaaadiaaaaak
hcaabaaaadaaaaaaegacbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaiadp
aaaaaaaablaaaaagbcaabaaaaeaaaaaadkiacaaaaaaaaaaaagaaaaaadgaaaaaf
dcaabaaaacaaaaaaegbabaaaabaaaaaadcaaaaajhcaabaaaacaaaaaaegacbaaa
adaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaafaaaaaa
abeaaaaaaaaaiadpdgaaaaaipcaabaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadgaaaaafhcaabaaaafaaaaaaegacbaaaacaaaaaadgaaaaai
ocaabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaab
cbaaaaahbcaabaaaahaaaaaadkaabaaaaeaaaaaaabeaaaaahiaaaaaaadaaaead
akaabaaaahaaaaaacbaaaaahbcaabaaaahaaaaaackaabaaaaeaaaaaaakaabaaa
aeaaaaaabpaaaeadakaabaaaahaaaaaaacaaaaabbfaaaaabbpaaaeadckaabaaa
abaaaaaaeiaaaaalpcaabaaaahaaaaaaegaabaaaafaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaaahaaaaaaakaabaaa
abaaaaaaakaabaaaahaaaaaabkaabaaaabaaaaaaaoaaaaakbcaabaaaahaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaahaaaaaabcaaaaab
eiaaaaalpcaabaaaaiaaaaaaegaabaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaahaaaaaaakaabaaaabaaaaaa
akaabaaaaiaaaaaabkaabaaaabaaaaaaaoaaaaakbcaabaaaahaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpbkaabaaaahaaaaaabfaaaaabdcaaaaaj
ccaabaaaahaaaaaaakaabaaaabaaaaaackaabaaaafaaaaaabkaabaaaabaaaaaa
aoaaaaakccaabaaaahaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
bkaabaaaahaaaaaaaaaaaaahccaabaaaahaaaaaabkaabaaaahaaaaaaabeaaaaa
lndhiglfdbaaaaahbcaabaaaahaaaaaaakaabaaaahaaaaaabkaabaaaahaaaaaa
bpaaaeadakaabaaaahaaaaaadgaaaaafpcaabaaaagaaaaaaegaobaaaafaaaaaa
dgaaaaafccaabaaaaeaaaaaaabeaaaaappppppppacaaaaabbfaaaaabdcaaaaaj
hcaabaaaafaaaaaaegacbaaaadaaaaaapgapbaaaadaaaaaaegacbaaaafaaaaaa
boaaaaahecaabaaaaeaaaaaackaabaaaaeaaaaaaabeaaaaaabaaaaaaboaaaaah
icaabaaaaeaaaaaadkaabaaaaeaaaaaaabeaaaaaabaaaaaadgaaaaaipcaabaaa
agaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafccaabaaa
aeaaaaaaabeaaaaaaaaaaaaabgaaaaabdgaaaaaficaabaaaafaaaaaaabeaaaaa
aaaaaaaadhaaaaajpcaabaaaaeaaaaaafgafbaaaaeaaaaaaegaobaaaagaaaaaa
egaobaaaafaaaaaaaaaaaaahbcaabaaaacaaaaaaakaabaaaaeaaaaaaabeaaaaa
aaaaaalpdbaaaaalgcaabaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaafgiecaaaaaaaaaaabfaaaaaabpaaaeadbkaabaaaacaaaaaadcaaaaap
dcaabaaaafaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaialpaaaaaaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaeiaaaaalpcaabaaa
aaaaaaaaegaabaaaafaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaabeaaaaa
aaaaaaaabfaaaaababaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaakgakbaaa
acaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaaaaadbaaaaaibcaabaaa
acaaaaaaabeaaaaaaaaaaadpakaabaiaibaaaaaaacaaaaaabpaaaeadakaabaaa
acaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaabaaaaaaah
bcaabaaaacaaaaaabkaabaaaaeaaaaaaabeaaaaaaaaaaalpdbaaaaaibcaabaaa
acaaaaaaabeaaaaaaaaaaadpakaabaiaibaaaaaaacaaaaaabpaaaeadakaabaaa
acaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaabdcaaaaal
bcaabaaaacaaaaaaakiacaaaabaaaaaaahaaaaaackaabaaaaeaaaaaabkiacaaa
abaaaaaaahaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpakaabaaaacaaaaaadbaaaaaibcaabaaaacaaaaaabkiacaaa
aaaaaaaaagaaaaaaakaabaaaacaaaaaadbaaaaaiecaabaaaacaaaaaackiacaaa
aaaaaaaabfaaaaaaabeaaaaaaaaaaadpabaaaaahbcaabaaaacaaaaaackaabaaa
acaaaaaaakaabaaaacaaaaaabpaaaeadakaabaaaacaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaabcaaaaabdbaaaaahbcaabaaaacaaaaaackaabaaa
aeaaaaaaabeaaaaamnmmmmdnbpaaaeadakaabaaaacaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaabcaaaaabbiaaaaahbcaabaaaacaaaaaadkaabaaa
aeaaaaaaabeaaaaaaaaaiadpbpaaaeadakaabaaaacaaaaaadcaaaaakhcaabaaa
afaaaaaaegacbaiaebaaaaaaadaaaaaapgapbaaaadaaaaaaegacbaaaaeaaaaaa
aoaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaah
ncaabaaaacaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaablaaaaagicaabaaa
adaaaaaackiacaaaaaaaaaaaagaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaadgaaaaafecaabaaaagaaaaaa
abeaaaaaaaaaiadpdgaaaaafhcaabaaaahaaaaaaigadbaaaacaaaaaadgaaaaai
hcaabaaaaiaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaf
hcaabaaaajaaaaaaegacbaaaafaaaaaadgaaaaafhcaabaaaakaaaaaaegacbaaa
adaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaaaaadgaaaaaficaabaaa
aeaaaaaaabeaaaaaaaaaaaaadgaaaaaficaabaaaafaaaaaaabeaaaaaaaaaaaaa
daaaaaabcbaaaaahicaabaaaagaaaaaadkaabaaaafaaaaaaabeaaaaaciaaaaaa
adaaaeaddkaabaaaagaaaaaacbaaaaahicaabaaaagaaaaaadkaabaaaaeaaaaaa
dkaabaaaadaaaaaabpaaaeaddkaabaaaagaaaaaaacaaaaabbfaaaaabbpaaaead
ckaabaaaabaaaaaaeiaaaaalpcaabaaaalaaaaaaegaabaaaakaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajicaabaaaagaaaaaa
akaabaaaabaaaaaaakaabaaaalaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaa
agaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaagaaaaaa
bcaaaaabeiaaaaalpcaabaaaalaaaaaaegaabaaaakaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaaabeaaaaaaaaaaaaadcaaaaajicaabaaaahaaaaaaakaabaaa
abaaaaaaakaabaaaalaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaaagaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaahaaaaaabfaaaaab
dcaaaaajicaabaaaahaaaaaaakaabaaaabaaaaaackaabaaaakaaaaaabkaabaaa
abaaaaaaaoaaaaakicaabaaaahaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaahaaaaaadbaaaaahicaabaaaaiaaaaaadkaabaaaagaaaaaa
dkaabaaaahaaaaaabpaaaeaddkaabaaaaiaaaaaaaaaaaaaiicaabaaaagaaaaaa
dkaabaiaebaaaaaaagaaaaaadkaabaaaahaaaaaadbaaaaaiicaabaaaagaaaaaa
dkaabaaaagaaaaaabkiacaaaaaaaaaaaahaaaaaabpaaaeaddkaabaaaagaaaaaa
dgaaaaafdcaabaaaagaaaaaaegaabaaaakaaaaaadgaaaaafhcaabaaaaiaaaaaa
egacbaaaagaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaappppppppacaaaaab
bfaaaaabdiaaaaaklcaabaaaagaaaaaaegaibaaaahaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaadpdcaaaaamhcaabaaaakaaaaaaegacbaaaahaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaegacbaaaajaaaaaadgaaaaaf
hcaabaaaahaaaaaaegadbaaaagaaaaaabcaaaaabaaaaaaahlcaabaaaagaaaaaa
egaibaaaahaaaaaaegaibaaaakaaaaaadgaaaaafhcaabaaaajaaaaaaegacbaaa
akaaaaaadgaaaaafhcaabaaaakaaaaaaegadbaaaagaaaaaabfaaaaabboaaaaah
icaabaaaaeaaaaaadkaabaaaaeaaaaaaabeaaaaaabaaaaaaboaaaaahicaabaaa
afaaaaaadkaabaaaafaaaaaaabeaaaaaabaaaaaadgaaaaaihcaabaaaaiaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaaaaabgaaaaabdgaaaaafecaabaaaakaaaaaaabeaaaaaaaaaaaaa
dhaaaaajhcaabaaaaeaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaa
akaaaaaabcaaaaabdgaaaaafecaabaaaaeaaaaaaabeaaaaaaaaaaaaabfaaaaab
dbaaaaahbcaabaaaabaaaaaackaabaaaaeaaaaaaabeaaaaaaknhcddmbpaaaead
akaabaaaabaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaab
aaaaaaaibcaabaaaaaaaaaaabkaabaiaebaaaaaaaeaaaaaaabeaaaaaaaaaiadp
dhaaaaajccaabaaaaeaaaaaabkaabaaaacaaaaaaakaabaaaaaaaaaaabkaabaaa
aeaaaaaaeiaaaaalpcaabaaaaaaaaaaaegaabaaaaeaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaabeaaaaaaaaaaaaadgaaaaafhccabaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpbfaaaaabbfaaaaab
bfaaaaabbfaaaaabbfaaaaabbfaaaaabbfaaaaabdoaaaaab"
}
SubProgram "gles3 " {
"!!GLES3"
}
SubProgram "metal " {
// Stats: 137 math, 12 textures, 30 branches
SetTexture 0 [_depthTexCustom] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_CameraNormalsTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
ConstBuffer "$Globals" 352
Matrix 64 [_ProjMatrix]
Matrix 128 [_ProjectionInv]
Matrix 192 [_ViewMatrix]
Matrix 288 [_CameraMV]
Vector 0 [_ScreenParams]
Vector 16 [_ZBufferParams]
Float 32 [_maxDepthCull]
Float 36 [_maxFineStep]
Float 40 [_maxStep]
Float 44 [_stepGlobalScale]
Float 48 [_bias]
Float 256 [_SSRRcomposeMode]
Float 260 [_FlipReflectionsMSAA]
Float 264 [_skyEnabled]
Float 268 [_IsInForwardRender]
Float 272 [_IsInLegacyDeffered]
Float 276 [_FullDeferred]
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
  float4 _ScreenParams;
  float4 _ZBufferParams;
  float _maxDepthCull;
  float _maxFineStep;
  float _maxStep;
  float _stepGlobalScale;
  float _bias;
  float4x4 _ProjMatrix;
  float4x4 _ProjectionInv;
  float4x4 _ViewMatrix;
  float _SSRRcomposeMode;
  float _FlipReflectionsMSAA;
  float _skyEnabled;
  float _IsInForwardRender;
  float _IsInLegacyDeffered;
  float _FullDeferred;
  float4x4 _CameraMV;
};
fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<half> _depthTexCustom [[texture(0)]], sampler _mtlsmp__depthTexCustom [[sampler(0)]]
  ,   texture2d<half> _MainTex [[texture(1)]], sampler _mtlsmp__MainTex [[sampler(1)]]
  ,   texture2d<half> _CameraNormalsTexture [[texture(2)]], sampler _mtlsmp__CameraNormalsTexture [[sampler(2)]]
  ,   texture2d<half> _CameraDepthTexture [[texture(3)]], sampler _mtlsmp__CameraDepthTexture [[sampler(3)]]
  ,   texture2d<half> _CameraDepthNormalsTexture [[texture(4)]], sampler _mtlsmp__CameraDepthNormalsTexture [[sampler(4)]]
  ,   texture2d<half> _CameraGBufferTexture2 [[texture(5)]], sampler _mtlsmp__CameraGBufferTexture2 [[sampler(5)]])
{
  xlatMtlShaderOutput _mtl_o;
  half4 tmpvar_1;
  float dofiemdklsf_2;
  float zudifkd_3;
  float3 ssped44s_4;
  float4 lerrre33dcs_5;
  float4 fasdei434fkkf_6;
  half4 tmpvar_7;
  tmpvar_7 = _MainTex.sample(_mtlsmp__MainTex, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
  float4 tmpvar_8;
  tmpvar_8 = float4(tmpvar_7);
  float tmpvar_9;
  if ((_mtl_u._skyEnabled > 0.5)) {
    tmpvar_9 = -165.6667;
  } else {
    tmpvar_9 = _mtl_u._ZBufferParams.x;
  };
  zudifkd_3 = tmpvar_9;
  float tmpvar_10;
  if ((_mtl_u._skyEnabled > 0.5)) {
    tmpvar_10 = 166.6667;
  } else {
    tmpvar_10 = _mtl_u._ZBufferParams.y;
  };
  dofiemdklsf_2 = tmpvar_10;
  if ((tmpvar_8.w == 0.0)) {
    fasdei434fkkf_6 = float4(0.0, 0.0, 0.0, 0.0);
  } else {
    float vardoifles_11;
    vardoifles_11 = 0.0;
    if ((_mtl_u._IsInForwardRender > 0.0)) {
      half4 tmpvar_12;
      tmpvar_12 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
      float tmpvar_13;
      tmpvar_13 = float(tmpvar_12.x);
      vardoifles_11 = tmpvar_13;
    } else {
      half4 tmpvar_14;
      tmpvar_14 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
      float tmpvar_15;
      tmpvar_15 = float(tmpvar_14.x);
      vardoifles_11 = tmpvar_15;
    };
    float tmpvar_16;
    tmpvar_16 = (1.0/(((tmpvar_9 * vardoifles_11) + tmpvar_10)));
    if ((tmpvar_16 > _mtl_u._maxDepthCull)) {
      fasdei434fkkf_6 = float4(0.0, 0.0, 0.0, 0.0);
    } else {
      float4 paAccurateColor_17;
      float4 origtmp_18;
      int s_19;
      float4 oiedofdefe_20;
      float varyutdffe_21;
      int i_33_22;
      bool qwweuiidu_23;
      float4 cjusduyfeef_24;
      int maxCount_29_25;
      float3 nndndduiefa_26;
      float3 ooppdsddd_27;
      float3 xxdkufex_28;
      float4 wqoidf_29;
      float4 vatieuf_30;
      float3 vuy7s_31;
      float4 v12iiose_32;
      v12iiose_32.w = 1.0;
      v12iiose_32.xy = ((_mtl_i.xlv_TEXCOORD0 * 2.0) - 1.0);
      v12iiose_32.z = vardoifles_11;
      float4 tmpvar_33;
      tmpvar_33 = (_mtl_u._ProjectionInv * v12iiose_32);
      float4 tmpvar_34;
      tmpvar_34 = (tmpvar_33 / tmpvar_33.w);
      vuy7s_31.xy = v12iiose_32.xy;
      vuy7s_31.z = vardoifles_11;
      vatieuf_30.w = 0.0;
      if ((_mtl_u._IsInForwardRender > 0.0)) {
        half3 tmpvar_35;
        tmpvar_35 = ((_CameraNormalsTexture.sample(_mtlsmp__CameraNormalsTexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0)).xyz * (half)2.0) - (half)1.0);
        vatieuf_30.xyz = float3(tmpvar_35);
      } else {
        if ((_mtl_u._IsInLegacyDeffered > 0.0)) {
          float4 dn_36;
          half4 tmpvar_37;
          tmpvar_37 = _CameraDepthNormalsTexture.sample(_mtlsmp__CameraDepthNormalsTexture, (float2)(_mtl_i.xlv_TEXCOORD0));
          dn_36 = float4(tmpvar_37);
          float3 n_38;
          float3 tmpvar_39;
          tmpvar_39 = ((dn_36.xyz * float3(3.5554, 3.5554, 0.0)) + float3(-1.7777, -1.7777, 1.0));
          float tmpvar_40;
          tmpvar_40 = (2.0 / dot (tmpvar_39, tmpvar_39));
          n_38.xy = (tmpvar_40 * tmpvar_39.xy);
          n_38.z = (tmpvar_40 - 1.0);
          float3x3 tmpvar_41;
          tmpvar_41[0] = _mtl_u._CameraMV[0].xyz;
          tmpvar_41[1] = _mtl_u._CameraMV[1].xyz;
          tmpvar_41[2] = _mtl_u._CameraMV[2].xyz;
          vatieuf_30.xyz = (tmpvar_41 * n_38);
        } else {
          if ((_mtl_u._FullDeferred > 0.0)) {
            half3 tmpvar_42;
            tmpvar_42 = ((_CameraGBufferTexture2.sample(_mtlsmp__CameraGBufferTexture2, (float2)(_mtl_i.xlv_TEXCOORD0)).xyz * (half)2.0) - (half)1.0);
            vatieuf_30.xyz = float3(tmpvar_42);
          };
        };
      };
      float3 tmpvar_43;
      tmpvar_43 = normalize(tmpvar_34.xyz);
      float3 tmpvar_44;
      tmpvar_44 = normalize((_mtl_u._ViewMatrix * vatieuf_30).xyz);
      wqoidf_29.w = 1.0;
      wqoidf_29.xyz = (tmpvar_34.xyz + normalize((tmpvar_43 - 
        (2.0 * (dot (tmpvar_44, tmpvar_43) * tmpvar_44))
      )));
      float4 tmpvar_45;
      tmpvar_45 = (_mtl_u._ProjMatrix * wqoidf_29);
      float3 tmpvar_46;
      tmpvar_46 = normalize(((tmpvar_45.xyz / tmpvar_45.w) - vuy7s_31));
      ssped44s_4.z = tmpvar_46.z;
      ssped44s_4.xy = (tmpvar_46.xy * 0.5);
      xxdkufex_28.xy = _mtl_i.xlv_TEXCOORD0;
      xxdkufex_28.z = vardoifles_11;
      float tmpvar_47;
      tmpvar_47 = (2.0 / _mtl_u._ScreenParams.x);
      float tmpvar_48;
      tmpvar_48 = sqrt(dot (ssped44s_4.xy, ssped44s_4.xy));
      float3 tmpvar_49;
      tmpvar_49 = (ssped44s_4 * ((tmpvar_47 * _mtl_u._stepGlobalScale) / tmpvar_48));
      ooppdsddd_27 = tmpvar_49;
      maxCount_29_25 = int(_mtl_u._maxStep);
      qwweuiidu_23 = bool(0);
      nndndduiefa_26 = (xxdkufex_28 + tmpvar_49);
      i_33_22 = 0;
      s_19 = 0;
      while (true) {
        if ((s_19 >= 120)) {
          break;
        };
        if ((i_33_22 >= maxCount_29_25)) {
          break;
        };
        if ((_mtl_u._IsInForwardRender > 0.0)) {
          half4 tmpvar_50;
          tmpvar_50 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(nndndduiefa_26.xy), level(0.0));
          varyutdffe_21 = (1.0/(((zudifkd_3 * (float)tmpvar_50.x) + dofiemdklsf_2)));
        } else {
          half4 tmpvar_51;
          tmpvar_51 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(nndndduiefa_26.xy), level(0.0));
          varyutdffe_21 = (1.0/(((zudifkd_3 * (float)tmpvar_51.x) + dofiemdklsf_2)));
        };
        float tmpvar_52;
        tmpvar_52 = (1.0/(((zudifkd_3 * nndndduiefa_26.z) + dofiemdklsf_2)));
        if ((varyutdffe_21 < (tmpvar_52 - 1e-06))) {
          oiedofdefe_20.w = 1.0;
          oiedofdefe_20.xyz = nndndduiefa_26;
          cjusduyfeef_24 = oiedofdefe_20;
          qwweuiidu_23 = bool(1);
          break;
        };
        nndndduiefa_26 = (nndndduiefa_26 + ooppdsddd_27);
        i_33_22++;
        s_19++;
      };
      if ((qwweuiidu_23 == bool(0))) {
        float4 efuiydfeef_53;
        efuiydfeef_53.w = 0.0;
        efuiydfeef_53.xyz = nndndduiefa_26;
        cjusduyfeef_24 = efuiydfeef_53;
        qwweuiidu_23 = bool(1);
      };
      lerrre33dcs_5 = cjusduyfeef_24;
      float tmpvar_54;
      tmpvar_54 = abs((cjusduyfeef_24.x - 0.5));
      origtmp_18 = tmpvar_8;
      if ((_mtl_u._FlipReflectionsMSAA > 0.0)) {
        float2 tmpouv_55;
        tmpouv_55.x = _mtl_i.xlv_TEXCOORD0.x;
        tmpouv_55.y = (1.0 - _mtl_i.xlv_TEXCOORD0.y);
        half4 tmpvar_56;
        tmpvar_56 = _MainTex.sample(_mtlsmp__MainTex, (float2)(tmpouv_55), level(0.0));
        float4 tmpvar_57;
        tmpvar_57 = float4(tmpvar_56);
        origtmp_18 = tmpvar_57;
      };
      paAccurateColor_17 = float4(0.0, 0.0, 0.0, 0.0);
      if ((_mtl_u._SSRRcomposeMode > 0.0)) {
        float4 tmpvar_58;
        tmpvar_58.w = 0.0;
        tmpvar_58.xyz = origtmp_18.xyz;
        paAccurateColor_17 = tmpvar_58;
      };
      if ((tmpvar_54 > 0.5)) {
        fasdei434fkkf_6 = paAccurateColor_17;
      } else {
        float tmpvar_59;
        tmpvar_59 = abs((cjusduyfeef_24.y - 0.5));
        if ((tmpvar_59 > 0.5)) {
          fasdei434fkkf_6 = paAccurateColor_17;
        } else {
          if ((((1.0/(
            ((_mtl_u._ZBufferParams.x * cjusduyfeef_24.z) + _mtl_u._ZBufferParams.y)
          )) > _mtl_u._maxDepthCull) && (_mtl_u._skyEnabled < 0.5))) {
            fasdei434fkkf_6 = paAccurateColor_17;
          } else {
            if ((cjusduyfeef_24.z < 0.1)) {
              fasdei434fkkf_6 = paAccurateColor_17;
            } else {
              if ((cjusduyfeef_24.w == 1.0)) {
                int j_60;
                float4 cmcnjkhdwe_61;
                float bbdkjfe_62;
                float3 oldPos_50_63;
                int i_49_64;
                bool iueidkjkjff_65;
                float4 tmpvar_47_66;
                int maxCount_45_67;
                float3 fjeiudiuiuiuse_68;
                float3 samplePos_43_69;
                float3 tmpvar_70;
                tmpvar_70 = (cjusduyfeef_24.xyz - tmpvar_49);
                float3 tmpvar_71;
                tmpvar_71 = (ssped44s_4 * (tmpvar_47 / tmpvar_48));
                fjeiudiuiuiuse_68 = tmpvar_71;
                maxCount_45_67 = int(_mtl_u._maxFineStep);
                iueidkjkjff_65 = bool(0);
                oldPos_50_63 = tmpvar_70;
                samplePos_43_69 = (tmpvar_70 + tmpvar_71);
                i_49_64 = 0;
                j_60 = 0;
                while (true) {
                  if ((j_60 >= 40)) {
                    break;
                  };
                  if ((i_49_64 >= maxCount_45_67)) {
                    break;
                  };
                  if ((_mtl_u._IsInForwardRender > 0.0)) {
                    half4 tmpvar_72;
                    tmpvar_72 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(samplePos_43_69.xy), level(0.0));
                    bbdkjfe_62 = (1.0/(((zudifkd_3 * (float)tmpvar_72.x) + dofiemdklsf_2)));
                  } else {
                    half4 tmpvar_73;
                    tmpvar_73 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(samplePos_43_69.xy), level(0.0));
                    bbdkjfe_62 = (1.0/(((zudifkd_3 * (float)tmpvar_73.x) + dofiemdklsf_2)));
                  };
                  float tmpvar_74;
                  tmpvar_74 = (1.0/(((zudifkd_3 * samplePos_43_69.z) + dofiemdklsf_2)));
                  if ((bbdkjfe_62 < tmpvar_74)) {
                    if (((tmpvar_74 - bbdkjfe_62) < _mtl_u._bias)) {
                      cmcnjkhdwe_61.w = 1.0;
                      cmcnjkhdwe_61.xyz = samplePos_43_69;
                      tmpvar_47_66 = cmcnjkhdwe_61;
                      iueidkjkjff_65 = bool(1);
                      break;
                    };
                    float3 tmpvar_75;
                    tmpvar_75 = (fjeiudiuiuiuse_68 * 0.5);
                    fjeiudiuiuiuse_68 = tmpvar_75;
                    samplePos_43_69 = (oldPos_50_63 + tmpvar_75);
                  } else {
                    oldPos_50_63 = samplePos_43_69;
                    samplePos_43_69 = (samplePos_43_69 + fjeiudiuiuiuse_68);
                  };
                  i_49_64++;
                  j_60++;
                };
                if ((iueidkjkjff_65 == bool(0))) {
                  float4 tmpvar_55_76;
                  tmpvar_55_76.w = 0.0;
                  tmpvar_55_76.xyz = samplePos_43_69;
                  tmpvar_47_66 = tmpvar_55_76;
                  iueidkjkjff_65 = bool(1);
                };
                lerrre33dcs_5 = tmpvar_47_66;
              };
              if ((lerrre33dcs_5.w < 0.01)) {
                fasdei434fkkf_6 = paAccurateColor_17;
              } else {
                float4 tmpvar_57_77;
                if ((_mtl_u._FlipReflectionsMSAA > 0.0)) {
                  lerrre33dcs_5.y = (1.0 - lerrre33dcs_5.y);
                };
                half3 tmpvar_78;
                tmpvar_78 = _MainTex.sample(_mtlsmp__MainTex, (float2)(lerrre33dcs_5.xy), level(0.0)).xyz;
                tmpvar_57_77.xyz = float3(tmpvar_78);
                tmpvar_57_77.w = 1.0;
                fasdei434fkkf_6 = tmpvar_57_77;
              };
            };
          };
        };
      };
    };
  };
  tmpvar_1 = half4(fasdei434fkkf_6);
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