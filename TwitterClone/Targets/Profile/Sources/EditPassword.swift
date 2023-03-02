//
//  EditPassword.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 1.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import Auth
import Combine

@MainActor
public class EditPasswordModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var isValid = false
    
    @Published var passwordErrorMessage = ""
    @Published var confirmPasswordErrorMessage = ""
    
    var auth: TwitterCloneAuth
    
    private var cancellable: Set<AnyCancellable> = []

    private var validConfirmPasswordPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest($newPassword, $confirmPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { pass, confirmPass in
                pass == confirmPass
            }
            .eraseToAnyPublisher()
    }
    
    private var passLengthPublisher: AnyPublisher<Bool, Never> {
        $newPassword
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count >= 8 }
            .eraseToAnyPublisher()
    }
    
    private var validFormPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(passLengthPublisher, validConfirmPasswordPublisher)
            .map { passwordValid, confirmPassValid in
                passwordValid && confirmPassValid
            }
            .eraseToAnyPublisher()
    }
    
    init(auth: TwitterCloneAuth) {
        self.auth = auth
        
        passLengthPublisher
            .receive(on: RunLoop.main)
            .map { $0 ? "" : "Password must be 8 or more characters long." }
            .assign(to: \.passwordErrorMessage, on: self)
            .store(in: &cancellable)
        
        validConfirmPasswordPublisher
            .receive(on: RunLoop.main)
            .map { $0 ? "" : "Passwords don't match." }
            .assign(to: \.confirmPasswordErrorMessage, on: self)
            .store(in: &cancellable)
        
        validFormPublisher.receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellable)
    }
    
    public func changePassword() async throws {
        try await auth.changePassword(password: oldPassword, newPassword: newPassword)
    }
}

public struct EditPassword: View {
    @State private var isShowingEditPassword = false
    @StateObject private var editPasswordModel: EditPasswordModel
    
    @Environment(\.dismiss) var dismiss
    
    public init (auth: TwitterCloneAuth) {
        let editPasswordModel = EditPasswordModel(auth: auth)
        _editPasswordModel = StateObject(wrappedValue: editPasswordModel)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Current password", text: $editPasswordModel.oldPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("Current password")
                }
                
                Section {
                    TextField("At least 8 characters", text: $editPasswordModel.newPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("New password")
                }
                
                Section {
                    TextField("At least 8 characters", text: $editPasswordModel.confirmPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("Confirm password")
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Edit password")
                        Text("@stefanjblos")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            try await editPasswordModel.changePassword()
                            dismiss()
                        }
                    } label: {
                        Text("Done")
                    }
                    .disabled(!editPasswordModel.isValid)
                }
            }
        }
    }
}

//struct EditPassword_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPassword()
//    }
//}
