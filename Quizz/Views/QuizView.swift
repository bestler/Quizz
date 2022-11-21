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
    
    var body: some View {
        VStack {
            HStack() {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(.lightGray))
                    Text("Simon").font(.footnote)
                    HStack{
                        ForEach(0..<3){i in
                            if let point = quizVM.pointMask[i] {
                                Circle().foregroundColor(point ? .green : .red)
                                
                            }else {
                                Circle().foregroundColor(Color(.lightGray))
                            }
                        }
                    }.frame(maxHeight: 20)
                }
                Spacer()
            }
            .frame(maxHeight: 100)
            .padding(30)
            GroupBox(label:
                        Label(quizVM.category.name.rawValue, systemImage: quizVM.category.iconName)
                .foregroundColor(Color(quizVM.category.color))
            ) {
                Text(quizVM.currentQuestion!.question)
                    .padding(.vertical)
            }
            .padding()
            if !quizVM.isShowNextQuestion {
                ProgressView(timerInterval: quizVM.startDate...quizVM.endDate).self
                    .padding()
            }
            answerArea
                .padding()
                .frame(maxHeight: 300)
            if quizVM.isShowNextQuestion {
                withAnimation{
                    Button("Next Question") {
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
        //.background(Color(quizVM.category.color))
    }
    
    var answerArea : some View {
        
        Grid(){
            GridRow {
                ForEach(0..<2){ i in
                    let answer = quizVM.currentAnswers[i]
                    ZStack {
                        QuizCardBackground(isCorrect: answer.1,
                                           isMasked: quizVM.mask[i])
                        Text(quizVM.currentAnswers[i].0)
                    }
                    .onTapGesture {
                        withAnimation {
                            quizVM.selectedAnswerPos = i
                            quizVM.evaluteQuestion()
                        }
                    }
                }
            }
            GridRow{
                ForEach(2..<4){ i in
                    let answer = quizVM.currentAnswers[i]
                    ZStack {
                        QuizCardBackground(isCorrect: answer.1,
                                           isMasked: quizVM.mask[i])
                        Text(quizVM.currentAnswers[i].0)
                    }
                    .onTapGesture {
                        withAnimation() {
                            quizVM.selectedAnswerPos = i
                            quizVM.evaluteQuestion()
                        }
                    }
                }
            }
        }
    }
    
}


struct QuizCardBackground : View {
    
    let isCorrect : Bool
    let isMasked : Bool
    
    var color : Color {
        isCorrect ? .green : .red
    }
    
    var body: some View {
        withAnimation{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isMasked ? color : Color(.secondarySystemBackground))
        }
    }
    
    struct Constants {
        static let timeRange : Int = 30
        static let colorTrue : Color = .green
        static let colorWrong : Color = .red
    }
    
    
    
    
    struct QuizView_Previews: PreviewProvider {
        
        
        static let exampleQuestion = Question(category: Question.Category.Computer,
                                              type: Question.QuestionType.multiple,
                                              difficulty: Question.Difficulty.hard,
                                              question: "Which of the following is the oldest of these computers by release date?",
                                              correct_answer: "TRS-80",
                                              incorrect_answers: ["Commodore 64","ZX Spectrum","Apple 3"])
        static var previews: some View {
            QuizView(quizVM: QuizVM(quiz: Quiz(category: QuestionRepository.categories[0], questions: [exampleQuestion]))).environmentObject(QuestionRepository())
        }
    }
}
