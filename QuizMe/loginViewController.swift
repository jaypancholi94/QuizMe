//
//  ViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 15/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    struct User {
        var userName : String
        var role : Bool
        var name : String
        var email : String
        var password : String
    }
    var fetchedData = [User]()
    var loginUser : User?
    //---------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
       // deleteAllData(entity: "User")
        loadData()
       // print(fetchedData)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true;
    }
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                    context.delete(data)
            }
            do{
             try context.save()
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
         if(varifyData()){
            if (checkExist()){
                if(loginUser!.role == true){
                    self.changeState()
                    self.performSegue(withIdentifier: "studentSegue", sender: self)
                }else{
                    self.changeState()
                    self.performSegue(withIdentifier: "teacherSegue", sender: self)
                }
            }else{
                let alert = UIAlertController(title: "Invalid entry", message: "Invalid user id or password", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                print("Not Exist")
            }
        }
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
            for data in fetch as! [NSManagedObject]{
                let un = data.value(forKey: "user_name") as! String
                if loginUser?.userName == un{
                    data.setValue(true, forKey: "active") // aya thase
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
    @IBAction func Register(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registrationSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrationSegue" {
            if let destination = segue.destination as? RegisterViewController {
            }
        }else if segue.identifier == "studentSegue"{
            if let destination = segue.destination as? StudentDashBoardViewController {
                destination.userName = loginUser!.userName
                destination.role = loginUser!.role
                destination.name = loginUser!.name
                destination.email = loginUser!.email
                destination.password = loginUser!.password
            }
        }else if segue.identifier == "teacherSegue"{
            if let destination = segue.destination as? TeacherDashBoardViewController{
                destination.userName = loginUser!.userName
                destination.role = loginUser!.role
                destination.name = loginUser!.name
                destination.email = loginUser!.email
                destination.password = loginUser!.password
            }
        }
    }
    
    func checkExist() -> Bool{
        print(fetchedData)
        for u in fetchedData{
            if(u.userName == userName.text && u.password == password.text){
                loginUser = u;
                return true
            }
        }
        return false
    }
    func varifyData() -> Bool {
        loadData()
        var flag = true
        if (userName.text == "") {
            userName.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            userName.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }
        if (password.text == "") {
            password.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 214/255, alpha: 1.0)
            flag = false
        }else{
            password.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }
        return flag
    }
    func loadData() {
        fetchedData.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                fetchedData.append(User(userName: data.value(forKey: "user_name") as! String, role: data.value(forKey: "role") as! Bool, name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, password: data.value(forKey: "password") as! String))
                //fetchedData.append(Login(userName: data.value(forKey: "user_name") as! String, password: data.value(forKey: "password") as! String))
               // var n = data.value(forKey: "user_name") as! String
               // var p = data.value(forKey: "password") as! String
               // print("\(n) || \(p) ")
            }
            
        } catch {
            
            print("Failed")
        }
    }
}

