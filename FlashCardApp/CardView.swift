//
//  CardView.swift
//  FlashCardApp
//
//  Created by Emir Okay on 5.10.2024.
//

import SwiftUI

struct CardView: View {
	
	var card: Card
	@ObservedObject var cardViewModel: CardViewModel
	var removal: (() -> Void)? = nil
	
	@State var offset = CGSize.zero
	@State var showAnswer = false
	
    var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 15)
				.foregroundStyle(Color(.systemGray6))
				.shadow(radius: 8)
			VStack {
				Text(card.question)
					.font(.title)
				if showAnswer {
					Text(card.answer)
						.foregroundStyle(.secondary)
						.font(.title2)
				}
			}
			.multilineTextAlignment(.center)
		}
		.rotationEffect(.degrees(offset.width / 1.5))
		.offset(x: offset.width * 5)
		.opacity(2 - Double(abs(offset.width / 40)))
		.gesture (
			DragGesture()
				.onChanged { gesture in
					offset = gesture.translation
				}
				.onEnded { _ in
					if abs(offset.width) > 50 {
						if (offset.width > 0) { cardViewModel.correctAnswerScore() } else { cardViewModel.falseAnswerScore() }
						removal?()
					} else {
						offset = .zero
					}
					
				}
		)
		.onTapGesture {
			self.showAnswer.toggle()
		}
    }
}


#Preview {
	ContentView()
}
