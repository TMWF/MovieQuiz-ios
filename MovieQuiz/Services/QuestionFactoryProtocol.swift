//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 30.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
