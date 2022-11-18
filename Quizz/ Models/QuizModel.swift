//
//  QuizModel.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

struct Quiz {
    
    let category : Category
    let questions : [Question]
    var points : [Bool?] = [nil, nil, nil]
    
    mutating func evaluteResult(_ result : Bool, at index: Int){
        points[index] = result
    }
    
    func getQuestionAt(_ index : Int) -> Question? {
        return questions[0]
    }
    
}
