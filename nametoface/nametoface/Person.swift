//
//  Person.swift
//  nametoface
//
//  Created by COM on 2016. 3. 27..
//  Copyright © 2016년 COM. All rights reserved.
//

import UIKit

class Person: NSObject , NSCoding{
    
    var id: String
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.id = String(NSDate().timeIntervalSince1970)
        self.name = name
        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as! String
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }

}
