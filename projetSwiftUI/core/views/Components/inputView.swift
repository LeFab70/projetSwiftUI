//
//  inputView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct inputView: View {
    @Binding var inputUser: String
    var placeholder: String = ""
    var imageName: String
    var isSecure:Bool=false
    var body: some View {
        VStack{
             userInput
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
            .background(Color.white.opacity(0.9))
        }
        }
    @ViewBuilder
    var userInput:some View {
        HStack (spacing:15){
            Image(systemName: imageName)
                .font(.system(size: 24))
                .foregroundStyle(.green)
            
            if isSecure{
               SecureField(placeholder,text: $inputUser)
                    .autocapitalization(.none)
                    .foregroundStyle(.black)
            }
            else{
                TextField(placeholder,text: $inputUser)
                    .autocapitalization(.none)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    VStack{
        inputView(inputUser: .constant("user's information"), imageName: "person.circle")
        inputView(inputUser: .constant("user's information"), imageName: "lock",isSecure: true)
    }
    .padding()
}
