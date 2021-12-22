//
//  ZLProgressHUD.swift
//  ZLPhotoBrowser
//
//  Created by long on 2020/8/17.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class ZLProgressHUD: NSObject {

    @objc public enum HUDStyle: Int {
        
        case light
        
        case lightBlur
        
        case dark
        
        case darkBlur
        
        func bgColor() -> UIColor {
            switch self {
            case .light:
                return .white
            case .dark:
                return .darkGray
            default:
                return .clear
            }
        }
        
        func textColor() -> UIColor {
            switch self {
            case .light, .lightBlur:
                return .black
            case .dark, .darkBlur:
                return .white
            }
        }
        
        func indicatorStyle() -> UIActivityIndicatorView.Style {
            switch self {
            case .light, .lightBlur:
                return .gray
            case .dark, .darkBlur:
                return .white
            }
        }
        
        func blurEffectStyle() -> UIBlurEffect.Style? {
            switch self {
            case .light, .dark:
                return nil
            case .lightBlur:
                return .extraLight
            case .darkBlur:
                return .dark
            }
        }
        
    }
    
    let style: ZLProgressHUD.HUDStyle
    
    var timeoutBlock: ( () -> Void )?
    
    var timer: Timer?
    
    deinit {
        self.cleanTimer()
    }
    
    @objc public init(style: ZLProgressHUD.HUDStyle) {
        self.style = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    @objc public func show(timeout: TimeInterval = 100) {
        if timeout > 0 {
            self.cleanTimer()
            self.timer = Timer.scheduledTimer(timeInterval: timeout, target: ZLWeakProxy(target: self), selector: #selector(timeout(_:)), userInfo: nil, repeats: false)
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
    @objc public func hide() {
        self.cleanTimer()
    }
    
    @objc func timeout(_ timer: Timer) {
        self.timeoutBlock?()
        self.hide()
    }
    
    func cleanTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}
