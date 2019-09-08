//
//  StudentQuizViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 20/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class StudentQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    var  subjectName : String?
    var subjectId : Int?
    var studentName : String?
    @IBOutlet weak var tableView: UITableView!
    struct quizCondition {
        var passPer : Int
        var attempt : Int
        var quizID : Int
        var quizName: String
    }
    var quizList = [quizCondition]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        subjectNameLabel.text = subjectName
        loadQuiz()
        loadAverage()
        tableView.rowHeight = 100
    }
    func loadAverage() {
        var marks : Int = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
                marks = 0
            }else{
                //print(result)
                var divide = 0
                for data in result as! [NSManagedObject] {
                    let si = data.value(forKey: "subject_id") as! Int
                    let un = data.value(forKey: "user_name") as! String
                    if si == subjectId && un == studentName{
                        divide += 1
                        marks = marks + (data.value(forKey: "marks") as! Int)
                        print("every \(data.value(forKey: "marks") as! Int)")
                    }
            }
              //  print("before\(marks)")
               // print("before\(result.count)")
                marks = Int(marks/divide)
            
            }
        } catch {
            print("Failed")
        }
        average.text = "\(marks)%"
    }
    func loadQuiz()  {
        quizList.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let subID = data.value(forKey: "subject_id") as! Int
                if subID == subjectId{
                    quizList.append(quizCondition(passPer: data.value(forKey: "passing_per") as! Int, attempt: data.value(forKey: "attempt") as! Int, quizID: data.value(forKey: "quiz_id") as! Int, quizName: data.value(forKey: "quiz_name") as! String))
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instruction" {
            if let destination = segue.destination as? InstructionViewController{
            let index = tableView.indexPath(for: sender as! UITableViewCell)
            destination.subjectID = subjectId
            destination.studentName = studentName
            destination.quizID = quizList[(index?.row)!].quizID
            destination.passMarks_var = quizList[(index?.row)!].passPer
            destination.attempt_var = quizList[(index?.row)!].attempt
            destination.quizName_var = quizList[(index?.row)!].quizName
            }
        }
    }
}
