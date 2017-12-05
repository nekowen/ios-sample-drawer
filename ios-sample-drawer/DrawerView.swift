//
//  DrawerView.swift
//  ios-sample-drawer
//
//  Created by Owen on 2017/12/05.
//  Copyright © 2017年 owen. All rights reserved.
//

import Foundation
import UIKit

class DrawerView: UIView {
    let drawerHeight: CGFloat = 390 // ドロワーの高さ(コンテナ + スクロール余剰分)
    let drawerContainerHeight: CGFloat = 320 // ドロワーコンテンツ内の高さ(開いた時の高さ)
    let drawerHeightClose: CGFloat = 96 // 閉じた時の高さ
    
    fileprivate var savedDrawerBottomConstant: CGFloat = 0
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerContainerHeightConstraint: NSLayoutConstraint!
    
    var backgroundViewAlpha: CGFloat? {
        get {
            return self.backgroundView.backgroundColor?.cgColor.alpha
        }
        set {
            let newColor = self.backgroundView.backgroundColor?.withAlphaComponent(newValue ?? 0.0)
            self.backgroundView.backgroundColor = newColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //  drawerView内のタップイベントを通さない
        if drawerView.frame.contains(point) {
            return true
        }
        
        //  drawerViewが開いている時はタップイベントを通さない
        if backgroundView.frame.contains(point) && self.backgroundViewAlpha != 0.0 {
            return true
        }
        
        return false
    }
    
    fileprivate func initUI() {
        guard let view = UINib(nibName: "DrawerView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        self.drawerHeightConstraint.constant = self.drawerHeight
        self.drawerContainerHeightConstraint.constant = self.drawerContainerHeight
        self.drawerBottomConstraint.constant = -self.drawerHeight
        self.addSubview(view)
    }
    
    //  ドロワーを開く
    internal func open() {
        self.drawerBottomConstraint.constant = -self.drawerHeight + self.drawerContainerHeight
        self.animateBackgroundColorIfNeeded()
        self.animateLayoutIfNeeded()
    }
    
    //  ドロワーを閉じる
    internal func close() {
        self.drawerBottomConstraint.constant = -self.drawerHeight + self.drawerHeightClose
        self.animateBackgroundColorIfNeeded()
        self.animateLayoutIfNeeded()
    }
    
    @IBAction func didPanGesture(_ sender: Any) {
        guard let recognizer = sender as? UIPanGestureRecognizer else {
            return
        }
        
        let translation = recognizer.translation(in: self)
        switch (recognizer.state) {
        case .began:
            self.savedDrawerBottomConstant = self.drawerBottomConstraint.constant
        case .ended:
            if translation.y >= 0 {
                self.close()
            } else {
                self.open()
            }
        default:
            var offset = CGFloat(self.savedDrawerBottomConstant - translation.y)
            if offset > 0 {
                offset = 0
            }
            self.drawerBottomConstraint.constant = offset
            self.animateBackgroundColorIfNeeded()
        }
    }
    
    fileprivate func animateLayoutIfNeeded() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func animateBackgroundColorIfNeeded() {
        let constant = self.drawerBottomConstraint.constant
        let diffHeight = (self.drawerHeight - self.drawerHeightClose)
        let diffContainerHeight = (self.drawerContainerHeight - self.drawerHeightClose)
        var alpha = (diffHeight + constant) / diffContainerHeight * 0.5
        //  Limit Alpha
        alpha = min(max(0.0, alpha), 0.4)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundViewAlpha = alpha
        }
    }
}
