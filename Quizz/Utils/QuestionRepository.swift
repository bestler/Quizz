//
//  QuestionRepository.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

class QuestionRepository : ObservableObject {
    
    private let defaultAmountOfQuestions = 9
    private let questionPerRound = 3
    let api = APIManager()
    
    //Change colors
    static let categories = [
        Category(id: 18, name: Question.Category.Computer, iconName: "laptopcomputer", color: "Color 1"),
        Category(id: 23, name: Question.Category.History, iconName: "building.columns", color: "Color 2"),
        Category(id: 24, name: Question.Category.Politics, iconName: "newspaper", color: "Color 3"),
        Category(id: 25, name: Question.Category.Art, iconName: "photo.artframe", color: "Color 4"),
        Category(id: 28, name: Question.Category.Vehicles, iconName: "car", color: "Color 5"),
    ]
    
    var questions : [Category:[Question]] = [:]
    
    func loadFirstData() async{
        print("Loading Data...")
        for category in QuestionRepository.categories {
            self.questions[category] = await api.fetchData(amount: defaultAmountOfQuestions, category: category)
        }
        print("Loading completed")
    }
    
    func selectRandomCategories() -> [Category]{
        
        let randCategories = QuestionRepository.categories.shuffled().prefix(3)
        return Array(randCategories[...2])
    }
    
    func reloadQuestions(for category : Category) async {
        print("Reloading questions...")
        let newQuestions = await APIManager().fetchData(amount: 6, category: category)
        questions[category]?.append(contentsOf: newQuestions)
    }
    
    
    func quizForCategory(_ category : Category) -> Quiz {
        var selectedQuestions : [Question] = []
        
        print("count: \(questions[category]?.count ?? -1)")
        for i in 0...questionPerRound-1 {
            selectedQuestions.append((questions[category]?[i])!)
        }
        return Quiz(category: category, questions: selectedQuestions)
    }
    
    func removeUsedQuestions(category : Category){
        
        for _ in 0...questionPerRound-1 {
            questions[category]?.remove(at: 0)
        }
        
        if (questions[category]?.count ?? 0 < 3) {
            Task {
                print("Count of questions before reloading ... \(questions[category]?.count ?? -1)")
                await reloadQuestions(for: category)
                print("Count of questions after reloading ... \(questions[category]?.count ?? 0)")

            }
        }
    }
    
}
