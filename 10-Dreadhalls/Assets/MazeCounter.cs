using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MazeCounter : MonoBehaviour
{

    public static int count = 1;

    // Start is called before the first frame update
    void Start()
    {
        GetComponentInChildren<Text>().GetComponent<Text>().text = "Maze " + count;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
