/*
 * Copyright (c) 2014-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var meterLabel: UILabel!
    @IBOutlet weak var speakButton: UIButton!
    let replicatorLayer = CAReplicatorLayer()
    let dot = CALayer()
    
    let monitor = MicMonitor()
    let assistant = Assistant()
    
    let dotLength: CGFloat = 6.0
    let dotOffset: CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replicatorLayer.frame = view.bounds
        view.layer.addSublayer(replicatorLayer)
        
        dot.frame = CGRect(x: replicatorLayer.frame.size.width - dotLength, y: replicatorLayer.position.y, width: dotLength, height: dotLength)
        dot.backgroundColor = UIColor.lightGray.cgColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.borderWidth = 0.5
        dot.cornerRadius = 1.5
        
        replicatorLayer.addSublayer(dot)
        
        replicatorLayer.instanceCount = Int(view.frame.size.width / dotOffset)
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(-dotOffset, 0.0, 0.0)
        
//        let move = CABasicAnimation(keyPath: "position.y")
//        move.fromValue = dot.position.y
//        move.toValue = dot.position.y - 50.0
//        move.duration = 1.0
//        move.repeatCount = 10
//        dot.add(move, forKey: nil)
        
        replicatorLayer.instanceDelay = 0.02
        
    }
    
    @IBAction func actionStartMonitoring(_ sender: AnyObject) {
        
    }
    
    @IBAction func actionEndMonitoring(_ sender: AnyObject) {
        
        //speak after 1 second
        delay(seconds: 1.0) {
            self.startSpeaking()
        }
    }
    
    func startSpeaking() {
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.4, 15, 1.0))
        scale.duration = 0.33
        scale.repeatCount = .infinity
        scale.autoreverses = true
        scale.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        dot.add(scale, forKey: "dotScale")
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.2
        fade.duration = 0.33
        fade.beginTime = CACurrentMediaTime() + 0.33
        fade.repeatCount = .infinity
        fade.autoreverses = true
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        dot.add(fade, forKey: "dotOpacity")
        
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.fromValue = UIColor.magenta.cgColor
        tint.toValue = UIColor.cyan.cgColor
        tint.duration = 0.66
        tint.beginTime = CACurrentMediaTime() + 0.28
        tint.repeatCount = .infinity
        tint.autoreverses = true
        tint.fillMode = kCAFillModeBackwards
        tint.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        dot.add(tint, forKey: "dotColor")
        
    }
    
    func endSpeaking() {
        
    }
}
