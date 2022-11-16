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
        Category(id: 18, name: Question.Category.Computer, iconName: "laptopcomputer", color: "Color 1"),
        Category(id: 23, name: Question.Category.History, iconName: "building.columns", color: "Color 2"),
        Category(id: 24, name: Question.Category.Politics, iconName: "newspaper", color: "Color 3")
    ]
    
    var questions : [Category:[Question]] = [:]
    
    mutating func loadFirstData() async{
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
