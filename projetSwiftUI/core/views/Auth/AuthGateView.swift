//
//  AuthGateView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct AuthGateView: View {
    @State private var isLogin:Bool=true
    @State private var auth = AuthService.shared
    var body: some View {
        VStack{
           textDesciption
            Spacer()
            userAuth
            Spacer()
            buttonSwithAuth
            
        }
        .padding()
      
    }
    
    
    
    @ViewBuilder
    var textDesciption:some View{
        VStack(spacing:8){
             Text("Welcome \n to ExpenseApp")
                 .font(.largeTitle)
                 .foregroundStyle(.green.opacity(0.8))
                 .multilineTextAlignment(.center)
             Text("Track expenses easily and stay in control of your budget.")
                 .font(.caption)
                 .foregroundStyle(.secondary)
                 .multilineTextAlignment(.center)
            Image("image-budget-800px")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 80, maxWidth: 100, minHeight: 80, maxHeight: 100)
                .clipped()
           
         }
        .padding()
    }
    @ViewBuilder
    var userAuth: some View{
        VStack{
            if isLogin{
                LoginView()
            }
            else{
                SignUpView()
            }
        }
    }
    
    @ViewBuilder
    var buttonSwithAuth: some View{
        Button(" \(isLogin ? "No Account? Signup" : "  Have an account Signin")") {
            withAnimation {
                isLogin.toggle()
                auth.errorMessage = nil 
            }
           
        }.font(.subheadline.bold())
            .foregroundColor(.green.opacity(0.9))
    }
    
}

#Preview {
    AuthGateView()
}
