//
//  Shaders.metal
//  PaintWithMetal
//
//  Created by Jae Hee Cho on 2015-11-29.
//  Copyright © 2015 Jae Hee Cho. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ColoredVertex {
    float4 position [[position]];
    float4 color;
};

vertex ColoredVertex basic_vertex ( constant float4 *position [[ buffer(0) ]],
                                   constant float4 *color [[buffer(1)]],
                                   unsigned int vid [[ vertex_id ]]) {
    ColoredVertex vert;
    vert.position = position[vid];
    vert.color = color[vid];
    return vert;
}

fragment half4 basic_fragment(ColoredVertex vert [[stage_in]]) {
    return half4(vert.color);
}
