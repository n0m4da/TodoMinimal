//
//  TodoList.swift
//  TodoList
//
//  Created by Luis Rivera on 06/02/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
     

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date

}

struct TodoListEntryView : View {
    var entry: Provider.Entry

    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    
    var body: some View {
       
        VStack{
            Text("Conteo: \(activeList.count)")
            
            ForEach(activeList){ todo in
                
                HStack(spacing: 20){
                    Button(intent: ToggleButton(id: todo.taskID), label: {
                        Image(systemName: "circle")
                        
                    })
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .containerBackground(Color(UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)), for:.widget)
        .overlay{
            if activeList.isEmpty{
                Text("No Tasks 🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
      
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted}
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor =  FetchDescriptor( predicate: predicate, sortBy: sort)
        descriptor.fetchLimit =  10
        
        print("entra")
        
        return descriptor
    }
}

struct TodoList: Widget {
    let kind: String = "TodoList"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            TodoListEntryView(entry: entry)
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}

#Preview(as: .systemSmall) {
    TodoList()
} timeline: {
    SimpleEntry(date: .now)
}

//button intent whisch will update the todo status
 struct ToggleButton: AppIntent{
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo state")
    
    @Parameter(title: "Todo ID")
    var id: String
    init(id: String) {
        self.id = id
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        /// UPDATING TODO STATUS
        let context = try ModelContext(.init(for: Todo.self))
        /// retreiving respective todo
        ///
        
        let descriptor =  FetchDescriptor(predicate: #Predicate<Todo>{ $0.taskID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            
            try context.save()
        }
        
        return .result()
    }
}
