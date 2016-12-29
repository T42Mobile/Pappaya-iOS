//
//  DataBaseBL.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit
import CoreData

enum EntityName : String
{
    case TimeSheetDateTable
    case TimeSheetTable
    case TimeSheetProjectTable
}

class DataBaseBL: NSObject
{
    static let sharedInstance = DataBaseBL()
    
    let managedObjectContext = getAppDelegate().managedObjectContext
    
    //MARK:- Basic function
    //MARK:-- Insert
    
    /**
     Insert new data in given table with key value dict.
     
     - Parameter tableName : EntityName - entity name where data to be inserted
     - Parameter dataDict : [String : Any] - dict of key and value to be inserted
     */
    
    func insertListOfDataInTable(tableName : EntityName, dataDictList : [[String : Any]])
    {
        for dataDict in dataDictList
        {
            self.insertDataInTable(tableName: tableName, dataDict: dataDict)
        }
    }
    
    /**
     Insert new data in given table with key value dict.
     
     - Parameter tableName : EntityName - entity name where data to be inserted
     - Parameter dataDict : [String : Any] - dict of key and value to be inserted
     */
    
    func insertDataInTable(tableName : EntityName, dataDict : [String : Any])
    {
        if dataDict.count > 0
        {
            let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: tableName.rawValue, into: managedObjectContext)
            
            newManagedObject.setValuesForKeys(dataDict)
            self.saveManagedContext()
        }
    }
    
    //MARK:-- Get
    
    /**
     Get all data available in given Table name
     
     - Parameter tableName : EntityName - entity name where data available
     - Returns [AnyObject] - array of available managedObjects
     */
    
    func getAllObjectsFromTable(tableName : EntityName , sortDescriptors : [NSSortDescriptor]) -> [NSManagedObject]
    {
        return self.getObjectsFromTable(tableName: tableName, predicate: nil, sortDescriptors:sortDescriptors)
    }
    
    
    
    /**
     Get selective datas available in given Table name for particular details (NSPredicate)
     
     - Parameter tableName : EntityName - entity name where data available
     - Parameter predicate : NSPredicate? - to fetch desired predicate data
     - Returns [AnyObject] - array of available managedObjects
     */
    
    func getObjectsFromTable(tableName : EntityName , predicate : NSPredicate? , sortDescriptors : [NSSortDescriptor]) -> [NSManagedObject]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let fetchedEmployees = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedEmployees
        } catch {
            print("Failed to fetch \(tableName): \(error)")
            return []
        }
    }
    
    //MARK:-- Delete
    
    /**
     Delete all data available in given Table name
     
     - Parameter tableName : EntityName - entity name where data available
     */
    
    func deleteAllDataInTable(tableName : EntityName)
    {
        self.deleteDataInTableForAttribute(tableName: tableName, predicate: nil)
    }
    
    /**
     Delete all data available in given Table name with custom predicate
     
     - Parameter tableName : EntityName - entity name where data available
     - Parameter predicate : NSPredicate? - to fetch desired predicate data
     */
    
    func deleteDataInTableForAttribute(tableName : EntityName , predicate : NSPredicate?)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName.rawValue)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(deleteRequest)
            self.saveManagedContext()
        }
        catch
        {
            print("Failed to delete \(tableName): \(error)")
        }
    }
    
    //MARK:-- Update
    
    /**
     Update given data in Table name with custom predicate
     
     - Parameter tableName : EntityName - entity name where data available
     - Parameter dataDict : [String : Any] - Data to be updated
     */
    
    func updateAllRowsInTable(tableName : EntityName , dataDict : [String : Any] )
    {
        self.updateRowsInTable(tableName: tableName, dataDict: dataDict, predicate: nil)
    }
    
    /**
     Update given data in Table name with custom predicate
     
     - Parameter tableName : EntityName - entity name where data available
     - Parameter dataDict : [String : Any] - Data to be updated
     - Parameter predicate : NSPredicate? - to fetch desired predicate data
     */
    
    func updateRowsInTable(tableName : EntityName , dataDict : [String : Any] , predicate : NSPredicate?)
    {
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: tableName.rawValue)
        batchUpdateRequest.predicate = predicate
        batchUpdateRequest.propertiesToUpdate = dataDict
        batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do
        {
            _ = try managedObjectContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            //print(batchUpdateResult.result)
        }
        catch
        {
            print("Failed to update entityName : \(tableName.rawValue) Error \(error)")
        }
    }
    
    //MARK:-- Check
    
    /**
     Check given data is available in Table name with custom predicate
     
     - Parameter tableName : EntityName - entity name where data available
     - Parameter predicate : NSPredicate? - to check desired predicate data
     - Return Bool
     */
    
    func checkIfDataAvailableInTable(tableName : EntityName , predicate : NSPredicate?) -> Bool
    {
        if self.getObjectsFromTable(tableName: tableName, predicate: predicate, sortDescriptors : []).count > 0
        {
            return true
        }
        return false
    }
    
    //MARK:- Private Functions
    
    /**
     Save the managed context
     */
    
    private func saveManagedContext()
    {
        do {
            try managedObjectContext.save()
        }
        catch
        {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // Example
    
    //DataBaseBL.sharedInstance.insertDataInTable(EntityName.NewEntity, dataDict: ["name" : "DATA2" , "type" : 1])
//    DataBaseBL.sharedInstance.updateAllRowsInTable(EntityName.NewEntity, dataDict: ["name" : "DATA1" ])
    //let predicate = NSPredicate(format: "name == %@", argumentArray: ["DATA2"])
    //DataBaseBL.sharedInstance.updateRowsInTable(EntityName.NewEntity, dataDict: ["name" : "DATA2" , "type" : 2 ], predicate: predicate)
    //DataBaseBL.sharedInstance.deleteDataInTableForAttribute(EntityName.NewEntity, predicate: nil)
    
    //DataBaseBL.sharedInstance.checkIfDataAvailableInTable(EntityName.NewEntity, predicate: predicate)
}
