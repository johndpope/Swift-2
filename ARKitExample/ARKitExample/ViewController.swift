//
//  ViewController.swift
//  ARKitExample
//
//  Created by Viktor Siedov on 15.08.2018.
//  Copyright © 2018 Viktor Siedov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: GameViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modelFilePath = Bundle.main.path(forResource: "Salsa", ofType: "fbx")
        self.animFilePath =  Bundle.main.path(forResource: "Salsa", ofType: "fbx")
        
        
//        self.modelFilePath = Bundle.main.path(forResource: "gen-3-0-samples_scan-036", ofType: "fbx")
//        self.animFilePath =  Bundle.main.path(forResource: "gen-3-0-samples_scan-036", ofType: "fbx")
        
        // Set the view's delegate
        self.loadAnimation()
        
        
    }
    override func loadAnimation() {
        
        // Load the scene

        let modelFileURL = URL(fileURLWithPath: modelFilePath)
//        let flipUVs = AssimpKitPostProcessSteps.process_FlipUVs
        let trianglulate = AssimpKitPostProcessSteps.process_Triangulate
        //        let flags = [flipUVs,trianglulate]
        let scene = SCNScene.assimpScene(with: modelFileURL,postProcessFlags:trianglulate)
        
        
        // Load the animation scene
        if let animFilePath = animFilePath {
            let animFileURL = URL(fileURLWithPath: animFilePath)
            let animScene = SCNScene.assimpScene( with: animFileURL,postProcessFlags:trianglulate)
            
            if let animationKeys = animScene?.animationKeys(){

                let settings = SCNAssimpAnimSettings()
                settings.repeatCount = 300
                settings.delegate = self
                let eventBlock: SCNAnimationEventBlock = { animation, animatedObject, playingBackwards in
                    print("Animation Event triggered")
                }

                let animEvent = SCNAnimationEvent.init(keyTime: 1, block: eventBlock)
                let animEvents = [animEvent]
                settings.animationEvents = animEvents
                
                let key = animationKeys[0] as! String
                let animation = animScene!.animationScene(forKey: key)
                scene!.modelScene.rootNode.addAnimationScene(animation,forKey: key, with: settings)
            }
        }
        let scnView = view as? SCNView
        
        // set the scene to the view
        scnView?.scene = scene!.modelScene
        
        // allows the user to manipulate the camera
        scnView?.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView?.showsStatistics = true
        
        // configure the view
        scnView?.backgroundColor = UIColor.black
        
        scnView?.isPlaying = true
        
    }
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
