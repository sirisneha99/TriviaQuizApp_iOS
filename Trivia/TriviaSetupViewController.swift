//
//  TriviaSetupViewController.swift
//  Trivia
//
//  Created by sneha siri nagabathula on 7/5/25.
//

//
//  TriviaSetupViewController.swift
//  Trivia
//

import UIKit

class TriviaSetupViewController: UIViewController {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!
    
    private let categories = [
        TriviaCategory(id: nil, name: "Any Category"),
        TriviaCategory(id: 9, name: "General Knowledge"),
        TriviaCategory(id: 10, name: "Entertainment: Books"),
        TriviaCategory(id: 11, name: "Entertainment: Film"),
        TriviaCategory(id: 12, name: "Entertainment: Music"),
        TriviaCategory(id: 13, name: "Entertainment: Musicals & Theatres"),
        TriviaCategory(id: 14, name: "Entertainment: Television"),
        TriviaCategory(id: 15, name: "Entertainment: Video Games"),
        TriviaCategory(id: 16, name: "Entertainment: Board Games"),
        TriviaCategory(id: 17, name: "Science & Nature"),
        TriviaCategory(id: 18, name: "Science: Computers"),
        TriviaCategory(id: 19, name: "Science: Mathematics"),
        TriviaCategory(id: 20, name: "Mythology"),
        TriviaCategory(id: 21, name: "Sports"),
        TriviaCategory(id: 22, name: "Geography"),
        TriviaCategory(id: 23, name: "History"),
        TriviaCategory(id: 24, name: "Politics"),
        TriviaCategory(id: 25, name: "Art"),
        TriviaCategory(id: 26, name: "Celebrities"),
        TriviaCategory(id: 27, name: "Animals"),
        TriviaCategory(id: 28, name: "Vehicles")
    ]
    
    private let difficulties = ["Any", "Easy", "Medium", "Hard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        startGameButton.layer.cornerRadius = 8.0
        startGameButton.backgroundColor = UIColor.systemBlue
        startGameButton.setTitleColor(.white, for: .normal)
        
        // Set default difficulty to "Any"
        difficultySegmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func startGameButtonTapped(_ sender: UIButton) {
        
        
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedCategoryIndex]
        
        let selectedDifficultyIndex = difficultySegmentedControl.selectedSegmentIndex
        let selectedDifficulty = selectedDifficultyIndex == 0 ? nil : difficulties[selectedDifficultyIndex].lowercased()
        
                // Navigate to trivia game
        if let triviaVC = storyboard?.instantiateViewController(withIdentifier: "TriviaViewController") as? TriviaViewController {
            triviaVC.selectedCategory = selectedCategory.id
            triviaVC.selectedDifficulty = selectedDifficulty
            navigationController?.pushViewController(triviaVC, animated: true)
        }
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension TriviaSetupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
}

// MARK: - TriviaCategory Model
struct TriviaCategory {
    let id: Int?
    let name: String
}
