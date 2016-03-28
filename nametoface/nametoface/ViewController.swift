//
//  ViewController.swift
//  nametoface
//
//  Created by COM on 2016. 3. 27..
//  Copyright © 2016년 COM. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var editModeEnabled = false
    
    var leftButton:UIBarButtonItem!
    var rightButton:UIBarButtonItem!


    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataStorage.sharedInstance.getPeople().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCellCollectionViewCell
        
        let person = DataStorage.sharedInstance.getPeople()[indexPath.item]
        
        let path = getDocumentsDirectory().stringByAppendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.name.text = person.name
        
        // Create a UIButton
        if  cell.deleteButton == nil {
            cell.createDeleteButton()
        }
        
        if !editModeEnabled {
            cell.deleteButton.hidden = true
        } else {
            cell.deleteButton.hidden = false
            cell.shakeIcons()

        }
        cell.deleteButton.layer.setValue(person.id, forKey: "index")
        
        // Add an action function to the delete button
        cell.deleteButton.addTarget(self, action: "deletePhotoCell:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.layer.cornerRadius = 7
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let person = DataStorage.sharedInstance.getPeople()[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "OK", style: .Default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            DataStorage.sharedInstance.save()
            self.collectionView.reloadData()
            })
        
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        let imageName = NSUUID().UUIDString
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
            jpegData.writeToFile(imagePath, atomically: true)
        }
        
        DataStorage.sharedInstance.addPerson(Person(name: "Unknown", image: imageName))
        collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func editPersonTap() {
        if(editModeEnabled == false) {
            // Put the collection view in edit mode
            
            rightButton!.style = .Done
            rightButton!.title = "Done"
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [PersonCellCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as PersonCellCollectionViewCell)!
                var cell: PersonCellCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! PersonCellCollectionViewCell!
                cell.deleteButton.hidden = false // Hide all of the delete buttons
                cell.shakeIcons()

            }
        } else {
            // Take the collection view out of edit mode
            rightButton!.style = .Plain
            rightButton!.title = "Edit"
            
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [PersonCellCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView.indexPathForCell(item as PersonCellCollectionViewCell)!
                var cell: PersonCellCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! PersonCellCollectionViewCell!
                cell.deleteButton.hidden = true  // Hide all of the delete buttons
                cell.stopShakingIcons()

            }
            
            
        }
        collectionView.reloadData()
    }
    
    func deletePhotoCell(sender:UIButton) {
        
        // Put the index number of the delete button the use tapped in a variable
        let id: String = (sender.layer.valueForKey("index")) as! String
        // Remove an object from the collection view's dataSource
        DataStorage.sharedInstance.deletePerson(id)
        editModeEnabled = false
        
        // Refresh the collection view
        self.collectionView!.reloadData()

    }
    
    // This function is fired when the collection view begin scrolling
    func collectionView(collectionView: UICollectionView, didBeginDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if editModeEnabled == true {
            for cell in self.collectionView!.visibleCells() as! [PersonCellCollectionViewCell] {
                // Shake all of the collection view cells
                cell.shakeIcons()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
        rightButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPersonTap")


        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

