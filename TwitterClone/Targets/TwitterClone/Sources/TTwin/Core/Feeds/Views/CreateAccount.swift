//
//  CreateAccount.swift
//  TTwin
//
//  MARK: Create a new account
//

import SwiftUI

struct CreateAccount: View {
    @State private var name = ""
    @State private var phoneOrEmail = ""
    @State private var dateOfBirth = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create your account")
                
                Form{
                    TextField("Name", text: $name)
                }
            }
        }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
