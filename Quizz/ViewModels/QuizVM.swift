//
//  QuizVM.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

class QuizVM : ObservableObject {
    
    @Published var currentQuestion : Question?
    @Published var currentAnswers : [(String,Bool)]
    @Published var selectedAnswerPos: Int?
    @Published var category : Category
    @Published var isShowNextQuestion = false
    @Published var mask : [Bool]
    @Published var pointMask : [Bool?]
    
    
    // private var questionRepository : QuestionRepository
    private let quiz : Quiz
    private var index : Int
    
    
    init(quiz : Quiz){
        self.quiz = quiz
        self.index = 0
        self.currentAnswers = quiz.questions[0].answers
        self.category = quiz.category
        self.currentQuestion = quiz.questions[index]
        self.mask = [false, false, false, false]
        self.pointMask = quiz.points
    }
    
    private func shuffleAnswers(){
        currentAnswers.shuffle()
    }

    func evaluteQuestion() {
        if let pos = selectedAnswerPos, !isShowNextQuestion {
            let selectedAnswer = currentAnswers[pos]
            pointMask[index] = selectedAnswer.1
            mask[pos] = true
            if let posCorrect = currentAnswers.firstIndex(where: {$0.1 == true}){
                mask[posCorrect] = true
            }
        }
        isShowNextQuestion = true
        
    }
    
    
    func nextQuestion(){
        isShowNextQuestion = false
        index += 1
        if index < 3 {
            currentQuestion = quiz.questions[index]
            currentAnswers = quiz.questions[index].answers
            resetMask()
        }
        
    }
    
    private func resetMask(){
        for i in mask.indices {
            mask[i] = false
        }
    }
    
    
    
}
