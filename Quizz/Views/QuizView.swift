//
//  QuizView.swift
//  Quizz
//
//  Created by Simon Bestler on 17.11.22.
//

import SwiftUI


struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var questionRepository : QuestionRepository
    @StateObject var quizVM : QuizVM
    @Environment(\.colorScheme) var colorScheme
    @AccessibilityFocusState private var isQuestionFocused
    
    
    var body: some View {
        VStack {
            Spacer()
            GroupBox(label:
                        Label(quizVM.category.name.rawValue,
                              systemImage: quizVM.category.iconName)) {
                Text(quizVM.currentQuestion!.question)
                    .padding(.vertical)
            }
                              .accessibilityElement()
                              .accessibilityLabel(quizVM.currentQuestion!.question)
                              .accessibilityFocused($isQuestionFocused)
                              .padding()
            if !quizVM.isShowNextQuestion {
                ProgressView(timerInterval: quizVM.startDate...quizVM.endDate).self
                    .padding()
            }
            answerArea
                .padding()
                .frame(idealHeight: 500, maxHeight: 500)
            PointView(pointMask: quizVM.pointMask)
                .padding()
            if quizVM.isShowNextQuestion {
                withAnimation{
                    Button("Next Question") {
                        isQuestionFocused = true
                        quizVM.nextQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .alert("Quiz finished", isPresented: $quizVM.isCompleted, presenting: quizVM.points) { _ in
            Button("Play again"){
                dismiss()
            }
        } message: { points in
            Text("You scored \(points)/3! You can start directly again.")
        }
        .onAppear(){
            questionRepository.removeUsedQuestions(category: quizVM.category)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    var answerArea : some View {
        Grid(){
            ForEach(0..<2) {col in
                let offset = col*2
                GridRow {
                    ForEach(offset..<offset+2, id:\.self){ i in
                        let answer = quizVM.currentAnswers[i]
                        QuizCard(answer: answer, isCorrect: answer.1,
                                 isMasked: quizVM.mask[i])
                        .onTapGesture {
                            withAnimation {
                                quizVM.selectedAnswerPos = i
                                quizVM.evaluteQuestion()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}

struct PointView : View {
    
    let pointMask : [Bool?]
    
    var body: some View {
        HStack{
            ForEach(0..<3){i in
                if let point = pointMask[i] {
                    Circle().foregroundColor(point ? .green : .red)
                    
                }else {
                    Circle().foregroundColor(Color(.lightGray))
                }
            }
        }.frame(maxHeight: 20)
    }
    
}


struct QuizCard : View {
    
    let answer : (String, Bool)
    let isCorrect : Bool
    let isMasked : Bool
    
    var color : Color {
        isCorrect ? .green : .red
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isMasked ? color : Color(.secondarySystemBackground))
            Text(answer.0)
        }
        
    }
    
    struct Constants {
        static let colorTrue : Color = .green
        static let colorWrong : Color = .red
    }
}


struct QuizView_Previews: PreviewProvider {
    
    
    static let exampleQuestion = Question(category: Question.Category.Computer,
                                          type: Question.QuestionType.multiple,
                                          difficulty: Question.Difficulty.hard,
                                          question: "Which of the following is the oldest of these computers by release date?",
                                          correct_answer: "TRS-80",
                                          incorrect_answers: ["Commodore 64","ZX Spectrum","Apple 3"])
    static var previews: some View {
        QuizView(quizVM: QuizVM(quiz: Quiz(category: QuestionRepository.categories[2], questions: [exampleQuestion]))).environmentObject(QuestionRepository())
    }
}

