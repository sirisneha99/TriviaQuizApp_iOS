//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private let triviaService = TriviaQuestionService.shared
  
  // Properties for category and difficulty selection
  var selectedCategory: Int?
  var selectedDifficulty: String?
  
  // Properties for feedback
  private var isShowingFeedback = false
  private var correctAnswer: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    setupUI()
    fetchTriviaQuestions()
  }
  
  private func setupUI() {
    // Hide answer buttons initially
    answerButton0.isHidden = true
    answerButton1.isHidden = true
    answerButton2.isHidden = true
    answerButton3.isHidden = true
    
    // Style answer buttons
    styleAnswerButton(answerButton0)
    styleAnswerButton(answerButton1)
    styleAnswerButton(answerButton2)
    styleAnswerButton(answerButton3)
    
    questionLabel.text = "Loading questions..."
    categoryLabel.text = ""
    currentQuestionNumberLabel.text = ""
    
    // Add back button
    navigationItem.title = "Trivia Game"
    navigationItem.hidesBackButton = false
  }
  
  private func styleAnswerButton(_ button: UIButton) {
    button.layer.cornerRadius = 8.0
    button.layer.borderWidth = 2.0
    button.layer.borderColor = UIColor.systemBlue.cgColor
    button.backgroundColor = UIColor.systemBackground
    button.setTitleColor(.systemBlue, for: .normal)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.textAlignment = .center
  }
  
  private func fetchTriviaQuestions() {
    triviaService.fetchTriviaQuestions(
      amount: 10,
      category: selectedCategory,
      difficulty: selectedDifficulty
    ) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let questions):
          self?.questions = questions
          self?.currQuestionIndex = 0
          self?.numCorrectQuestions = 0
          if !questions.isEmpty {
            self?.updateQuestion(withQuestionIndex: 0)
          }
        case .failure(let error):
          self?.showError(error)
        }
      }
    }
  }
  
  private func showError(_ error: Error) {
    let alertController = UIAlertController(
      title: "Error",
      message: "Failed to load questions: \(error.localizedDescription)",
      preferredStyle: .alert
    )
    
    let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
      self?.fetchTriviaQuestions()
    }
    
    let backAction = UIAlertAction(title: "Back to Setup", style: .default) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    
    alertController.addAction(retryAction)
    alertController.addAction(backAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    isShowingFeedback = false
    resetButtonStyles()
    
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
    questionLabel.text = question.question
    categoryLabel.text = question.category
    correctAnswer = question.correctAnswer
    
    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
    
    // Hide all buttons first
    answerButton0.isHidden = true
    answerButton1.isHidden = true
    answerButton2.isHidden = true
    answerButton3.isHidden = true
    
    // Show and set titles for available answers
    if answers.count > 0 {
      answerButton0.setTitle(answers[0], for: .normal)
      answerButton0.isHidden = false
    }
    if answers.count > 1 {
      answerButton1.setTitle(answers[1], for: .normal)
      answerButton1.isHidden = false
    }
    if answers.count > 2 {
      answerButton2.setTitle(answers[2], for: .normal)
      answerButton2.isHidden = false
    }
    if answers.count > 3 {
      answerButton3.setTitle(answers[3], for: .normal)
      answerButton3.isHidden = false
    }
  }
  
  private func resetButtonStyles() {
    styleAnswerButton(answerButton0)
    styleAnswerButton(answerButton1)
    styleAnswerButton(answerButton2)
    styleAnswerButton(answerButton3)
  }
  
  private func showFeedback(selectedAnswer: String, selectedButton: UIButton) {
    isShowingFeedback = true
    let isCorrect = selectedAnswer == correctAnswer
    
    // Update button colors to show feedback
    if !answerButton0.isHidden {
      updateButtonForFeedback(answerButton0, isCorrect: answerButton0.titleLabel?.text == correctAnswer)
    }
    if !answerButton1.isHidden {
      updateButtonForFeedback(answerButton1, isCorrect: answerButton1.titleLabel?.text == correctAnswer)
    }
    if !answerButton2.isHidden {
      updateButtonForFeedback(answerButton2, isCorrect: answerButton2.titleLabel?.text == correctAnswer)
    }
    if !answerButton3.isHidden {
      updateButtonForFeedback(answerButton3, isCorrect: answerButton3.titleLabel?.text == correctAnswer)
    }
    
    if isCorrect {
      numCorrectQuestions += 1
    }
    
    // Show feedback message
    let feedbackMessage = isCorrect ? "Correct! ✅" : "Wrong! ❌\nCorrect answer: \(correctAnswer)"
    let alertController = UIAlertController(
      title: feedbackMessage,
      message: nil,
      preferredStyle: .alert
    )
    
    let nextAction = UIAlertAction(title: "Next Question", style: .default) { [weak self] _ in
      self?.moveToNextQuestion()
    }
    
    alertController.addAction(nextAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func updateButtonForFeedback(_ button: UIButton, isCorrect: Bool) {
    if isCorrect {
      button.backgroundColor = UIColor.systemGreen
      button.setTitleColor(.white, for: .normal)
      button.layer.borderColor = UIColor.systemGreen.cgColor
    } else {
      button.backgroundColor = UIColor.systemRed
      button.setTitleColor(.white, for: .normal)
      button.layer.borderColor = UIColor.systemRed.cgColor
    }
  }
  
  private func moveToNextQuestion() {
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func updateToNextQuestion(answer: String, selectedButton: UIButton) {
    guard !isShowingFeedback else { return }
    showFeedback(selectedAnswer: answer, selectedButton: selectedButton)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let percentage = Int((Double(numCorrectQuestions) / Double(questions.count)) * 100)
    let alertController = UIAlertController(
      title: "Game Over! 🎉",
      message: "Final Score: \(numCorrectQuestions)/\(questions.count) (\(percentage)%)",
      preferredStyle: .alert
    )
    
    let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
      self?.fetchTriviaQuestions()
    }
    
    let newGameAction = UIAlertAction(title: "New Game Setup", style: .default) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    
    alertController.addAction(playAgainAction)
    alertController.addAction(newGameAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "", selectedButton: sender)
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "", selectedButton: sender)
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "", selectedButton: sender)
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "", selectedButton: sender)
  }
}
