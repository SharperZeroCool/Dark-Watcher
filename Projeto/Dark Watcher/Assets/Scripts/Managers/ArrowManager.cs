using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ArrowManager : MonoBehaviour {

	public GameObject prefab;

	public int maxNumberOfObjects;

	protected Queue<GameObject> objects;

	public static ArrowManager instance;

	private void Start() {
		if ( instance == null ) {
			instance = this;

		} else if ( instance != this ) {
			Destroy(gameObject);

		}

		DontDestroyOnLoad(gameObject);
		CacheGameObjects();
	}

	public GameObject SpawnObjectAt(Vector3 spawnLocation, Quaternion spawnRotation) {
		GameObject gameObject = CacheManager.SpawnNewGameObject(objects, spawnLocation, spawnRotation, LayerMask.NameToLayer("Arrow"));
		ChangeLayers(gameObject, LayerMask.NameToLayer("Arrow"));
		return gameObject;
	}

	public static void ChangeLayers(GameObject go, int layer) {
		go.layer = layer;
		foreach ( Transform child in go.transform ) {
			ChangeLayers(child.gameObject, layer);
		}
	}

	private void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}
}
