//
//  TodoMainViewModel.swift
//  TODO App
//
//  Created by Levan Loladze on 08.01.24.
//

import SwiftUI


final class TodoMainViewModel: ObservableObject {
    
    @Published var doneTodos = [
        TodoItem(todo: "Task 1", isDone: true),
        TodoItem(todo: "Task 2", isDone: true),
        TodoItem(todo: "Task 6", isDone: true)
    ]
    
    @Published var notDoneTodos = [
        TodoItem(todo: "Task 1", isDone: true),
        TodoItem(todo: "Task 2", isDone: true),
        TodoItem(todo: "Task 6", isDone: true)
    ]
    
    @Published var completedTasks = 0
    
}
