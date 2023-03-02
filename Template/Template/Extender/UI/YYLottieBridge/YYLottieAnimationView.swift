//
//  YYLottieAnimationView.swift
//  Template
//
//  Created by nevsee on 2021/12/29.
//

import Foundation
import UIKit
import Lottie

@objcMembers class YYLottieAnimationView : UIView {
    let lottieView = AnimationView()
    
    public var isAnimationPlaying: Bool {
        lottieView.isAnimationPlaying
    }
    
    public var fileName: String? {
        didSet {
            if fileName == nil { return }
            lottieView.animation = Animation.named(fileName!)
        }
    }

    public var animationSpeed: CGFloat = 1 {
        didSet {
            lottieView.animationSpeed = animationSpeed
        }
    }
    
    public var animationScale: CGFloat = 1 {
        didSet {
            self.transform = CGAffineTransform.init(scaleX: animationScale, y: animationScale);
        }
    }
    
    public var currentProgress: AnimationProgressTime {
        set {
            lottieView.currentProgress = newValue
        }
        get {
            return lottieView.currentProgress
        }
    }
    
    public var loopMode: LottieLoopMode = .loop {
        didSet {
            lottieView.loopMode = loopMode
        }
    }

    public override var contentMode: UIView.ContentMode {
      didSet {
          lottieView.contentMode = contentMode
      }
    }

    public init() {
        super.init(frame: .zero)
        lottieView.loopMode = .loop
        lottieView.contentMode = .center
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(lottieView)
    }
    
    public init(fileName: String) {
        super.init(frame: .zero)
        lottieView.animation = Animation.named(fileName)
        lottieView.loopMode = .loop
        lottieView.contentMode = .center
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.fileName = fileName
        self.addSubview(lottieView)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lottieView.loopMode = .loop
        lottieView.contentMode = .center
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(lottieView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        lottieView.loopMode = .loop
        lottieView.contentMode = .center
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(lottieView)
    }

    public func play() {
        self.play(completion: nil)
    }
    
    public func play(completion: LottieCompletionBlock? = nil) {
        lottieView.play(completion: completion)
    }
    
    public func play(
      fromProgress: AnimationProgressTime? = nil,
      toProgress: AnimationProgressTime,
      loopMode: LottieLoopMode? = nil,
      completion: LottieCompletionBlock? = nil) {
        lottieView.play(fromProgress: fromProgress, toProgress: toProgress, loopMode: loopMode, completion: completion)
    }
    
    public func stop() {
        lottieView.stop()
    }
        
    public func pause() {
        lottieView.pause()
    }
    
    public func setColorValueProvider(colorValue: UIColor, keypath: String) {
        let lottieKeypath = AnimationKeypath.init(keypath: keypath)
        let lottieValueProvider = ColorValueProvider.init(colorValue.lottieColorValue)
        lottieView.setValueProvider(lottieValueProvider, keypath: lottieKeypath)
    }
    
    public func setFloatValueProvider(floatValue: CGFloat, keypath: String) {
        let lottieKeypath = AnimationKeypath.init(keypath: keypath)
        let lottieFloatProvider = FloatValueProvider.init(floatValue)
        lottieView.setValueProvider(lottieFloatProvider, keypath: lottieKeypath)
    }
    
    public func setGradientValueProvider(_ colors: [UIColor], locations: [Double] = [], keypath: String) {
        let lottieKeypath = AnimationKeypath.init(keypath: keypath)
        var lottieColors = [Color]()
        for color in colors {
            lottieColors.append(color.lottieColorValue)
        }
        let lottieGradientProvider = GradientValueProvider.init(lottieColors, locations: locations)
        lottieView.setValueProvider(lottieGradientProvider, keypath: lottieKeypath)
    }
    
    public func setSizeValueProvider(sizeValue: CGSize, keypath: String) {
        let lottieKeypath = AnimationKeypath.init(keypath: keypath)
        let lottieSizeProvider = SizeValueProvider.init(sizeValue)
        lottieView.setValueProvider(lottieSizeProvider, keypath: lottieKeypath)
    }

    /// 改变所有元素颜色
    public func changeAllElementColor(color: UIColor) {
        self.setColorValueProvider(colorValue: color, keypath: "**.Color")
    }
    
    /// 改变所有元素透明度（0 ~ 100）
    public func changeAllElementOpacity(opacity: CGFloat) {
        self.setFloatValueProvider(floatValue: opacity, keypath: "**.Opacity")
    }
}
