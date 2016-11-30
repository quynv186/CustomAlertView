//
//  ViewController.swift
//  UIDynamicAnimator
//
//  Created by QUYNV on 11/25/16.
//  Copyright © 2016 QUYNV. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var ball = UIImageView()
    var animator = UIDynamicAnimator()
    var attachmentBehavior : UIAttachmentBehavior!
    var pushBehavior : UIPushBehavior!
    
    @IBOutlet weak var brickV4: UIView!
    @IBOutlet weak var brickV3: UIView!
    @IBOutlet weak var brickV2: UIView!
    @IBOutlet weak var brickV1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ball = UIImageView(frame: CGRect(x: 100, y: 100, width: 40, height: 40))
        self.ball.image = UIImage(named: "ball.png")
        self.view.addSubview(ball)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior(items: [self.ball])
        
        gravityBehavior.magnitude = 0.1
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        
        animator.addBehavior(gravityBehavior)
        
        let collistionBehavior = UICollisionBehavior(items: [self.ball])
        collistionBehavior.translatesReferenceBoundsIntoBoundary = true
        collistionBehavior.collisionDelegate = self
        animator.addBehavior(collistionBehavior)
        
        attachmentBehavior = UIAttachmentBehavior(item: self.ball, attachedToAnchor: self.ball.center)
        attachmentBehavior.length = 50
        attachmentBehavior.frequency = 10
        attachmentBehavior.damping = 10
        animator.addBehavior(attachmentBehavior)
        
        //Push
        self.pushBehavior = UIPushBehavior(items: [self.ball], mode: UIPushBehaviorMode.continuous)
        self.animator.addBehavior(self.pushBehavior)
        
        //UIDynamicItemBehavior
        let ballProperty = UIDynamicItemBehavior(items: [self.ball])
//        ballProperty.elasticity = 1 //Do nay khi va dap
//        ballProperty.allowsRotation = true  //qua bong quay
//        ballProperty.resistance = 100
//        ballProperty.friction = 0
        
        self.animator.addBehavior(ballProperty)
        
        //Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePlus(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        behavior.addItem(brickV1)
        behavior.addItem(brickV2)
        behavior.addItem(brickV3)
        behavior.addItem(brickV4)
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
        behavior.addItem(brickV1)
        behavior.addItem(brickV2)
        behavior.addItem(brickV3)
        behavior.addItem(brickV4)
    }
    
    func handlePan(gesture : UIPanGestureRecognizer) {
        attachmentBehavior.anchorPoint = gesture.location(in: self.view)
    }
    
    func handlePlus(gesture : UITapGestureRecognizer) {
        let p = gesture.location(in: self.view)
        let o = self.ball.center
        let distance = sqrt(powf(Float(p.x) - Float(o.x), 2.0) + powf(Float(p.y) - Float(o.y), 2.0))
        let angel = atan2(p.y - o.y, p.x - o.x)
        pushBehavior.magnitude = CGFloat(distance/100.0)
        pushBehavior.angle = angel
        
    }

}

