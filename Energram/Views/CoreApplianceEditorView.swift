//
//  CoreApplianceEditorView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI


struct CoreApplianceEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var createMode: Bool = false // create or edit.. if create - hide "Delete" button
    
    @ObservedObject var viewModel: ApplianceEditorViewModel
    
    init(appliance: Appliance?, createMode: Bool = false, dataManager: DataManager = DataManager.shared) {
        self.viewModel = ApplianceEditorViewModel(appliance: appliance, dataManager: dataManager)
        self.createMode = createMode
    }
    
    
    var powerIntProxy: Binding<Double>{
        // Used to bind Double for Slider to Int for data model
        Binding<Double>(get: {
            return Double( $viewModel.editingAppliance.wrappedValue.power )
        }, set: {
            //print($0.description)
            $viewModel.editingAppliance.wrappedValue.power = Int($0)
        })
    }
    
    var durationIntProxy: Binding<Double>{
        // Used to bind Double for Slider to Int for data model
        Binding<Double>(get: {
            return Double( $viewModel.editingAppliance.wrappedValue.typical_duration )
        }, set: {
            //print($0.description)
            $viewModel.editingAppliance.wrappedValue.typical_duration = Int($0)
        })
    }
    
    var humanReadableDuration: String {
        func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
            return (minutes / 60, (minutes % 60))
        }
        if $viewModel.editingAppliance.wrappedValue.typical_duration < 60 {
            return "\($viewModel.editingAppliance.wrappedValue.typical_duration) minutes"
        } else {
            let tuple = minutesToHoursAndMinutes($viewModel.editingAppliance.wrappedValue.typical_duration)
            return "\(tuple.hours):\( String(format: "%02d", tuple.leftMinutes) )"
        }
        
        
    }

    
    
    var body: some View {
        Form {
            Section {
 
                TextField("Name", text: $viewModel.editingAppliance.name)
                    //TextField("Power", text: $viewModel.editingAppliance.power)
                    //TextField("Duration", text: $viewModel.editingAppliance.typical_duration)
                    
                   
                
//                DatePicker("Date", selection: $viewModel.editingAppliance.createdAt)
                //Toggle("Complete", isOn: $viewModel.editingTodo.isComplete)
            }
            Section {
                VStack {
                    
                    
                    
                    VStack {
                                         
                        Text("Power: \(String($viewModel.editingAppliance.wrappedValue.power)) kWh")
                        Slider(value: powerIntProxy, in: 100...5000, step: 100, minimumValueLabel: Image(systemName: "light.min"), maximumValueLabel: Image(systemName: "light.beacon.max"), label: {})
                            .accentColor(Palette.brandGreen)
                        
                        Text("Is on for: \(humanReadableDuration)")
                        Slider(value: durationIntProxy, in: 10...60*6, step: 10, minimumValueLabel: Image(systemName: "clock"), maximumValueLabel: Image(systemName: "clock"), label: {})
                            .accentColor(Palette.brandGreen)
                        
                        
                        
                        
//                        Text("Power \($viewModel.editingAppliance.wrappedValue.power, specifier: "%.1f") KWh is \($viewModel.editingAppliance.wrappedValue.power * 9 / 5 + 32, specifier: "%.1f") Fahrenheit")
                    }
                    
                    //Text("Created by: \(String($viewModel.editingAppliance.wrappedValue.created_by))")
                }
            }
            
            if !createMode {
                Section {
                    Button(role: .destructive) {
                        presentationMode.wrappedValue.dismiss()
                        
                        Notification.fire(name: .applianceWillBeRemoved, payload: String(describing: $viewModel.editingAppliance.wrappedValue.id))
                        
                        withAnimation {
                            viewModel.delete(appliance: $viewModel.editingAppliance.wrappedValue)
                        }
//                        Notification.fire(name: .applianceRemoved)
                    } label: {
                        Label("Delete", systemImage: "trash").foregroundColor(.red)
                    }
                }
            }

        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 30) {
                Button() {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Cancel", systemImage: "arrow.uturn.backward")
                }
                .padding(.bottom)
                
                Button {
    //                print($viewModel.editingAppliance.wrappedValue.name)
                    presentationMode.wrappedValue.dismiss()
                    
                    if $viewModel.editingAppliance.wrappedValue.name == "" {
                        $viewModel.editingAppliance.wrappedValue.name = "New device"
                    }
                    
                    withAnimation {
                        viewModel.saveAppliance()
                    }
                    
                    Notification.fire(name: .applianceModified, payload: String(describing: $viewModel.editingAppliance.wrappedValue.id))
                    
                } label: {
                    Label($viewModel.editingAppliance.wrappedValue.name == "" ? "Create" : "Save", systemImage: "checkmark.circle")
                }
//                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
            
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

extension Binding {

    static func convert<TInt, TFloat>(from intBinding: Binding<TInt>) -> Binding<TFloat>
    where TInt:   BinaryInteger,
          TFloat: BinaryFloatingPoint{

        Binding<TFloat> (
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0) }
        )
    }

    static func convert<TFloat, TInt>(from floatBinding: Binding<TFloat>) -> Binding<TInt>
    where TFloat: BinaryFloatingPoint,
          TInt:   BinaryInteger {

        Binding<TInt> (
            get: { TInt(floatBinding.wrappedValue) },
            set: { floatBinding.wrappedValue = TFloat($0) }
        )
    }
}
