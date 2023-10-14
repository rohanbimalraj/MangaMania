//
//  LottieView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/08/23.
//

import SwiftUI
import Lottie
 
struct LottieView: UIViewRepresentable {
 
    let animationView: LottieAnimationView!
    
    init(animationName: String = "flower") {
        self.animationView = LottieAnimationView(name: animationName)
    }
 
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}
