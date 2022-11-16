//
//  CategoryVM.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

class CategoryVM {
    @Published var possibleCategories : [Category]
    @Published var selectedCategory : Category?
    
    private var questionRepository : QuestionRepository
    
    @MainActor
    init() async{
        self.questionRepository = await QuestionRepository()
        possibleCategories = questionRepository.selectRandomCategories()
        
        let questions = questionRepository.questionsOfCategory(category: possibleCategories[0].name)
        print(questions)
    }
}

struct Category : Identifiable, Hashable {
    var id : Int
    let name : Question.Category
    let iconName: String
    let color : String
}
