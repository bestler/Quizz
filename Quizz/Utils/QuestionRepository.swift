//
//  QuestionRepository.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

struct QuestionRepository {
    
    private let defaultAmountOfQuestions = 10
    private let questionPerRound = 3
    let api = APIManager()
    
    //Change colors
    static let categories = [
        Category(id: 18, name: Question.Category.Computer, iconName: "laptopcomputer", color: "Color 1"),
        Category(id: 23, name: Question.Category.History, iconName: "building.columns", color: "Color 2"),
        Category(id: 24, name: Question.Category.Politics, iconName: "newspaper", color: "Color 3")
    ]
    
    var questions : [Category:[Question]] = [:]
    
    mutating func loadFirstData() async{
        print("Loading Data...")
        for category in QuestionRepository.categories {
            self.questions[category] = await api.fetchData(amount: defaultAmountOfQuestions, category: category)
        }
        print("Loading completed")
    }
    
    func selectRandomCategories() -> [Category]{
        //TODO: function to return three random categories from categories array
        return QuestionRepository.categories
    }
    
    static func reloadQuestions(for category : Category) async -> [Question] {
        return await APIManager().fetchData(amount: 10, category: category)
    }
    
    mutating func questionsOfCategory(category : Question.Category) -> [Question] {
        //TODO: Make sure that their are at least 3 questions avaiable, else refresh
        if let selectedCategory = questions.first(where: {$0.key.name == category}){
            var allQuestions = selectedCategory.value
            var selectedQuestions : [Question] = []
            
            for i in 0...questionPerRound-1 {
                selectedQuestions.append(allQuestions[i])
            }
            
            questions[selectedCategory.key] = allQuestions
            return selectedQuestions
                                    
        } else {
            return [Question]()
        }
    }
    
    mutating func quizForCategory(_ category : Category) -> Quiz {
        return Quiz(category: category, questions: questionsOfCategory(category: category.name))
    }
    
}
