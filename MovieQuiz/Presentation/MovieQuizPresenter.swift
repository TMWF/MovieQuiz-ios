//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 03.01.2023.
//

import UIKit

final class MovieQuizPresenter {
    weak var movieQuizViewController: MovieQuizViewController?
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    
    func getCurrentQuestionIndex() -> Int {
        currentQuestionIndex
    }
    
    func getQuestionsAmount() -> Int {
        questionsAmount
    }
    
    func setCurrentQuestion(_ question: QuizQuestion?) {
        currentQuestion = question
    }
    
    public func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        guard let currentQuestion else { return }
        movieQuizViewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        guard let currentQuestion else { return }
        movieQuizViewController?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}

