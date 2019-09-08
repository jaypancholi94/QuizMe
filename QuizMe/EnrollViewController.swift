//
//  EnrollViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 19/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class EnrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct subject{
        var subjectName : String
        var subjectId : Int
    }
   
    
    @IBOutlet weak var tableView: UITableView!
    var studentId: String?
    var enrolledSubjectList = [Int]()
    var subjects = [subject]()
    var selectedSubject = [subject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
           // selectedSubject.index
            //for check in selectedSubject{
              //  if check.subjectId == subjects[indexPath.row].subjectId{
                    
             //   }
           // }
            //print("SA :: \(selectedSubject)")
            //print("remove::: \(subjects[indexPath.row].subjectId)")
            
           selectedSubject = selectedSubject.filter(){$0.subjectId != subjects[indexPath.row].subjectId}
           // print(selectedSubject)
            
        }else{
            //print("add")
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            selectedSubject.append(subject(subjectName: subjects[indexPath.row].subjectName, subjectId: subjects[indexPath.row].subjectId))
         
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = subjects[indexPath.row].subjectName
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    override func viewWillAppear(_ animated: Bool) {
        loadSubjects()
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func loadSubjects() {
        subjects.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            //print(">>> \(enrolledSubjectList) || \(studentId)")
            for data in result as! [NSManagedObject] {
                var subId = data.value(forKey: "subject_id") as! Int
                
                if enrolledSubjectList.contains(subId){
                    print(">>>>>>>>>>>true")
                }else{
                    print(">>>>>>>>>>>false")
                    subjects.append(subject(subjectName: data.value(forKey: "subject_name") as! String, subjectId: data.value(forKey: "subject_id") as! Int))
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    @IBAction func enrollToSubject(_ sender: UIButton) {
        for en in selectedSubject{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Enroll", in: context)
            let newSubject = NSManagedObject(entity: entity!, insertInto: context)
            
            newSubject.setValue(en.subjectName, forKey: "subject_name")
            newSubject.setValue(en.subjectId, forKey: "subject_id")
            newSubject.setValue(studentId, forKey: "user_name")
            //print(userName)
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}
