//
//  FlashcardUseCases.swift
//  Domain
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

public protocol FlashcardUseCases {
    func flashcardSet(withId id: String) throws -> FlashcardSet
    func flashcardsFrom(_ set: FlashcardSet, sortedBy: FlashcardSortingKey, ascending: Bool) throws -> [Flashcard]

    func flashcardSets() throws -> [FlashcardSet]
    
    func save(flashcardSet: FlashcardSet) throws
    func update(flashcardSet: FlashcardSet) throws
    func delete(flashcardSet: FlashcardSet) throws

    func add(flashcard: Flashcard, to flashcardSet: FlashcardSet) throws
    func update(flashcard: Flashcard) throws
    func remove(flashcard: Flashcard, from flashcardSet: FlashcardSet) throws
}

public enum FlashcardSortingKey {
    case creationDate
    case title
}

public enum FlashcardError: Error {
    case wrongSetId(String)
    case wrongCardId(String)
    case noSets
}

