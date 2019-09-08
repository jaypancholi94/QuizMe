//
//  RegisterViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 15/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class RegisterViewController: UIViewController {
    
    struct User {
        var uName: String
        var email: String
    }
    var users = [User]()
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    //----------- errors -----------
    @IBOutlet weak var userNameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    //------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        loadData()
    }
    @IBAction func register(_ sender: UIButton) {
        if(checkFields())
        {
            var roleValue: Bool
            if(role.selectedSegmentIndex == 0)
            {
                roleValue = true; // Student
            }
            else{
                roleValue = false; // Teacher
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(userName.text, forKey: "user_name")
            newUser.setValue(roleValue, forKey: "role")
            newUser.setValue(password.text, forKey: "password")
            newUser.setValue(name.text, forKey: "name")
            newUser.setValue(email.text, forKey: "email")
            newUser.setValue(false, forKey: "active")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                users.append(User(uName: data.value(forKey: "user_name") as! String, email: data.value(forKey: "email") as! String ))
            }
            print(">>> Data Loaded!!")
            
        } catch {
            print("Failed")
        }
    }
    func checkFields() -> Bool {
        var flag: Bool = true
        if(name.text == ""){
            name.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            name.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }
        if(userName.text == ""){
            userNameError.text = "Field cannot be empty!"
            userName.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            var userNameFlag = true
            for u in users{
                if(u.uName == userName.text){
                    userNameFlag = false
                }
            }
            if(userNameFlag == false){
                userNameError.text = "User Name already exists!"
                userName.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
                flag = false
            }else{
                userNameError.text = ""
                userName.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            }
        }
        if(email.text == ""){
            email.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            emailError.text = "Field cannot be empty!"
            flag = false
        }else{
            var emailFlag = true
            for u in users{
                if(u.email == email.text){
                    emailFlag = false
                }
            }
            if(emailFlag == false){
                emailError.text = "Email already exists!"
                print("Email exists")
                email.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
                flag = false
            }else{
                email.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
                emailError.text = ""
            }
        }
        
        if(password.text == ""){
            passwordError.text = "Field cannot be empty!"
            password.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            confirmPassword.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false;
        }
        else{
            passwordError.text = ""
            password.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 225/255, alpha: 1.0)
            confirmPassword.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            if(password.text != confirmPassword.text){
                passwordError.text = "password must mathes conforim password!"
                password.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
                confirmPassword.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
                flag = false;
            }
            else
            {
                passwordError.text = ""
                password.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 225/255, alpha: 1.0)
                confirmPassword.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
        }
        return flag
    }
}
