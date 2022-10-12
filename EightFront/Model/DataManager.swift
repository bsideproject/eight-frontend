//
//  DataManager.swift
//  EightFront
//
//  Created by wargi on 2022/09/27.
//

import Foundation
import CoreData

final class DataManager {
    static let shared = DataManager()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @Published var currentSetting: Setting?
    var setting: Setting? {
        didSet {
            currentSetting = setting
        }
    }
    
    func fetchData() {
        let settingRequest: NSFetchRequest<Setting> = Setting.fetchRequest()
        
        if let setting = try? mainContext.fetch(settingRequest).first {
            self.setting = setting
        } else {
            let newSetting = NewSetting(naviType: "naver")
            addNew(setting: newSetting)
        }
    }
    
    func addNew(setting: NewSetting) {
        let newSetting = Setting(context: mainContext)
        newSetting.naviType = setting.naviType
        self.setting = newSetting
        
        saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
