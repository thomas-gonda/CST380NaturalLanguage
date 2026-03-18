//
//  ContentView.swift
//  CST380NaturalLanguage
//
//  Created by Thomas Gonda on 3/18/26.
//

import SwiftUI
import NaturalLanguage

struct ContentView: View {
    @State private var inputText: String = "No habla español."
    @State private var detectedLanguage: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Natural Language Framework Demo")
                .font(.largeTitle)
                .bold()

            Text("Hit Analyze to figure out language of the text.")
                .font(.subheadline)

            TextEditor(text: $inputText)
                .frame(height: 500)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Button("Analyze Text") {
                analyzeText()
            }
            .buttonStyle(.borderedProminent)

            if !detectedLanguage.isEmpty {
                Text("Detected language: \(detectedLanguage)")
                    .font(.headline)
            }
        }
        .padding()
    }

    func analyzeText() {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(inputText)

        if let language = recognizer.dominantLanguage {
            detectedLanguage =
                Locale.current.localizedString(forIdentifier: language.rawValue) ?? language.rawValue
        } else {
            detectedLanguage = "Unable to detect language"
        }
    }
}

#Preview {
    ContentView()
}
