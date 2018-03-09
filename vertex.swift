//
//  vertex.swift
//  MandelbulbRenderer
//
//  Created by Harsimrat Bhundar on 18/04/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Foundation

struct vertex{
    var x,y,z: Float
    var r,g,b,a: Float

    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
}
