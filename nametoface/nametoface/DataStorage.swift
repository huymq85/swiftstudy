//
//  DataStorage.swift
//  nametoface
//
//  Created by COM on 2016. 3. 27..
//  Copyright © 2016년 COM. All rights reserved.
//

import Foundation

public class DataStorage {
    
    let userDefaults: NSUserDefaults
    
    var people = [Person]()

    
    static let sharedInstance = DataStorage()
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        loadPeople()
    }
    
    func loadPeople(){
        if let savedPeople = userDefaults.objectForKey("people") as? NSData {
            people = NSKeyedUnarchiver.unarchiveObjectWithData(savedPeople) as! [Person]
        }
    }
    
    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(people)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "people")
    }
    
    func getPeople() -> [Person] {
        return people;
    }
    
    func addPerson(person:Person){
        people.append(person)
        save()
    }
    
    func deletePerson(id:String){
        for (index, p) in people.enumerate() {
            if p.id == id {
                people.removeAtIndex(index)
                break
            }
        }
        save()
    }





}