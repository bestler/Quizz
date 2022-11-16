//
//  APIManager.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

struct Question : Codable {
    
    let category : Category
    let type : QuestionType
    let difficulty : Difficulty
    let question : String
    let correct_answer : String
    let incorrect_answers : [String]
    
    enum Difficulty : String, Codable {
        case easy, medium, hard
    }
    
    enum Category : String, Codable {
        case computer = "Science: Computers"
    }
    
    enum QuestionType : String, Codable {
        case multiple, boolean
    }
    
}

struct Response : Codable {
    let results : [Question]
}


struct APIManager {
    
    func loadData() async -> [Question] {
        
        var questions = [Question]()
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category=18&type=multiple") else {
            print("Invalid URL")
            return questions
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                //print(decodedResponse)
                let questions = decodedResponse.results
            }else {
                print("Error parsing")
            }
        } catch {
            print("Invalid data")
        }
        
        return questions

    }
    
}







