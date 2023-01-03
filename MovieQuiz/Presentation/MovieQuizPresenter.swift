//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 03.01.2023.
//

import UIKit

final class MovieQuizPresenter {
    weak var movieQuizViewController: MovieQuizViewController?
    var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion?
    private var statistics: StatisticService = StatisticServiceImplementation()
    private let questionsAmount = 10
    var questionFactory: QuestionFactoryProtocol = QuestionFactory(movieLoader: MoviesLoader())

    
    func getCurrentQuestionIndex() -> Int {
        currentQuestionIndex
    }
    
    func getQuestionsAmount() -> Int {
        questionsAmount
    }
    
    public func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        movieQuizViewController?.showAnswerResult(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.movieQuizViewController?.show(next: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func showNextQuestionOrResults() {
        if isLastQuestion() {
            statistics.store(correct: correctAnswers, total: getQuestionsAmount())
            let text = "Ваш результат: \(correctAnswers)/\(getQuestionsAmount())\nКоличество сыгранных квизов: \(statistics.gamesCount)\nРекорд: \(statistics.bestGame.correct)/\(statistics.bestGame.total) (\(statistics.bestGame.date.dateTimeString))\nCредняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            movieQuizViewController?.show(result: viewModel)
        } else {
            switchToNextQuestion()
            
            questionFactory.requestNextQuestion()
        }
    }

    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
}

