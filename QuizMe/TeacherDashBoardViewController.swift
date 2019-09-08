//
//  TeacherDashBoardViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 15/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class TeacherDashBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userName : String?
    var role : Bool?
    var name : String?
    var email : String?
    var password : String?
    struct subjectsStruct {
        var subjectName : String
        var subjectId: Int
    }
    var subjects = [subjectsStruct]()
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        teacherName.text = userName // change it to name
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tableView.rowHeight = 100
        navigationController?.navigationBar.barTintColor = UIColor(red: 253.00/255.00, green: 147.00/255.00, blue: 39.00/255.00, alpha: 1.0)
        //loadSubject()
        //print("Main")
        
    }
    
    @IBAction func addSubject(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addSubject", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        loadSubject()
        tableView.reloadData()
    }
    func loadSubject() {
        subjects.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let un = data.value(forKey: "user_name") as! String
                if un == userName{
                    subjects.append(subjectsStruct(subjectName: data.value(forKey: "subject_name") as! String, subjectId: data.value(forKey: "subject_id") as! Int))
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
    @IBAction func logOut(_ sender: UIButton) {
        changeState()
        //self.performSegue(withIdentifier: "logOut", sender: self)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func changeState() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "user_name = \(loginUser!.userName)")
        do{
            let fetch = try context.fetch(request)
            // let changeState = fetch as! NSManagedObject
            // changeState.setValue(true, forKey: "active")
            //print(">>>\(fetch)")
            for data in fetch as! [NSManagedObject]{
                let un = data.value(forKey: "user_name") as! String
                if userName == un{
                    data.setValue(false, forKey: "active")
                }
            }
            
            do{
                try context.save()
            }catch{
                print(error)
            }
        } catch{
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logOut" {
            let destination = segue.destination as? RegisterViewController
        }
        else if segue.identifier == "addSubject"{
            if let destination = segue.destination as? addSubjectViewController{
                destination.userName = userName
            }
        }else if segue.identifier == "quiz"{
            if let destination = segue.destination as? QuizViewController{
                let index = tableView.indexPath(for: sender as! UITableViewCell)
                destination.subjectNm = subjects[(index?.row)!].subjectName
                destination.userName = userName
                destination.subjectId = subjects[(index?.row)!].subjectId
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = subjects[indexPath.row].subjectName
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let sub = subjects[indexPath.row]
            deleteData(index: indexPath.row)
            
            subjects.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func deleteData(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        let quiz = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        let condition = NSFetchRequest<NSFetchRequestResult>(entityName: "Condition")
        var quizId = [Int]()
        
        request.returnsObjectsAsFaults = false
        quiz.returnsObjectsAsFaults = false
        result.returnsObjectsAsFaults = false
        condition.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let id = data.value(forKey: "subject_id") as! Int
                if id == subjects[index].subjectId{
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
        do{
            let con = try context.fetch(condition)
            for data in con as! [NSManagedObject]
            {
                let id = data.value(forKey: "subject_id") as! Int
                if id == subjects[index].subjectId{
                    let qi = data.value(forKey: "quiz_id") as! Int
                    quizId.append(qi)
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
        do{
            let q = try context.fetch(quiz)
            for data in q as! [NSManagedObject]
            {
                let id = data.value(forKey: "quiz_id") as! Int
                if quizId.contains(id){
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
        do{
            let re = try context.fetch(result)
            for data in re as! [NSManagedObject]
            {
                let id = data.value(forKey: "subject_id") as! Int
                if id == subjects[index].subjectId{
                    context.delete(data)
                    try context.save()
                }
            }
        }catch{
            print(error)
        }
        
    }
    
    
}
