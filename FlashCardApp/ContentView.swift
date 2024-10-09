//
//  ContentView.swift
//  FlashCardApp
//
//  Created by Emir Okay on 5.10.2024.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var cardViewModel = CardViewModel()
	@State private var showAddCardView = false
	
	var body: some View {
		GeometryReader { geometry in
			NavigationStack {
				VStack{
					if !cardViewModel.cards.isEmpty {
						ZStack {
							ForEach(0..<cardViewModel.cards.count, id: \.self) { index in
								CardView(card: cardViewModel.cards[index], cardViewModel: cardViewModel) {
									withAnimation {
										cardViewModel.removeCard(at: index)
									}
								}
								.stacked(at: index, in: cardViewModel.cards.count)
								.allowsHitTesting(index == cardViewModel.cards.count - 1)
							}
						}
					} else {
						CardView(card: Card(question: cardViewModel.cardData.isEmpty ? "Add cards and start learning now!" : "No Cards Left \n Your Score: \n \(cardViewModel.falseAnswer) flase, \(cardViewModel.correctAnswer) correct", answer: ""), cardViewModel: cardViewModel)
							.allowsHitTesting(false)
					}
				}
				.frame(width: min(geometry.size.width, geometry.size.height) * 0.90, height: min(geometry.size.width, geometry.size.height) * 0.70)
				.padding()
				.toolbar{
					ToolbarItem(placement: .topBarLeading) {
						scoreView(label: "False", score: cardViewModel.falseAnswer)
					}
					ToolbarItem(placement: .topBarTrailing) {
						scoreView(label: "Correct", score: cardViewModel.correctAnswer)
					}
					
				}
			}
			.overlay {
				VStack {
					Spacer()
					HStack {
						Button {
							showAddCardView.toggle()
						} label: {
							cardViewModel.customSystemImage(systemName: "plus")
						}
						Spacer()
						Button {
							cardViewModel.resetData()
						} label: {
							cardViewModel.customSystemImage(systemName: "arrow.counterclockwise")
						}
					}
				}
				.padding()
			}
			.sheet(isPresented: $showAddCardView) { AddCardView(cardViewModel: cardViewModel) }
			.onAppear(perform: cardViewModel.resetData)
		}
	}
	
	struct scoreView: View {
		var label: String
		var score: Int
		
		var body: some View {
			VStack {
				Text(label)
					.font(.headline)
				Text("\(score)")
					.font(.system(size: 20))
					.bold()
			}
			
		}
	}
	
}



#Preview {
	ContentView()
}
