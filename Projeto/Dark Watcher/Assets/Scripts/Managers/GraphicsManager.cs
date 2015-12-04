using UnityEngine;
using System.Collections;

public class GraphicsManager : MonoBehaviour {

	public GameObject[] effectsToDisable;

	void Start () {
		int qualityLevel = QualitySettings.GetQualityLevel();
		if(qualityLevel <= 4) {
			for(int i = 0; i < effectsToDisable.Length; i++ ) {
				effectsToDisable[i].SetActive(false);
			}
		}
	}
	
}
