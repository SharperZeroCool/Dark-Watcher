// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

using UnityEngine;

[ExecuteInEditMode] //Make SSRR live-update even when not in play mode
[RequireComponent (typeof(Camera))]
[AddComponentMenu("Image Effects/CandelaSSRR")]
public class CandelaSSRR : MonoBehaviour
{
	//-------Public Parameter-------------
	[HideInInspector]
    [Range(0.1f, 40.0f)]
    public float GlobalScale = 7.5f;
	[HideInInspector]
	[Range(1, 120)]
    public int maxGlobalStep = 85;
	[HideInInspector]
	[Range(1, 40)]
    public int maxFineStep = 12;
	[HideInInspector]
   	[Range(0f, 0.001f)]
	public float bias = 0.0065f;
	[HideInInspector]
	[Range(0.0f, 1.0f)]
    public float fadePower = 0.0f;
	[HideInInspector]
	[Range(1.0f, 10.0f)]
	public float fresfade = 7.9f;
	[HideInInspector]
	[Range(0.001f, 1.5f)]
	public float fresrange = 0.38f;
	[HideInInspector]
    [Range(0f, 1f)]
    public float maxDepthCull = 1.0f;
	[HideInInspector]
   	[Range(0f, 1f)]
    public float reflectionMultiply = 1.0f;
	[HideInInspector]
	[Range(0.0f, 10f)]
	public float GlobalBlurRadius = 0.8f;
	[HideInInspector]
	[Range(0.0f, 8f)]
	public float DistanceBlurRadius   = 0.8f;
	[HideInInspector]
	[Range(0.0f, 10f)]
	public float DistanceBlurStart    = 3.5f;
	[HideInInspector]
	[Range(0.0f, 1.0f)]
	public float GrazeBlurPower       = 0.0f;
	[HideInInspector]
	public bool BlurQualityHigh 	  = true;
	[HideInInspector]
	[Range(1, 5)]
    public int HQ_BlurIterations = 2;
	[HideInInspector]
	public float HQ_DepthSensetivity   = 1.15f;
	[HideInInspector]
	public float HQ_NormalsSensetivity = 1.07f;
	//[HideInInspector]
	//public bool ResolutionOptimized = false;
	//ScreenFade Related Controls
	[HideInInspector] public float DebugScreenFade = 0.0f;
	[Range(0.0f, 10.0f)]
	[HideInInspector] public float ScreenFadePower  = 9.47f;
	[Range(0.0f, 3.0f)]
	[HideInInspector] public float ScreenFadeSpread = 0.0f;
	[Range(0.0f, 4.0f)]
	[HideInInspector] public float ScreenFadeEdge   = 0.03f;
	[HideInInspector] public float UseEdgeTexture = 0.0f;
	[HideInInspector] public Texture2D EdgeFadeTexture;
	[HideInInspector] public float SSRRcomposeMode = 1.0f;
	[HideInInspector] public bool HDRreflections = true;
	[HideInInspector] public bool UseCustomDepth = false;
	[HideInInspector] public bool InvertRoughness = false;
	
	//[HideInInspector] public float FlipReflectionsForMSAA = 0.0f;
	[HideInInspector] public bool UseLayerMask = false;
	public LayerMask cullingmask = 0;
	[HideInInspector] public bool renderCustomColorMap = false;
	[HideInInspector] public float alphaBiasControlSSRR = 1.0f;
	[HideInInspector] public bool enableSkyReflections = true;

	[HideInInspector] public int convolutionMode = 2;
	[HideInInspector] public float convolutionSamples = 8.0f;


	[HideInInspector] public int qualityWidth  = 1024;
	[HideInInspector] public int qualityHeight = 512;
	[HideInInspector] public int qualityIndex  = 1;

	[HideInInspector]
	public Camera attachedCamera;

	//------Internal Use-------------------
	private Shader   CustomDepth_SHADER;
	private Shader   CustomNormal_SHADER;
	private Camera   RTcustom_CAMERA; 
	private Material SSRR_MATERIAL;
	private Material LUMACOMP_MAT;
	private RenderTexture reflectionTexture;
	private RenderTexture afterLumaCompRT;
	private Material POST_COMPOSE_MATERIAL;
	private static void DestroyMaterial (Material mat)
	{
		if (mat)
		{
			DestroyImmediate (mat);
			mat = null;
		}
	}
	
	void Awake()
	{
		CustomDepth_SHADER 	  = Shader.Find("Hidden/CustomDepthSSRR");
		CustomNormal_SHADER   = Shader.Find("Hidden/CandelaWorldNormal");


	}

	void OnEnable () 
	{
			
		if(!RTcustom_CAMERA)
		{

		
		//Render Cam
		GameObject go = new GameObject ("RenderCamPos", typeof(Camera));
    	go.hideFlags  = HideFlags.HideAndDontSave;
   		RTcustom_CAMERA      = go.GetComponent<Camera>();
		RTcustom_CAMERA.CopyFrom(this.GetComponent<Camera>());
	   	RTcustom_CAMERA.clearFlags = CameraClearFlags.Color;
		RTcustom_CAMERA.renderingPath = RenderingPath.Forward;
		RTcustom_CAMERA.backgroundColor = new Color(0,0,0,0);
		RTcustom_CAMERA.enabled = false;
					
		}
		
		//Create The Materials Required
		SSRR_MATERIAL 		    = new Material(Shader.Find("Hidden/CandelaSSRRv2"));
		SSRR_MATERIAL.hideFlags = HideFlags.HideAndDontSave;
		POST_COMPOSE_MATERIAL   = new Material(Shader.Find("Hidden/CandelaCompose"));
		POST_COMPOSE_MATERIAL.hideFlags = HideFlags.HideAndDontSave;

		LUMACOMP_MAT = new Material(Shader.Find("Hidden/LumaComp"));
		LUMACOMP_MAT.hideFlags = HideFlags.HideAndDontSave;

	}
		
	void OnPreRender()
	{


		if( (this.GetComponent<Camera>().renderingPath == RenderingPath.DeferredLighting))
		{
		attachedCamera = this.GetComponent<Camera>();
		attachedCamera.depthTextureMode |= DepthTextureMode.Depth;
		attachedCamera.depthTextureMode |= DepthTextureMode.DepthNormals;
		
		}

		if(RTcustom_CAMERA)
		{
		RTcustom_CAMERA.CopyFrom(this.GetComponent<Camera>());
		RTcustom_CAMERA.renderingPath = RenderingPath.Forward;
		RTcustom_CAMERA.clearFlags = CameraClearFlags.Color;
		
		if( (this.GetComponent<Camera>().renderingPath == RenderingPath.Forward))
		{

				attachedCamera = this.GetComponent<Camera>();
				attachedCamera.depthTextureMode |= DepthTextureMode.Depth;
				attachedCamera.depthTextureMode |= DepthTextureMode.DepthNormals;

		RTcustom_CAMERA.backgroundColor = new Color(1,1,1,1);
		RenderTexture camRT = RenderTexture.GetTemporary(Screen.width,Screen.height, 24, RenderTextureFormat.RFloat);
						
		camRT.filterMode = FilterMode.Point;
		RTcustom_CAMERA.targetTexture = camRT;
        RTcustom_CAMERA.RenderWithShader(CustomDepth_SHADER,"");
		camRT.SetGlobalShaderProperty("_depthTexCustom");
		RenderTexture.ReleaseTemporary (camRT);
		
		
		RTcustom_CAMERA.backgroundColor = new Color(0,0,0,0);
		RenderTexture camRT2 = RenderTexture.GetTemporary(Screen.width,Screen.height, 24, RenderTextureFormat.ARGBFloat);
		RTcustom_CAMERA.targetTexture = camRT2;
		RTcustom_CAMERA.RenderWithShader(CustomNormal_SHADER,"");
		camRT2.SetGlobalShaderProperty("_CameraNormalsTexture");
		RenderTexture.ReleaseTemporary (camRT2);
			
		
		}

		}
			
	}
	
	
	void OnDisable ()
    {
   	DestroyImmediate (RTcustom_CAMERA);
	DestroyMaterial(SSRR_MATERIAL);
	DestroyMaterial(POST_COMPOSE_MATERIAL);
	DestroyMaterial(LUMACOMP_MAT);

	DestroyImmediate(reflectionTexture);       	   reflectionTexture        		= null;
	DestroyImmediate(afterLumaCompRT);         	   afterLumaCompRT        			= null;
	}
		
	[ImageEffectOpaque]
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		//DO SSRR RENDERING
		int sWidth  = qualityWidth;
		int sHeight = qualityHeight;
	
		//HDRreflections
		RenderTextureFormat tmpFormat = RenderTextureFormat.ARGB32;
		if(HDRreflections) tmpFormat  = RenderTextureFormat.ARGBHalf;


		if (((reflectionTexture == null) || (reflectionTexture.width != sWidth)) || (reflectionTexture.height != sHeight))
		{
			DestroyImmediate(reflectionTexture);
			reflectionTexture = new RenderTexture(sWidth, sHeight, 0, tmpFormat);
			reflectionTexture.hideFlags  = HideFlags.HideAndDontSave;
			//reflectionTexture.wrapMode   = TextureWrapMode.Clamp;
			reflectionTexture.isPowerOfTwo = true;
			reflectionTexture.useMipMap = true;
			reflectionTexture.generateMips = true;
			reflectionTexture.filterMode = FilterMode.Trilinear;
		}

		if (((afterLumaCompRT == null) || (afterLumaCompRT.width != sWidth)) || (afterLumaCompRT.height != sHeight))
		{
			DestroyImmediate(afterLumaCompRT);
			afterLumaCompRT = new RenderTexture(sWidth, sHeight, 0, tmpFormat);
			afterLumaCompRT.hideFlags  = HideFlags.HideAndDontSave;
			//afterLumaCompRT.wrapMode   = TextureWrapMode.Clamp;
			afterLumaCompRT.isPowerOfTwo = true;
			afterLumaCompRT.useMipMap = true;
			afterLumaCompRT.generateMips = true;
			afterLumaCompRT.filterMode = FilterMode.Trilinear;
		}

		POST_COMPOSE_MATERIAL.SetFloat("_swidth", (float)sWidth);

		//SSRR RELATED PARAMETERS
		SSRR_MATERIAL.SetFloat("_stepGlobalScale", this.GlobalScale);
   		SSRR_MATERIAL.SetFloat("_bias", this.bias);
		SSRR_MATERIAL.SetFloat("_maxStep", (float) this.maxGlobalStep);
        SSRR_MATERIAL.SetFloat("_maxFineStep", (float) this.maxFineStep);
        SSRR_MATERIAL.SetFloat("_maxDepthCull", this.maxDepthCull);
        SSRR_MATERIAL.SetFloat("_fadePower", (float) this.fadePower);
		POST_COMPOSE_MATERIAL.SetFloat("_fadePower", (float) this.fadePower);
		POST_COMPOSE_MATERIAL.SetFloat("_fresfade", (float) this.fresfade);
		POST_COMPOSE_MATERIAL.SetFloat("_fresrange", (float) this.fresrange);

		Matrix4x4 P  = this.GetComponent<Camera>().projectionMatrix;
	    bool d3d = SystemInfo.graphicsDeviceVersion.IndexOf("Direct3D") > -1;
        if (d3d) {
              for (int i = 0; i < 4; i++) {
                P[2,i] = P[2,i]*0.5f + P[3,i]*0.5f;
            }
        }
		
		Matrix4x4 viewProjInverse = (P * this.GetComponent<Camera>().worldToCameraMatrix).inverse;
        Shader.SetGlobalMatrix("_ViewProjectInverse", viewProjInverse);
		Shader.SetGlobalFloat("_DistanceBlurRadius", DistanceBlurRadius);
		Shader.SetGlobalFloat("_GrazeBlurPower", 	 GrazeBlurPower);
		Shader.SetGlobalFloat("_DistanceBlurStart", DistanceBlurStart);
		Shader.SetGlobalFloat("_SSRRcomposeMode", SSRRcomposeMode);



		Shader.SetGlobalFloat("_FlipReflectionsMSAA", ( (QualitySettings.antiAliasing > 0 && GetComponent<Camera>().renderingPath == RenderingPath.Forward) ? 1.0f : 0.0f) );
		
		SSRR_MATERIAL.SetMatrix("_ProjMatrix", P);
		SSRR_MATERIAL.SetMatrix("_ProjectionInv", P.inverse);
	   	SSRR_MATERIAL.SetMatrix("_ViewMatrix",this.GetComponent<Camera>().worldToCameraMatrix.inverse.transpose);
		SSRR_MATERIAL.SetMatrix("_CameraMV",this.GetComponent<Camera>().cameraToWorldMatrix);
		POST_COMPOSE_MATERIAL.SetMatrix("_CameraMV",this.GetComponent<Camera>().cameraToWorldMatrix);
		POST_COMPOSE_MATERIAL.SetMatrix("_ViewProjectInverse", viewProjInverse );

		float skyenabled = 0.0f;
		if(enableSkyReflections) skyenabled = 1.0f;
		SSRR_MATERIAL.SetFloat("_skyEnabled", skyenabled);
	
		POST_COMPOSE_MATERIAL.SetVector ("_ScreenFadeControls",new Vector4 (DebugScreenFade, ScreenFadePower, ScreenFadeSpread, ScreenFadeEdge));
		POST_COMPOSE_MATERIAL.SetFloat("_UseEdgeTexture",UseEdgeTexture);
		POST_COMPOSE_MATERIAL.SetTexture("_EdgeFadeTexture",EdgeFadeTexture);
		POST_COMPOSE_MATERIAL.SetFloat("_reflectionMultiply", this.reflectionMultiply);
		POST_COMPOSE_MATERIAL.SetFloat("_convolutionSamples", convolutionSamples);

		float renderPathForward = 0.0f;
		float legacyDeferred 	= 0.0f;
		float FullDeferred 		= 0.0f;

		if(this.GetComponent<Camera>().renderingPath == RenderingPath.Forward) renderPathForward = 1.0f;
		POST_COMPOSE_MATERIAL.SetFloat("_IsInForwardRender", renderPathForward);
		SSRR_MATERIAL.SetFloat("_IsInForwardRender", renderPathForward);

		if(this.GetComponent<Camera>().renderingPath == RenderingPath.DeferredLighting) legacyDeferred = 1.0f;
		POST_COMPOSE_MATERIAL.SetFloat("_IsInLegacyDeffered", legacyDeferred);
		SSRR_MATERIAL.SetFloat("_IsInLegacyDeffered", legacyDeferred);
	
		if(this.GetComponent<Camera>().renderingPath == RenderingPath.DeferredShading) FullDeferred = 1.0f;
		POST_COMPOSE_MATERIAL.SetFloat("_FullDeferred", FullDeferred);
		SSRR_MATERIAL.SetFloat("_FullDeferred", FullDeferred);
	

		Graphics.Blit(source, reflectionTexture, SSRR_MATERIAL,0);

		Graphics.Blit(reflectionTexture, afterLumaCompRT, LUMACOMP_MAT);

		POST_COMPOSE_MATERIAL.SetTexture("_SSRtexture", afterLumaCompRT);



		Graphics.Blit(source , destination, POST_COMPOSE_MATERIAL);
		

	}
}
