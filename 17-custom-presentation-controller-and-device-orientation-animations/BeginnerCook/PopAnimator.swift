//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Pritam Hinger on 02/04/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originalFrame = CGRect.zero
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
//        containerView.addSubview(toView)
//        toView.alpha = 0.0
//        UIView.animate(withDuration: duration, animations: {
//            toView.alpha = 1.0
//        }, completion: { _ in
//            transitionContext.completeTransition(true)
//        })
        
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame  = presenting ? originalFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originalFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / originalFrame.width
        let yScaleFactor = presenting ? originalFrame.height / finalFrame.height : finalFrame.height / originalFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting{
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        if !self.presenting{
            self.dismissCompletion?()
        }
    }
}
