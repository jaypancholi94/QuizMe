//
//  QuizAttemptViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 22/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class QuizAttemptViewController: UIViewController {
    var subjectID : Int?
    var studentName : String?
    var quizID : Int?
    var passMarks : Int?
    var quizName : String?
    var attempt : Int?
    //----------------------------------------
   
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    @IBOutlet weak var remainingQues: UILabel!
    //-----------------------------------------
    struct Question {
        var question : String
        var optionA : String
        var optionB : String
        var optionC : String
        var optionD : String
        var ans : String
    }
    var questions = [Question]()
    var correctAnswers : Int = 0
    var questionCounter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        loadQuiz()
        updateUI()
        updateQuestion()
    }
    func loadQuiz() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "quiz_id") as! Int
                //print("quiz id: \(id)|| \(quiz_id)")
                //print("que: \(que) || \(question)")
                if  quizID == id{
                    //  print("Inside")
                    let options = (data.value(forKey: "options") as! String)
                    let option = options.split(separator: "|")
                    questions.append(Question(question: (data.value(forKey: "question") as! String), optionA: String(option[0]), optionB: String(option[1]), optionC: String(option[2]), optionD: String(option[3]), ans: (data.value(forKey: "correct_answer") as! String)))
                }
            }
        } catch {
            
            print("Failed")
        }
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == questions[questionCounter].ans {
            print("Correct")
            correctAnswers += 1
        }
        else
        {
            print("Wrong")
        }
        questionCounter += 1
        updateUI()
        updateQuestion()
    }
    func updateUI() {
        remainingQues.text = "\(questionCounter + 1)/\(questions.count)"
        progressBar.progress = (1.000 / Float(questions.count)) * Float(questionCounter + 1)
    }
    func updateQuestion() {
        
        if questionCounter < questions.count{
            questionLabel.text = questions[questionCounter].question
            optionA.setTitle(questions[questionCounter].optionA, for: UIControl.State.normal)
            optionB.setTitle(questions[questionCounter].optionB, for: UIControl.State.normal)
            optionC.setTitle(questions[questionCounter].optionC, for: UIControl.State.normal)
            optionD.setTitle(questions[questionCounter].optionD, for: UIControl.State.normal)
        }
        else
        {
            performSegue(withIdentifier: "result", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result"{
            if let destination = segue.destination as? ResultViewController{
                destination.subjectID = subjectID
                destination.studentName = studentName
                destination.quizID = quizID
                destination.passMarks = passMarks
                destination.quizName = quizName
                destination.totalQuestions = questions.count
                destination.right = correctAnswers
                destination.attempt = attempt
            }
        }
    }
}
