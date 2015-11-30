//
//  JHViewController+TouchHandler.swift
//  PaintWithMetal
//
//  Created by Jae Hee Cho on 2015-11-29.
//  Copyright © 2015 Jae Hee Cho. All rights reserved.
//

import Foundation
import UIKit

extension JHViewController {
    func handleTouches(touches: Set<UITouch>, withEvent event:UIEvent?) {
        for touch in touches {
            let touchPoint = touch.locationInView(self.view)
            
            self.didTouchEnded = 0
            
            if self.prevVertex == nil {
                self.prevVertex = touchPoint
            } else {
                let distance = distanceBetween(pointA: self.prevVertex, pointB: touchPoint)
                var lineThickness = distance/10
                
                lineThickness = min(20, lineThickness)
                lineThickness = max(0.2, lineThickness)
                
                var dirVector = CGPointMake(touchPoint.x - self.prevVertex.x, touchPoint.y - self.prevVertex.y)
                dirVector = normalize(dirVector)
                
                var normalVector = CGPointMake(dirVector.y, -dirVector.x)
                
                let a = CGPointMake(self.prevVertex.x + normalVector.x * lineThickness , self.prevVertex.y + normalVector.y * lineThickness)
                let b = CGPointMake(touchPoint.x + normalVector.x * lineThickness, touchPoint.y + normalVector.y * lineThickness)
                
                normalVector = CGPointMake(-dirVector.y, dirVector.x)
                
                let c = CGPointMake(self.prevVertex.x + normalVector.x * lineThickness , self.prevVertex.y + normalVector.y * lineThickness)
                
                let d = CGPointMake(touchPoint.x + normalVector.x * lineThickness, touchPoint.y + normalVector.y * lineThickness)
                
                let metalCoordinateA = getMetalCoordinate(forPoint: a, forFrame: self.view.frame)
                let metalCoordinateB = getMetalCoordinate(forPoint: b, forFrame: self.view.frame)
                let metalCoordinateC = getMetalCoordinate(forPoint: c, forFrame: self.view.frame)
                let metalCoordinateD = getMetalCoordinate(forPoint: d, forFrame: self.view.frame)
                
                self.vertexData.append(metalCoordinateA.0)
                self.vertexData.append(metalCoordinateA.1)
                self.vertexData.appendContentsOf([metalZCoordinate, metalWCoordinate])
                
                self.vertexData.append(metalCoordinateC.0)
                self.vertexData.append(metalCoordinateC.1)
                self.vertexData.appendContentsOf([metalZCoordinate, metalWCoordinate])
                
                self.vertexData.append(metalCoordinateB.0)
                self.vertexData.append(metalCoordinateB.1)
                self.vertexData.appendContentsOf([metalZCoordinate, metalWCoordinate])
                
                self.vertexData.append(metalCoordinateD.0)
                self.vertexData.append(metalCoordinateD.1)
                self.vertexData.appendContentsOf([metalZCoordinate, metalWCoordinate])
                
                var dataSize = self.vertexData.count * sizeofValue(self.vertexData[0])
                self.vertexBuffer = self.device.newBufferWithBytes(self.vertexData, length: dataSize, options: [])
                
                let redColorComponents = UnsafeMutablePointer<CGFloat>.alloc(1)
                let greenColorComponents = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blueColorComponents = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alphaColorComponents = UnsafeMutablePointer<CGFloat>.alloc(1)
                
                
                self.currentColor.getRed(redColorComponents, green: greenColorComponents, blue: blueColorComponents, alpha: alphaColorComponents)
                
                for _ in 1...4 {
                    self.colorData.append(Float(redColorComponents.memory))
                    self.colorData.append(Float(greenColorComponents.memory))
                    self.colorData.append(Float(blueColorComponents.memory))
                    self.colorData.append(Float(alphaColorComponents.memory))
                }
                
                redColorComponents.destroy()
                redColorComponents.dealloc(1)
                greenColorComponents.destroy()
                greenColorComponents.dealloc(1)
                blueColorComponents.destroy()
                blueColorComponents.dealloc(1)
                alphaColorComponents.destroy()
                alphaColorComponents.dealloc(1)
                
                dataSize = self.colorData.count * sizeofValue(self.colorData[0])
                self.colorBuffer = self.device.newBufferWithBytes(self.colorData, length: dataSize, options: [])
                
                self.prevVertex = touchPoint
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handleTouches(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handleTouches(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handleTouches(touches, withEvent: event)
    }    
}
