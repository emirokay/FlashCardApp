//
//  AddCardView.swift
//  FlashCardApp
//
//  Created by Emir Okay on 6.10.2024.
//

import SwiftUI

struct AddCardView: View {
	@ObservedObject var cardViewModel: CardViewModel
	@Environment(\.dismiss) var dismiss
	@State private var question = ""
	@State private var answer = ""
	@State private var showAlert = false
	@State private var alertMessage = ""
	
	var body: some View {
		NavigationStack {
			List{
				Section("Add New Card") {
					TextField("Question", text: $question)
						.padding()
						.background(Color(.systemGray5))
						.clipShape(RoundedRectangle(cornerRadius: 15))
					TextField("Answer", text: $answer)
						.padding()
						.background(Color(.systemGray5))
						.clipShape(RoundedRectangle(cornerRadius: 15))
						
					HStack {
						Spacer()
						Button("Add") {
							if !question.isEmpty && !answer.isEmpty {
								cardViewModel.addCard(question: question, answer: answer)
								question = ""
								answer = ""
							} else {
								alertMessage = "Question or Answer field is empty"
								showAlert = true
							}
						}
						.buttonStyle(.borderedProminent)
						Spacer()
					}
				}
				.listRowSeparator(.hidden)
				.listRowBackground(Color(.systemGray6))
				
				Section {
					NavigationLink {
						AddListView(cardViewModel: cardViewModel)
					} label: {
						Text("Add List")
							.foregroundStyle(.blue)
					}
				}
				
				if !cardViewModel.cardData.isEmpty {
					Button("Delete All Cards", role: .destructive) {
						cardViewModel.deleteAllCards()
					}
				}
				
				Section("All Cards") {
					ForEach(cardViewModel.cardData){ card in
						VStack(alignment: .leading) {
							Text(card.question)
								.font(.headline)
							Text(card.answer)
								.foregroundColor(.secondary)
						}
					}
					.onDelete(perform: cardViewModel.removeCardData)
				}
				
				
				
			}
			.navigationTitle("Edit Cards")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Save") {
						cardViewModel.saveCards()
						dismiss()
					}
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						dismiss()
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

#Preview {
	AddCardView(cardViewModel: CardViewModel())
}
