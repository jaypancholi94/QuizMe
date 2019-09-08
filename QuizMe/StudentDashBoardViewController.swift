//
//  StudentDashBoardViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 15/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class StudentDashBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userName : String?
    var role : Bool?
    var name : String?
    var email : String?
    var password : String?
    
    struct enrollStruct{
        var subjectName : String
        var subjectID : Int
    }
    @IBOutlet weak var tableView: UITableView!
    
    var enrollArray = [enrollStruct]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enrollArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = enrollArray[indexPath.row].subjectName
        return cell
    }   
//-------------------------------------------
    @IBOutlet weak var studentName: UILabel!
    
//-------------------------------------------
    var student : User?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        studentName.text = userName
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        loadEnroll()
        tableView.reloadData()
         navigationController?.navigationBar.barTintColor = UIColor(red: 48.00/255.00, green: 167.00/255.00, blue: 29.00/255.00, alpha: 1.0)
        tableView.rowHeight = 100
    }
    func loadEnroll()  {
        enrollArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Enroll")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let un = data.value(forKey: "user_name") as! String
                if un == userName{
                    enrollArray.append(enrollStruct(subjectName: data.value(forKey: "subject_name") as! String, subjectID: data.value(forKey: "subject_id") as! Int))
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
    @IBAction func logOut(_ sender: UIButton) {
        changeState()
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
    
    @IBAction func enroll(_ sender: Any) {
        self.performSegue(withIdentifier: "enroll", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enroll" {
            if let destination = segue.destination as? EnrollViewController{
                destination.studentId = userName
                var subList = [Int]()
                for selSub in enrollArray{
                    subList.append(selSub.subjectID)
                }
                destination.enrolledSubjectList = subList
                
            }
        }
        else if segue.identifier == "quiz"{
            if let destination = segue.destination as? StudentQuizViewController{
                let index = tableView.indexPath(for: sender as! UITableViewCell)
                destination.subjectId = enrollArray[(index?.row)!].subjectID
                destination.subjectName = enrollArray[(index?.row)!].subjectName
                destination.studentName = userName
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let sub = enrollArray[indexPath.row]
            deleteData(index: indexPath.row)
            enrollArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func deleteData(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Enroll")
        let re = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let subid = data.value(forKey: "subject_id") as! Int
                let id = data.value(forKey: "user_name") as! String
                if subid == enrollArray[index].subjectID && id == userName{
                    context.delete(data)
                    try context.save()
                    break
                }
            }
        }catch{
            print(error)
        }
        do{
            let r = try context.fetch(re)
            for data in r as! [NSManagedObject]
            {
                let subid = data.value(forKey: "subject_id") as! Int
                let id = data.value(forKey: "user_name") as! String
                if subid == enrollArray[index].subjectID && id == userName{
                    context.delete(data)
                    try context.save()
                    break
                }
            }
        }catch{
            print(error)
        }
    }
}
