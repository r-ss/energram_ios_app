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
    
    //    @EnvironmentObject private var userAuthState: UserAuthStateViewModel
    //
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        GeometryReader { geometry in

                
                
//                VStack {
//
//                            Image(uiImage: self.image)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .edgesIgnoringSafeArea(.all)
//
//                            Button(action: {
//                                self.isShowPhotoLibrary = true
//                            }) {
//                                HStack {
//                                    Image(systemName: "photo")
//                                        .font(.system(size: 20))
//
//                                    Text("Photo library")
//                                        .font(.headline)
//                                }
//                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(20)
//                                .padding(.horizontal)
//                            }
//                        }
                
                VStack(alignment: .leading, spacing: 10) {

                    Group {
                        //if let url = userpicUrl {


                            AsyncImage(
                                url: userpicUrl,
                                transaction: Transaction(animation: .easeInOut)
                            ) { phase in
                                switch phase {
                                case .empty:
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 150, height: 150)
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


                     
//                    else {
//                            Circle()
//                                .fill(.black)
//                                .frame(width: 150, height: 150)
//                        }
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
    
    
    
    @State private var loading: Bool = false
    
    @State private var authData: AuthData?
    
    //    @State private var tryToShowUserpic: Bool = false
    @State private var userpicUrl: URL?
    
    private func readFromSettings() {
        self.authData = UserService().readAuthData()
    }
    
    private func imageJustWasSelected() {
        print("> imageJustWasSelected")
        
        Task(priority: .background) {
            let response = await UserService().uploadUserpic(image: self.image)
            switch response {
            case .success(let result):
                
                print(result)
                
//                if let userpics = result.userpic {
//
//                    if let first = userpics.first {
//                        userpicUrl = URL(string: "https://media.energram.co/\(first.value)")
//                    }
//                }
                if let url = URL(string: result.userpicUrl) {
                    userpicUrl = url
                    print(userpicUrl)
                }
                
                
                
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                
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
                        userpicUrl = URL(string: "https://media.energram.co/\(first.value)")
                    }
                }
                
                
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                
            }
        }
    }
    
}

struct UserpicView_Previews: PreviewProvider {
    static var previews: some View {
        UserpicView()
    }
}
