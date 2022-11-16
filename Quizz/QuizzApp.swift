//
//  QuizzApp.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import SwiftUI

@main
struct QuizzApp: App {
    
    let categoryVM = CategoryVM()
    

    
    var body: some Scene {
        WindowGroup {
            CategoryView(categoryVM: categoryVM)
        }
    }
}
