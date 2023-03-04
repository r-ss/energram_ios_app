//
//  ApplianceEditorViewModel.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import Foundation
import Combine

@MainActor
final class ApplianceEditorViewModel: ObservableObject {
    
    @Published var editingAppliance: Appliance
    @Published var projectSearchText: String = ""
//    @Published var selectedProjectToEdit: Appliance? = nil
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(appliance: Appliance?, dataManager: DataManager = DataManager.shared) {
        if let appliance = appliance {
            self.editingAppliance = appliance
        } else {
            self.editingAppliance = Appliance(name: "", typical_duration: 60, power: 1000, created_by: "NA")
        }
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
//    var projects: [Project] {
//        dataManager.projectsArray
//    }
    
//    var searchFilteredProjects: [Appliance] {
//        if !projectSearchText.isEmpty {
//            return projects.filter({$0.title.localizedLowercase.contains(projectSearchText.localizedLowercase)})
//        } else {
//            return projects
//        }
//    }
    
//    func toggleProject(project: Project) {
//        if editingTodo.projectID == project.id {
//            editingTodo.projectID = nil
//        } else {
//            editingTodo.projectID = project.id
//        }
//    }
    
    func saveAppliance() {
        dataManager.updateAndSave(appliance: editingAppliance)
    }
    
//    func addNewProject() {
//        projectSearchText = String(projectSearchText.trailingSpacesTrimmed)
//        if !projects.contains(where: {$0.title.localizedLowercase == projectSearchText.localizedLowercase}) {
//            var project = Project()
//            project.title = projectSearchText
//            dataManager.updateAndSave(project: project)
//            projectSearchText = ""
//        }
//    }
}

extension StringProtocol {

    @inline(__always)
    var trailingSpacesTrimmed: Self.SubSequence {
        var view = self[...]

        while view.last?.isWhitespace == true {
            view = view.dropLast()
        }

        return view
    }
}
