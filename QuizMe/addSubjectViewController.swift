//
//  addSubjectViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 16/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class addSubjectViewController: UIViewController {
    @IBOutlet weak var subject_name: UITextField!
    var userName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    
    }
    @IBAction func addSubject(_ sender: UIButton) {
        if subject_name.text == "" {
            subject_name.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
        }else
        {
            let number = Int.random(in: 0 ..< 10000)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Subject", in: context)
            let newSubject = NSManagedObject(entity: entity!, insertInto: context)
            newSubject.setValue(subject_name.text, forKey: "subject_name")
            newSubject.setValue(number, forKey: "subject_id")
            newSubject.setValue(userName, forKey: "user_name")
            //print(userName)
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
         _ = navigationController?.popViewController(animated: true)
        }
        
    
        
    }
    
}
