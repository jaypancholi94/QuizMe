//
//  SingleQueViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 19/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class SingleQueViewController: UIViewController {

    var quizId : Int?
    
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var optionA: UITextField!
    @IBOutlet weak var optionB: UITextField!
    @IBOutlet weak var optionC: UITextField!
    @IBOutlet weak var optionD: UITextField!
    var tag : Int =  -1
    
    @IBOutlet var correctAnswer: [UISwitch]!
    var ans : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addQuestion(_ sender: UIButton) {
        if validate() {
            if tag == 1{
             ans = optionA!.text
                print("1")
            }else if tag == 2{
             ans = optionB!.text
                print("2")
            }else if tag == 3{
            ans = optionC!.text
                print("3")
            }else if tag == 4{
             ans = optionD!.text
                print("4")
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Quiz", in: context)
            let newQuestion = NSManagedObject(entity: entity!, insertInto: context)
            newQuestion.setValue(quizId, forKey: "quiz_id")
            newQuestion.setValue(question!.text, forKey: "question")
            newQuestion.setValue("\(optionA!.text!)|\(optionB!.text!)|\(optionC!.text!)|\(optionD!.text!)", forKey: "options")
            print("\(optionA!.text!)|\(optionB!.text!)|\(optionC!.text!)|\(optionD!.text!)")
            newQuestion.setValue(ans, forKey: "correct_answer")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    func validate() -> Bool {
        var flag = true
        if question.text == "" {
            //error
            question.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            question.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
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
    @IBAction func optionAtoggle(_ sender: UISwitch) {
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        
        tag = 1
    }
    @IBAction func optionBtoggle(_ sender: UISwitch) {
        (correctAnswer[0].isOn == true ? correctAnswer[0].setOn(false, animated: true) : nil )
        
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        tag = 2
    }
    @IBAction func optionCtoggle(_ sender: UISwitch) {
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[0].isOn == true ? correctAnswer[0].setOn(false, animated: true) : nil)
        
        (correctAnswer[3].isOn == true ? correctAnswer[3].setOn(false, animated: true) : nil)
        tag = 3
    }
    @IBAction func optionDtoggle(_ sender: UISwitch) {
        (correctAnswer[1].isOn == true ? correctAnswer[1].setOn(false, animated: true) : nil )
        (correctAnswer[2].isOn == true ? correctAnswer[2].setOn(false, animated: true) : nil)
        (correctAnswer[0].isOn == true ? correctAnswer[0].setOn(false, animated: true) : nil)
        
        tag = 4
    }

}
