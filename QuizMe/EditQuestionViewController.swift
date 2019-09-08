//
//  EditQuestionViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 18/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class EditQuestionViewController: UIViewController {
 
    var question : String?
     var tag : Int?
    var quiz_id : Int?
    var queCoreData : String?
    var options : String?
    var ans : String?
    @IBOutlet weak var questionBox: UITextField!
    
    @IBOutlet weak var optionA: UITextField!
    @IBOutlet weak var optionB: UITextField!
    @IBOutlet weak var optionC: UITextField!
    @IBOutlet weak var optionD: UITextField!
    
    @IBOutlet var correctAnswer: [UISwitch]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadQuestion()
        display()
        //print(">>editQuestion>>>> \(quiz_id)")
        //print(">>editQuestion>>>> \(question)")
    }
    func display() {
        questionBox.text = queCoreData
        print(">>>\(options)")
        let option = options!.split(separator: "|")
        print(">>>>>\(option)")
        optionA.text = String(option[0])
        optionB.text = String(option[1])
        optionC.text = String(option[2])
        optionD.text = String(option[3])
        print("\(ans) || \(String(option[0]))")
        print("\(ans) || \(optionA.text))")
        (ans == optionA.text as! String ? correctAnswer[0].setOn(true, animated: true) : nil)
        (ans == optionB.text as! String ? correctAnswer[1].setOn(true, animated: true) : nil)
        (ans == optionC.text as! String ? correctAnswer[2].setOn(true, animated: true) : nil)
        (ans == optionD.text as! String ? correctAnswer[3].setOn(true, animated: true) : nil)
        
    }
    @IBAction func editQuestion(_ sender: UIButton) {
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        do{
            let fetch = try context.fetch(request)
            for data in fetch as! [NSManagedObject]{
                let id = data.value(forKey: "quiz_id") as! Int
                let que = data.value(forKey: "question") as! String
                if id == quiz_id && que == question{
                    data.setValue(quiz_id, forKey: "quiz_id")
                    data.setValue(questionBox!.text, forKey: "question")
                    data.setValue("\(optionA!.text!)|\(optionB!.text!)|\(optionC!.text!)|\(optionD!.text!)", forKey: "options")
                    print("\(optionA!.text!)|\(optionB!.text!)|\(optionC!.text!)|\(optionD!.text!)")
                    data.setValue(ans, forKey: "correct_answer")
                }
                
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }catch {
            print(error)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    func loadQuestion() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "quiz_id") as! Int
                let que = data.value(forKey: "question") as! String
                //print("quiz id: \(id)|| \(quiz_id)")
                //print("que: \(que) || \(question)")
                if  question == que && quiz_id == id{
                  //  print("Inside")
                    queCoreData = (data.value(forKey: "question") as! String)
                    options = (data.value(forKey: "options") as! String)
                    ans = (data.value(forKey: "correct_answer") as! String)
                }
            }
        } catch {
            
            print("Failed")
        }
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
