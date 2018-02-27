//
//  ModelReader.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class ModelReader {
    enum ModelReaderError : Error {
        case ResourceNotFound(file: String)
    }
    public static func read(objPath: String) throws -> Model {
        let path = Bundle.main.path(forResource: objPath, ofType: "obj")
        if (path == nil) {
            throw ModelReaderError.ResourceNotFound(file: objPath)
        }
        let objFile = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        var vertices = [GLfloat]()
        var normals = [GLfloat]()
        var texels = [GLfloat]()
        var faces = [GLint]()

        objFile.enumerateLines { line, _ in
            switch (line.prefix(2)) {
            case "v ":
                vertices += parseVertex(line: line)
            case "vt":
                texels += parseTexel(line: line)
            case "vn":
                normals += parseNormal(line: line)
            case "f ":
                faces += parseFace(line: line)
            default:
                break
            }
        }
        
        return Model(vertices: vertices, normals: normals, texels: texels, faces: faces)
    }
    
    private static func parseVertex(line: String) -> [GLfloat] {
        let sc = Scanner(string: line)
        sc.charactersToBeSkipped = CharacterSet(charactersIn: "v ")
        var dec = Float(0.0)
        var vals = [GLfloat]()
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        return vals;
    }
    
    private static func parseTexel(line: String) -> [GLfloat] {
        let sc = Scanner(string: line)
        sc.charactersToBeSkipped = CharacterSet(charactersIn: "vt ")
        var dec = Float(0.0)
        var vals = [GLfloat]()
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        return vals;
    }
    
    private static func parseNormal(line: String) -> [GLfloat] {
        let sc = Scanner(string: line)
        sc.charactersToBeSkipped = CharacterSet(charactersIn: "vn ")
        var dec = Float(0.0)
        var vals = [GLfloat]()
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        sc.scanFloat(&dec)
        vals.append(dec)
        return vals;
    }
    
    private static func parseFace(line: String) -> [GLint] {
        let sc = Scanner(string: line)
        sc.charactersToBeSkipped = CharacterSet(charactersIn: "f/ ")
        var dec = Int(0.0)
        var vals = [GLint]()
        sc.scanInt(&dec)
        vals.append(GLint(dec - 1))
        sc.scanInt(nil)
        sc.scanInt(&dec)
        vals.append(GLint(dec - 1))
        sc.scanInt(nil)
        sc.scanInt(&dec)
        vals.append(GLint(dec - 1))
        return vals
    }
}
