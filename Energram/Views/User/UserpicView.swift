//
//  UserpicView.swift
//  Energram
//
//  Created by Alex Antipov on 22.02.2023.
//


import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    var callback: (() -> Void)
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
            parent.callback()
        }
    }
}


struct UserpicView: View {
    
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .leading, spacing: 10) {
                Group {
                    AsyncImage(
                        url: userpicUrl,
                        transaction: Transaction(animation: .easeInOut)
                    ) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Circle()
                                    .fill(Palette.a)
                                    .frame(width: 150, height: 150)
                                Image(systemName: "photo")
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .transition(.opacity)
                        case .failure:
                            Image(systemName: "wifi.slash")
                        @unknown default:
                            EmptyView()
                        }
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.gray)
                    .clipShape(Circle())

                }.onTapGesture {
                    self.isShowPhotoLibrary = true
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .padding(0)
            .onAppear {
                self.readFromSettings()
                if let id = authData?.id {
                    Task { await self.requestUserProfileFromBackend(id: id)}
                }
            }
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, callback: imageJustWasSelected)
            }
        }
    }
    
    // MARK: Private
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    @State private var authData: AuthData?
    
    @State private var userpicUrl: URL?
    
    private func readFromSettings() {
        self.authData = UserService().readAuthData()
    }
    
    private func imageJustWasSelected() {
        //print("> imageJustWasSelected")
        Task(priority: .background) {
            let response = await UserService().uploadUserpic(image: self.image)
            switch response {
            case .success(let result):
                if let first = result.userpic.first {
                    userpicUrl = URL(string: first.value)
                }
            case .failure(let error):
                log("Request failed with error: \(error.customMessage)")
            }
        }
    }
    
    private func requestUserProfileFromBackend(id: String) async {
        
        Task(priority: .background) {
            let response = await UserService().getUserProfile(id: id)
            switch response {
            case .success(let result):
                if let userpics = result.userpic {
                    if let first = userpics.first {
                        userpicUrl = URL(string: first.value)
                    }
                }
            case .failure(let error):
                log("Request failed with error: \(error.customMessage)")
                
            }
        }
    }
}

struct UserpicView_Previews: PreviewProvider {
    static var previews: some View {
        UserpicView()
    }
}
