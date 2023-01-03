import UIKit




final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers = 0
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory(movieLoader: MoviesLoader())
    private var statistics: StatisticService = StatisticServiceImplementation()
    private var alertPresenter: AlertPresenter = ResultAlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        alertPresenter.controller = self
        presenter.movieQuizViewController = self
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Private Functions
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self else { return }
            self.showLoadingIndicator()
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory.loadData()
        }
        
        alertPresenter.showAlert(alertModel)
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func show(next step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] _ in
            guard let self else {return}
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        }
        
        alertPresenter.showAlert(alertModel)
    }
    
    
    
    func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.imageView.layer.borderWidth = 0
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statistics.store(correct: correctAnswers, total: presenter.getQuestionsAmount())
            let text = "Ваш результат: \(correctAnswers)/\(presenter.getQuestionsAmount())\nКоличество сыгранных квизов: \(statistics.gamesCount)\nРекорд: \(statistics.bestGame.correct)/\(statistics.bestGame.total) (\(statistics.bestGame.date.dateTimeString))\nCредняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(result: viewModel)
        } else {
            presenter.switchToNextQuestion()
            
            questionFactory.requestNextQuestion()
        }
    }
    
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
