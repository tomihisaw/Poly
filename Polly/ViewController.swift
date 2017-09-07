//
//  ViewController.swift
//
//  Created by Tom Welsh on 9/6/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var objects = [SCNNode]()
    var mesh:SCNNode?;
    var lines = [SCNNode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 0)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add a tap gesture recognizer
        let longPress1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(from:)))
        longPress1.minimumPressDuration = 0.5
        scnView.addGestureRecognizer(longPress1)

    }

    public func insertNode(_ node:SCNNode) {
        let scnView = self.view as! SCNView
        self.objects.append(node)
        scnView.scene?.rootNode.addChildNode(node)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView

        let tapPoint = gestureRecognize.location(in: scnView)
        print("handleTap... scene position \(tapPoint.x),\(tapPoint.y)")
        let hitResults = scnView.hitTest(tapPoint, options: [:])
            
        // check that we clicked on at least one object (floor)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = createNode_circle(radius:0.05, color:UIColor.red)
            node.name = "circle"
            node.position = result.worldCoordinates
            self.insertNode(node)
            self.triangulate()
        }
    }
    @objc func handleLongPress(from recognizer:UILongPressGestureRecognizer) {
        self.reset()
    }
    
    func geometryFromPoints(indices:IntData3?, vertices:[Float]) -> SCNGeometry {
        var triangles = [SCNVector3]()
        if let results = indices {
            for i in 0..<results.count {
                let index = Int(results.data[Int(i)]);
                let position = SCNVector3(vertices[2*index],vertices[2*index+1],0)
                triangles.append(position)
            }
        }
        return SCNGeometry.triangleGeometry(vertices: triangles)
    }
    
    func triangulate() {
        if self.objects.count >= 3 {
            var positions = self.objects.flattenedPositions()
            let points = FloatData2(data: &positions, count: UInt(positions.count/2))
            let wrapper = GeometryWrapper(points: points)
            let triangles = wrapper?.triangleVertices()
            let geometry = geometryFromPoints(indices: triangles, vertices: positions)
            let material = SCNMaterial()
            material.isDoubleSided = true; //important
            
            material.diffuse.contents = UIColor.blue.withAlphaComponent(0.85)

            geometry.materials = [material]

            if mesh == nil {
                self.mesh = SCNNode(geometry: geometry)
                if let node = self.mesh {
                    node.eulerAngles = SCNVector3Make(Float.pi / 2.0, 0, 0);
                    node.position = SCNVector3(0,0,0.01)
                    let scnView = self.view as! SCNView
                    scnView.scene?.rootNode.addChildNode(node)
                }
            } else{
                self.mesh?.geometry = geometry
            }
        }
    }
    
    func reset() {
        for obj in self.objects {
            obj.removeFromParentNode()
        }
        self.objects.removeAll()
        self.mesh?.removeFromParentNode()
        self.mesh = nil
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
