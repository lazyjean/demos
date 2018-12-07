//
//  ViewController.swift
//  coredata-swift
//
//  Created by 刘真 on 2018/12/7.
//  Copyright © 2018 Liu Zhen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: nil, queue: OperationQueue.main) { (notification) in
                                                print("context objects did chagne")
                                                print(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextWillSave,
                                               object: nil, queue: OperationQueue.main) { (notification) in
                                                print("context objects will save")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil, queue: OperationQueue.main) { (notification) in
                                                print("context objects did save")
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
        
        let user = User(context: context)
        user.nickname = nickname.text
        user.mobile = mobile.text
        
        nickname.text = nil
        mobile.text = nil
    }
    
    var users:[User] = []
    
    @IBAction func queryUsers(_ sender: Any) {
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            users = try context.fetch(request)
            tableView.reloadData()
        } catch (let e) {
            print("do fetch failed \(e)")
        }

    }
    
    @IBOutlet weak var mergePolicy: UISegmentedControl!
    
    @IBAction func save(_ sender: Any) {
        switch mergePolicy.selectedSegmentIndex {
        case 0:
            context.mergePolicy = NSRollbackMergePolicy
        case 1:
            context.mergePolicy = NSOverwriteMergePolicy
        case 2:
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        case 3:
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        default:
            break
        }
        do {
            try self.context.save()
        } catch (let e) {
            print("保存出错 \(e)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.nickname
        cell.detailTextLabel?.text = user.mobile
        return cell
    }
}

