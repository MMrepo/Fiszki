//
//  Flashcard.swift
//  Domain
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation


public struct Flashcard {
    public let uid: String
    public let title: String
    public let description: String
    public let translation: String
    public let createdAt: String
    public let isLearned: Bool
    
    public init(uid: String, title: String, description: String, translation: String, createdAt: String, isLearned: Bool) {
        self.uid = uid
        self.title = title
        self.description = description
        self.translation = translation
        self.createdAt = createdAt
        self.isLearned = isLearned
    }
}

extension Flashcard: Equatable {
    public static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.translation == rhs.translation &&
            lhs.createdAt == rhs.createdAt
    }
}

extension Flashcard: Hashable {
    public var hashValue: Int {
        return uid.hashValue ^ title.hashValue ^ description.hashValue ^ translation.hashValue ^ createdAt.hashValue
    }
}
