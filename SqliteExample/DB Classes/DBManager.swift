//
//  DBManager.swift
//  SqliteExample
//
//  Created by Mayank Barnwal on 22/07/24.
//

import Foundation
import FMDB

class DBManager:NSObject{
    
    private override init() {
        
    }
    
    private var database:FMDatabase!
    
    static var shared:DBManager = {
        print("Called")
        return DBManager.init()
    }()
    
    func getPath(_ fileName: String) -> String{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        print("Database Path :- \(fileUrl.path)")
        return fileUrl.path
    }
    
    func copyDatabase(_ filename: String){
        let dbPath = getPath(filename)
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: dbPath){
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(filename)
            var error:NSError?
            do{
                try fileManager.copyItem(atPath: (file?.path)!, toPath: dbPath)
            }catch let error1 as NSError{
                error = error1
            }
            
            if error == nil{
                print("Yeah!!!")
            }else{
                print("error in db")
            }
        }
        database = FMDatabase(path:dbPath)
    }
 
    func getUsers() -> [UserModal]{
        var user:[UserModal] = []
        database.open()
        if let resultSet = database.executeQuery("select * from User", withArgumentsIn: []){
            while(resultSet.next()) {
                let fName = resultSet.string(forColumn: "first_name") ?? ""
                let lName = resultSet.string(forColumn: "last_name") ?? ""
                let email = resultSet.string(forColumn: "email") ?? ""
                let password = resultSet.string(forColumn: "password") ?? ""
                user.append(UserModal.init(fName: fName, lName: lName, email: email, password: password))
            }
        }
        database.close()
        return user
    }
    
    func getUser(email:String) -> UserModal?{
        var user:UserModal!
        database.open()
        if let resultSet = database.executeQuery("select * from User where email = '\(email)'", withArgumentsIn: []){
            while(resultSet.next()) {
                let fName = resultSet.string(forColumn: "first_name") ?? ""
                let lName = resultSet.string(forColumn: "last_name") ?? ""
                let email = resultSet.string(forColumn: "email") ?? ""
                let password = resultSet.string(forColumn: "password") ?? ""
                user = UserModal.init(fName: fName, lName: lName, email: email, password: password)
            }
        }
        database.close()
        return user
    }
    
    func updateData(user:UserModal) ->  Bool{
        database.open()
        let isSave = database.executeUpdate("update User set first_name = '\(user.fName)', last_name = '\(user.lName)' , password = '\(user.password)' where email = '\(user.email)'", withArgumentsIn: [user.fName,user.lName,user.email,user.password])
        database.close()
        return isSave
        
    }
    
    func saveData(user:UserModal) -> Bool{
        database.open()
        let isSave = database.executeUpdate("INSERT INTO User (first_name,last_name,email,password) VALUES (?,?,?,?)", withArgumentsIn: [user.fName,user.lName,user.email,user.password])
        database.close()
        return isSave
    }
    
    func deleteUser(user:UserModal) -> Bool{
        database.open()
        let result = database.executeUpdate("DELETE FROM User WHERE email like '%\(user.email)%'", withArgumentsIn: [])
        database.close()
        return result
    }
}

