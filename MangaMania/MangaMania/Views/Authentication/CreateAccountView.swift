//
//  CreateAccountView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 19/07/23.
//

import SwiftUI

struct CreateAccountView: View {
        
    @FocusState private var isKeyBoardPresented: Bool
    
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    @StateObject private var viewModel = CreateAccountViewModel()
    
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
                    Text("Create Account")
                        .font(.custom(.black, size: 35))
                        .foregroundColor(.themeFour)
                        .minimumScaleFactor(0.5)

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
                    }
                    
                    Rectangle()
                        .fill(.themeFour.opacity(0.6))
                        .frame(height: 2)
                        .padding(.top, 5)
                }
                .padding(.top, 20)
                
                VStack {
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.themeFour.opacity(0.75))
                        
                        SecureField("CONFIRM PASSWORD", text: $viewModel.confirmPassword, prompt:
                          Text("CONFIRM PASSWORD")
                            .font(.custom(.semiBold, size: 15))
                            .foregroundColor(.themeFour.opacity(0.75))
                        )
                        .foregroundColor(.themeFour.opacity(0.75))
                        .focused($isKeyBoardPresented)
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
                                try await viewModel.signUp()
                                appRouter.push(.settings)
                                appRouter.dismissFullScreenCover()
                            }catch {
                                aleretMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }label: {
                        HStack {
                            Text("SIGN UP")
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
                Text("Already have an account?")
                    .font(.custom(.semiBold, size: 18))
                    .foregroundColor(.themeFour)
                Button {
                    appRouter.dismissFullScreenCover()
                }label: {
                    Text("Sign in")
                        .font(.custom(.semiBold, size: 18))
                        .foregroundColor(.themeThree)
                }
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appRouter.dismissFullScreenCover()
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.themeFour)
                }
            }
        }
        .alert("Error!", isPresented: $showAlert) {
            Button("OK"){}
        }message: {
            Text(aleretMessage)
        }
        .onAppear{
            viewModel.authenticationManager = authenticationManager
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(AuthenticationManager())
    }
}
