//
//  Card.swift
//  FlashCardApp
//
//  Created by Emir Okay on 5.10.2024.
//

import Foundation

struct Card: Codable, Identifiable {
	var id = UUID()
	let question: String
	let answer: String
	
	static let example = Card(question: "Sunum, sunum, sunum, kimeee???", answer: "KARABIBERIME")
}
