//
//  Home.swift
//  TodoMinimal
//
//  Created by Luis Rivera on 31/01/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    //MARK: - PROPERTIES
    @Query(filter: #Predicate<Todo>{!$0.isCompleted}, sort: 
        [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private
     var activeList: [Todo]
    
    
   

    //MARK: - ModelContext
    @Environment(\.modelContext) private var context
    
    @State private var showAll : Bool = false
//MARK: - BODY
    var body: some View {
        List{
            Section(activeSectionTitle){
                ForEach(activeList){
               TodoRowView(todo: $0)
                }
            }
            CompletedTodoList(showAll: $showAll)
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                Button(action:{
    
                    let todo = Todo(task: "", priority: .high)
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
        
        
        var activeSectionTitle: String {
            let count = activeList.count
            return count == 0 ? "Active": "Active \(count)"
        }
   
    }
   
}

#Preview {
ContentView()
}
