//
//  CategoryView.swift
//  Quizz
//
//  Created by Simon Bestler on 16.11.22.
//

import SwiftUI

struct CategoryView: View {
    
    let categoryVM : CategoryVM
    
    var body: some View {
        ZStack {
            //background.ignoresSafeArea()
            VStack {
                Text("Select a category").font(.largeTitle).bold()
                VStack {
                    ForEach(categoryVM.possibleCategories, id: \.id){ category in
                        CategoryCard(category: category)
                    }
            
                }
            }
            .padding()
        }
    }
    let background = LinearGradient(gradient: Gradient(colors: [.secondary, Color("Color 2")]), startPoint: .top, endPoint: .bottom)
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
        .padding(.vertical, 10)
        .padding(20)
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(categoryVM: CategoryVM())
    }
}
