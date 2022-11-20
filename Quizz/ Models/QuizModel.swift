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
    
    var points_count : Int {
        var count = 0
        for point in points {
            if point ?? false {
                count += 1
            }
        }
        return count
    }
    
    mutating func evaluteResult(_ result : Bool, at index: Int){
        points[index] = result
    }
    
    func getQuestionAt(_ index : Int) -> Question? {
        return questions.first
    }
    
}
