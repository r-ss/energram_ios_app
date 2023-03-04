//
//  DataManager.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import Foundation
import CoreData
import OrderedCollections

enum DataManagerType {
    case normal, preview, testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
//    @Published var appliances: [Appliance]
    @Published var appliances: OrderedDictionary<UUID, Appliance> = [:]
//    @Published var projects: OrderedDictionary<UUID, Project> = [:]
    
    var appliancesArray: [Appliance] {
        Array(appliances.values)
    }
    
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let appliancesFRC: NSFetchedResultsController<ApplianceMO>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            for i in 0..<10 {
                let newAppliance = ApplianceMO(context: managedObjectContext)
                newAppliance.name = "Appliance \(i)"
                newAppliance.id = UUID()
                newAppliance.power = 60
                newAppliance.typical_duration = 90
            }
//            for i in 0..<4 {
//                let newProject = ProjectMO(context: managedObjectContext)
//                newProject.title = "Project \(i)"
//                newProject.id = UUID()
//            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let applianceFR: NSFetchRequest<ApplianceMO> = ApplianceMO.fetchRequest()
        applianceFR.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        appliancesFRC = NSFetchedResultsController(fetchRequest: applianceFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
//        let projectFR: NSFetchRequest<ProjectMO> = ProjectMO.fetchRequest()
//        projectFR.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        projectsFRC = NSFetchedResultsController(fetchRequest: projectFR,
//                                                 managedObjectContext: managedObjectContext,
//                                                 sectionNameKeyPath: nil,
//                                                 cacheName: nil)
        
        super.init()
        
        // Initial fetch to populate appliances array
        appliancesFRC.delegate = self
        try? appliancesFRC.performFetch()
        if let newAppliances = appliancesFRC.fetchedObjects {
            
            print(newAppliances)
            self.appliances = OrderedDictionary(uniqueKeysWithValues: newAppliances.map({ ($0.id!, Appliance(applianceMO: $0)) }))
            
        }
        
//        projectsFRC.delegate = self
//        try? projectsFRC.performFetch()
//        if let newProjects = projectsFRC.fetchedObjects {
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                log("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newAppliances = controller.fetchedObjects as? [ApplianceMO] {
            self.appliances = OrderedDictionary(uniqueKeysWithValues: newAppliances.map({ ($0.id!, Appliance(applianceMO: $0)) }))
        }
//        else if let newProjects = controller.fetchedObjects as? [ProjectMO] {
//            print(newProjects)
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchAppliances(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            appliancesFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            appliancesFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? appliancesFRC.performFetch()
        if let newAppliances = appliancesFRC.fetchedObjects {
            self.appliances = OrderedDictionary(uniqueKeysWithValues: newAppliances.map({ ($0.id!, Appliance(applianceMO: $0)) }))
        }
    }
    
    func resetFetch() {
        appliancesFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        appliancesFRC.fetchRequest.predicate = nil
        try? appliancesFRC.performFetch()
        if let newAppliances = appliancesFRC.fetchedObjects {
            self.appliances = OrderedDictionary(uniqueKeysWithValues: newAppliances.map({ ($0.id!, Appliance(applianceMO: $0)) }))
        }
    }

}

//MARK: - Appliance Methods
extension Appliance {
    
    fileprivate init(applianceMO: ApplianceMO) {
        self.id = applianceMO.id ?? UUID()
        self.name = applianceMO.name ?? ""
        
        self.created_by = "zzz"
        self.power = Int(applianceMO.power)
        self.typical_duration = Int(applianceMO.typical_duration)
//        if let projectMO = ApplianceMO.projectMO {
//            self.projectID = projectMO.id
//        }
    }
}

extension DataManager {
    
    func updateAndSave(appliance: Appliance) {
        let predicate = NSPredicate(format: "id = %@", appliance.id as CVarArg)
        let result = fetchFirst(ApplianceMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let ApplianceMO = managedObject {
                update(applianceMO: ApplianceMO, from: appliance)
            } else {
                applianceMO(from: appliance)
            }
        case .failure(_):
            print("Couldn't fetch ApplianceMO to save")
        }
        
        saveData()
    }
    
    func delete(appliance: Appliance) {
        let predicate = NSPredicate(format: "id = %@", appliance.id as CVarArg)
        let result = fetchFirst(ApplianceMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let applianceMO = managedObject {
                managedObjectContext.delete(applianceMO)
            }
        case .failure(_):
            print("Couldn't fetch ApplianceMO to save")
        }
        saveData()
    }
    
    func getAppliance(with id: UUID) -> Appliance? {
        return appliances[id]
    }
    
    private func applianceMO(from appliance: Appliance) {
        let ApplianceMO = ApplianceMO(context: managedObjectContext)
        ApplianceMO.id = appliance.id
        update(applianceMO: ApplianceMO, from: appliance)
    }
    
    private func update(applianceMO: ApplianceMO, from appliance: Appliance) {
        applianceMO.name = appliance.name
//        if let id = appliance.projectID, let project = getProject(with: id) {
//            ApplianceMO.projectMO = getProjectMO(from: project)
//        } else {
//            ApplianceMO.projectMO = nil
//        }
    }
    
    ///Get's the ApplianceMO that corresponds to the appliance. If no ApplianceMO is found, returns nil.
    private func getApplianceMO(from appliance: Appliance?) -> ApplianceMO? {
        guard let appliance = appliance else { return nil }
        let predicate = NSPredicate(format: "id = %@", appliance.id as CVarArg)
        let result = fetchFirst(ApplianceMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let ApplianceMO = managedObject {
                return ApplianceMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
        
    }
    
}

