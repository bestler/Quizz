//
//  QuizVM.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

class QuizVM : ObservableObject {
    
    @Published var currentQuestion : Question
    @Published var currentAnswers : [(String,Bool)]
    @Published var selectedAnswerPos: Int?
    @Published var evalutedResponse: Bool?
    @Published var category : Category
    @Published var isShowNextQuestion = false
    @Published var mask : [Bool]
    
    private let quiz : Quiz
    private var index : Int
    
    init(category : Category, questions : [Question]) {
        index = 0
        self.quiz = Quiz(category: category, questions: questions)
        self.currentQuestion = quiz.getQuestionAt(index)!
        self.category = quiz.category
        self.currentAnswers = quiz.getQuestionAt(index)!.answers
        self.mask = [false, false, false, false]
        shuffleAnswers()
    }
    
    private func shuffleAnswers(){
        currentAnswers.shuffle()
    }
    

    
    func evaluteQuestion() {
        if let pos = selectedAnswerPos, !isShowNextQuestion {
            let selectedAnswer = currentAnswers[pos]
            evalutedResponse = selectedAnswer.1
            mask[pos] = true
            if let posCorrect = currentAnswers.firstIndex(where: {$0.1 == true}){
                mask[posCorrect] = true
            }
        }
        isShowNextQuestion = true
        
    }
    
    
    func nextQuestion(){
        evalutedResponse = nil
        isShowNextQuestion = false
        resetMask()
        
    }
    
    private func resetMask(){
        for i in mask.indices {
            mask[i] = false
        }
    }
    
    
    
}
