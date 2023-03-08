//
//  ViewController.swift
//  CAMediaTimingDemo
//
//  Created by huangzhenda on 2023/3/8.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var needleImageView: UIImageView!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var offsetSlider: UISlider!
    @IBOutlet weak var beginTimeTextField: UITextField!
    @IBOutlet weak var localTimeLabel: UILabel!
    @IBOutlet weak var timeOffsetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.createDisplayLink()
    }
    
    private func createDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(self.linkTriggered(_:)))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func linkTriggered(_ displaylink: CADisplayLink) {
        
        let currentTime =  self.needleImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
        let localTime = "local time: \(currentTime)\n"
        let speed = "speed: \(self.needleImageView.layer.speed)\n"
        let beginTime = "beginTime: \(self.needleImageView.layer.beginTime)\n"
        let timeOffset = "time offset: \(self.needleImageView.layer.timeOffset)\n"
        let duration = "duration: \(self.needleImageView.layer.duration)\n"
        let animation = "animation: \(self.needleImageView.layer.animation(forKey: "rotationAnimation"))\n"
        self.localTimeLabel.text = localTime + speed + beginTime + timeOffset + duration + animation
                
    }


    @IBAction func buttonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            self.play(isReverses: false)
        }else{
            self.play(isReverses: true)
        }
    }
    
    @IBAction func changeBeginTime(_ sender: Any) {
        
        if self.beginTimeTextField.text?.isEmpty == false {
            let time = CFTimeInterval(Double(self.beginTimeTextField.text!)!)
            self.needleImageView.layer.beginTime = time
        }else{
            self.needleImageView.layer.beginTime = 0
        }
    }
    
    @IBAction func changeOffsetTme(_ sender: Any) {
        if self.timeOffsetTextField.text?.isEmpty == false {
            let time = CFTimeInterval(Double(self.timeOffsetTextField.text!)!)
            self.needleImageView.layer.timeOffset = time
        }else{
            self.needleImageView.layer.timeOffset = 0
        }
    }
    
    var animationBeginTime : CFTimeInterval = 0.0
    func play(isReverses:Bool) {
        
        self.needleImageView.layer.removeAllAnimations()
        let animation = self.getNeedleRotationAnimation(true)
        
        
        let layerCurrentTime = self.needleImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
        let animationDuration = layerCurrentTime - animationBeginTime
        if animationDuration < animation.duration {
            animation.beginTime =  layerCurrentTime  - (animation.duration - animationDuration)
            self.animationBeginTime = animation.beginTime
        }else{
            self.animationBeginTime = layerCurrentTime
        }
        animation.speed = isReverses ? -1 : 1
        self.needleImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    
    //MARK: -
    func getNeedleRotationAnimation(_ start:Bool) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        if start == true {
            animation.fromValue = NSNumber(value: 0)
            animation.toValue = NSNumber(value: Double.pi / 6.0)
        }else{
            animation.toValue = NSNumber(value: 0)
            animation.fromValue = NSNumber(value: Double.pi / 6.0)
        }
        
        animation.duration = 3
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        return animation
    }

    
    @IBAction func speedSliderValueChange(_ sender: UISlider) {
        
        self.needleImageView.layer.speed = sender.value
    }
    
    @IBAction func timeOffsetValueChange(_ sender: UISlider) {
        self.needleImageView.layer.timeOffset = 3 *  CFTimeInterval(sender.value)
    }
}

