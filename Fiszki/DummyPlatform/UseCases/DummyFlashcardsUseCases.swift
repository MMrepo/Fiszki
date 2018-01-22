//
//  DummyFlashcardsUseCases.swift
//  DummyPlatform
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Domain

public final class DummyFlashcardUseCases {
    private var exampleFlashcardSets: [FlashcardSet]?
    
    public init() {
        let firstFlashcard = Flashcard(uid: "1", title: "First", description: "being before all others with respect to time, order, rank, importance, etc., used as the ordinal number of one: the first edition; the first vice president.", translation: "Pierwszy", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
        let secondFlashcard = Flashcard(uid: "2", title: "Second", description: "next after the first; being the ordinal number for two.", translation: "Drugi", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
         let thirdFlashcard = Flashcard(uid: "3", title: "Third", description: "next after the second; being the ordinal number for three.", translation: "Trzeci", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
         let fourthFlashcard = Flashcard(uid: "4", title: "Fourth", description: "next after the third; being the ordinal number for four.", translation: "Czwarty", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
         let fifthFlashcard = Flashcard(uid: "5", title: "Fifth", description: "next after the fourth; being the ordinal number for five.", translation: "Piąty", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
         let sixthFlashcard = Flashcard(uid: "6", title: "Sixth", description: "next after the fifth; being the ordinal number for six.", translation: "Szósty", createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
        exampleFlashcardSets = [FlashcardSet(uid: "1", title: "Numerals", description: "Flashcard set with numerals", createdAt: "\(Date().timeIntervalSince1970)", flashcards: [firstFlashcard, secondFlashcard, thirdFlashcard, fourthFlashcard, fifthFlashcard, sixthFlashcard])]
    }
}

extension DummyFlashcardUseCases: Domain.FlashcardUseCases  {
    public func flashcardSet(withId id: String) throws -> FlashcardSet {
        guard let set = exampleFlashcardSets?.filter({ $0.uid == id }).first else {
            throw FlashcardError.wrongSetId(id)
        }
        return set
    }
    
    public func flashcardsFrom(_ set: FlashcardSet, sortedBy: FlashcardSortingKey, ascending: Bool) throws -> [Flashcard] {
        let originalSet = try flashcardSet(withId: set.uid)
        
        switch sortedBy {
        case .title:
            return originalSet.flashcards.sorted(by: { ascending ? $0.title < $1.title : $0.title > $1.title })
        case .creationDate:
            return originalSet.flashcards.sorted(by: { ascending ? $0.createdAt < $1.createdAt : $1.createdAt > $0.createdAt })
        }
    }
    
    public func flashcardSets() throws -> [FlashcardSet] {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }
        return allSets
    }
    
    public func save(flashcardSet: FlashcardSet) throws {
        guard exampleFlashcardSets != nil else {
            throw FlashcardError.noSets
        }
        
        exampleFlashcardSets!.append(flashcardSet)
    }
    
    public func update(flashcardSet: FlashcardSet) throws {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }
        guard let originalSet = allSets.filter({ $0.uid == flashcardSet.uid }).first, let index = allSets.index(of: originalSet) else {
            throw FlashcardError.wrongSetId(flashcardSet.uid)
        }
        
        exampleFlashcardSets![index] = flashcardSet
    }
    
    public func delete(flashcardSet: FlashcardSet) throws {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }
        guard let originalSet = allSets.filter({ $0.uid == flashcardSet.uid }).first, let index = allSets.index(of: originalSet) else {
            throw FlashcardError.wrongSetId(flashcardSet.uid)
        }
        
        exampleFlashcardSets!.remove(at: index)
    }
    
    public func add(flashcard: Flashcard, to flashcardSet: FlashcardSet) throws {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }
        guard let originalSet = allSets.filter({ $0.uid == flashcardSet.uid }).first, let index = allSets.index(of: originalSet) else {
            throw FlashcardError.wrongSetId(flashcardSet.uid)
        }
        
        var flashcards = originalSet.flashcards
        flashcards.insert(flashcard)
        let newSet = FlashcardSet(uid: originalSet.uid, title: originalSet.title, description: originalSet.description, createdAt: originalSet.createdAt, flashcards: flashcards)
        exampleFlashcardSets![index] = newSet
    }
    
    public func update(flashcard: Flashcard) throws {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }

        let setsWithFlashcard = allSets.filter({ $0.flashcards.filter({ $0.uid == flashcard.uid }).count > 0 })
        guard setsWithFlashcard.count > 0 else {
            throw FlashcardError.wrongCardId(flashcard.uid)
        }
        
        setsWithFlashcard.forEach { originalSet in
            let setIndex = allSets.index(of: originalSet)!
            var flashcards = originalSet.flashcards
            let originalFlashcard = flashcards.filter({ $0.uid == flashcard.uid }).first!
            flashcards.remove(originalFlashcard)
            flashcards.insert(flashcard)
            let newSet = FlashcardSet(uid: originalSet.uid, title: originalSet.title, description: originalSet.description, createdAt: originalSet.createdAt, flashcards: flashcards)
            exampleFlashcardSets![setIndex] = newSet
        }
    }
    
    public func remove(flashcard: Flashcard, from flashcardSet: FlashcardSet) throws {
        guard let allSets = exampleFlashcardSets else {
            throw FlashcardError.noSets
        }
        guard let originalSet = allSets.filter({ $0.uid == flashcardSet.uid }).first, let index = allSets.index(of: originalSet) else {
            throw FlashcardError.wrongSetId(flashcardSet.uid)
        }
        
        var flashcards = originalSet.flashcards
        let originalFlashcard = flashcards.filter({ $0.uid == flashcard.uid }).first!

        flashcards.remove(originalFlashcard)
        let newSet = FlashcardSet(uid: originalSet.uid, title: originalSet.title, description: originalSet.description, createdAt: originalSet.createdAt, flashcards: flashcards)
        exampleFlashcardSets![index] = newSet
    }
}
