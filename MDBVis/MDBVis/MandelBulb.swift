//
//  MandelBulb.swift
//  MandelbulbVisualization
//
//  Created by Harsimrat Bhundar on 20/04/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Foundation
import Metal

//class Mandelbulb - Child class of node, defines a drawable Mandelbulb
class Mandelbulb : Node{
    
    //init(device, mandelBulbData) - Initalizes the Mandelbulb based on the Metal device to be rednered on and the MandelbulbData
    init(device: MTLDevice, mandelBulbData:MandelbulbData){
        
        var verticesArray:Array<vertex> = [] //initalizes the vertices array for the mandelbulb
   
        //iterates over the data points in the MandelbulbData and creates a new vertex based on the point
        for point in mandelBulbData.dataPoints{
            let a = point.x //let a - the x-coordinate of the point at the iteration
            let b = point.y //let a - the x-coordinate of the point at the iteration
            let c = point.z //let a - the x-coordinate of the point at the iteration
            
            let shade = coord(a, b, c).getVecMagnitude() //let shade - the value for r, g, anf b for the vertex to color the vertex based on its distance from the origin (0,0,0)
            verticesArray.append(vertex(x: a, y: b, z:  c, r: shade , g: shade, b: shade, a:  0.25)) //adds the newly created vertex to the vertices array
        }
        mandelBulbData.destroy()//destroys the dmandelbulb data
        super.init(name: "MandelBulb", vertices: verticesArray, device: device)//initalizes the Mandelbulb by assigning the name, devices and vertex data genereated
    }
    
}
