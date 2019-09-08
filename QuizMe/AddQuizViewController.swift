//
//  AddQuizViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 17/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class AddQuizViewController: UIViewController {
    var subjectId : Int?
    var userName : String?
    var quizId : Int?
    //--------------
    struct quiz {
        var question : String
        var optionA : String
        var optionB : String
        var optionC : String
        var optionD : String
        var ans : String
    }
    var quizQuestions = [quiz]()
    @IBOutlet var correctAnswer: [UISwitch]!
    var count : Int?
    @IBOutlet weak var QuizName: UITextField!
    @IBOutlet weak var passPer: UITextField!
    @IBOutlet weak var attempt: UITextField!
    var tag : Int?
    
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var Question: UITextField!
    @IBOutlet weak var optionA: UITextField!
    @IBOutlet weak var optionB: UITextField!
    @IBOutlet weak var optionC: UITextField!
    @IBOutlet weak var optionD: UITextField!
    @IBOutlet weak var nextQuestion: UIButton!
    //--------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        count = 0
        questionCount.text = String (count! + 1)
    }
    
    @IBAction func optionOneToggle(_ sender: UISwitch) {
       
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        tag = 1
    }
    @IBAction func optionTwoToggle(_ sender: UISwitch) {
        (correctAnswer[0].isOn == true ? correctAnswer[0].setOn(false, animated: true) : nil )
        
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        tag = 2
    }
    @IBAction func optionThreeToggle(_ sender: UISwitch) {
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[0].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
       
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        tag = 3
    }
    @IBAction func optionFourToggle(_ sender: UISwitch) {
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        (correctAnswer[0].isOn == true ? correctAnswer[0].setOn(false, animated: true) : nil)
       
        tag = 4
    }
    
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        if validate(){
            appendQuestion()
            loadNew()
            print(">>\(quizQuestions.count)")
        }
    }
    func validate() -> Bool {
        var flag = true
        if Question.text == "" {
            //error
            Question.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            Question.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if optionA.text == "" {
            //error
            optionA.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            optionA.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if optionB.text == "" {
            //error
            optionB.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            optionB.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if optionC.text == "" {
            //error
            optionC.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            optionC.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if optionD.text == "" {
            //error
            optionD.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            optionD.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if correctAnswer[0].isOn == false && correctAnswer[1].isOn == false && correctAnswer[2].isOn == false && correctAnswer[3].isOn == false{
            let alert = UIAlertController(title: "Invalid entry", message: "Correct answer must be selected", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        return flag
    }
    func loadNew() {
        count! = count! + 1
        questionCount.text = String (count! + 1)
        Question.text = ""
        optionA.text = ""
        optionB.text = ""
        optionC.text = ""
        optionD.text = ""
        correctAnswer[0].setOn(false, animated: true)
        correctAnswer[1].setOn(false, animated: true)
        correctAnswer[2].setOn(false, animated: true)
        correctAnswer[3].setOn(false, animated: true)
    }
    func appendQuestion() {
        //print("question:>>>>\(Question.text!)")
        if tag == 1 {
            
            quizQuestions.append(quiz(question: Question.text!, optionA: optionA.text!, optionB: optionB.text!, optionC: optionC.text!, optionD: optionD.text!, ans: optionA.text!))
            print("Array>>>\(quizQuestions)")//
        }
        if tag == 2{
            //print("B")
            quizQuestions.append(quiz(question: Question.text!, optionA: optionA.text!, optionB: optionB.text!, optionC: optionC.text!, optionD: optionD.text!, ans: optionB.text!))
        }
        if tag == 3{
            //print("C")
            quizQuestions.append(quiz(question: Question.text!, optionA: optionA.text!, optionB: optionB.text!, optionC: optionC.text!, optionD: optionD.text!, ans: optionC.text!))
        }
        if tag == 4{
            //print("D")
            quizQuestions.append(quiz(question: Question.text!, optionA: optionA.text!, optionB: optionB.text!, optionC: optionC.text!, optionD: optionD.text!, ans: optionD.text!))
        }
        
    }
    func validateCondtion() -> Bool {
        var flag = false
        if QuizName.text != "" {
            flag = true
            QuizName.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }else
        {
            flag = false
            QuizName.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
        }
        if passPer.text != "" && passPer.text!.isInt{
            if 1 <= Int(passPer.text!)! && Int(passPer.text!)! <= 100{
                flag = true
                passPer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            }else{
                passPer.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
                let alert = UIAlertController(title: "Invalid entry", message: "pass Percentage must be between 1 to 100", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Not Exist")
            }
            
        }else
        {
            flag = false
            passPer.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
        }
        if attempt.text != "" && attempt.text!.isInt{
            flag = true
            attempt.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }else
        {
            flag = false
            attempt.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
        }
        
        
        return flag
    }
    
    @IBAction func save(_ sender: UIButton) {
       if validateCondtion() == true && validate() == true{
            quizId = Int.random(in: 0 ..< 10000)
            appendQuestion()
            addQuizConditionToCoreData()
            addQuestionToCoreData()
        _ = navigationController?.popViewController(animated: true)
        }
    }
    func addQuizConditionToCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Condition", in: context)
        let newCondition = NSManagedObject(entity: entity!, insertInto: context)
        newCondition.setValue(userName, forKey: "user_name")
        newCondition.setValue(subjectId, forKey: "subject_id")
        newCondition.setValue(quizId, forKey: "quiz_id")
        newCondition.setValue(QuizName.text!, forKey: "quiz_name")
        newCondition.setValue(Int(passPer.text!), forKey: "passing_per")
        newCondition.setValue(Int(attempt.text!), forKey: "attempt")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func addQuestionToCoreData()  {
        
        for newQ in quizQuestions{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Quiz", in: context)
            let newQuestion = NSManagedObject(entity: entity!, insertInto: context)
            newQuestion.setValue(quizId, forKey: "quiz_id")
            newQuestion.setValue(newQ.question, forKey: "question")
            newQuestion.setValue("\(newQ.optionA)|\(newQ.optionB)|\(newQ.optionC)|\(newQ.optionD)", forKey: "options")
            newQuestion.setValue(newQ.ans, forKey: "correct_answer")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
