//
//  MandelbulbData.swift
//  MandelbulbRenderer
//
//  Created by Harsimrat Bhundar on 03/04/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Foundation

//class MandelbulbData - Defines a collection of data such as the 'n' value and data points related to an instance of a Mandelbulb set
class MandelbulbData{
    var dataPoints:[coord] //var dataPoints - An array of points used to store the points in a Mandebulb Set
    let n:Float //let n - The power of the Mandelbulb (n > 3) each instance of a Mandelbulb Set will vary depending on the power
    
    
    //init(n) - Initalizes the Mandelbulb set by setting it's power value from a paramterized input
    init(_ _n:Float){//aliyahlovesjamal
        self.n = _n //sets the power of the Mandelbulb Set
        dataPoints = [] //creates an empty array to initalize data points
    }
    
    //func destroy() - Removes all values from the array, dataPoints
    func destroy() {
        dataPoints.removeAll()
    }
    
    //func pointExists(x,y,z) - Function used to check whether a point is a part of the Mandelbulb set based on the point's x,y & z coordinates
    func pointExists(x:Float, y:Float, z:Float)->Bool{
        let iterations = 5 //let iterations - Number of iterations to run an iterative process to check whether the point converges or not
        var counter = 0 //var counter - Counts the number of iterations that the point's absolute value squared < 1.25
        
        var x = x
        var y = y
        var z = z
       
        
        //iterative process to check whether point converges, process breaks when x*x + y*y + z*z < 1.25
        repeat{
            
            counter += 1 //the count increases when a new iteration occurs
            if (counter == iterations + 1) {return true} //if the counter equals the number of iterations + 1, the process is automatically ended as the the point is belived to be converged
            
            let r = pow((x*x + y*y + z*z), n/2) //the r value that is the absolute value of the point raised to the power 'n' of the Mandelbulb set
            let theta:Float = n * atan2(sqrt(x*x + y*y), z) //let theta - theta value for the new point
            let phi = n * atan2(y, x) //let phi - phi value for the new point
            
            x = r * sin(theta) * cos(phi) + x //calculates the x value for the new point,alternative equations: sin tan, cos cos for radiolarai variations
            
            y = r * sin(theta) * sin(phi) + y //calculates the y value for the new point
            z = r * cos(theta) + z //calculates the z value for the new point
        }while(x*x + y*y + z*z < 1.25)
        
        return false //function returns false as the point does not converge
    }
    
    //func genPoints(xmax,ymax,zmax) - Genereates data points and stores them in the array, dataPoints by testing several points in the cube from (-xmax,-ymax,-zmax) - (xmax,ymax,zmax) to check if they converge, points that converge are stored
    func genPoints(xmax:Float, ymax:Float, zmax:Float){
        let stepVal:Float = 0.005 //the stepValue between each coordinate in different points
        var x = -xmax //var x - The x-coordinate for the point to be tested, starts with -xmax and goes until x <=xmax
        while (x <= xmax){
            var y = -ymax//var y - The y-coordinate for the point to be tested, starts with -ymax and goes until y <=ymax
            while (y <= ymax){
                var z = -zmax//var z - The z-coordinate for the point to be tested, starts with -zmax and goes until z <=zmax
                while(z <= zmax){
                    //checks if the point exists in the Mandelbulb set
                    if(pointExists(x: x, y: y, z: z)){
                        dataPoints.append(coord(x,y,z)) //if the point is apart of the Mandelbulb set it is added to dataPoints
                    }
                    z += stepVal //increments the z-coordinate by stepVal
                }
                y += stepVal //increments the y-coordinate by stepVal
            }
            x += stepVal //increments the x-coordinate by stepVal
        }
    }
}
