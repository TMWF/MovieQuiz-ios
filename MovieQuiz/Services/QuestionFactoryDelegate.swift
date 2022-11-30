//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 30.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
