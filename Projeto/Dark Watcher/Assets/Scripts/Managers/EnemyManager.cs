using UnityEngine;
using System.Collections;
public class EnemyManager : AbstractManager {

	public Transform player;

	public float intervalSeconds;

	public int percentChance;

	public float startingHealth;

	public float minZ;

	public float maxZ;

	protected override IEnumerator ManageSpawn() {
		while ( true ) {
			int random = Random.Range(0, 100);

			if ( random <= percentChance ) {
				SpawnGameObject();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}
	}

	protected override void SpawnGameObject() {
		float randomPositionZ;
		do {
			randomPositionZ = Random.Range(minZ, maxZ);
		} while ( Mathf.Abs(randomPositionZ - player.position.z) < 80 );

		GameObject gameObject = CacheManager.SpawnNewGameObject(objects, Vector3.forward * randomPositionZ, transform.rotation);
		gameObject.GetComponent<EnemyMovement>().target = player;
		gameObject.GetComponent<EnemyHealth>().startingHealth = startingHealth;
		gameObject.GetComponent<EnemyHealth>().ResetHealth();
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}

}
