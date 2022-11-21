//
//  QuizzApp.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import SwiftUI

@main
struct QuizzApp: App {
    
    @StateObject var questionRepository = QuestionRepository()
    
            
    var body: some Scene {
        WindowGroup {
            CategoryView(categoryVM: CategoryVM(questionRepository: questionRepository))
                .environmentObject(questionRepository)
        }
    }
}
