//
//  FlashcardSet.swift
//  Domain
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

public struct FlashcardSet {
    public let uid: String
    public let title: String
    public let description: String
    public let createdAt: String
    public let flashcards: Set<Flashcard>
    public var count: Int {
        return flashcards.count
    }
    
    public init(uid: String, title: String, description: String, createdAt: String, flashcards: Set<Flashcard> = []) {
        self.uid = uid
        self.title = title
        self.description = description
        self.flashcards = flashcards
        self.createdAt = createdAt
    }
}

extension FlashcardSet: Equatable {
    public static func == (lhs: FlashcardSet, rhs: FlashcardSet) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.createdAt == rhs.createdAt &&
            lhs.flashcards == rhs.flashcards
    }
}
