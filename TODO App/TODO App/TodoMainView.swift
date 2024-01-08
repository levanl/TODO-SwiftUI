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
    @StateObject private var viewModel = TodoMainViewModel()
    
    @State var isDialogActive: Bool = false
    
    
    private var progress: Double {
        let totalTasks = viewModel.doneTodos.count + viewModel.notDoneTodos.count
        return totalTasks > 0 ? Double(viewModel.doneTodos.filter { $0.isDone }.count) / Double(totalTasks) * 100 : 0
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.notDoneTodos.isEmpty ? "All the tasks are complete" : "You have \(viewModel.notDoneTodos.count) tasks to complete")
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
                    if viewModel.notDoneTodos.isEmpty {
                        viewModel.notDoneTodos = viewModel.doneTodos
                        viewModel.doneTodos.removeAll()
                        for index in viewModel.notDoneTodos.indices {
                            viewModel.notDoneTodos[index].isDone = false
                        }
                    } else {
                        for index in viewModel.notDoneTodos.indices {
                            viewModel.notDoneTodos[index].isDone = true
                            viewModel.doneTodos.append(viewModel.notDoneTodos[index])
                        }
                        viewModel.notDoneTodos.removeAll()
                    }
                }) {
                    Text(viewModel.notDoneTodos.isEmpty ? "Reset All" : "Complete All")
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
                        Text("\(viewModel.doneTodos.filter { $0.isDone }.count)/\(viewModel.doneTodos.count + viewModel.notDoneTodos.count) Task Completed")
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
                    Section(header: Text("Not Completed")) {
                        ForEach($viewModel.notDoneTodos) { $todo in
                            TodoItemView(todo: $todo) {
                                todo.isDone.toggle()
                                viewModel.doneTodos.append(todo)
                                viewModel.notDoneTodos.removeAll { $0.id == todo.id }
                                viewModel.completedTasks += 1
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .cornerRadius(10)
                    
                    Section(header: Text("Completed")) {
                        ForEach($viewModel.doneTodos) { $todo in
                            TodoItemView(todo: $todo) {
                                todo.isDone.toggle()
                                viewModel.notDoneTodos.append(todo)
                                viewModel.doneTodos.removeAll { $0.id == todo.id }
                                viewModel.completedTasks -= 1
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .cornerRadius(10)
                    
                }
                .listStyle(PlainListStyle())
                .cornerRadius(10)
            }
            .padding()
            
            VStack {
                Spacer()
                
                Button(action: {
                    isDialogActive = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                }
                .padding(10)
                .padding(.bottom, 10)
            }
            
            if isDialogActive {
                CustomDialog(title: "Todo", message: "do todo", buttonTitle: "Save", action: {}, isDialogActive: $isDialogActive)
                    .zIndex(1)
            }
            
        }
        .onAppear {
            viewModel.completedTasks = viewModel.doneTodos.filter { $0.isDone }.count
        }
    }
}

struct TodoItemView: View {
    
    @Binding var todo: TodoItem
    var onButtonTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var itemColor: Color = {
        Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }()
    
    var body: some View {
        
        HStack {
            Rectangle()
                .frame(width: 10)
                .foregroundColor(itemColor)
                .alignmentGuide(.leading, computeValue: { d in d[.leading] })
            
            
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
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal)
        }
        .background(itemBackgroundColor)
    }
    
    private var itemBackgroundColor: Color {
        switch colorScheme {
        case .dark:
            return Color(red: 31/255, green: 31/255, blue: 31/255)
        case .light:
            return .white
        @unknown default:
            return .white
        }
    }
}


struct TodoMainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoMainView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            TodoMainView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
        }
    }
}
