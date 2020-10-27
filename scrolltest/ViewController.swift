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
    
    var addPointY: CGFloat = 10000
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
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 120
            // 一定速度アニメーション
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            var nextPoint = self.clipView.bounds.origin
            nextPoint.y = (self.addPointY * CGFloat(self.count))
            self.clipView.animator().setBoundsOrigin(nextPoint)
            self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
        }, completionHandler: {
        })
        
        if self.count == 1 {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                guard let clipView = self.clipView.layer?.presentation() else {
                    self.stopAnimation()
                    return
                }
                
                // アニメーション中の値を取得する場合はlayer.presentationを使用
                let pt = clipView.bounds.origin
                
                if (pt.y + self.clipView.bounds.height) >= self.textView.bounds.height {
                    self.stopAnimation()
                }
            })
        }
    }
    
    func stopAnimation() {
        print("stopAnimation")
        
        self.count = 0
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        let nextPoint = self.clipView.bounds.origin
        self.clipView.animator().setBoundsOrigin(nextPoint)
        //self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
        NSAnimationContext.endGrouping()
        
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

