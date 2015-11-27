// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/LumaComp" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 4 math
 //        d3d9 : 5 math
 //       gles3 : 41 math, 10 texture, 1 branch
 //       metal : 3 math
 //      opengl : 39 math, 10 texture, 1 branch
 // Stats for Fragment shader:
 //       d3d11 : 30 math, 9 texture
 //        d3d9 : 29 math, 9 texture
 //       metal : 41 math, 10 texture, 1 branch
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 26635
Program "vp" {
SubProgram "opengl " {
// Stats: 39 math, 10 textures, 1 branches
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
uniform sampler2D _MainTex;
uniform vec4 _MainTex_TexelSize;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  float lumadiff_1;
  vec2 tmpvar_2;
  tmpvar_2 = _MainTex_TexelSize.xy;
  vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  float cse_4;
  cse_4 = -(_MainTex_TexelSize.y);
  tmpvar_3.y = cse_4;
  vec2 tmpvar_5;
  float cse_6;
  cse_6 = -(_MainTex_TexelSize.x);
  tmpvar_5.x = cse_6;
  tmpvar_5.y = tmpvar_2.y;
  vec2 tmpvar_7;
  tmpvar_7.y = 0.0;
  tmpvar_7.x = cse_6;
  vec2 tmpvar_8;
  tmpvar_8.y = 0.0;
  tmpvar_8.x = tmpvar_2.x;
  vec2 tmpvar_9;
  tmpvar_9.x = 0.0;
  tmpvar_9.y = cse_4;
  vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = tmpvar_2.y;
  float tmpvar_11;
  tmpvar_11 = clamp (((
    dot (texture2D (_MainTex, xlv_TEXCOORD0), vec4(0.299, 0.587, 0.114, 0.0))
   / 1.5) - (
    ((((
      (((dot (texture2D (_MainTex, 
        (xlv_TEXCOORD0 - _MainTex_TexelSize.xy)
      ), vec4(0.299, 0.587, 0.114, 0.0)) + dot (texture2D (_MainTex, 
        (xlv_TEXCOORD0 + tmpvar_3)
      ), vec4(0.299, 0.587, 0.114, 0.0))) + dot (texture2D (_MainTex, (xlv_TEXCOORD0 + tmpvar_5)), vec4(0.299, 0.587, 0.114, 0.0))) + dot (texture2D (_MainTex, (xlv_TEXCOORD0 + _MainTex_TexelSize.xy)), vec4(0.299, 0.587, 0.114, 0.0)))
     + 
      dot (texture2D (_MainTex, (xlv_TEXCOORD0 + tmpvar_7)), vec4(0.299, 0.587, 0.114, 0.0))
    ) + dot (texture2D (_MainTex, 
      (xlv_TEXCOORD0 + tmpvar_8)
    ), vec4(0.299, 0.587, 0.114, 0.0))) + dot (texture2D (_MainTex, (xlv_TEXCOORD0 + tmpvar_9)), vec4(0.299, 0.587, 0.114, 0.0))) + dot (texture2D (_MainTex, (xlv_TEXCOORD0 + tmpvar_10)), vec4(0.299, 0.587, 0.114, 0.0)))
   / 8.0)), 0.0, 1.0);
  lumadiff_1 = tmpvar_11;
  if ((tmpvar_11 > 1.0)) {
    lumadiff_1 = 0.0;
  };
  gl_FragData[0] = (texture2D (_MainTex, xlv_TEXCOORD0) * pow ((1.0 - lumadiff_1), 12.0));
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
// Stats: 41 math, 10 textures, 1 branches
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
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_TexelSize;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 final_1;
  mediump float tmpvar_2;
  highp float lumadiff_3;
  highp float centretap_4;
  highp float luma1_5;
  mediump vec2 offset8_6;
  mediump vec2 offset7_7;
  mediump vec2 offset6_8;
  mediump vec2 offset5_9;
  mediump vec2 offset4_10;
  mediump vec2 offset3_11;
  mediump vec2 offset2_12;
  mediump vec2 offset1_13;
  mediump vec2 offset0_14;
  mediump vec2 texel_15;
  highp vec2 tmpvar_16;
  tmpvar_16 = _MainTex_TexelSize.xy;
  texel_15 = tmpvar_16;
  offset0_14 = xlv_TEXCOORD0;
  highp vec2 tmpvar_17;
  tmpvar_17 = (xlv_TEXCOORD0 - texel_15);
  offset1_13 = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = texel_15.x;
  tmpvar_18.y = -(texel_15.y);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0 + tmpvar_18);
  offset2_12 = tmpvar_19;
  mediump vec2 tmpvar_20;
  tmpvar_20.x = -(texel_15.x);
  tmpvar_20.y = texel_15.y;
  highp vec2 tmpvar_21;
  tmpvar_21 = (xlv_TEXCOORD0 + tmpvar_20);
  offset3_11 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (xlv_TEXCOORD0 + texel_15);
  offset4_10 = tmpvar_22;
  mediump vec2 tmpvar_23;
  tmpvar_23.y = 0.0;
  tmpvar_23.x = -(texel_15.x);
  highp vec2 tmpvar_24;
  tmpvar_24 = (xlv_TEXCOORD0 + tmpvar_23);
  offset5_9 = tmpvar_24;
  mediump vec2 tmpvar_25;
  tmpvar_25.y = 0.0;
  tmpvar_25.x = texel_15.x;
  highp vec2 tmpvar_26;
  tmpvar_26 = (xlv_TEXCOORD0 + tmpvar_25);
  offset6_8 = tmpvar_26;
  mediump vec2 tmpvar_27;
  tmpvar_27.x = 0.0;
  tmpvar_27.y = -(texel_15.y);
  highp vec2 tmpvar_28;
  tmpvar_28 = (xlv_TEXCOORD0 + tmpvar_27);
  offset7_7 = tmpvar_28;
  mediump vec2 tmpvar_29;
  tmpvar_29.x = 0.0;
  tmpvar_29.y = texel_15.y;
  highp vec2 tmpvar_30;
  tmpvar_30 = (xlv_TEXCOORD0 + tmpvar_29);
  offset8_6 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture (_MainTex, offset1_13);
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.299, 0.587, 0.114, 0.0));
  luma1_5 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_MainTex, offset2_12);
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture (_MainTex, offset3_11);
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture (_MainTex, offset4_10);
  mediump float tmpvar_38;
  tmpvar_38 = dot (tmpvar_37, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_MainTex, offset5_9);
  mediump float tmpvar_40;
  tmpvar_40 = dot (tmpvar_39, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture (_MainTex, offset6_8);
  mediump float tmpvar_42;
  tmpvar_42 = dot (tmpvar_41, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture (_MainTex, offset7_7);
  mediump float tmpvar_44;
  tmpvar_44 = dot (tmpvar_43, vec4(0.299, 0.587, 0.114, 0.0));
  lowp vec4 tmpvar_45;
  tmpvar_45 = texture (_MainTex, offset8_6);
  mediump float tmpvar_46;
  tmpvar_46 = dot (tmpvar_45, vec4(0.299, 0.587, 0.114, 0.0));
  highp float tmpvar_47;
  tmpvar_47 = (((
    ((((luma1_5 + tmpvar_34) + tmpvar_36) + tmpvar_38) + tmpvar_40)
   + tmpvar_42) + tmpvar_44) + tmpvar_46);
  luma1_5 = tmpvar_47;
  lowp vec4 tmpvar_48;
  tmpvar_48 = texture (_MainTex, offset0_14);
  mediump float tmpvar_49;
  tmpvar_49 = (dot (tmpvar_48, vec4(0.299, 0.587, 0.114, 0.0)) / 1.5);
  centretap_4 = tmpvar_49;
  highp float tmpvar_50;
  tmpvar_50 = clamp ((centretap_4 - (tmpvar_47 / 8.0)), 0.0, 1.0);
  lumadiff_3 = tmpvar_50;
  if ((tmpvar_50 > 1.0)) {
    lumadiff_3 = 0.0;
  };
  tmpvar_2 = lumadiff_3;
  lowp vec4 tmpvar_51;
  tmpvar_51 = texture (_MainTex, xlv_TEXCOORD0);
  final_1 = tmpvar_51;
  _glesFragData[0] = (final_1 * pow ((1.0 - tmpvar_2), 12.0));
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
// Stats: 29 math, 9 textures
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
def c1, 0.298999995, 0.587000012, 0.114, 0.666666687
def c2, 1, -1, 0, 0.125
def c3, 12, 0, 0, 0
dcl_texcoord v0.xy
dcl_2d s0
add_pp r0.xy, -c0, v0
texld r0, r0, s0
dp3 r0.x, r0, c1
mov r1.xy, c0
mad_pp r2, r1.xyxy, c2.xyyx, v0.xyxy
texld r3, r2, s0
texld r2, r2.zwzw, s0
dp3 r0.y, r2, c1
dp3 r0.z, r3, c1
add r0.x, r0.z, r0.x
add r0.x, r0.y, r0.x
add_pp r0.yz, c0.xxyw, v0.xxyw
texld r2, r0.yzzw, s0
dp3 r0.y, r2, c1
add r0.x, r0.y, r0.x
mad_pp r2, r1.x, c2.yzxz, v0.xyxy
texld r3, r2, s0
texld r2, r2.zwzw, s0
dp3 r0.y, r2, c1
dp3 r0.z, r3, c1
add r0.x, r0.z, r0.x
add r0.x, r0.y, r0.x
mad_pp r1, r1.xyxy, c2.zyzx, v0.xyxy
texld r2, r1, s0
texld r1, r1.zwzw, s0
dp3 r0.y, r1, c1
dp3 r0.z, r2, c1
add r0.x, r0.z, r0.x
add r0.x, r0.y, r0.x
mul r0.x, r0.x, c2.w
texld r1, v0, s0
dp3 r0.y, r1, c1
mad_sat_pp r0.x, r0.y, c1.w, -r0.x
add_pp r0.x, -r0.x, c2.x
pow_pp r2.x, r0.x, c3.x
mul_pp oC0, r1, r2.x

"
}
SubProgram "d3d11 " {
// Stats: 30 math, 9 textures
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 112
Vector 96 [_MainTex_TexelSize]
BindCB  "$Globals" 0
"ps_4_0
eefiecedicgfpnaiinakgeinckjbmefkhbceeohnabaaaaaakeagaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoeafaaaa
eaaaaaaahjabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaadgaaaaahhcaabaaaaaaaaaaa
egiacaiaebaaaaaaaaaaaaaaagaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegbebaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaaaaaaaaaogakbaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
ihbgjjdokcefbgdpnfhiojdnaaaaaaaabaaaaaakccaabaaaaaaaaaaaegacbaaa
abaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaadcaaaaanpcaabaaa
abaaaaaaegiecaaaaaaaaaaaagaaaaaaaceaaaaaaaaaiadpaaaaialpaaaaialp
aaaaiadpegbebaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogakbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaabaaaaaakecaabaaaaaaaaaaa
egacbaaaabaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaabaaaaaak
icaabaaaaaaaaaaaegacbaaaacaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdn
aaaaaaaaaaaaaaahccaabaaaaaaaaaaadkaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaai
mcaabaaaaaaaaaaaagbebaaaabaaaaaaagiecaaaaaaaaaaaagaaaaaaefaaaaaj
pcaabaaaabaaaaaaogakbaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
baaaaaakecaabaaaaaaaaaaaegacbaaaabaaaaaaaceaaaaaihbgjjdokcefbgdp
nfhiojdnaaaaaaaaaaaaaaahccaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
dgaaaaagbcaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadgaaaaaigcaabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaahicaabaaa
abaaaaaabkiacaiaebaaaaaaaaaaaaaaagaaaaaaaaaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaaegbebaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogakbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaabaaaaaakccaabaaa
aaaaaaaaegacbaaaabaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaa
baaaaaakecaabaaaaaaaaaaaegacbaaaacaaaaaaaceaaaaaihbgjjdokcefbgdp
nfhiojdnaaaaaaaaaaaaaaahbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
dgaaaaafbcaabaaaabaaaaaaabeaaaaaaaaaaaaadgaaaaagccaabaaaabaaaaaa
bkiacaaaaaaaaaaaagaaaaaaaaaaaaahgcaabaaaaaaaaaaaagabbaaaabaaaaaa
agbbbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaajgafbaaaaaaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaabaaaaaakccaabaaaaaaaaaaaegacbaaaabaaaaaa
aceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaaaaaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadoefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaabaaaaaakccaabaaaaaaaaaaaegacbaaa
abaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaadccaaaakbcaabaaa
aaaaaaaabkaabaaaaaaaaaaaabeaaaaaklkkckdpakaabaiaebaaaaaaaaaaaaaa
aaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaeaebbjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaab"
}
SubProgram "gles3 " {
"!!GLES3"
}
SubProgram "metal " {
// Stats: 41 math, 10 textures, 1 branches
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 16
Vector 0 [_MainTex_TexelSize]
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
  float4 _MainTex_TexelSize;
};
fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<half> _MainTex [[texture(0)]], sampler _mtlsmp__MainTex [[sampler(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  half4 final_1;
  half tmpvar_2;
  float lumadiff_3;
  float centretap_4;
  float luma1_5;
  half2 offset8_6;
  half2 offset7_7;
  half2 offset6_8;
  half2 offset5_9;
  half2 offset4_10;
  half2 offset3_11;
  half2 offset2_12;
  half2 offset1_13;
  half2 offset0_14;
  half2 texel_15;
  float2 tmpvar_16;
  tmpvar_16 = _mtl_u._MainTex_TexelSize.xy;
  texel_15 = half2(tmpvar_16);
  offset0_14 = half2(_mtl_i.xlv_TEXCOORD0);
  float2 tmpvar_17;
  tmpvar_17 = (_mtl_i.xlv_TEXCOORD0 - (float2)texel_15);
  offset1_13 = half2(tmpvar_17);
  half2 tmpvar_18;
  tmpvar_18.x = texel_15.x;
  tmpvar_18.y = -(texel_15.y);
  float2 tmpvar_19;
  tmpvar_19 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_18);
  offset2_12 = half2(tmpvar_19);
  half2 tmpvar_20;
  tmpvar_20.x = -(texel_15.x);
  tmpvar_20.y = texel_15.y;
  float2 tmpvar_21;
  tmpvar_21 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_20);
  offset3_11 = half2(tmpvar_21);
  float2 tmpvar_22;
  tmpvar_22 = (_mtl_i.xlv_TEXCOORD0 + (float2)texel_15);
  offset4_10 = half2(tmpvar_22);
  half2 tmpvar_23;
  tmpvar_23.y = half(0.0);
  tmpvar_23.x = -(texel_15.x);
  float2 tmpvar_24;
  tmpvar_24 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_23);
  offset5_9 = half2(tmpvar_24);
  half2 tmpvar_25;
  tmpvar_25.y = half(0.0);
  tmpvar_25.x = texel_15.x;
  float2 tmpvar_26;
  tmpvar_26 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_25);
  offset6_8 = half2(tmpvar_26);
  half2 tmpvar_27;
  tmpvar_27.x = half(0.0);
  tmpvar_27.y = -(texel_15.y);
  float2 tmpvar_28;
  tmpvar_28 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_27);
  offset7_7 = half2(tmpvar_28);
  half2 tmpvar_29;
  tmpvar_29.x = half(0.0);
  tmpvar_29.y = texel_15.y;
  float2 tmpvar_30;
  tmpvar_30 = (_mtl_i.xlv_TEXCOORD0 + (float2)tmpvar_29);
  offset8_6 = half2(tmpvar_30);
  half4 tmpvar_31;
  tmpvar_31 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset1_13));
  half tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, (half4)float4(0.299, 0.587, 0.114, 0.0));
  luma1_5 = float(tmpvar_32);
  half4 tmpvar_33;
  tmpvar_33 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset2_12));
  half tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_35;
  tmpvar_35 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset3_11));
  half tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_37;
  tmpvar_37 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset4_10));
  half tmpvar_38;
  tmpvar_38 = dot (tmpvar_37, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_39;
  tmpvar_39 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset5_9));
  half tmpvar_40;
  tmpvar_40 = dot (tmpvar_39, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_41;
  tmpvar_41 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset6_8));
  half tmpvar_42;
  tmpvar_42 = dot (tmpvar_41, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_43;
  tmpvar_43 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset7_7));
  half tmpvar_44;
  tmpvar_44 = dot (tmpvar_43, (half4)float4(0.299, 0.587, 0.114, 0.0));
  half4 tmpvar_45;
  tmpvar_45 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset8_6));
  half tmpvar_46;
  tmpvar_46 = dot (tmpvar_45, (half4)float4(0.299, 0.587, 0.114, 0.0));
  float tmpvar_47;
  tmpvar_47 = (((
    ((((luma1_5 + (float)tmpvar_34) + (float)tmpvar_36) + (float)tmpvar_38) + (float)tmpvar_40)
   + (float)tmpvar_42) + (float)tmpvar_44) + (float)tmpvar_46);
  luma1_5 = tmpvar_47;
  half4 tmpvar_48;
  tmpvar_48 = _MainTex.sample(_mtlsmp__MainTex, (float2)(offset0_14));
  half tmpvar_49;
  tmpvar_49 = (dot (tmpvar_48, (half4)float4(0.299, 0.587, 0.114, 0.0)) / (half)1.5);
  centretap_4 = float(tmpvar_49);
  float tmpvar_50;
  tmpvar_50 = clamp ((centretap_4 - (tmpvar_47 / 8.0)), 0.0, 1.0);
  lumadiff_3 = tmpvar_50;
  if ((tmpvar_50 > 1.0)) {
    lumadiff_3 = 0.0;
  };
  tmpvar_2 = half(lumadiff_3);
  half4 tmpvar_51;
  tmpvar_51 = _MainTex.sample(_mtlsmp__MainTex, (float2)(_mtl_i.xlv_TEXCOORD0));
  final_1 = tmpvar_51;
  _mtl_o._glesFragData_0 = (final_1 * pow (((half)1.0 - tmpvar_2), (half)12.0));
  return _mtl_o;
}

"
}
}
 }
}
Fallback Off
}