//
//  CoreDataManager.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 10.02.2023.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func fetchProducts() -> [Products] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Products")
        do {
            let products = try managedContext.fetch(fetchRequest)
            return products as! [Products]
        } catch  let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return []
    }
    
    func fetchPrice() -> String {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Products")
        var totalPrice: Float = 0.0
        do {
            let products = try managedContext.fetch(fetchRequest) as? [Products]
            if let models = products {
                for model in models {
                    totalPrice += model.price
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        let formatted = String(format: "%.2f", totalPrice)
        return formatted
    }
    
    func quantityUpdate(name: String, quantity: String, price: Float) {
        let request: NSFetchRequest<Products> = Products.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", argumentArray: [name])
        
        do {
            let results = try managedContext.fetch(request)
            if results.count != 0 {
                let product = results[0]
                
                product.setValue(name, forKey: "name")
                product.setValue(quantity, forKey: "quantity")
                product.setValue(price, forKey: "price")
                self.save()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    
    @discardableResult
    func saveProducts(id: String, name: String, price: Float,image: String, quantity: String) -> Products? {
        let entity = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)!
        let product = NSManagedObject(entity: entity, insertInto: managedContext)
        product.setValue(id, forKey: "id")
        product.setValue(name, forKey: "name")
        product.setValue(price, forKey: "price")
        product.setValue(image, forKey: "image")
        product.setValue(quantity, forKey: "quantity")
        if save() {
            return product as? Products
        }
        return nil
    }
    
    func deleteProduct(model: Products) {
        managedContext.delete(model)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllProducts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Products")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.persistentStoreCoordinator?.execute(deleteRequest, with: managedContext)
        } catch {
            print( "Error on deletion of entity:" + error.localizedDescription)
        }
    }
    
    func deleteSingleProduct(id: String) {
        let request: NSFetchRequest<Products> = Products.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        if let result = try? managedContext.fetch(request) {
            for object in result {
                managedContext.delete(object)
            }
        }
        do {
            try managedContext.save()
        } catch {
            print( "Error on deletion of entity:" + error.localizedDescription)
        }
    }
    
    func countOfModel() -> Int {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        let entity = NSEntityDescription.entity(forEntityName: "ENTITY", in: managedContext)
        let statusDesc = entity?.attributesByName["id"]
        
        fetch.propertiesToFetch = [statusDesc].compactMap { $0 }
        fetch.resultType = .dictionaryResultType
        
        var results: [Any]? = [Any]()
        do {
            results = try managedContext.fetch(fetch)
            
        } catch {
            print( "Error on deletion of entity:" + error.localizedDescription)
        }
        return results!.count
    }
    
    func ifProductExist(productName: String) -> Bool {
        let request: NSFetchRequest<Products> = Products.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", argumentArray: [productName])
        do {
            let results = try managedContext.fetch(request)
            return results.count > 0
        } catch {
            print("Fetch Failed: \(error)")
            return false
        }
    }
    
    @discardableResult
    func save() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save \(error.localizedDescription), \(error.userInfo)")
        }
        return false
    }
}

