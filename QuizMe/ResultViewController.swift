//
//  ResultViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 22/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {
    var subjectID : Int?
    var studentName : String?
    var quizID : Int?
    var passMarks : Int?
    var quizName : String?
    var totalQuestions : Int?
    var right : Int?
    var attempt : Int?
    var per : Int?
    /*struct resultCore {
        var userName : String
        var subjectID : Int
        var quiz_ID : Int
        var marks : Int
    }*/
    var resultsCount : Int?
//----------------------------------------------
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var totalQue: UILabel!
    @IBOutlet weak var correctAns: UILabel!
    @IBOutlet weak var wrongAns: UILabel!
    @IBOutlet weak var minReq: UILabel!
    @IBOutlet weak var back: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        calculate()
        search()
        save()
        
    }
    func search() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            resultsCount = 0
            for data in result as! [NSManagedObject] {
                let un = data.value(forKey: "user_name") as! String
                let si = data.value(forKey: "subject_id") as! Int
                let qi = data.value(forKey: "quiz_id") as! Int
                if studentName == un && subjectID == si && qi == quizID{
                    resultsCount = 1
                }
                }
            }catch {
            print("Failed")
        }
    }
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if resultsCount == 0 {
            print("first entry")
            let entity = NSEntityDescription.entity(forEntityName: "Result", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(studentName!, forKey: "user_name")
            newUser.setValue(subjectID!, forKey: "subject_id")
            newUser.setValue(quizID!, forKey: "quiz_id")
            newUser.setValue(per!, forKey: "marks")
            newUser.setValue(1, forKey: "attempt")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            print("new one")
        }else{
            
            print("second entry")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
            //request.predicate = NSPredicate(format: "user_name = \(loginUser!.userName)")
            do{
                let fetch = try context.fetch(request)
                // let changeState = fetch as! NSManagedObject
                // changeState.setValue(true, forKey: "active")
                //print(">>>\(fetch)")
                for data in fetch as! [NSManagedObject]{
                    let un = data.value(forKey: "user_name") as! String
                    let si = data.value(forKey: "subject_id") as! Int
                    let qi = data.value(forKey: "quiz_id") as! Int
                    if studentName == un && subjectID == si && qi == quizID{
                        let m = data.value(forKey: "marks") as! Int
                        let a = data.value(forKey: "attempt") as! Int
                        if m < per!{
                                data.setValue(per, forKey: "marks")
                                data.setValue((a + 1), forKey: "attempt")
                        }else{
                             data.setValue((a + 1), forKey: "attempt")
                        }
                    }
                }
                
                do{
                    try context.save()
                }catch{
                    print(error)
                }
                print("old one")
            } catch{
                print(error)
            }
        }
        
    }
    func calculate() {
        per = Int(Double(right!) / Double(totalQuestions!) * 100)
        
        if(per! >= passMarks!)
        {
            percentage.text = "\(per!)%"
            status.text = "Congratulations"
            totalQue.text = "\(totalQuestions!)"
            correctAns.text = "\(right!)"
            wrongAns.text = "\(totalQuestions! - right!)"
            minReq.text = "\(passMarks!)%"
            back.backgroundColor = UIColor.init(red: 153/255, green: (255/255), blue: (153/255), alpha: 1.0)
        }
        else{
            percentage.text = "\(per!)%"
            status.text = "Sorry! Fail"
            totalQue.text = "\(totalQuestions!)"
            correctAns.text = "\(right!)"
            wrongAns.text = "\(totalQuestions! - right!)"
            minReq.text = "\(passMarks!)%"
            back.backgroundColor = UIColor.init(red: 255/255, green: (51/255), blue: (51/255), alpha: 1.0)
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
}
