//
//  LoginView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 19/07/23.
//

import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()
    
    @FocusState private var isKeyBoardPresented: Bool
    
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    @State private var aleretMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .onTapGesture {
                    isKeyBoardPresented = false
                }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Login")
                        .font(.custom(.black, size: 50))
                        .foregroundColor(.themeFour)
                        .minimumScaleFactor(0.5)
                    Text("Please sigin to continue.")
                        .font(.custom(.bold, size: 18))
                        .foregroundColor(.themeFour.opacity(0.75))
                }
                .padding(.bottom, 40)
                
                VStack {
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.themeFour.opacity(0.75))
                        
                        TextField("EMAIL", text: $viewModel.email, prompt:
                          Text("EMAIL")
                            .font(.custom(.semiBold, size: 15))
                            .foregroundColor(.themeFour.opacity(0.75))
                        )
                        .foregroundColor(.themeFour.opacity(0.75))
                        .keyboardType(.emailAddress)
                        .focused($isKeyBoardPresented)

                    }
                    
                    Rectangle()
                        .fill(.themeFour.opacity(0.6))
                        .frame(height: 2)
                        .padding(.top, 5)
                }
                
                VStack {
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.themeFour.opacity(0.75))
                        
                        SecureField("PASSWORD", text: $viewModel.password, prompt:
                          Text("PASSWORD")
                            .font(.custom(.semiBold, size: 15))
                            .foregroundColor(.themeFour.opacity(0.75))
                        )
                        .foregroundColor(.themeFour.opacity(0.75))
                        .focused($isKeyBoardPresented)
                        
                        Button {
                            
                            appRouter.present(fullScreenCover: .forgotPassword)
                            
                        } label: {
                            Text("FORGOT")
                                .font(.custom(.bold, size: 13))
                                .foregroundColor(.themeThree)
                        }

                    }
                    
                    Rectangle()
                        .fill(.themeFour.opacity(0.6))
                        .frame(height: 2)
                        .padding(.top, 5)
                }
                .padding(.top, 20)
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                        Task {
                            do {
                                try await viewModel.login()
                                //appRouter.push(.content)
                            }catch {
                                aleretMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }label: {
                        HStack {
                            Text("LOGIN")
                                .font(.custom(.bold, size: 20))
                                .foregroundColor(.themeFour)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.themeFour)
                        }
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeThree]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Capsule())
                    }
                    .padding()
                }
                .frame(idealWidth: .infinity)
                
            }
            .padding(30)
        }
        .overlay(alignment: .bottom) {
            HStack {
                Text("Don't have an account?")
                    .font(.custom(.semiBold, size: 18))
                    .foregroundColor(.themeFour)
                Button {
                    
                    appRouter.present(fullScreenCover: .createAccount)
                    
                }label: {
                    Text("Sign up")
                        .font(.custom(.semiBold, size: 18))
                        .foregroundColor(.themeThree)
                }
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear{
            viewModel.authenticationManager = authenticationManager
        }
        .alert("Error!", isPresented: $showAlert) {
            Button("OK"){}
        }message: {
            Text(aleretMessage)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationManager())
    }
}
