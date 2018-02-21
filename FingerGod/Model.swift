//
//  Renderer.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

public class Model {
    public var vertices: [Float]
    public var normals: [Float]
    public var texels: [Float]
    public var faces: [Int]
    
    public init(vertices: [Float], normals: [Float], texels: [Float], faces: [Int]) {
        self.vertices = vertices
        self.normals = normals
        self.texels = texels
        self.faces = faces
    }
}
