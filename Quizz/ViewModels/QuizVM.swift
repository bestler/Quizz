//
//  QuizVM.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import Foundation

@MainActor

class QuizVM : ObservableObject {
    
    @Published var currentQuestion : Question?
    @Published var currentAnswers : [(String,Bool)]
    @Published var selectedAnswerPos: Int?
    @Published var category : Category
    @Published var isShowNextQuestion = false
    @Published var mask : [Bool]
    @Published var pointMask : [Bool?]
    @Published var startDate : Date
    @Published var endDate: Date
    @Published var isCompleted = false
    @Published var points : Int
    
    private var quiz : Quiz
    private let timeLimit : TimeInterval = 25
    private var index : Int
    private var timer : Timer = Timer()
    

    
    init(quiz : Quiz){
        self.quiz = quiz
        self.index = 0
        self.currentAnswers = quiz.questions[0].answers
        self.category = quiz.category
        self.currentQuestion = quiz.questions[index]
        self.mask = [false, false, false, false]
        self.pointMask = quiz.points
        self.startDate = Date()
        self.endDate = Date().addingTimeInterval(timeLimit)
        self.points = quiz.points_count
        createTimer()
    }
    

    
    private func createTimer() {
        timer = Timer(fireAt: endDate, interval: 0, target: self, selector: #selector(evaluteQuestion), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func shuffleAnswers(){
        currentAnswers.shuffle()
    }

    @objc func evaluteQuestion() {
        if let pos = selectedAnswerPos, !isShowNextQuestion {
            timer.invalidate()
            let selectedAnswer = currentAnswers[pos]
            pointMask[index] = selectedAnswer.1
            mask[pos] = true
            if let posCorrect = currentAnswers.firstIndex(where: {$0.1 == true}){
                mask[posCorrect] = true
            }
        }else {
            if let posCorrect = currentAnswers.firstIndex(where: {$0.1 == true}){
                mask[posCorrect] = true
            }
            pointMask[index] = false
        }
        isShowNextQuestion = true
        index += 1
        if index > 2 {
            quiz.points = pointMask
            points = quiz.points_count
            index = 0
            isCompleted = true
        }
    }
    
    
    func nextQuestion(){
        isShowNextQuestion = false
        selectedAnswerPos = nil
        if index < 3 {
            currentQuestion = quiz.questions[index]
            currentAnswers = quiz.questions[index].answers
            resetMask()
        }
        startDate = Date()
        endDate = Date().addingTimeInterval(timeLimit)
        createTimer()

        
    }
    
    private func resetMask(){
        for i in mask.indices {
            mask[i] = false
        }
    }
}
