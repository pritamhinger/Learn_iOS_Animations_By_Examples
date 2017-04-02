//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Pritam Hinger on 02/04/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

    let duration = 2.0
    var operation: UINavigationControllerOperation = .push
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if operation == .push {
            let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
            let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController
            
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let transformLogo = CABasicAnimation(keyPath: "transform")
            transformLogo.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            transformLogo.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0)))
            transformLogo.duration = duration
            transformLogo.delegate = self
            transformLogo.fillMode = kCAFillModeForwards
            transformLogo.isRemovedOnCompletion = false
            transformLogo.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
            maskLayer.position = fromVC.logo.position
            toVC.view.layer.mask = maskLayer
            maskLayer.add(transformLogo, forKey: nil)
            
            fromVC.logo.add(transformLogo, forKey: nil)
            
            let viewOpacity = CABasicAnimation(keyPath: "opacity")
            viewOpacity.fromValue = 0.0
            viewOpacity.toValue = 1.0
            viewOpacity.duration = duration
            toVC.view.layer.add(viewOpacity, forKey: nil)
        }
        else{
            let fromVC = transitionContext.view(forKey: .from)!
            let toVC = transitionContext.view(forKey: .to)!
            transitionContext.containerView.insertSubview(toVC, belowSubview: fromVC)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
                fromVC.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext{
            context.completeTransition(!context.transitionWasCancelled)
            
            let fromVC = context.viewController(forKey: .from) as! MasterViewController
            fromVC.logo.removeAllAnimations()
            
            let toVC = context.viewController(forKey: .to) as! DetailViewController
            toVC.view.layer.mask = nil
        }
        
        storedContext = nil
    }
}
