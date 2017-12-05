//
//  DrawerContainerView.swift
//  ios-sample-drawer
//
//  Created by Owen on 2017/12/05.
//  Copyright © 2017年 owen. All rights reserved.
//

import Foundation
import UIKit

class DrawerContainerView: UIView {
    fileprivate let sampleTextAnimationKey = "SampleTextLabelRotation"
    @IBOutlet weak var sampleTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    fileprivate func initUI() {
        guard let view = UINib(nibName: "DrawerContainerView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        self.addSubview(view)
    }
    
    @IBAction func didTapSushi(_ sender: Any) {
        if let _ = self.sampleTextLabel.layer.animation(forKey: self.sampleTextAnimationKey) {
            self.sampleTextLabel.layer.removeAnimation(forKey: self.sampleTextAnimationKey)
        } else {
            //  🍣
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = .pi / 2.0
            animation.duration = 0.3
            animation.isCumulative = true
            animation.repeatCount = .infinity
            self.sampleTextLabel.layer.add(animation, forKey: self.sampleTextAnimationKey)
        }
    }
}
