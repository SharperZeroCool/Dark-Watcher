using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public abstract class AbstractManager : MonoBehaviour {

	public GameObject prefab;

	public int maxNumberOfObjects;

	protected Queue<GameObject> objects;

	private void Start() {
		CacheGameObjects();
		StartCoroutine("ManageSpawn");
	}

	protected abstract IEnumerator ManageSpawn();

	protected abstract void SpawnGameObject();

	protected abstract void CacheGameObjects();

}