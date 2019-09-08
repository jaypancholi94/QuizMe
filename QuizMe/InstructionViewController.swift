//
//  InstructionViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 21/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class InstructionViewController: UIViewController {

    @IBOutlet weak var quizName: UILabel!
    @IBOutlet weak var attempt: UILabel!
    @IBOutlet weak var passMarks: UILabel!
    
    @IBOutlet weak var startQuiz: UIButton!
    //--------------------------------------
    var subjectID : Int?
    var studentName : String?
    var quizID : Int?
    var passMarks_var : Int?
    var attempt_var : Int?
    var quizName_var : String?
    //--------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        var temp = getAttempt()
        if temp >= attempt_var! {
            startQuiz.isEnabled = false
            attempt.text = "\(temp)/\(attempt_var!)"
            passMarks.text = "\(passMarks_var!)"
        }else{
            quizName.text = quizName_var
            attempt.text = "\(temp)/\(attempt_var!)"
            passMarks.text = "\(passMarks_var!)"
        }
    }
    func getAttempt() -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                var un = data.value(forKey: "user_name") as! String
                var si = data.value(forKey: "subject_id") as! Int
                var qi = data.value(forKey: "quiz_id") as! Int
                if un == studentName && si == subjectID && qi == quizID{
                    return data.value(forKey: "attempt") as! Int
                }
            }
            
        } catch {
            print("Failed")
        }
        return 0
    }
    @IBAction func startQuiz(_ sender: UIButton) {
        performSegue(withIdentifier: "quiz", sender: self)
    }
    @IBAction func goBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "quiz"{
            if let destination = segue.destination as? QuizAttemptViewController{
                destination.subjectID = subjectID
                destination.studentName = studentName
                destination.quizID = quizID
                destination.passMarks = passMarks_var
                destination.quizName = quizName_var
                destination.attempt = attempt_var
            }
        }
    }
}
