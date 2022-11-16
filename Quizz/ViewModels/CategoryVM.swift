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
    
    init() {
        self.questionRepository = QuestionRepository()
        possibleCategories = questionRepository.selectRandomCategories()
        Task{
            //await loadFirstData()
        }
    }
    
    func loadFirstData() async {
        await questionRepository.loadFirstData()
    }
}

struct Category : Identifiable, Hashable {
    var id : Int
    let name : Question.Category
    let iconName: String
    let color : String
}
