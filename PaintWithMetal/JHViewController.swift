//
//  JHViewController.swift
//  PaintWithMetal
//
//  Created by Jae Hee Cho on 2015-11-29.
//  Copyright © 2015 Jae Hee Cho. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class JHViewController: UIViewController {

    // Metal related fields
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    var renderPassDescriptor: MTLRenderPassDescriptor! = nil
    
    var bufferCleared = 0
    var didTouchEnded = 0
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var redButton: UIBarButtonItem!
    @IBOutlet weak var yellowButton: UIBarButtonItem!
    @IBOutlet weak var greenButton: UIBarButtonItem!
    @IBOutlet weak var blueButton: UIBarButtonItem!
    @IBOutlet weak var blackButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    // Coordinate constants for z and w axis (used for 3D rendering in Metal)
    let metalZCoordinate:Float = 0
    let metalWCoordinate:Float = 1
    
    // Stroke(vertex) information
    var prevVertex:CGPoint!
    var prevRadius:CGFloat!
    
    var vertexData:Array<Float> = []
    var vertexBuffer:MTLBuffer!
    
    var colorData:Array<Float> = []
    var colorBuffer:MTLBuffer!
    
    var currentColor:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentColor = UIColor.blackColor()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.metalLayer = CAMetalLayer()
        self.metalLayer.device = self.device
        self.metalLayer.pixelFormat = .BGRA8Unorm
        self.metalLayer.framebufferOnly = true
        self.metalLayer.frame = self.view.frame
        self.view.layer.insertSublayer(self.metalLayer, below: self.toolbar.layer)
        
        self.commandQueue = self.device.newCommandQueue()
        
        let defaultLibrary = self.device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary?.newFunctionWithName("basic_fragment")
        let vertexProgram = defaultLibrary?.newFunctionWithName("basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        do {
            try self.pipelineState = self.device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            if self.pipelineState == nil {
                print("Something's wrong with pipelinestate initialization")
            }
        }
        
        self.timer = CADisplayLink(target: self, selector: Selector("gameLoop"))
        self.timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.view.multipleTouchEnabled = false
        self.view.userInteractionEnabled = true
    }
    
    @IBAction func redButtonTapped(sender: AnyObject) {
        self.currentColor = UIColor.redColor()
    }
    
    @IBAction func yellowButtonTapped(sender: AnyObject) {
        self.currentColor = UIColor.yellowColor()
    }
    
    @IBAction func greenButtonTapped(sender: AnyObject) {
        self.currentColor = UIColor.greenColor()
    }
    
    @IBAction func blueButtonTapped(sender: AnyObject) {
        self.currentColor = UIColor.blueColor()
    }
    
    @IBAction func blackButtonTapped(sender: AnyObject) {
        self.currentColor = UIColor.blackColor()
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        self.bufferCleared = 0
        self.prevVertex = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

