//
//  node.swift
//  MandelbulbRenderer
//
//  Created by Harsimrat Bhundar on 18/04/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

// class Node - Defines a vertices based drawable object in Metal
class Node {
    
    let device: MTLDevice // let device - assigns the type of target device for running the program
    let name: String //let name - assigns name of the drawable object
    var vertexCount: Int // var vertexCount - assigns the number of vertices of the object
    var vertexBuffer: MTLBuffer // var vertexBuffer - Buffer for vertex data to be sent to the GPU from the CPU
    
    var positionX: Float = 0.0 //var positionX - The position of the vertices of the object on the x-axis
    var positionY: Float = 0.0 //var positionY - The position of the vertices of the object on the y-axis
    var positionZ: Float = 0.0 //var positionZ - The position of the vertices of the object on the z-axis
    
    var rotationX: Float = 0.0 //var roationX - The rotation of the object in respect to the x-axis
    var rotationY: Float = 0.0 //var roationX - The rotation of the object in respect to the x-axis
    var rotationZ: Float = 0.0 //var roationX - The rotation of the object in respect to the x-axis
    var scale: Float     = 0.9 //var scale - The scale of the object from its default scale (1.0)
    
    
    //init(name, vertices, device) - initalizes the object with a string based name, an array of vertices and reference to a device for the object to be rendered on
    init(name: String, vertices: Array<vertex>, device: MTLDevice){
        var vertexData = Array<Float>()//var vertexData - a float based array to store each the paramters of each of thr vertives
        for vertex in vertices{
            vertexData += vertex.floatBuffer() //adds the paramter data (x,y,z,r,g,b,a) for each vertex into the collection of vertexData
        }
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) //let dataSize - A constant that assigns the data size of the object
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) //initalizes the vertexBuffer based on the the data for the vertices of the object and the size of the vertex data
        
        self.name = name //initalizes the name of the object
        self.device = device //initalizes the device for the object to be rendered on
        vertexCount = vertices.count //intializes the vertexCount for the object
    }
    
    //func render(commandQueue, pipelineState, drawable, parentModelViewMatrix, projectionMatrix, clearColor) - Renders the drawable object based on a command queue (to execute commands in the GPU for the object), the pipelineState (used to define the vertex and fragment shading functions), the drawable object, the parentModelViewMatrix and the projectionMatrix that are used to roate and position the vertices in order to set the view of the object
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: Matrix4, projectionMatrix: Matrix4, clearColor: MTLClearColor?) {
        
        let renderPassDescriptor = MTLRenderPassDescriptor() //let renderPassDescriptor - The renderPassDescriptor which contains the data in forms of attachments for the space the object will be rendered
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture //assigns the texture of the space
        renderPassDescriptor.colorAttachments[0].loadAction = .clear //assigns the load action as clear in order to attach a value to each pixel
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0) //assigns the color of the space
        renderPassDescriptor.colorAttachments[0].storeAction = .store//assigns the store action to .store meaning the final rendered product would be stored to the attachments defining the drawable space
        
        let commandBuffer = commandQueue.makeCommandBuffer() //let commandBuffer - The buffer for the command Queue to parse the commands in the commandQueue to the GPU
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) //let renderEncoder - The render enconder represents a single rendering pass to send rendering commands to an attachment of the renderPassDescriptor
        
        //For now cull mode is used instead of depth buffer
        renderEncoder.setCullMode(MTLCullMode.front)//sets the object's primitives to be front facing
        renderEncoder.setRenderPipelineState(pipelineState)//sets the render encoder's pipeline state (vertex shader and fragment functions)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)//set's rhe render encoder's vertex buffer using the vertex buffer previously intilaised in this function
        
        
        let nodeModelMatrix = self.modelMatrix() // let nodeModelMatrix - The matrix that defines the object's transformations
        nodeModelMatrix.multiplyLeft(parentModelViewMatrix) //The model matrix is multiplied by the parent view matrix to get the resultant of the parent view being the inital view matrix and the transformation matrix
        
        let uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2, options: []) //let uniformBuffer - The primary buffer to store the data to be sent to the GPU
        
        let bufferPointer = uniformBuffer.contents() // let bufferPointer - The pointer to the unifrom buffer i.e. the primary buffer
        
        //memcpy function calls used to copy memory from the parameter-referenced source to the parameter-refereneced destination. In this case the memory from the matrices nodeModelMatrix and projectionMatrix is copied over to the bufferPointer (the pointer that points to the contents of uniformBuffer)
        memcpy(bufferPointer, nodeModelMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size * Matrix4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        
        
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, at: 1)//sets the vertexBuffer to uniformBuffer, the vertexBuffer is used to parse and send the data for the vertex primitives (the vertex data) over to the GPU
        
        renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount)//draws the primitives for the object (i.e. the vertices for the object), vertices can be point, line or triangle based. The primitive type is set to point
        
        renderEncoder.endEncoding()//ends the encoding process, since all the commands have been passed the encoder no longer needs to continue encoding commands
        
        commandBuffer.present(drawable)//once after the encoding process has ended as in all the rendering commands have been stored by the render encoder, the command buffer presents the drawable object created by the rendering commands
        
        commandBuffer.commit()//commits the rendered results
    }
    
    //func modelMatrix() - Returns the model matrix which is the transformation matrix for the object
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4() //initalizes the matrix
        matrix.translate(positionX, y: positionY, z: positionZ) //sets the translations for the model matrix over the x,y & z axis
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ) //sets the rotations fo the model matrix over the x,y & z axis
        matrix.scale(scale, y: scale, z: scale) //sets the scale for the model matrix over the x,y & z axis
        return matrix //returns the transformation/model matrix
    }
    
    
}
