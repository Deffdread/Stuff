using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadTitle : MonoBehaviour
{
	// Use this for initialization
	void Start () {
		GetComponents<AudioSource>()[0].Play();
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			SceneManager.LoadScene("Title");
		}
	}
}
