using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public sealed class CacheManager {

	private CacheManager() {
	}

	public static void CachePrefabs(out Queue<GameObject> queue, int collectionSize, GameObject prefab) {
		queue = new Queue<GameObject>(collectionSize);
		for ( int i = 0; i < collectionSize; i++ ) {
			GameObject instantiantedPrefab = (GameObject) MonoBehaviour.Instantiate(prefab);
			instantiantedPrefab.SetActive(false);
			queue.Enqueue(instantiantedPrefab);
		}
	}

	public static GameObject SpawnNewGameObject(Queue<GameObject> queue, Vector3 position, Quaternion rotation) {
		GameObject gameObject = queue.Dequeue();
		ResetGameObjectState(gameObject, position, rotation);
		gameObject.SetActive(true);
		queue.Enqueue(gameObject);
		return gameObject;
	}

	private static void ResetGameObjectState(GameObject gameObject, Vector3 position, Quaternion rotation) {
		gameObject.transform.position = position;
		gameObject.transform.rotation = rotation;

		Rigidbody rigidbody = gameObject.GetComponent<Rigidbody>();
		if ( rigidbody != null ) {
			rigidbody.velocity = Vector3.zero;
			rigidbody.angularVelocity = Vector3.zero;
			rigidbody.Sleep();
		}

		Collider collider = gameObject.GetComponent<Collider>();
		if ( collider != null ) {
			collider.enabled = true;
		}

		MeshRenderer[] meshes = gameObject.GetComponentsInChildren<MeshRenderer>();
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].enabled = true;
		}
	}

}
