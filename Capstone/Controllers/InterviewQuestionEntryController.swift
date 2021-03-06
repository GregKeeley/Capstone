//
//  InterviewQuestionEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewQuestionEntryController: UIViewController {
    
    @IBOutlet weak var questionTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    private func configureNavBar() {
        navigationItem.title = "Add A Custom Question"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(createQuestionButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
    }
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @objc private func createQuestionButtonPressed(_ sender: UIBarButtonItem){
        guard let questionText = questionTextfield.text, !questionText.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert(title: "Missing Fields", message: "You will need to enter a question first")
            }
            return
        }
        let newQuestion = InterviewQuestion(question: questionText, suggestion: nil, id: UUID().uuidString)
        DatabaseService.shared.addCustomInterviewQuestion(customQuestion: newQuestion) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Could not create your custom question at this time error: \(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Your question has been created!", message: "You can now add an answer and/or attach a STAR Story to the question")
                    self?.questionTextfield.text = ""
                }
            }
        }
    }
}
