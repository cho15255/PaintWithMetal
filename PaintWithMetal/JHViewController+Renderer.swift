//
//  JHViewController+Renderer.swift
//  PaintWithMetal
//
//  Created by Jae Hee Cho on 2015-11-29.
//  Copyright © 2015 Jae Hee Cho. All rights reserved.
//

import Foundation
import UIKit
import Metal

extension JHViewController {
    func render() {
        if let drawable = self.metalLayer.nextDrawable() {
            if self.bufferCleared <= 3 {
                self.renderPassDescriptor = MTLRenderPassDescriptor()
                self.renderPassDescriptor.colorAttachments[0].loadAction = .Clear
                self.renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.9, 0.9, 0.9, 1)
                self.renderPassDescriptor.colorAttachments[0].storeAction = .Store
                
                self.bufferCleared++
            } else {
                self.renderPassDescriptor.colorAttachments[0].loadAction = .Load
            }
            
            self.renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            
            if self.vertexData.count <= 0 {
                let commandBuffer = self.commandQueue.commandBuffer()
                
                let renderEncoderOpt:MTLRenderCommandEncoder? = commandBuffer.renderCommandEncoderWithDescriptor(self.renderPassDescriptor)
                if let renderEncoder = renderEncoderOpt {
                    renderEncoder.setRenderPipelineState(self.pipelineState)
                    renderEncoder.endEncoding()
                }
                
                commandBuffer.presentDrawable(drawable)
                commandBuffer.commit()
            } else {
                let commandBuffer = self.commandQueue.commandBuffer()
                
                let renderEncoderOpt:MTLRenderCommandEncoder? = commandBuffer.renderCommandEncoderWithDescriptor(self.renderPassDescriptor)
                
                if let renderEncoder = renderEncoderOpt {
                    renderEncoder.setRenderPipelineState(self.pipelineState)
                    renderEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, atIndex: 0)
                    renderEncoder.setVertexBuffer(self.colorBuffer, offset: 0, atIndex: 1)
                    
                    if self.vertexData.count > 0 {
                        renderEncoder.drawPrimitives(.TriangleStrip, vertexStart: 0, vertexCount: self.vertexData.count/4, instanceCount: 3)
                    }
                    
                    renderEncoder.endEncoding()
                }
                
                if self.vertexData.count > 800 {
                    self.vertexData.removeFirst(400)
                }
                
                if self.colorData.count > 800 {
                    self.colorData.removeFirst(400)
                }
                
                if self.didTouchEnded < 3 {
                    self.didTouchEnded++
                } else {
                    self.vertexData = []
                    self.colorData = []
                    self.prevVertex = nil
                }
                
                commandBuffer.presentDrawable(drawable)
                commandBuffer.commit()
            }
        }
    }
    
    func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }

}
