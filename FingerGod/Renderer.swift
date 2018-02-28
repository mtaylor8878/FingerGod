//
//  Renderer.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//
import GLKit


public class Renderer {
    public static var perspectiveMatrix: GLKMatrix4 {
        get {
            return Renderer.camera.perspectiveMatrix
        }
    }
    
    public class Camera {
        
        public var perspectiveMatrix : GLKMatrix4!
        public var transform = GLKMatrix4Identity
        
        public func move(x: Float, y: Float, z: Float) {
            let tmp = GLKMatrix4Translate(GLKMatrix4Identity, x, y, z)
            transform = GLKMatrix4Multiply(tmp, transform)
        }
        
        public func moveRelative(x: Float, y: Float, z: Float) {
            transform = GLKMatrix4Translate(transform, x, y, z)
        }
        
        public func rotate(angle: Float, x: Float, y: Float, z: Float) {
            transform = GLKMatrix4Rotate(transform, angle, x, y, z)
        }
        
    }
    
    private struct UniformContainer {
        var mvp: GLint!
        var normal: GLint!
        var pass: GLint!
        var shade: GLint!
    }
    private static var uniforms = UniformContainer()
    private static var view : GLKView!
    private static var program: GLuint!
    public static var camera = Camera()
    
    private static var modelInstances = [ModelInstance]()
    
    public static func setup(view: GLKView) {
        let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES3)
        if context == nil {
            print("Failed to create GLES3 Context")
        }
        view.drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        view.context = context!
        
        Renderer.view = view
        EAGLContext.setCurrent(view.context)
        
        setupShaders()
        setupUniforms()
        
        glClearColor(0.3, 0.65, 1.0, 1.0)
        glEnable(GLenum(GL_DEPTH_TEST))
	}
    
    private static func setupShaders() {
        let vsh = loadShader(filename: "Shader", type: GL_VERTEX_SHADER)
        let fsh = loadShader(filename: "Shader", type: GL_FRAGMENT_SHADER)
        program = glCreateProgram()
        
        glAttachShader(program, vsh)
        glAttachShader(program, fsh)
        glLinkProgram(program)
        
        var linkStatus = GLint(0)
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        if (linkStatus == 0) {
            var msg = [GLchar](repeating: 0, count: 1024);
            glGetProgramInfoLog(program, 1024, nil, &msg)
            print("Problem linking shader: ", String(cString: msg))
        }
        
        glDeleteShader(vsh)
        glDeleteShader(fsh)
    }
    
    private static func setupUniforms() {
        uniforms.mvp = glGetUniformLocation(program, "modelViewProjectionMatrix")
        uniforms.normal = glGetUniformLocation(program, "normalMatrix")
        uniforms.pass = glGetUniformLocation(program, "passThrough")
        uniforms.shade = glGetUniformLocation(program, "shadeInFrag")
    }
    
    private static func loadShader(filename: String, type: Int32) -> GLuint {
        do {
            let path = Bundle.main.path(forResource: filename, ofType: (type == GL_VERTEX_SHADER ? "vsh" : "fsh"))!
            let shadeSrc = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
            
            let shader = glCreateShader(GLenum(type))
            if (shader == 0) {
                print("Failed to create shader")
            }
            
            var src = UnsafePointer<GLchar>(shadeSrc.cString(using: String.Encoding.ascii))
            
            glShaderSource(shader, 1, &src, nil)
            glCompileShader(shader)
            
            
            var compileStatus = GLint(0)
            glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileStatus)
            if (compileStatus == 0) {
                var msg = [GLchar](repeating: 0, count: 1024);
                glGetShaderInfoLog(shader, 1024, nil, &msg)
                print("Problem compiling shader: ", String(cString: msg))
            }
            
            return shader
            
        } catch {
            print("There was a problem: \(error)");
        }
        
        return 0
    }
	
    public static func draw(drawRect: CGRect) {
        // We do this in multiple draw calls for now
        // Eventually it may be a good idea to make less draw calls
        
        glViewport(0, 0, GLsizei(view.drawableWidth), GLsizei(view.drawableHeight))

        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        glUseProgram(program)
        
        camera.perspectiveMatrix = GLKMatrix4MakePerspective(Float(60.0 * Double.pi / 180.0), Float(view.drawableWidth) / Float(view.drawableHeight), 1.0, 300.0)
        
        let cameraMatrix = GLKMatrix4Invert(camera.transform, nil)
        
        for inst in modelInstances {
            var mvpMatrix = inst.transform
            var normMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvpMatrix), nil)
            mvpMatrix = GLKMatrix4Multiply(cameraMatrix, mvpMatrix)
            mvpMatrix = GLKMatrix4Multiply(perspectiveMatrix, mvpMatrix)
            
            let vertices = inst.model.vertices
            let normals = inst.model.normals
            let indices = inst.model.faces

            glUniformMatrix4fv(uniforms.mvp, 1, 0, &mvpMatrix.m.0)
            glUniformMatrix3fv(uniforms.normal, 1, 0, &normMatrix.m.0)
            
            glUniform1i(uniforms.pass, GL_FALSE)
            glUniform1i(uniforms.shade, GL_TRUE)
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(3 * MemoryLayout<GLfloat>.size), vertices)
            glEnableVertexAttribArray(0)
            
            glVertexAttrib4f(1, inst.color[0], inst.color[1], inst.color[2], inst.color[3])
            
            glVertexAttribPointer(2, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(3 * MemoryLayout<GLfloat>.size), normals)
            glEnableVertexAttribArray(2)
            
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), indices)
        }
	}
    
    public static func addInstance(inst: ModelInstance) {
        modelInstances.append(inst)
        setupLists()
    }
    
    public static func removeInstance(inst: ModelInstance) {
        modelInstances.remove(at: modelInstances.index(where: {$0 === inst})!)
        setupLists()
    }
    
    // Sets up all of the necessary lists for rendering
    // Not currently used, but eventually may be useful for putting all of the vertices in one buffer and etc
    private static func setupLists() {
        
    }
}
