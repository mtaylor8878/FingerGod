//
//  ModelReader.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class ModelReader {
    enum ModelReaderError : Error {
        case ResourceNotFound(file: String)
    }
    public static func read(objPath: String) throws{
        let path = Bundle.main.path(forResource: objPath, ofType: "obj")
        if (path == nil) {
            throw ModelReaderError.ResourceNotFound(file: objPath)
        }
        let objFile = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        NSLog(objFile);
        
    }
}
