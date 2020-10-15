//
//  CoreDataService.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import UIKit
import CoreData

class CoreDataService {
    
    init(){
        
    }
    
    func createMeal(meal: Meal) -> Bool{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteMeal", in: context)
        let newMeal = NSManagedObject(entity: entity!, insertInto: context)
        
        do{
         
            let dict = try meal.asDictionary()
            
            newMeal.setValuesForKeys(dict)
            
            try context.save()
            
            return true
            
        }catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func readMeal(id: String) -> Meal? {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteMeal")
        request.predicate = NSPredicate(format: "idMeal = %@", id)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let keys = FavouriteMeal.init(context: context).entity.attributesByName.keys.sorted()
            
            var retrievedMeals: [Meal] = []
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                retrievedMeals.append(try Meal(from: data.dictionaryWithValues(forKeys: keys)))
            }
            
            return retrievedMeals.count > 0 ? retrievedMeals[0] : nil
        } catch let error {
            
            print(error.localizedDescription)
            return nil
        }
    }
    
    func readMeals() -> [Meal]? {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteMeal")
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let keys = FavouriteMeal.init(context: context).entity.attributesByName.keys.sorted()
            
            var retrievedMeals: [Meal] = []
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                if(data.value(forKey: "idMeal") != nil){
                    retrievedMeals.append(try Meal(from: data.dictionaryWithValues(forKeys: keys)))
                }
            }
            
            return retrievedMeals
        } catch let error {
            
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteMeal(id: String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteMeal")
        request.predicate = NSPredicate(format: "idMeal = %@", id)
        request.returnsObjectsAsFaults = false
        
        do {
                        
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                context.delete(data)
            }
            
            return true
        } catch let error {
            
            print(error.localizedDescription)
            return false
        }
    }
    
    func deleteMeals() -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteMeal")        
        request.returnsObjectsAsFaults = false
        
        do {
                        
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                context.delete(data)
            }
            
            return true
        } catch let error {
            
            print(error.localizedDescription)
            return false
        }
    }
}
