using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.Audio;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class PauseManager : MonoBehaviour {
	
	public AudioMixerSnapshot paused;

	public AudioMixerSnapshot unpaused;
	
	private Canvas canvas;

	private RectTransform rectTransform;

	private const float DEFAULT_SCREEN_TO_MENU_RATIO = 0.45f;

	private const int MIN_WIDTH = 365;

	private const int MIN_HEIGHT = 310;

	public void Quit()
	{
		#if UNITY_EDITOR 
		EditorApplication.isPlaying = false;
		#else 
		Application.Quit();
		#endif
	}

	public void Pause()
	{
		Time.timeScale = Time.timeScale == 0 ? 1 : 0;
		Lowpass ();
		
	}
	
	private void Start()
	{

		canvas = GetComponent<Canvas>();

		definePauseMenuResolution ();

		Time.timeScale = 1;

	}

	private void definePauseMenuResolution()
	{

		rectTransform = GameObject.FindGameObjectWithTag ("PausePanel").GetComponent<RectTransform>();
		
		float width = Screen.width * DEFAULT_SCREEN_TO_MENU_RATIO;
		
		float height = Screen.height * DEFAULT_SCREEN_TO_MENU_RATIO;
		
		width = width < MIN_WIDTH ? MIN_WIDTH : width;
		
		height = height < MIN_HEIGHT ? MIN_HEIGHT : height;
		
		rectTransform.sizeDelta = new Vector2(width, height);

	}
	
	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{

			canvas.enabled = !canvas.enabled;

			Cursor.visible = !Cursor.visible;

			if(isPaused())
			{

				Cursor.lockState = CursorLockMode.None;

			}
			else 
			{

				Cursor.lockState = CursorLockMode.Locked;

			}

			Pause();

		}
	}
		
	private void Lowpass()
	{
		if (Time.timeScale == 0)
		{
			paused.TransitionTo(.01f);
		}
		
		else
			
		{
			unpaused.TransitionTo(.01f);
		}
	}

	private bool isPaused()
	{

		return Cursor.visible;

	}

}
