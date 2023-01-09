//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 03.01.2023.
//

import UIKit

final class MovieQuizPresenter {
    private weak var movieQuizViewController: MovieQuizViewControllerProtocol?
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion?
    private var statistics: StatisticService = StatisticServiceImplementation()
    private let questionsAmount = 10
    var questionFactory: QuestionFactoryProtocol = QuestionFactory(movieLoader: MoviesLoader())

    init(movieQuizViewController: MovieQuizViewControllerProtocol?) {
        self.movieQuizViewController = movieQuizViewController
        questionFactory.delegate = self
        questionFactory.loadData()
        movieQuizViewController?.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isCorrect:Bool) {
        if isCorrect { correctAnswers += 1 }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func makeResultsMessage() -> String {
        statistics.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statistics.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statistics.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }

    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory.requestNextQuestion()
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        movieQuizViewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        didAnswer(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.movieQuizViewController?.enableButtonsAndReduceIVBorderWidth()
            self.proceedToNextQuestionOrResults()
        }
    }

    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let text = makeResultsMessage()
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

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didLoadDataFromServer() {
        movieQuizViewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        movieQuizViewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.movieQuizViewController?.show(next: viewModel)
        }
    }
}

