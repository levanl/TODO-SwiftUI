//
//  TodoMainView.swift
//  TODO App
//
//  Created by Levan Loladze on 08.12.23.
//

import SwiftUI

struct TodoItem: Identifiable, Hashable {
    var id = UUID()
    var todo: String
    var isDone: Bool
}

struct TodoMainView: View {
    
    @State private var doneTodos = [
        TodoItem(todo: "Task 1", isDone: true),
        TodoItem(todo: "Task 2", isDone: true),
        TodoItem(todo: "Task 6", isDone: true)
    ]
    
    @State private var notDoneTodos = [
        TodoItem(todo: "Task 3", isDone: false),
        TodoItem(todo: "Task 4", isDone: false),
        TodoItem(todo: "Task 8", isDone: false)
    ]
    
    @State private var completedTasks = 0
    
    private var progress: Double {
        let totalTasks = doneTodos.count + notDoneTodos.count
        return totalTasks > 0 ? Double(doneTodos.filter { $0.isDone }.count) / Double(totalTasks) * 100 : 0
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(notDoneTodos.isEmpty ? "All the tasks are complete" : "You have \(notDoneTodos.count) tasks to complete")
                    .frame(width: 200)
                    .font(.system(size: 25))
                    .fontWeight(.bold)

                Spacer()
                
                Image("person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            .padding(.vertical)
            
            Button(action: {
                if notDoneTodos.isEmpty {
                    notDoneTodos = doneTodos
                    doneTodos.removeAll()
                    for index in notDoneTodos.indices {
                        notDoneTodos[index].isDone = false
                    }
                } else {
                    for index in notDoneTodos.indices {
                        notDoneTodos[index].isDone = true
                        doneTodos.append(notDoneTodos[index])
                    }
                    notDoneTodos.removeAll()
                }
            }) {
                Text(notDoneTodos.isEmpty ? "Reset All" : "Complete All")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 186/255, green: 131/255, blue: 222/255),
                                                        Color(red: 222/255, green: 131/255, blue: 176/255)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
            }
            
            HStack {
                Text("Progress")
                    .font(.system(size: 18))
                
                Spacer()
            }
            .padding(.vertical)
            
            VStack {
                HStack {
                    Text("Daily Task")
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    Text("\(doneTodos.filter { $0.isDone }.count)/\(doneTodos.count + notDoneTodos.count) Task Completed")
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    Text("Keep working")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(progress))%")
                        .foregroundColor(.white)
                }
                ProgressView(value: progress / 100)
            }
            .padding()
            .background(Color(red: 24/255, green: 24/255, blue: 24/255))
            .cornerRadius(8)
            
            Spacer()
            
            List {
                Section(header: Text("Completed")) {
                    ForEach($doneTodos) { $todo in
                        TodoItemView(todo: $todo) {
                            todo.isDone.toggle()
                            notDoneTodos.append(todo)
                            doneTodos.removeAll { $0.id == todo.id }
                            completedTasks -= 1
                        }
                    }
                }
                Section(header: Text("Not Completed")) {
                    ForEach($notDoneTodos) { $todo in
                        TodoItemView(todo: $todo) {
                            todo.isDone.toggle()
                            doneTodos.append(todo)
                            notDoneTodos.removeAll { $0.id == todo.id }
                            completedTasks += 1
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
        .onAppear {
            
            completedTasks = doneTodos.filter { $0.isDone }.count
        }
        
    }
}

#Preview {
    TodoMainView()
}



struct TodoItemView: View {
    
    @Binding var todo: TodoItem
    var onButtonTap: () -> Void
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.todo)
                
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                    
                    Text("4 oct")
                }
            }
            
            Spacer()
            
            Button(action: {
                
                onButtonTap()
            }) {
                if todo.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.green)
                        
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
            }
        }
    }
}
