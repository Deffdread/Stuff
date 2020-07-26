using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.Characters.FirstPerson;
using UnityEngine.SceneManagement;


public class DeSpawnOnHeight : MonoBehaviour
{   

    private bool gameOver = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {   
        if(transform.position.y < 0 && gameOver == false){

            Debug.Log("Game Over");
            gameOver = true;

            Destroy(GameObject.Find("WhisperSource"));
            //GameObject.Find("WhisperSource").GetComponent<AudioSource>();

            MazeCounter.count = 1;
            
            SceneManager.LoadScene("GameOver");
        }
    }
}
