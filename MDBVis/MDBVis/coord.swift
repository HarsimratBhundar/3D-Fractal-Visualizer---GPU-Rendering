//
//  coord.swift
//  MandelbulbRenderer
//
//  Created by Harsimrat Bhundar on 03/04/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Foundation

//class coord - Defines a point in 3-space
class coord{
    var x, y, z:Float //var x,y,z - Defines x, y & z coordinates of a point in 3-space
    
    //init(x,y,z) - initalizes an istance of a point in 3 space with x,y & z coordinates passed as paramaters
    init(_ _x:Float,_ _y:Float,_ _z:Float){
        x = _x
        y = _y
        z = _z
    }
    
    //init(vec[]) - initalizes an istance of a point in 3 space with x,y & z coordinates passed as an array as a parameter
    init(_ vec:[Float]){
        x = vec[0]
        y = vec[1]
        z = vec[3]
    }
    
    //func getVecMagnitude() - returns the magnitude of the position vector of the point
    func getVecMagnitude()->Float{
        return sqrt(x*x + y*y + z*z)
    }
    
    //func getUnitVec() - returns the unit vector of the point's position vector as a point
    func getUnitVec()->coord{
        let mag = getVecMagnitude()
        return coord(x/mag, y/mag, z/mag)
    }
    
    //func getArray() - returns an array with the x,y & z coordinates of the point
    func getArray()->[Float]{
        let coordArray = [x, y, z]
        return coordArray
    }
}
