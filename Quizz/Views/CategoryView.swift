//
//  CategoryView.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import SwiftUI

struct CategoryView: View {
    
    @ObservedObject var categoryVM : CategoryVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Select a category").font(.largeTitle).bold()
                    VStack {
                        if !categoryVM.finishedLoading {
                                ProgressView("Loading Questions...")
                            }
                        ForEach(categoryVM.possibleCategories, id: \.id){ category in
                            if categoryVM.finishedLoading {
                                NavigationLink(value : category){
                                    CategoryCard(category: category)
                                }.simultaneousGesture(TapGesture().onEnded{
                                    categoryVM.newRandomCategories()
                                })
                            }
                            else {
                                CategoryCard(category: category)
                            }
                        }
                        .navigationDestination(for: Category.self) { category in
                            QuizView(quizVM: QuizVM(quiz: categoryVM.getQuiz(for:category)))
                        }
                        .padding(.vertical, 10)
                        .padding(20)
                        .navigationBarBackButtonHidden(true)
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }.task{
            print(categoryVM.finishedLoading)
            await categoryVM.loadFirstData()
            print("Task completed")
            print("var: finishedLoading \(categoryVM.finishedLoading)")
        }
    }
}


struct CategoryCard : View {
    
    let category: Category
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(category.color))
                .shadow(color: .black, radius: 5, x: 2, y:2)
            HStack(alignment: .center){
                Image(systemName: category.iconName).font(.largeTitle)
                    .padding(.leading)
                Spacer()
                Text(category.name.rawValue).bold()
                    .font(.title)
                Spacer()
            }
        }
        .frame(maxHeight: 100)
        .padding()
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(categoryVM: CategoryVM(questionRepository: QuestionRepository()))
    }
}
