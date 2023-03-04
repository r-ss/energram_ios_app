//
//  CoreApplianceEditorView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI


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
