//
//  CardsCollectionViewLayout2.swift
//  MainModule
//
//  Created by Mateusz Małek on 21.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import PocketTool
import Arithmos

protocol FlipableCell {
   var isFlipped: Bool { get }
   func flip(withAnimation: Bool, to: Bool?)
}

private struct Card: Equatable {
   static func ==(lhs: Card, rhs: Card) -> Bool {
      return lhs.indexPath == rhs.indexPath
   }
   
   var indexPath: IndexPath
   static var size: CGSize = .zero
   var rotation: CGFloat = 0
   
   init(indexPath: IndexPath) {
      self.indexPath = indexPath
   }
}

private protocol CardStack: class {
   var cards: [Card] {get set}
   var topCard: Card? {get}
   var visibleCards: Int {get}
   var position: CGPoint {get set}
   func take(card: Card) -> Card?
   func add(card: Card)
   func frameFor(card: Card) -> CGRect?
   func rotationFor(card: Card) -> CGFloat?
   func attributes(for card:Card) -> UICollectionViewLayoutAttributes?
   var attributes: [UICollectionViewLayoutAttributes] {get}
}

extension CardStack {
   func take(card: Card) -> Card? {
      guard let index = cards.index(of: card) else {
         return nil
      }
      cards.remove(at: index)
      return card
   }
   
   func attributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cards.filter({ $0.indexPath == indexPath }).first.flatMap({ attributes(for: $0)})
   }
   
   var attributes: [UICollectionViewLayoutAttributes] {
      return cards.flatMap({ attributes(for: $0)})
   }
}

private class FirstStack: CardStack {
   var cards: [Card] = []
   var visibleCards = 4
   let varticalOffsetBetweenCards:CGFloat = 10
   var position: CGPoint
   
   init(position: CGPoint) {
      self.position = position
   }
   
   func frameFor(card: Card) -> CGRect? {
      guard let index = cards.index(of: card) else {
         return nil
      }
      let visibleCardIndex = index < visibleCards ? index : visibleCards-1
      var frame = CGRect(origin: .zero, size: Card.size)
      let yPosition = position.y - varticalOffsetBetweenCards*CGFloat(visibleCardIndex)
      frame.center = CGPoint(x: position.x, y: yPosition)
      return frame
   }
   
   func rotationFor(card: Card) -> CGFloat? {
      guard cards.contains(card) else {
         return nil
      }
      return 0
   }
   
   func attributes(for card: Card) -> UICollectionViewLayoutAttributes? {
      guard let cardIndex = cards.index(of: card) else {
         return nil
      }
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: card.indexPath)
      attributes.frame = frameFor(card: card) ?? attributes.frame
      attributes.isHidden = cardIndex >= visibleCards + 1 // hack for allowing custom animation on taking card out
      attributes.zIndex = -cardIndex
      return attributes
   }
   
   var topCard: Card? {
      return cards.first
   }
   
   func add(card: Card) {
      cards.insert(card, at: 0)
   }
}

fileprivate class SecondStack: CardStack {
   
   var cards: [Card] = []
   var visibleCards = 30
   var position: CGPoint
   
   init(position: CGPoint) {
      self.position = position
   }
   
   func frameFor(card: Card) -> CGRect? {
      guard cards.contains(card) else {
         return nil
      }
      var frame = CGRect(origin: .zero, size: Card.size)
      frame.center = position
      return frame
   }
   
   func rotationFor(card: Card) -> CGFloat? {
      guard cards.contains(card) else {
         return nil
      }
      return card.rotation
   }
   
   func attributes(for card: Card) -> UICollectionViewLayoutAttributes? {
      guard let cardIndex = cards.index(of: card) else {
         return nil
      }
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: card.indexPath)
      attributes.frame = frameFor(card: card) ?? attributes.frame
      let rotation = rotationFor(card: card) ?? 0
      attributes.transform3D = CATransform3DMakeRotation(rotation, 0, 0, 1)
      attributes.isHidden = cardIndex >= visibleCards
      attributes.zIndex = cardIndex
      return attributes
   }
   
   var topCard: Card? {
      return cards.last
   }
   
   func add(card: Card) {
      cards.append(card)
   }
}

open class CardsCollectionViewLayout: UICollectionViewLayout {
   
   private let firstStack = FirstStack(position: .zero)
   private let secondStack = SecondStack(position: .zero)
   private var animator: UIDynamicAnimator!
   private var panGestureRecognizer: UIPanGestureRecognizer?
   private var tapGestureRecognizer: UITapGestureRecognizer?
   private var dragAttachementBehaviour: UIAttachmentBehavior!
   private var takenCard: Card?
   
   public override init() {
      super.init()
   }
   
   public func setup() {
      let items = collectionView!.numberOfItems(inSection: 0)
      (0...items-1).forEach { [unowned self] (item) in
         let card = Card(indexPath: IndexPath(item: item, section: 0))
         self.firstStack.add(card: card)
      }
      
      let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
      collectionView?.addGestureRecognizer(recognizer)
      panGestureRecognizer = recognizer
      panGestureRecognizer!.delegate = self
      
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
      collectionView?.addGestureRecognizer(tapGestureRecognizer!)
      tapGestureRecognizer!.delegate = self
      
      animator = UIDynamicAnimator(collectionViewLayout: self)
      animator?.delegate = self
      
      NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: UIDevice.current)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: - UICollectionViewLayout provide layout attributes
   override open var collectionViewContentSize : CGSize {
      return collectionView!.frame.size
   }
   
   open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      calculatePositions()
      
      var attributes: [UICollectionViewLayoutAttributes] = []
      attributes += layoutAttributesFor(stack: firstStack) ?? []
      attributes += layoutAttributesFor(stack: secondStack) ?? []
      
      return attributes
   }
   
   open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      if let layoutAttributes = animator?.layoutAttributesForCell(at:indexPath) {
         return layoutAttributes
      }
      
      return firstStack.attributes(at: indexPath) ?? secondStack.attributes(at: indexPath)
   }
}

private extension CardsCollectionViewLayout {
   // MARK: - helpers
   @objc func orientationChanged(notification: NSNotification) {
      animator?.removeAllBehaviors()
   }
   
   func layoutAttributesFor(stack: CardStack) -> [UICollectionViewLayoutAttributes]? {
      var attributes: [UICollectionViewLayoutAttributes] = []
      stack.cards.forEach { [unowned self] (card) in
         guard let cardAttributes = self.layoutAttributesForItem(at: card.indexPath) else {
            return
         }
         attributes.append(cardAttributes)
      }
      return attributes
   }
   
   func autoCardSize() -> CGSize {
      let cardAspectRatio:CGFloat = 4/3
      var dimmension = collectionViewContentSize.width < collectionViewContentSize.height ? collectionViewContentSize.width : collectionViewContentSize.height
      dimmension = dimmension > 420 ? dimmension / 2 : dimmension - 80
      return CGSize(width: dimmension, height: dimmension / cardAspectRatio)
   }
   
   func calculatePositions() {
      Card.size = autoCardSize()
      if collectionViewContentSize.width < collectionViewContentSize.height {
         firstStack.position = CGPoint(x: collectionViewContentSize.width/2, y: collectionViewContentSize.height/4)
         secondStack.position = CGPoint(x: collectionViewContentSize.width/2, y: 3*collectionViewContentSize.height/4)
      } else {
         firstStack.position = CGPoint(x: collectionViewContentSize.width/4, y: collectionViewContentSize.height/2)
         secondStack.position = CGPoint(x: 3*collectionViewContentSize.width/4, y: collectionViewContentSize.height/2)
      }
   }
}

private extension CardsCollectionViewLayout {
   // MARK: - Handling the Pan Gesture
   @objc func handleTap(_ sender: UIPanGestureRecognizer) {
      let location = sender.location(in: collectionView)
      guard let indexPath = collectionView?.indexPathForItem(at: location), firstStack.topCard?.indexPath == indexPath, let cell = cellAt(location: location) as? FlipableCell else {
         return
      }
      
      cell.flip(withAnimation: true, to: nil)
   }
   
   @objc func handlePan(_ sender: UIPanGestureRecognizer) {
      let location = sender.location(in: collectionView)
      
      if let indexPath = collectionView?.indexPathForItem(at: location), takenCard == nil  {
         guard firstStack.topCard?.indexPath == indexPath || secondStack.topCard?.indexPath == indexPath else {
            return
         }
      }
      
      if let card = takenCard, let takenCardAttributes = layoutAttributesForItem(at: card.indexPath) {
         moveCardToFront(withAttributes: takenCardAttributes)
      }
      
      if (sender.state == .began) {
         handlePanBeginState(sender: sender)
      } else if (sender.state == .changed) {
         dragAttachementBehaviour?.anchorPoint = location
      } else {
         handlePanEndState(sender: sender)
         animator?.removeBehavior(dragAttachementBehaviour)
      }
   }
   
   // MARK: - helpers
   func moveCardToFront(withAttributes attributes:UICollectionViewLayoutAttributes) {
      attributes.zIndex = 1000
   }
   
   func cellAt(location: CGPoint) -> UICollectionViewCell? {
      guard let indexPath = collectionView?.indexPathForItem(at: location) else {
         return nil
      }
      return collectionView?.cellForItem(at: indexPath)
   }
   
   func handlePanBeginState(sender: UIPanGestureRecognizer) {
      animator?.removeAllBehaviors()
      let location = sender.location(in: collectionView)
      guard let indexPath = collectionView?.indexPathForItem(at: location),  let attributes = layoutAttributesForItem(at: indexPath), let cell = cellAt(location:location) else {
         return
      }
      
      let cellLocation = sender.location(in: cell)
      let offset = UIOffset(horizontal: cellLocation.x - cell.bounds.midX, vertical: cellLocation.y - cell.bounds.midY)
      
      dragAttachementBehaviour = UIAttachmentBehavior(item: attributes, offsetFromCenter: offset, attachedToAnchor: location)
      dragAttachementBehaviour.length = 0.0
      dragAttachementBehaviour.frictionTorque = 100.0
      animator?.addBehavior(dragAttachementBehaviour)
      
      let cardStack: CardStack
      if self.firstStack.topCard?.indexPath == indexPath {
         cardStack = self.firstStack
      } else if self.secondStack.topCard?.indexPath == indexPath {
         cardStack = self.secondStack
      } else {
         return
      }
      takenCard = cardStack.topCard
   }
   
   func lerpAngle(from: CGFloat, to: CGFloat, progress:CGFloat) -> CGFloat {
      return (1 - progress) * from + progress * to
   }
   
   func addSnapFor(item: UICollectionViewLayoutAttributes, to destinationPoint: CGPoint, destinationRotation: CGFloat) {
      let snapBehaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
      let dynamicItemBehavior = UIDynamicItemBehavior(items: [item])
      
      dynamicItemBehavior.resistance = 4
      dynamicItemBehavior.allowsRotation = false
      
      animator?.addBehavior(snapBehaviour)
      snapBehaviour.addChildBehavior(dynamicItemBehavior)
      
      snapBehaviour.frequency = 1.2
      snapBehaviour.damping = 0.4
      snapBehaviour.anchorPoint = destinationPoint
      
      let startDistance = item.center.distance(to: snapBehaviour.anchorPoint)
      let startRotation = self.currentRotationForCell(at: item.indexPath)
      
      snapBehaviour.action = { [unowned self] in
         guard let currentAttributes = self.layoutAttributesForItem(at: item.indexPath) else  {
            return
         }
         
         let distance = startDistance - currentAttributes.center.distance(to: snapBehaviour.anchorPoint)
         let progress = CGFloat((0...startDistance).remap(distance, in: 0...1))
         let rotation:CGFloat = self.lerpAngle(from: startRotation, to: destinationRotation, progress: progress)
         currentAttributes.transform3D = CATransform3DMakeRotation(rotation, 0, 0, 1)
         self.animator?.updateItem(usingCurrentState: currentAttributes)
      }
   }
   
   func handlePanEndState(sender: UIPanGestureRecognizer) {
      guard let indexPath = takenCard?.indexPath,  let cardAttributes = layoutAttributesForItem(at: indexPath) else {
         return
      }
      
      let cardStack: CardStack
      var destinationCardStack: CardStack
      let isOnFirstStack: Bool
      if self.firstStack.topCard?.indexPath == indexPath {
         cardStack = self.firstStack
         destinationCardStack = self.secondStack
         isOnFirstStack = true
      } else if self.secondStack.topCard?.indexPath == indexPath {
         cardStack = self.secondStack
         destinationCardStack = self.firstStack
         isOnFirstStack = false
      } else {
         return
      }
      
      let returnPosition:CGPoint = cardStack.position
      let shouldSnapBack = cardAttributes.center.distance(to: returnPosition) < Card.size.height/2
      if shouldSnapBack {
         destinationCardStack = cardStack
      }
      let destinationCardPosition:CGPoint = destinationCardStack.position
      
      var rotation = currentRotationForCell(at: indexPath)
      var card = takenCard!
      card = cardStack.take(card: card)!
      animateCardsPositionOn(stack: cardStack, without: card)
      
      rotation = (isOnFirstStack && !shouldSnapBack) || (!isOnFirstStack && shouldSnapBack) ? (-CGFloat.pi...CGFloat.pi).remap(rotation, in: -0.4...0.4) : 0
      card.rotation = rotation
      
      addSnapFor(item: cardAttributes, to: destinationCardPosition, destinationRotation: card.rotation)
      destinationCardStack.add(card: card)
      takenCard = nil
      
      animateCardsPositionOn(stack: destinationCardStack, without: card)
   }
   
   func animateCardsPositionOn(stack: CardStack, without card: Card) {
      for cardToAnimation in stack.cards {
         guard cardToAnimation != card, let attributes = stack.attributes(for: cardToAnimation), let cell = collectionView!.cellForItem(at: cardToAnimation.indexPath)  else {
            continue
         }
         UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            cell.center = attributes.center
         })
      }
   }
   
   func currentRotationForCell(at indexPath: IndexPath) -> CGFloat {
      guard let cell = collectionView!.cellForItem(at: indexPath) else {
         return 0
      }
      let transform = cell.transform
      return atan2(transform.b, transform.a)
   }
}

extension CardsCollectionViewLayout: UIGestureRecognizerDelegate {
   //MARK: - UIGestureRecognizerDelegate
   open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
      -> Bool {
         return false
   }
}

extension CardsCollectionViewLayout: UIDynamicAnimatorDelegate {
   //MARK: - UIDynamicAnimationDelegate
   public func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
   }
   
   public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
      if animator.behaviors.contains(dragAttachementBehaviour) {
         return
      }
      
      animator.removeAllBehaviors()
      collectionView?.performBatchUpdates({
         _ = self.invalidateLayout()
      }, completion: { (Bool) in
      })
   }
}
