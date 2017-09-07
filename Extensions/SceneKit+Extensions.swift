//
//  SceneKit+Extensions.swift
//
//  Created by Tom Welsh on 8/18/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

import Foundation
import SceneKit

public extension SCNGeometry {
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }

    class func line(with thickness:Float, vector vector1: SCNVector3,
                             toVector vector2: SCNVector3,
                             toCamera vectorC:SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0,1,2,3]
        let source = SCNGeometrySource(vertices: verticesFrom(vector: vector1, toVector: vector2, normal:vectorC.normalized(),thickness:thickness))
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        return SCNGeometry(sources: [source], elements: [element])
    }

    class func verticesFrom(vector p1: SCNVector3, toVector p2:SCNVector3, normal:SCNVector3, thickness:Float) -> [SCNVector3] {
        var strip = [SCNVector3]()
        let toVector = (p2 - p1).normalized()
        let sideVector = toVector.cross(vector: normal)
        strip.append(p1)
        strip.append(p1+sideVector*thickness)
        strip.append(p2)
        strip.append(p2+sideVector*thickness)
        return strip
    }
    
    class func triangleGeometry(vertices:[SCNVector3]) -> SCNGeometry {
        var indices = [Int32]()
        for i in 0..<vertices.count {
            indices.append(Int32(i))
        }
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        return SCNGeometry(sources: [source], elements: [element])
    }

}

public class CylinderLine: SCNNode {
    init( parent: SCNNode,//Needed to line to your scene
        v1: SCNVector3,//Source
        v2: SCNVector3,//Destination
        radius: CGFloat,// Radius of the cylinder
        radSegmentCount: Int, // Number of faces of the cylinder
        color: UIColor )// Color of the cylinder
    {
        super.init()
        
        //Calcul the height of our line
        let height = v1.distance(vector: v2)
        
        //set position to v1 coordonate
        position = v1
        
        //Create the second node to draw direction vector
        let nodeV2 = SCNNode()
        
        //define his position
        nodeV2.position = v2
        //add it to parent
        parent.addChildNode(nodeV2)
        
        //Align Z axis
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float.pi/2.0
        
        //create our cylinder
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
        cyl.radialSegmentCount = radSegmentCount
        cyl.firstMaterial?.diffuse.contents = color
        
        //Create node with cylinder
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/2.0
        zAlign.addChildNode(nodeCyl)
        
        //Add it to child
        addChildNode(zAlign)
        
        //set constraint direction to our vector
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SCNNode {
    
    public func setDiffuseColor(color:UIColor) {
        guard let geometry = self.geometry,
            let material = geometry.firstMaterial else {
            return
        }
        material.lightingModel = .blinn
        material.diffuse.contents = color
        material.isDoubleSided = true
    }
}

extension Array where Element == SCNNode {
    public func flattenedPositions() -> [Float] {
        var flat: [Float] = []
        for node in self {
            flat.append(node.position.x)
            flat.append(node.position.z)
        }
        return flat
    }
}

public func positionToCamera(fromTransform matrix:matrix_float4x4) -> SCNVector3 {
    return SCNVector3Make(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z);
}

public func directionToCamera(fromTransform matrix:matrix_float4x4) ->SCNVector3 {
    let mat = SCNMatrix4(matrix) // 4x4 transform matrix describing camera in world space
    return SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
}

public func createNode_cube(size dimension:Float) -> SCNNode {
    let cube = SCNBox.init(width: CGFloat(dimension), height: CGFloat(dimension), length: CGFloat(dimension), chamferRadius: 0)
    let node = SCNNode(geometry: cube)
    return node
}

public func createNode_sphere(size dimension:Float) -> SCNNode {
    let sphere = SCNSphere.init(radius: CGFloat(dimension))
    let node = SCNNode(geometry: sphere)
    return node
}
public func createNode_cylinder(size dimension:Float, height:Float, color:UIColor) -> SCNNode {
    let cylinder = SCNCylinder(radius: CGFloat(dimension), height: CGFloat(height))
    cylinder.materials.first?.diffuse.contents = color
    let node = SCNNode(geometry: cylinder)
    return node
}

public func createNode_circle(radius:Float, color:UIColor) -> SCNNode {
    let path = UIBezierPath(arcCenter:CGPoint(x:0, y:0),radius:CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Float.pi * 2), clockwise: true)
    path.flatness = 0.001
    let shape = SCNShape(path: path, extrusionDepth: 0.1 )
    shape.firstMaterial?.diffuse.contents = color;
    shape.firstMaterial?.isDoubleSided = true
    let node = SCNNode(geometry:shape)
    node.eulerAngles = SCNVector3(-Float.pi/2,0,0)
    return node
}

public extension SCNMaterial {
    
    public static var transparent: SCNMaterial {
        let mat = SCNMaterial()
        mat.transparency = 0
        return mat
    }
}
