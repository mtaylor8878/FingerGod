//
//  Renderer.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//
import GLKit

public class Renderer {
    private static var view : GLKView? = nil
    private static var models = [Model]()
    public static func setup(view: GLKView) {
        let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES3)
        if context == nil {
            print("Failed to create GLES3 Context")
        }
        view.context = context!
        view.drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        
        Renderer.view = view
        EAGLContext.setCurrent(view.context)
        
        let vsh = loadShader(filename: "Shader.vsh", type: GL_VERTEX_SHADER)
        let fsh = loadShader(filename: "Shader.fsh", type: GL_FRAGMENT_SHADER)
        let program = glCreateProgram()
        
        glAttachShader(program, vsh)
        glAttachShader(program, fsh)
        glLinkProgram(program)
        
        var linkStatus = GLint(0)
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        if (linkStatus == 0) {
            var msg = [GLchar](repeating: 0, count: 51);
            glGetProgramInfoLog(program, 50, nil, &msg)
            print("Problem compiling shader: ", msg)
        }
        
        glDeleteShader(vsh)
        glDeleteShader(fsh)
        
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glEnable(GLenum(GL_DEPTH_TEST))
	}
    
    private static func loadShader(filename: String, type: Int32) -> GLuint {
        do {
            let path = Bundle.main.path(forResource: filename, ofType: (type == GL_VERTEX_SHADER ? "vsh" : "fsh"))!
            let shadeSrc = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
            let shader = glCreateShader(GLenum(type))
            var src = UnsafePointer<GLchar>(shadeSrc.cString(using: String.Encoding.ascii))
            glShaderSource(shader, 1, &src, nil)
            glCompileShader(shader)
            
            var compileStatus = GLint(0)
            glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileStatus)
            if (compileStatus == 0) {
                var msg = [GLchar](repeating: 0, count: 51);
                glGetShaderInfoLog(shader, 50, nil, &msg)
                print("Problem compiling shader: ", msg)
            }
            
            return shader
            
        } catch {
            print("There was a problem: \(error)");
        }
        
        return 0
    }
	
    public static func draw(drawRect: CGRect) {
	}
    
    public static func addModel(model: Model) {
        models.append(model)
    }
    
    public static func removeModel(model: Model) {
        models.remove(at: models.index(where: {$0 === model})!)
    }
}
