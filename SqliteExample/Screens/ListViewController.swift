//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Mayank Barnwal on 17/07/24.
//

import UIKit


class ListViewController: UIViewController {

    @IBOutlet weak var containerTableView: UITableView!
    
    private lazy var userArray:[UserModal] = []{
        didSet{
            containerTableView.reloadData()
        }
    }
    
    private var dbManager = DBManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onRegisterBtn(_ sender: Any) {
        performSegue(withIdentifier: "OpenRegisterView", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userArray = dbManager.getUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenRegisterView" && sender != nil{
            if let registerViewController = segue.destination as? RegisterViewController{
                registerViewController.user = sender as? UserModal
            }
        }
    }
}


extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration ()
        let user = userArray[indexPath.row]
        content.text = "\(user.fName) \(user.lName)"
        content.secondaryText = user.email
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = dbManager.getUser(email: userArray[indexPath.row].email){
            performSegue(withIdentifier: "OpenRegisterView", sender: user)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let alert = UIAlertController(title: "Alert!!!", message: "Are you sure?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) {[weak self] action in
                guard let self else{
                    return
                }
                if dbManager.deleteUser(user: userArray[indexPath.row]){
                    userArray = dbManager.getUsers()
                }
                else{
                
                    let alert = UIAlertController(title: "Alert!!!", message: "Something went wrong!!!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                        
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true)
                }
                
            }
            
            alert.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .default) { action in
                
            }
            alert.addAction(noAction)
                    
            present(alert, animated: true)

        }
    }
}
