//
//  CoreDataHandler.swift
//  TopaceForReddit
//
//  Created by hesham on 12/18/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import CoreData

// https://medium.com/xcblog/core-data-with-swift-4-for-beginners-1fc067cca707
struct CoreDataHandler {

    private var context : NSManagedObjectContext?
    private let SUBREDDIT_ENTITY_NAME = "Subreddit"
    private let DISPLAY_ORDER_ATTRIBUTE = "displayOrder"
    private let NAME_ATTRIBUTE = "name"

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    var subredditNames : [String] {
        var subsNames = [String]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SUBREDDIT_ENTITY_NAME)
        request.sortDescriptors = [NSSortDescriptor(key: DISPLAY_ORDER_ATTRIBUTE, ascending: true)]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            for name in result as! [NSManagedObject] {
                let subName = name.value(forKey: NAME_ATTRIBUTE) as! String
                subsNames.append(subName)
            }
        } catch {
            print("CoreDataHandler:subredditNames: Failed")
        }
        return subsNames
    }

    func saveSubredditNames(names: [String]) {
        if let context = context {
            let entity = NSEntityDescription.entity(forEntityName: SUBREDDIT_ENTITY_NAME, in: context)
            for (index,name) in names.enumerated() {
                let newSub = NSManagedObject(entity: entity!, insertInto: context)
                newSub.setValue(name, forKey: NAME_ATTRIBUTE)
                // when retrieved back it won't be in order, so this attribute is added in the table.
                newSub.setValue(index+1, forKey: DISPLAY_ORDER_ATTRIBUTE)
            }
            saveContext()
        }
    }

    func saveContext() {
        do {
            try context?.save()
        } catch  let error as NSError {
            print("CoreDataHandler:saveContext: Failed saving context - \(error) \(error.userInfo)")
        }
    }

    // https://stackoverflow.com/a/47200619/
    func deleteSubredditNames() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SUBREDDIT_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context?.fetch(fetchRequest)
            if let results = results {
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    context?.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("CoreDataHandler:deleteSubredditNames - \(error) \(error.userInfo)")
        }
        saveContext()
    }
}
