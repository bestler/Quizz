//
//  APIManager.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

struct Question : Codable, Identifiable {
    
    var id : UUID {
       UUID()
    }
    let category : Category
    let type : QuestionType
    let difficulty : Difficulty
    let question : String
    let correct_answer : String
    let incorrect_answers : [String]
    var answers : [(String, Bool)] {
        var answers = incorrect_answers.map({($0,false)})
        answers.append((correct_answer, true))
        return answers
    }
    
    enum Difficulty : String, Codable {
        case easy, medium, hard
    }
    
    enum Category : String, Codable {
        case Computer = "Science: Computers"
        case Politics = "Politics"
        case History = "History"
    }
    
    enum QuestionType : String, Codable {
        case multiple, boolean
    }
    
}

struct Response : Codable {
    let results : [Question]
}


struct APIManager {
    
    func fetchData(amount: Int, category : Category) async -> [Question] {
        
        var questions = [Question]()
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)&category=\(category.id)&type=multiple") else {
            print("Invalid URL")
            return questions
        }
        print(url)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                //print(decodedResponse)
                questions = decodedResponse.results
                //TODO: Decode HTML Encoding
            }else {
                print("Error parsing")
            }
        } catch {
            print("Invalid data")
        }
        
        return questions

    }
}
