//
//  FlashcardsListTableViewDataSource.swift
//  Module
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import Domain

class FlashcardsDataSource: NSObject, UICollectionViewDataSource {
   private let services: FlashcardUseCases
   private let cellID: String
   private let flashcardSetId: String
   
   init(cellID: String, services: FlashcardUseCases, flashcardSetId: String) {
      self.cellID = cellID
      self.services = services
      self.flashcardSetId = flashcardSetId
      super.init()
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return flashcardsSet(with: flashcardSetId).count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? FlashcardCell else {
         return UICollectionViewCell()
      }
      
      let set = flashcardsSet(with: flashcardSetId)
      let cards = sortedCards(from: set)
      cell.viewModel = viewModelFor(card: cards[indexPath.row], at: indexPath.row)
      return cell
   }
}

extension FlashcardsDataSource {
   private func viewModelFor(card: Flashcard, at index: Int) -> FlashcardCell.ViewModel {
      return FlashcardCell.ViewModel(title: card.title, definition: card.description, translation: card.translation, style: FlashcardCell.ViewModel.Style(withIndex:index))
   }
   
   internal func flashcardsSet(with id: String) -> FlashcardSet {
      do {
         return try services.flashcardSet(withId: id)
      } catch FlashcardError.noSets {
         fatalError("There are no flashcards sets!") // TODO: later might be better to show some notification instead of crashing ;)
      } catch FlashcardError.wrongCardId(let id) {
         fatalError("There is no flashcard with id: \(id)!")
      } catch FlashcardError.wrongSetId(let id) {
         fatalError("There is no flashcards set with id: \(id)!")
      } catch {
         fatalError("Undefined error just happend!")
      }
   }
   
   internal func sortedCards(from set: FlashcardSet) -> [Flashcard] {
      do {
         return try services.flashcardsFrom(set, sortedBy: .title, ascending: true)
      } catch FlashcardError.noSets {
         fatalError("There are no flashcards sets!") // TODO: later might be better to show some notification instead of crashing ;)
      } catch FlashcardError.wrongCardId(let id) {
         fatalError("There is no flashcard with id: \(id)!")
      } catch FlashcardError.wrongSetId(let id) {
         fatalError("There is no flashcards set with id: \(id)!")
      } catch {
         fatalError("Undefined error just happend!")
      }
   }
}
