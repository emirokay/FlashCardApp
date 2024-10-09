//
//  CardViewModel.swift
//  FlashCardApp
//
//  Created by Emir Okay on 6.10.2024.
//

import SwiftUI

class CardViewModel: ObservableObject {
	@Published var correctAnswer = 0
	@Published var falseAnswer = 0
	@Published var cards: [Card] = []
	@Published var cardData: [Card] = []
	
	func loadCards() {
		if let data = UserDefaults.standard.data(forKey: "Cards") {
			if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
				cardData = decoded
				cards = decoded
			}
		}
	}
	
	func saveCards() {
		if let data = try? JSONEncoder().encode(cardData) {
			UserDefaults.standard.set(data, forKey: "Cards")
		}
	}
	
	func addCard(question: String, answer: String) {
		let trimmedQuestion = question.trimmingCharacters(in: .whitespaces)
		let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
		let card = Card(question: trimmedQuestion, answer: trimmedAnswer)
		cardData.insert(card, at: 0)
		cards.insert(card, at: 0)
		saveCards()
	}
	
	func correctAnswerScore() {
		correctAnswer += 1
	}
	
	func falseAnswerScore() {
		falseAnswer += 1
	}
	
	func removeCard(at index: Int) {
		guard index >= 0 && index < cards.count else { return }
		cards.remove(at: index)
	}
	
	func removeCardData(at offsets: IndexSet) {
		cardData.remove(atOffsets: offsets)
		saveCards()
	}
	
	func resetData() {
		correctAnswer = 0
		falseAnswer = 0
		loadCards()
	}
	
	func customSystemImage(systemName: String) -> some View {
		Image(systemName: systemName)
			.padding()
			.font(.title3)
			.bold()
			.foregroundStyle(.white)
			.background(Color(.systemBlue))
			.clipShape(Circle())
	}
	
	func addListOfCards(from input: String, completion: (Bool, String?) -> Void) {
		guard !input.isEmpty else {
			completion(false, "The list is empty")
			return
		}
		
		let lines = input.components(separatedBy: .newlines)
		
		for line in lines {
			let parts = line.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
			
			if parts.count == 2 {
				let question = String(parts[0])
				let answer = String(parts[1])
				addCard(question: question, answer: answer)
			} else {
				completion(false, "Invalid format for line: \(line). \nUse 'Question:Answer' format.")
				return
			}
		}
		completion(true, nil)
	}
	
	func deleteAllCards() {
		cards.removeAll()
		cardData.removeAll()
		saveCards()
	}
}

extension View {
	func stacked(at position: Int, in total: Int) -> some View {
		let offset = Double(total - position)
		
		let opacity: Double
		if position < total {
			opacity = max(0.0, 1.0 - (Double(total - position - 1) * 0.05))
		} else {
			opacity = 0.0
		}
		
		return self
			.offset(x: 0, y: offset * -10)
			.opacity(opacity)
	}
}
