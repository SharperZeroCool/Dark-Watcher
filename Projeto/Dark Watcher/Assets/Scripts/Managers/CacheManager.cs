using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class CacheManager {

	public static void CachePrefabs(out Queue<GameObject> queue, int collectionSize, GameObject prefab) {
		queue = new Queue<GameObject>(collectionSize);
		for ( int i = 0; i < collectionSize; i++ ) {
			GameObject instantiantedPrefab = (GameObject) MonoBehaviour.Instantiate(prefab, Vector3.zero, new Quaternion());
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

	public static GameObject SpawnNewGameObject(Queue<GameObject> queue, Vector3 position, Quaternion rotation, int layer) {
		GameObject gameObject = SpawnNewGameObject(queue, position, rotation);
		ChangeLayers(gameObject, layer);
		return gameObject;
	}

	public static GameObject DeSpawnGameObject(GameObject gameObject) {
		gameObject.transform.position = Vector3.zero;

		Rigidbody rigidbody = gameObject.GetComponent<Rigidbody>();
		if ( rigidbody != null ) {
			rigidbody.velocity = Vector3.zero;
			rigidbody.angularVelocity = Vector3.zero;
			rigidbody.useGravity = false;
			rigidbody.isKinematic = true;
		}

		Collider collider = gameObject.GetComponent<Collider>();
		if ( collider != null ) {
			collider.enabled = false;
		}

		Renderer[] meshes = gameObject.GetComponentsInChildren<Renderer>();
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].enabled = false;
		}

		NavMeshAgent agent = gameObject.GetComponent<NavMeshAgent>();
		if ( agent != null ) {
			agent.enabled = false;
		}

		Animator anim = gameObject.GetComponent<Animator>();
		if ( anim != null ) {
			anim.Stop();
			anim.enabled = false;
		}

		MonoBehaviour[] scripts = gameObject.GetComponentsInChildren<MonoBehaviour>();
		for ( int i = 0; i < scripts.Length; i++ ) {
			scripts[i].enabled = false;
		}

		return gameObject;
	}

	public static GameObject DeSpawnGameObject(GameObject gameObject, int layer) {
		gameObject = DeSpawnGameObject(gameObject);
		ChangeLayers(gameObject, layer);
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
			rigidbody.useGravity = true;
			rigidbody.isKinematic = false;
		}

		Collider collider = gameObject.GetComponent<Collider>();
		if ( collider != null ) {
			collider.enabled = true;
		}

		Renderer[] meshes = gameObject.GetComponentsInChildren<Renderer>();
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].enabled = true;
		}

		NavMeshAgent agent = gameObject.GetComponent<NavMeshAgent>();
		if ( agent != null ) {
			agent.enabled = true;
		}

		Animator anim = gameObject.GetComponent<Animator>();
		if ( anim != null ) {
			anim.enabled = true;
		}

		MonoBehaviour[] scripts = gameObject.GetComponentsInChildren<MonoBehaviour>();
		for ( int i = 0; i < scripts.Length; i++ ) {
			scripts[i].enabled = true;
		}

		gameObject.SetActive(true);
	}

	private static void ChangeLayers(GameObject gameObject, int layer) {
		gameObject.layer = layer;
		foreach ( Transform child in gameObject.transform ) {
			ChangeLayers(child.gameObject, layer);
		}
	}

}
