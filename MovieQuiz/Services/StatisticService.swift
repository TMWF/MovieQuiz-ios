//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 03.12.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            
            return Double(correct) / Double(total) * 100
    }
    
    var gamesCount: Int {
        userDefaults.integer(forKey: Keys.gamesCount.rawValue)
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        userDefaults.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
        
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        let totalCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(totalCorrect + gameRecord.correct, forKey: Keys.correct.rawValue)
        
        let globalGames = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(globalGames + gameRecord.total, forKey: Keys.total.rawValue)
        
        if gameRecord > bestGame {
            bestGame = gameRecord
        }
    }
}
