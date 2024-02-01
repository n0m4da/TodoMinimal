//
//  TodoRowvIEW.swift
//  TodoMinimal
//
//  Created by Luis Rivera on 31/01/24.
//

import SwiftUI

struct TodoRowView: View {
    
    @Bindable var todo: Todo
    
    @FocusState private var isActive: Bool
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        HStack(spacing: 8){
            if !isActive && !todo.task.isEmpty {
                Button(action: {}, label: {
                    Image(systemName:  todo.isCompleted ? "checkmark.circle.fill": "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : .primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            
            TextField("Record video", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray: .primary)
                .focused($isActive)
            
            //MARK: - Piority Menu
            if !isActive && !todo.task.isEmpty {
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue){ priority in
                        
                        Button(action: {todo.priority = priority}, label: {
                            HStack{
                                Text(priority.rawValue)
                                
                                if todo.priority == priority { Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .onAppear{
            isActive = todo.task.isEmpty
        }
        //swipe to delet
        .swipeActions(edge: .trailing  , allowsFullSwipe: false){
            Button("", systemImage: "trash"){
                context.delete(todo)
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty{
                /// deleting
                context.delete(todo)
            
            }
        }
    }
}

#Preview {
  ContentView()
}
