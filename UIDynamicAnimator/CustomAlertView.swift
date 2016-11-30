//
//  CustomAlertView.swift
//  UIDynamicAnimator
//
//  Created by QUYNV on 11/29/16.
//  Copyright © 2016 QUYNV. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController, UICollisionBehaviorDelegate {
    var ball = UIImageView()
    var alertView : UIView! = nil
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        if (alertView != nil) {
            let gravityBehavior = UIGravityBehavior(items: [self.alertView])
            
            gravityBehavior.magnitude = 0.1
            gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
            
            animator.addBehavior(gravityBehavior)
            
            let collision = UICollisionBehavior(items: [alertView])
            collision.translatesReferenceBoundsIntoBoundary = true
            collision.collisionDelegate = self
            animator.addBehavior(collision)
        }
        
    }
    
    func createAlert() {
        let alertWidth : CGFloat = 250
        let alertHeight : CGFloat = 150
        let buttonWidth : CGFloat = 40
        let alertViewFrame = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.black
        alertView.alpha = 0
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10.0
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth / 2 - buttonWidth / 2, y: -buttonWidth / 2, width: buttonWidth, height: buttonWidth)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight / 2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "aHihi"
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        // HomeWork
        let cancel = UIButton(type: .custom)
        cancel.frame = CGRect(x: alertWidth / 4 - 25, y: button.frame.origin.y + button.frame.height + label.frame.height, width: 50, height: 30)
        cancel.setTitle("Cancel", for: .normal)
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cancel.setTitleColor(UIColor.white, for: .normal)
        cancel.addTarget(self, action: #selector(action_Cancel), for: .touchUpInside)
        
        let accept = UIButton(type: .custom)
        accept.frame = CGRect(x: alertWidth / 4 - 25 + alertWidth / 2, y: button.frame.origin.y + button.frame.height + label.frame.height, width: 50, height: 30)
        accept.setTitle("OK", for: .normal)
        accept.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        accept.setTitleColor(UIColor.white, for: .normal)
        accept.addTarget(self, action: #selector(action_Accept), for: .touchUpInside)
        
        alertView.addSubview(label)
        alertView.addSubview(button)
        alertView.addSubview(cancel)
        alertView.addSubview(accept)
        view.addSubview(alertView)
        
    }
    
    func dismissAlert() {
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
        }) { (finished) in
            if (self.alertView != nil) {
                self.alertView.removeFromSuperview()
                self.alertView = nil
            }
        }
    }
    
    func action_Cancel() {
        print("This is cancel button")
    }
    
    func action_Accept() {
        print("This is OK button")
    }
    
    
    @IBAction func showAlertView(_ sender: UIButton) {
        
        showAlert()
    }
    
    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        
        createGesture()
        
        animator.removeAllBehaviors()
        
        alertView.alpha = 1.0
        let snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        animator.addBehavior(snapBehavior)
        
    }
    
    func createGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func handlePan(gesture : UIPanGestureRecognizer) {
        if (alertView != nil) {
            let panLocationInView = gesture.location(in: self.view)
            let panLocationInAlertView = gesture.location(in: self.alertView)
            
            if (gesture.state == .began) {
                let offset = UIOffset(horizontal: panLocationInAlertView.x - alertView.bounds.midX, vertical: panLocationInAlertView.y - alertView.bounds.midY)
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                animator.addBehavior(attachmentBehavior)
            }
            
            if (gesture.state == .changed) {
                attachmentBehavior.anchorPoint = panLocationInView
            } else if (gesture.state == .ended) {
                animator.removeAllBehaviors()
                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center )
                animator.addBehavior(snapBehavior)
            }
            
            if (attachmentBehavior.anchorPoint.y >= self.view.bounds.maxY - 20) {
                dismissAlert()
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
        
    }
    
}
