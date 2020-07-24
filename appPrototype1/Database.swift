//
//  Database.swift
//  PT1
//
//  Created by 福島雄一朗 on 2020/05/13.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

import CoreData

class Database{


    var db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate



    init (){}

    func setData(){
        self.getDatabaseVersion(completion: {(fver : String) -> Void in self.setUpsdatabase(ver: fver)})
    }

    func setUpsdatabase(ver : String){


        let newVer = self.gerCurrentVersion(fireVer: ver)

        if (newVer == false) {
            self.deleteCoreData(name: "Shop")
            self.updateCoreDataVer(newVer: ver)
            self.loadDatatoCore(completion: {() -> Void in self.getDatafromCore()})

        }
    }

//MARK: - Core data SET UP related

    func gerCurrentVersion(fireVer : String ) -> Bool{
        print("comparing current database with firebase ..... ")
        var returnboolean : Bool
        let context = appDelegate.persistentContainer.viewContext
        var currentVar : String = ""
        let databaseVar = fireVer
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DatabaseInfo")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                currentVar = data.value(forKey: "version") as! String
                print("CURRRENT VER :" + currentVar)
                print("FIREBASE VER :" + databaseVar)
          }
        } catch {
            print("Failed")
        }

        if(databaseVar == currentVar){
            returnboolean = true
            print("result : same version ")
        }else{
            returnboolean = false
            print("result : diffrent version updating..... ")
        }
        return returnboolean
    }


    func set(){
        self.deleteCoreData(name: "DatabaseInfo")
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DatabaseInfo", in: context)
        let newversion = NSManagedObject(entity: entity!, insertInto: context)
        newversion.setValue("0", forKey: "version")
    }


    func deleteCoreData(name : String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = appDelegate.persistentContainer.viewContext

        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
    }

    func updateCoreDataVer(newVer : String){
        self.deleteCoreData(name: "DatabaseInfo")
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DatabaseInfo", in: context)
        let newversion = NSManagedObject(entity: entity!, insertInto: context)

        newversion.setValue(newVer, forKey: "version")
    }

    func getDatafromCore(){

        let context = appDelegate.persistentContainer.viewContext
        print("getting....")

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "info") as! String)
          }
        } catch {
            print("Failed")
        }
    }


//MARK:  Core data FETCH related
    
    func getByCategory() -> [Shop]{
        var shoplist = [Shop]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        request.returnsObjectsAsFaults = false
              do {
                  let result = try context.fetch(request)
                  for data in result as! [NSManagedObject] {
                    shoplist.append(data as! Shop)
                }
              } catch {
                  print("Failed")
              }

        return shoplist
    }
    
    func getByCategory(categ : String) -> [Shop]{
        var shoplist = [Shop]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        let predicate = NSPredicate(format: "category = %@", categ)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
              do {
                  let result = try context.fetch(request)
                  for data in result as! [NSManagedObject] {
                    shoplist.append(data as! Shop)
                }
              } catch {
                  print("Failed")
              }

        return shoplist
    }

    func findMatch(keyWord : String) -> [Shop]{
        var shoplist = [Shop]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        let predicate = NSPredicate(format: "info CONTAINS[c] %@", keyWord )
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
              do {
                  let result = try context.fetch(request)
                  for data in result as! [NSManagedObject] {
                    shoplist.append(data as! Shop)
                }
              } catch {
                  print("Failed")
              }
        print("Resulting list")
        print(shoplist)
        return shoplist
    }
    
    
    func findShop(shopId : String) -> [Shop]{
        var shoplist = [Shop]()
        print(shopId)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        let predicate = NSPredicate(format: "id = %@", shopId)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
              do {
                  let result = try context.fetch(request)
                  for data in result as! [NSManagedObject] {
                    shoplist.append(data as! Shop)
                }
                print(shoplist)
              } catch {
                  print("Failed")
              }

        return shoplist
    }
    
    



//    service firebase.storage { match /b/{bucket}/o { match /{allPaths=**} { allow read, write: if request.auth != null; } } }
//MARK: - Firebase related

    func loadDatatoCore(completion:  @escaping () -> Void ){

        let docRef = db.collection("shops")
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Shop", in: context)

        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.documentID != "version"){

                        let newShop = NSManagedObject(entity: entity!, insertInto: context)

                        let id = document.documentID
                        let name = document.get("name") as! String
                        let locKey = document.get("locationKey") as! String
                        var locLong = Float(0.00000)
                        if let temp = document.get("locLong") as? NSNumber{
                            locLong = temp.floatValue
                        }
                        var locLang = Float(0.00000)
                        if let temp1 = document.get("locLang") as? NSNumber{
                            locLang = temp1.floatValue
                        }
                        let categ = document.get("category") as! String
                        let infotgt = name + "," + locKey + "," + categ
                        let image = self.getImage(keyId: id)
                        let detail = document.get("description") as! String
                        //let imageKey = image.pngData()

                        newShop.setValue(id, forKey: "id")
                        newShop.setValue(name, forKey: "name")
                        newShop.setValue(locKey, forKey: "locationKey")
                        newShop.setValue(locLang, forKey: "locLang")
                        newShop.setValue(locLong, forKey: "locLong")
                        newShop.setValue(categ, forKey: "category")
                        newShop.setValue(infotgt, forKey: "info")
                        newShop.setValue(image, forKey: "image")
                        newShop.setValue(detail, forKey: "detail")


                        //print("\(document.documentID) => \(document.data())")
                    }
                }
            }
            do {
               try context.save()
                print("saved")
              } catch {
               print("Failed saving")
            }
            completion()
        }
    }

    func getDatabaseVersion(completion:  @escaping (String) -> Void) {

        print("Getting the firebase version")

        let docRef = db.collection("shops").document("version")
        var databaseVer : String = ""

        docRef.getDocument { (document, error) in
        if let error = error {
            print("Error retrieving document: \(error)")
            return
        }else{
            databaseVer = document?.get("versionNum") as! String
            }
            completion(databaseVer)
        }
    }
    
    func getImage(keyId : String) -> NSData{
        
        var returnImage = UIImage(named: "1")
        
        if(keyId == "111111"){
            returnImage = UIImage(named: "1")
        }else if(keyId == "111112"){
            returnImage = UIImage(named: "5")
        }else if(keyId == "111113"){
            returnImage = UIImage(named: "8")
        }else if(keyId == "111114"){
            returnImage = UIImage(named: "2")
        }else if(keyId == "111115"){
            returnImage = UIImage(named: "7b")
        }else if(keyId == "111116"){
            returnImage = UIImage(named: "9")
        }else if(keyId == "111117"){
            returnImage = UIImage(named: "10")
        }else if(keyId == "111118"){
            returnImage = UIImage(named: "10")
        }else if(keyId == "111119"){
            returnImage = UIImage(named: "4")
        }else if(keyId == "111120"){
            returnImage = UIImage(named: "6")
        }else{
            returnImage = UIImage(named: "nus")
        }

        let storageRef = storage.reference()
        
        let imageURL = "shopImages/" + keyId + ".jpg"
        let islandRef = storageRef.child(imageURL)
        
        

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error!)
          } else {
            // Data for "images/island.jpg" is returned
                print("ok")
            //returnImage = UIImage(data: data!)
          }
        }
        return returnImage!.jpegData(compressionQuality: 1)! as NSData
    }
    
    func getComments(keyId : String, completion:  @escaping ([String]) -> Void){
        
        var commentsArr = [String]()
        let docRef = db.collection("shops").document(keyId)
        
        docRef.getDocument { (document, error) in
        if let error = error {
            print("Error retrieving document: \(error)")
            return
        }else{
            let arr = document?.get("comments") as? Array ?? [""]
            print(arr)
            for eachCom in arr{
                commentsArr.append(eachCom)
            }
            completion(commentsArr)
        }
        
        }
    }
        
    func updateCommnent(keyId : String, newComment : String){
        let docRef = db.collection("shops").document(keyId)
        
        docRef.updateData([
            "comments": FieldValue.arrayUnion([newComment])
        ])
        
    }
    
    
    
    func getRating(keyId : String, completion:  @escaping (Double) -> Void){
        var rating : Double = 0.0
        let docRef = db.collection("shops").document(keyId)
        
        
        docRef.getDocument { (document, error) in
        if let error = error {
            print("Error retrieving document: \(error)")
            return
        }else{
            rating = document?.get("rating") as! Double
            }
            completion(rating)
        }
    }
    
    
    
        
    func UpdateRating(keyId : String, currentRating : Double,  newRating : Double){
        var deviser = 2.0
        let docRef = db.collection("shops").document(keyId)
        
        if(currentRating == 0.0){
            deviser = 1.0
        }
        
        docRef.updateData([
            "rating": (currentRating + newRating) / deviser
        ])
    }
    



    
}

