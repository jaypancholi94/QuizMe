//
//  QuizViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 17/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class QuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var SubjectName: UILabel!
    var subjectNm : String?
    var userName : String?
    var subjectId : Int?
    struct quiz {
        var quizName : String
        var quizId : Int
    }
    var quizList = [quiz]()
    //--------------------------------------
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        SubjectName.text = subjectNm
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 253.00/255.00, green: 147.00/255.00, blue: 39.00/255.00, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadQuiz()
        tableView.reloadData()
        tableView.rowHeight = 100
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addQuiz"{
            if let destination = segue.destination as? AddQuizViewController {
                //destination.subjectName = subjectNm
                destination.userName = userName
                destination.subjectId = subjectId
            }
        }else if segue.identifier == "questionList"{
            if let destination = segue.destination as? QuestionListViewController{
                let index = tableView.indexPath(for: sender as! UITableViewCell)
                destination.quizId = quizList[(index?.row)!].quizId
            }
        }
    }
    func loadQuiz(){
        quizList.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "subject_id") as! Int
                if id == subjectId{
                    quizList.append(quiz(quizName: data.value(forKey: "quiz_name") as! String, quizId: data.value(forKey: "quiz_id") as! Int))
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = quizList[indexPath.row].quizName
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let quiz = quizList[indexPath.row]
            deleteDataFromQuiz(index: indexPath.row)
            deleteDataFromCondition(index: indexPath.row)
            quizList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func deleteDataFromCondition(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requestCondition = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
        requestCondition.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(requestCondition)
            for data in result as! [NSManagedObject]
            {
                let id = data.value(forKey: "quiz_id") as! Int
                if id == quizList[index].quizId{
                    context.delete(data)
                    try context.save()
                    break
                }
            }
        }catch{
            print(error)
        }
    }
    func deleteDataFromQuiz(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requestQuiz = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        let temp = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        requestQuiz.returnsObjectsAsFaults = false
        temp.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(requestQuiz)
            for data in result as! [NSManagedObject]
            {
                let id = data.value(forKey: "quiz_id") as! Int
               // print("debug>> deleted")
                if id == quizList[index].quizId{
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
        do{
            let re = try context.fetch(temp)
            for data in re as! [NSManagedObject]
            {
                let id = data.value(forKey: "quiz_id") as! Int
                // print("debug>> deleted")
                if id == quizList[index].quizId{
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
    }
    @IBAction func addQuiz(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addQuiz", sender: self)
    }
}
