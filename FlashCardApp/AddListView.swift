//
//  AddListView.swift
//  FlashCardApp
//
//  Created by Emir Okay on 7.10.2024.
//

import SwiftUI

struct AddListView: View {
	@State private var text = ""
	@State private var showAlert = false
	@State private var alertMessage = ""
	
	@ObservedObject var cardViewModel: CardViewModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		GeometryReader { geometry in
			NavigationStack {
				VStack(alignment: .leading) {
					Text("Instructions")
						.padding(.horizontal, 24)
						.font(.headline)
					Text("Adding list of cards is line sensitive. Please provide a list of questions and answers separated by ':' and new line for each card. Example format: \nQuestion:Answer\nQuestion2:Answer2")
						.padding(.horizontal, 24)
						.font(.footnote)
						.foregroundStyle(.secondary)
					TextEditor(text: $text)
						.padding(4)
						.frame(minWidth: min(geometry.size.width, geometry.size.height) * 0.80, minHeight: min(geometry.size.width, geometry.size.height) * 0.50)
						.overlay {
							HStack {
								VStack{
									Text("Enter List")
										.padding(.horizontal, 9)
										.padding(.top, 13)
										.foregroundColor(.secondary)
										.opacity(text != "" ? 0 : 1)
									Spacer()
								}
								Spacer()
							}
						}
						.textEditorStyle(PlainTextEditorStyle())
						.background(Color(.secondarySystemBackground))
						.cornerRadius(10)
						.padding(.horizontal, 24)
						.shadow(radius: 3)
					
				}
				.padding(.bottom)
				.scrollIndicators(.hidden)
				.navigationBarBackButtonHidden()
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Done") {
							cardViewModel.addListOfCards(from: text) { success, errorMessage in
								if success {
									dismiss()
								} else if let error = errorMessage {
									alertMessage = error
									showAlert = true
								}
							}
						}
					}
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							presentationMode.wrappedValue.dismiss()
						} label: {
							HStack {
								Image(systemName: "chevron.left")
								Text("Back")
							}
						}
					}
				}
				.alert(isPresented: $showAlert) {
					Alert(
						title: Text("Error"),
						message: Text(alertMessage),
						dismissButton: .default(Text("OK"))
					)
				}
			}
		}
	}
}

#Preview {
	AddListView(cardViewModel: CardViewModel())
}

