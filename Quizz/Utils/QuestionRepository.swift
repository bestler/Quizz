//
//  QuestionRepository.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

struct QuestionRepository {
    
    private let defaultAmountOfQuestions = 10
    let api = APIManager()
    
    //Change colors
    static let categories = [
        Category(id: 18, name: Question.Category.computer, iconName: "laptopcomputer", color: "blue"),
        Category(id: 23, name: Question.Category.history, iconName: "building.columns.circle", color: "red"),
        Category(id: 24, name: Question.Category.politics, iconName: "newspaper.circle", color: "gree")
    ]
    
    var questions : [Category:[Question]] = [:]
    
    init() async {
        for category in QuestionRepository.categories {
            self.questions[category] = await api.fetchData(amount: defaultAmountOfQuestions, category: category)
        }
    }
    
    func selectRandomCategories() -> [Category]{
        //TODO: function to return three random categories from categories array
        return QuestionRepository.categories
    }
    
    func questionsOfCategory(category : Question.Category) -> [Question] {
        
        if let questionsOfCategory = questions.first(where: {$0.key.name == category}){
            return questionsOfCategory.value
            //TODO: Make sure that their are at least 3 questions avaiable, else refresh
            
        } else {
            return [Question]()
        }
        
    }
    
}
