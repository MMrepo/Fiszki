//
//  FlashcardLogoView.swift
//  FlashcardLogoView
//
//  Created by Mateusz Małek on 18.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import PocketSVG
import Arithmos

public class FlashcardLogoView: UIView {
   
   private let animationsOriginalFrame: CGRect
   private let animations: [UIBezierPath]
   private let containerLayer: CALayer
   private let cardsRange: CountableClosedRange<Int>
   private let lettersRange: CountableClosedRange<Int>
   
   @objc dynamic public var firstCardColor: UIColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0) {
      didSet {
         updateColors()
      }
   }
   @objc dynamic public var secondCardColor: UIColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0) {
      didSet {
         updateColors()
      }
   }
   @objc dynamic public var thirdCardColor: UIColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0) {
      didSet {
         updateColors()
      }
   }
   @objc dynamic public var fontColor: UIColor = .white {
      didSet {
         updateColors()
      }
   }
   
   public init() {
      let bundle = Bundle(for: type(of: self))
      let urlLogo = bundle.url(forResource: "FlashcardsLogo3", withExtension: "svg")!
      let animations = SVGBezierPath.pathsFromSVG(at: urlLogo)
      
      containerLayer = CALayer()
      let frame = animations.first!
      self.animations = Array(animations.dropFirst())
      animationsOriginalFrame = frame.bounds
      cardsRange = 0...2
      lettersRange = 3...animations.count-2

      super.init(frame: .zero)
      
      self.layer.addSublayer(containerLayer)
      for path in self.animations {
         let layer = CAShapeLayer()
         layer.path = path.cgPath
         layer.lineWidth = 1
         layer.fillColor = fontColor.withAlphaComponent(0).cgColor
         layer.strokeColor = fontColor.cgColor
         layer.strokeEnd = 0
         containerLayer.addSublayer(layer)
      }
   }
   
   public func startAnimation(withDelay delay:TimeInterval = 0.3) {
       for layer in containerLayer.sublayers! {
         if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
            layer.removeAllAnimations()
         }
      }
      self.layoutIfNeeded()
      
      let animationContour = self.strokeEndAnimation
      let animationFill = self.fillAnimation
      let animationPosition = self.positionAnimation
      let colors = [firstCardColor, secondCardColor, thirdCardColor]
      var startTime = delay
      
      startTime = addAnimationsForCards(animationFill, animationPosition, startTime: startTime, colors: colors)
      startTime += 0.2
      animationFill.duration =  0.5
      animationContour.duration =  0.5
      startTime = addAnimationsForLetters(animationContour, animationFill, startTime: startTime)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   } 
   
   override public func layoutSublayers(of layer: CALayer) {
      super.layoutSublayers(of: layer)
      guard let sublayers = containerLayer.sublayers else {
         return
      }
      
      let scaleW = (self.bounds.width/animationsOriginalFrame.width)
      let scaleH = (self.bounds.height/animationsOriginalFrame.height)
      let scale = scaleW < scaleH ? scaleW : scaleH
      
      containerLayer.frame = CGRect(x: 0, y: 0, width: animationsOriginalFrame.width*scale, height: animationsOriginalFrame.height*scale)
      containerLayer.frame.center = layer.bounds.center

      for (index, layer) in sublayers.enumerated() {
         guard let layer = layer as? CAShapeLayer else {
            return
         }
         let path = animations[index].copy() as! UIBezierPath
         path.scale(factor: scale)
         layer.path = path.cgPath
      }
   }
}

//MARK: - Default animations
private extension FlashcardLogoView {
   var strokeEndAnimation: CABasicAnimation {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0.0
      animation.toValue = 1.0
      animation.duration =  0.7
      animation.beginTime = 0
      animation.isRemovedOnCompletion = false
      animation.fillMode = kCAFillModeForwards
      return animation
   }
   
   var fillAnimation: CABasicAnimation {
      let animation = CABasicAnimation(keyPath: "fillColor")
      animation.fromValue = fontColor.withAlphaComponent(0).cgColor
      animation.toValue = fontColor.withAlphaComponent(1).cgColor
      animation.duration = 0.5
      animation.beginTime = 0
      animation.isRemovedOnCompletion = false
      animation.fillMode = kCAFillModeForwards
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
      return animation
   }
   
   var positionAnimation: CABasicAnimation {
      let animation = CABasicAnimation(keyPath: "position.y")
      animation.fromValue = -UIScreen.main.bounds.height
      animation.duration =  0.2
      animation.beginTime = 0
      animation.isRemovedOnCompletion = false
      animation.fillMode = kCAFillModeForwards
      return animation
   }
}

//MARK: - Helpers
private extension FlashcardLogoView {
   func updateColors() {
      for layer in containerLayer.sublayers! {
         guard let _ = layer.animationKeys() else {
            return
         }
      }
      startAnimation()
   }
   
   func addAnimationsForLetters(_ animationContour: CABasicAnimation, _ animationFill: CABasicAnimation, startTime: TimeInterval) -> TimeInterval {
      var beginTime = startTime
      for index in lettersRange {
         let layer = containerLayer.sublayers![index] as! CAShapeLayer
         layer.strokeColor = fontColor.cgColor
         animationContour.beginTime =  CACurrentMediaTime() + beginTime
         beginTime += 0.25
         animationFill.beginTime =  CACurrentMediaTime() + beginTime
         animationFill.fromValue = fontColor.withAlphaComponent(0).cgColor
         animationFill.toValue = fontColor.withAlphaComponent(1).cgColor
         layer.add(animationContour, forKey:  "animationContour")
         layer.add(animationFill, forKey:  "animationFill")
      }
      return beginTime
   }
   
   func addAnimationsForCards(_ animationFill: CABasicAnimation,_ animationPosition: CABasicAnimation, startTime: TimeInterval, colors: [UIColor]) -> TimeInterval {
      var beginTime = startTime
      for index in cardsRange {
         let layer = containerLayer.sublayers![index] as! CAShapeLayer
         animationFill.beginTime =  CACurrentMediaTime() + beginTime
         animationPosition.beginTime =  CACurrentMediaTime() + beginTime
         animationPosition.toValue = layer.presentation()?.position.y
         
         beginTime += 0.5
         animationFill.fromValue = colors[index].withAlphaComponent(0.4).cgColor
         animationFill.toValue = colors[index].withAlphaComponent(1).cgColor
         layer.add(animationPosition, forKey:  "positionAnimation")
         layer.add(animationFill, forKey:  "animationFill")
         
         layer.shadowColor = UIColor.black.cgColor
         layer.shadowRadius = 4
         layer.shadowOpacity = 0.8
         layer.shadowOffset = CGSize(width: 2, height: 3)
      }
      return beginTime
   }
}

private extension UIBezierPath
{
   func scale(factor: CGFloat)
   {
      let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
      self.apply(scaleTransform)
   }
}
