//
//  CompletedTodoList.swift
//  TodoMinimal
//
//  Created by Luis Rivera on 31/01/24.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    //MARK: - PROPERTIES
    @State private var showAll : Bool = false
    
    @Query private var completedlist: [Todo]
    
    
    init() {
        let predicate = #Predicate<Todo> {$0.isCompleted}
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        
        if !showAll {
            descriptor.fetchLimit = 15
        }
        
        _completedlist = Query(descriptor, animation: .snappy)
    }
    //MARK: - BODY
    var body: some View {
        Section{
            
        }header: {
            HStack{
                
                Text("Completed")
                
                Spacer(minLength: 0)
                
                if showAll {
                    Button("Show recents")
                    {
                        showAll = false
                    }
                }
            }
            
        } footer: {
            if completedlist.count == 15 && !showAll {
                HStack{
                    Text("Showing recent 15 tasks")
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 0)
                    
                    Button("Show All"){
                        showAll = true
                    }
                }
            }
        }
        .font(.caption)
    }
}

#Preview {
    ContentView()
}
