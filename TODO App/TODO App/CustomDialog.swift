//
//  CustomDialog.swift
//  TODO App
//
//  Created by Levan Loladze on 25.12.23.
//

import SwiftUI

struct CustomDialog: View {
    
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> ()
    @State private var offset: CGFloat = 1000
    @Binding var isDialogActive: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(message)
                    .font(.body)
                
                Button {
                    // TODO:
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.red)
                        
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                    }
                    Spacer()
                    
                }
                .padding()
                
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0 , y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
        
        func close() {
            withAnimation(.spring()) {
                offset = 1000
                isDialogActive = false
            }
        }
    
}

#Preview {
    CustomDialog(title: "AccessPhotos", message: "This lets you choose which photos u want to setup", buttonTitle: "pressme", action: {}, isDialogActive: .constant(true))
}
