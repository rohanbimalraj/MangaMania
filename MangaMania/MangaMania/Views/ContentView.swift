//
//  ContentView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 12/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email = ""
    @State private var passowrd = ""
    
    var body: some View {
        ZStack {
            
            VStack {
                VStack {
                    Text("MangaMania")
                        .font(.custom("Montserrat-Black", size: 40))
                        .foregroundColor(.themeFour)
                        .padding(.top, 30)
                    
                    VStack(spacing: 30) {
                        VStack(spacing: 20) {
                            TextField("Enter Email", text: $email, prompt: Text("Enter Email")
                                .foregroundColor(.themeThree)
                            )
                                .foregroundColor(.themeFour)
                                .padding()
                                .frame(height: 50)
                                .background(.themeTwo)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.horizontal)
                                .tint(.themeFour)
                            
                            TextField("Enter Password", text: $passowrd, prompt: Text("Enter Password")
                                .foregroundColor(.themeThree)
                            )
                                .foregroundColor(.themeFour)
                                .padding()
                                .frame(height: 50)
                                .background(.themeTwo)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.horizontal)
                                .tint(.themeFour)

                        }
                        
                        Button{
                            
                        }label: {
                            Text("Login")
                                .font(.title2.bold())
                                .foregroundColor(.themeFour)
                                .frame(width: 270, height: 50)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeThree]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                }
                .frame(width: 350, height: 370)
                .background(.themeOne)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeThree]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
