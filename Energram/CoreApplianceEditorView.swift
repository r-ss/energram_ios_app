//
//  CoreApplianceEditorView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI
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


struct CoreApplianceEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ApplianceEditorViewModel
    
    init(appliance: Appliance?, dataManager: DataManager = DataManager.shared) {
        self.viewModel = ApplianceEditorViewModel(appliance: appliance, dataManager: dataManager)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.editingAppliance.name)
                //DatePicker("Date", selection: $viewModel.editingTodo.date)
                //Toggle("Complete", isOn: $viewModel.editingTodo.isComplete)
            }
            Section {
//                TextField("Add a project", text: $viewModel.projectSearchText) {
//                    if viewModel.searchFilteredProjects.isEmpty {
//                        viewModel.addNewProject()
//                    }
//                }
//                if viewModel.searchFilteredProjects.isEmpty {
//                    Button {
//                        viewModel.addNewProject()
//                    } label: {
//                        Label("Add Project", systemImage: "plus.circle")
//                    }
//                } else {
//                    ForEach(viewModel.searchFilteredProjects) { project in
//                        Button {
//                            viewModel.selectedProjectToEdit = project
//                        } label: {
//                            HStack {
//                                Button {
//                                    viewModel.toggleProject(project: project)
//                                } label: {
//                                    Image(systemName: "circle" + (viewModel.editingTodo.projectID == project.id ? ".fill" : ""))
//                                }
//                                Text(project.title)
//                            }
//                            .foregroundColor(.primary)
//                        }
//                    }
//                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                presentationMode.wrappedValue.dismiss()
                withAnimation {
                    viewModel.saveAppliance()
                }
            } label: {
                Label("Save", systemImage: "checkmark.circle")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .navigationTitle("Edit Appliance")
        //        .sheet(item: $viewModel.selectedProjectToEdit) { project in
        //            Text("Project editor")
        ////            ProjectEditorView(project: project)
        //        }
    
    }
}

struct CoreApplianceEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CoreApplianceEditorView(appliance: Appliance.mocked.appliance1, dataManager: DataManager.preview)
    }
}
