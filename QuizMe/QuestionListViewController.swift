//
//  QuestionListViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 18/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class QuestionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var quizNameLabel: UITextField!
    @IBOutlet weak var passPerLabel: UITextField!
    @IBOutlet weak var attemptLabel: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var quizId : Int?
        var quizName : String?
        var passPer : Int?
        var attempt : Int?
    var question = [String?]()
    //var conditionList  = [Condition?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadConditions()
        loadQuestions()
        quizNameLabel.text = quizName
        passPerLabel.text =  String(passPer!)
        attemptLabel.text = String(attempt!)
        //print(">>question list>> \(quizId)")
        tableView.reloadData()
    }
    func loadConditions() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "quiz_id") as! Int
                if id == quizId{
                    quizName = (data.value(forKey: "quiz_name") as! String)
                    passPer = (data.value(forKey: "passing_per") as! Int)
                    attempt = (data.value(forKey: "attempt") as! Int)
                }
            }
        } catch {
            
            print("Failed")
        }
    }
    func loadQuestions() {
        question.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "quiz_id") as! Int
                if id == quizId{
                    question.append(data.value(forKey: "question") as! String)
                    
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = question[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let que = question[indexPath.row]
            deleteQuestion(index: indexPath.row)
            question.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func deleteQuestion(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requestCondition = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        requestCondition.returnsObjectsAsFaults = false
        do{
            print("called")
            let result = try context.fetch(requestCondition)
            for data in result as! [NSManagedObject]
            {
                print("loop")
                let que = data.value(forKey: "question") as! String
                if que == question[index]{
                    print("entered")
                    context.delete(data)
                    try context.save()
                    break
                }
            }
        }catch{
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Segue called")
        //print(">>\(segue.identifier)")
        if segue.identifier == "editQuestion"{
            if let destination = segue.destination as? EditQuestionViewController{
                let index = tableView.indexPath(for: sender as! UITableViewCell)
                destination.question = question[index!.row]
               // print(">>segue>> \(question[index!.row])")
                destination.quiz_id = quizId!
            }
        }else if segue.identifier == "addQues"{
            if let destination = segue.destination as? SingleQueViewController{
                // print(">>segue>> \(question[index!.row])")
                destination.quizId = quizId!
            }
        }
    }
    @IBAction func addSingleQues(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addQues", sender: self)
    }
    @IBAction func saveCondition(_ sender: UIButton) {
        if validate() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
            do{
                let fetch = try context.fetch(request)
                for data in fetch as! [NSManagedObject]{
                    let id = data.value(forKey: "quiz_id") as! Int
                    
                    if id == quizId {
                        data.setValue(quizNameLabel.text!, forKey: "quiz_name")
                        data.setValue(Int(passPerLabel.text!), forKey: "passing_per")
                        data.setValue(Int(attemptLabel.text!), forKey: "attempt")
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

        }
                //alert
    }
    func validate() -> Bool {
        var flag = true
        if quizNameLabel.text ==  ""{
            quizNameLabel.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            quizNameLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if passPerLabel.text ==  ""{
            passPerLabel.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            passPerLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        if attemptLabel.text ==  ""{
            attemptLabel.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            attemptLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            flag = true
        }
        return flag
    }
    
}
