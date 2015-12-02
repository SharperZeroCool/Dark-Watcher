using UnityEngine;
using System.Collections;

public class Arrow : MonoBehaviour {

	public GameObject core;

	public Transform target;

	public GameObject explosionEffect;

	public float arcHeight = 30f;

	public float duration = 5f;

	public float attackDamage = 2f;

	private MeshExploder[] meshExploders;

	private float speed;

	private void Start() {
		meshExploders = GetComponentsInChildren<MeshExploder>();
		GetComponent<Rigidbody>().velocity = ArcVelocity();
	}

	private void Update() {
		Vector3 targetDir = target.position - transform.position;
		float step = speed * Time.deltaTime;
		Vector3 newDir = Vector3.RotateTowards(transform.forward, targetDir, step, 0.0F);
		Debug.DrawRay(transform.position, newDir, Color.red);
		transform.rotation = Quaternion.LookRotation(newDir);
	}

	private Vector3 ArcVelocity() {
		Vector3 direction = GetRandomDirection();
		float height = direction.y;
		direction.y = 0;
		float distance = direction.magnitude;
		direction.y = distance;
		distance += height;
		speed = Mathf.Sqrt(distance * Physics.gravity.magnitude);
		return speed * direction.normalized;
	}

	private Vector3 GetRandomDirection() {
		Vector3 randomness = Vector3.right * Random.Range(-1f, 1f) + Vector3.forward * Random.Range(-2f, 2f) + Vector3.up * Random.Range(0f, 3f);
		return target.position + randomness - transform.position;
	}

	private void OnCollisionEnter(Collision collision) {
		if ( collision.gameObject.tag == "Player" ) {
			collision.gameObject.GetComponent<PlayerHealth>().TakeDamage(attackDamage, false);
		} else if ( collision.transform.gameObject.tag == "Player2" ) {
			collision.transform.gameObject.GetComponent<Player2Health>().TakeDamage(attackDamage, false);
		}

		explosionEffect.SetActive(true);
		for ( int i = 0; i < meshExploders.Length; i++ ) {
			meshExploders[i].Explode();
			meshExploders[i].gameObject.SetActive(false);
		}
		CacheManager.DeSpawnGameObject(gameObject, LayerMask.NameToLayer("DestroyedArrow"));
	}
}
