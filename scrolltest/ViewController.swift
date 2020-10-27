//
//  ViewController.swift
//  scrolltest
//
//  Created by tsuyoshi on 2020/10/24.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var clipView: NSClipView!
    @IBOutlet var textView: NSTextView!
    
    var duration: Double = 5
    var addPointY: CGFloat = 100
    var count = 0;
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...100 {
            textView.insertText("\(i)行目\n", replacementRange: NSMakeRange(-1, 0))
        }
    }
    
    @IBAction func didTouchButton(_ sender: Any) {
        self.scrollToCursor()
    }
    
    @IBAction func didTouchCancel(_ sender: Any) {
        print("didTouchCancel")
        self.stopAnimation()
    }
    
    func scrollToCursor() {
        print("scrollToCursor:")
        
        self.count += 1
        
        /*
        // CABasicAnimation
        // スクロールはできたけど、テキストビュー側の表示がうまくいかない
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 120
        //animation.repeatCount = .infinity
        var b = self.clipView.bounds
        animation.fromValue = b
        b.origin.y = (self.addPointY * CGFloat(self.count))
        animation.toValue = b
        animation.autoreverses = true
        self.clipView.layer?.add(animation, forKey: "test")
         */
        
        self.startAnimation()
        
        if self.count != 1 {
            return
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            print("timer event")
            
            // アニメーション中の値を取得する場合はlayer.presentationを使用
            guard let clipView = self.clipView.layer?.presentation() else {
                self.stopAnimation()
                return
            }
            
            let origin = clipView.bounds.origin
            
            // 最下部まで到達した場合
            if (origin.y + self.clipView.bounds.height) >= self.textView.bounds.height {
                self.stopAnimation()
                return
            }
        })
        
        /*
        // 上書きバージョン
         // ストップが・・・
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            guard let clipView = self.clipView.layer?.presentation() else {
                self.stopAnimation()
                return
            }
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 1
                // 一定速度アニメーション
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                var nextPoint = clipView.bounds.origin
                nextPoint.y += (100 * CGFloat(self.count))
                self.clipView.animator().setBoundsOrigin(nextPoint)
            }, completionHandler: {
            })

            // アニメーション中の値を取得する場合はlayer.presentationを使用
            let pt = clipView.bounds.origin
            
            if (pt.y + self.clipView.bounds.height) >= self.textView.bounds.height {
                self.stopAnimation()
            }
        })
        */
        
    }
    
    func startAnimation() {
        print("animation")
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = self.duration
            // 一定速度アニメーション
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            var origin = self.clipView.bounds.origin
            origin.y += (self.addPointY * CGFloat(self.count))
            self.clipView.animator().setBoundsOrigin(origin)
            //self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
        }, completionHandler: {
            print("completionHandler")
            
            if let timer = self.timer {
                if timer.isValid {
                    print("restart")
                    self.startAnimation()
                }
            }
        })
    }
    
    func stopAnimation() {
        print("stopAnimation")
        
        self.count = 0
        
        // stop animation
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            self.clipView.animator().setBoundsOrigin(self.clipView.bounds.origin)
        }, completionHandler: {
        })
        
        if let timer = self.timer {
            timer.invalidate()
            print("stop timer")
        }
        
        self.timer = nil
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
}

