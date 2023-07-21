//
//  ForgotPasswordView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 19/07/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email = ""
    
    @FocusState private var isKeyBoardPresented: Bool
    
    @EnvironmentObject private var appRouter: AppRouter
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .onTapGesture {
                    isKeyBoardPresented = false
                }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Forgot Password?")
                        .font(.custom(.black, size: 50))
                        .foregroundColor(.themeFour)
                        .minimumScaleFactor(0.5)
                    Text("Please enter email to continue.")
                        .font(.custom(.bold, size: 18))
                        .foregroundColor(.themeFour.opacity(0.75))
                }
                .padding(.bottom, 40)
                
                VStack {
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.themeFour.opacity(0.75))
                        
                        TextField("EMAIL", text: $email, prompt:
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
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                    }label: {
                        HStack {
                            Text("CONTINUE")
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

    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
