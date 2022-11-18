//
//  QuizView.swift
//  Quizz
//
//  Created by Simon Bestler on 17.11.22.
//

import SwiftUI


struct QuizView: View {
    
    @ObservedObject var quizVM : QuizVM
    let user = NSUserName()
    
    var body: some View {
        VStack {
            HStack() {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                    Text(user)
                    HStack{
                        ForEach(0..<3){_ in
                            Circle().foregroundColor(.gray)
                        }
                    }.frame(maxHeight: 20)
                }
                Spacer()
            }
            .frame(maxHeight: 60)
            .padding(30)
            GroupBox(label:
                        Label(quizVM.category.name.rawValue, systemImage: quizVM.category.iconName)
            ) {
                Text(quizVM.currentQuestion.question)
                    .padding(.vertical)
            }
            .padding()
            answerArea
            .padding()
            .frame(maxHeight: 300)
            if quizVM.isShowNextQuestion {
                Button("Next Question") {
                    quizVM.nextQuestion()
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
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
                                           //isRevelead: isRevealed,
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
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(isMasked ? color : Color(.lightGray))
    }
}
    
    struct Constants {
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
            QuizView(quizVM: QuizVM(category: QuestionRepository.categories[0], questions: [exampleQuestion]))
        }
    }
