//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 03.12.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
    
    let correct: Int
    let total: Int
    let date: Date
}
