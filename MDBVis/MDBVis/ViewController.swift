//
//  ViewController.swift
//  MDBVis
//
//  Created by Harsimrat Bhundar on 15/05/17.
//  Copyright © 2017 Harsimrat Bhundar. All rights reserved.
//

import Cocoa


//class ViewController - Defines the control system / the manager of the application's view
class ViewController: NSViewController {

    var device: MTLDevice! //var device - The device for the application to be run on, it is more so a way to reference the GPU of the device
    var metalLayer: CAMetalLayer! //ver metalLayer - The application layer that is the base/foundation for all metal objects to be rendered on
    var pipelineState: MTLRenderPipelineState! //var pipelineState - Defines fragment shader and vertex functions for the program
    var commandQueue: MTLCommandQueue! //var commandQueue - Collection of executable commands to be sent to the GPU for the creation of the object
    
    var mandelBulbData: MandelbulbData! //var mandelBulbData - Stores all the data for the mandelbulb set to be rendered in the program
    var mandelbulb: Mandelbulb! //var mandelBulb - Instance of the drawable Mandelbulb based on a collection of point based vertices
    
    var projectionMatrix: Matrix4! //var projectionMatrix - The projection matrix for the object in this case being the Mandelbulb

    //func viewDidLoad() - Loads the view for the application
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 30.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)//initializes the projection matrix that conrols the view and the perspective of the object's appearance
        
        device = MTLCreateSystemDefaultDevice()//initalizes the GPU reference for the system the application is being run on
        
        metalLayer = CAMetalLayer()//initalizes the metal layer as a basic Metal Layer with default properties
        metalLayer.device = device //intializes the device (GPU reference property)
        metalLayer.pixelFormat = .bgra8Unorm //sets the pixel format to a standard 8 bit rgba fromat
        metalLayer.framebufferOnly = true //framebufferOnly configuration is set to true, which restricts textures to only be used as an attachment through renderPassDescriptor
        metalLayer.frame = (view.layer?.frame)!
        view.layer?.addSublayer(metalLayer)//adds the metalLayer to the view as a sub layer
        
        mandelBulbData = MandelbulbData(8)// creates an instance of MandelbulbData based on the power based argument, the power should be greater than 3, NOTE: change powers for different variations of the Mandelbulb
        mandelBulbData.genPoints(xmax: 1.04, ymax: 1.04, zmax: 1.04)//generates points for the mandelbulb data within cube based bounds from -xmax to xmax, -ymax to ymax and lastly -zmax to zmax
        mandelbulb = Mandelbulb(device: device, mandelBulbData: mandelBulbData)//initalizes the drawable mandelbulb based on the device and the instance of mandelBulbData
        
        let defaultLibrary = device.newDefaultLibrary()!//let defaultLibrary - Library to make fragment and vertex functions for the device
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")//let fragementProgram - Instance of a fragment shader function for the program
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")//let vertexProgram - Instance of a vertex shader function for the program

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()//let pipelineStateDescriptor - Creates information for metal attachments and shader functions
        pipelineStateDescriptor.vertexFunction = vertexProgram//sets the vertex function as "vertexProgram" i.e. the instance of the vertex function created above
        pipelineStateDescriptor.fragmentFunction = fragmentProgram//sets the fragment function as "fragmentProgram" i.e. the instance of the fragment function created above
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm//sets the first attachment's (the base attachment being the "background") pixel format as a standard 8 bit rgba format
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)//creates the pipelineState based on the pipelineStateDescriptor defined in the code above
        
        commandQueue = device.makeCommandQueue()//initalizes the command queue using the generic makeCommandQueue function
        
        render()//calls the render function to render the drawable mandelbulb
    }
    
    //func render() - renders the mandelbulb and displays it on the view screen
    func render() {
        
        let worldModelMatrix = Matrix4()//creates an instance of the "position" matrix
        worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)//translates the "position" of the mandelbulb on the x,y & z axis
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 90)/*5*/, y: Matrix4.degrees(toRad:0)/*5*/, z: Matrix4.degrees(toRad:10)) //roates the object around the x,y & z axis, use the parameter configurations to switch the view angles, for top view: x offset is 5, y offset is 5, and z offset is 0, for side view x offset is 90, y offset is 0, and z offset is 10
        guard let drawable = metalLayer?.nextDrawable() else { return }
        mandelbulb.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)//calls the render function for the drawable mandelbulb in order to render and present the object
    }


}

