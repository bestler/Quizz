//
//  CategoryVM.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

class CategoryVM : ObservableObject{
    @Published var finishedLoading = false
    @Published var possibleCategories : [Category]
    @Published var questions : [Question]?
    
    private var questionRepository : QuestionRepository
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
        possibleCategories = questionRepository.selectRandomCategories()
    }
    
    @MainActor
    func loadFirstData() async {
        await questionRepository.loadFirstData()
        finishedLoading = true
    }
    
    func newRandomCategories(){
        possibleCategories = questionRepository.selectRandomCategories()
    }

    func getQuiz(for category: Category) -> Quiz {
        return questionRepository.quizForCategory(category)
    }
    
}

struct Category : Identifiable, Hashable {
    var id : Int
    let name : Question.Category
    let iconName: String
    let color : String
}
