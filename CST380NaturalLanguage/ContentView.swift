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
                .frame(height: 200)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Button("Analyze Text") {
                analyzeText()
                tokenizeText()
            }
            .buttonStyle(.borderedProminent)

            if !detectedLanguage.isEmpty {
                let parts = detectedLanguage.components(separatedBy: "\n\n")
                let dominantName = parts.first?.replacingOccurrences(of: "Dominant: ", with: "") ?? ""
                Text("Detected Language: \(dominantName)")
                    .font(.headline)
                Text("Dominant: \(dominantName)")
                    .font(.subheadline)
                Text(parts.dropFirst().joined(separator: "\n\n"))
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    func analyzeText() {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(inputText)

        if let language = recognizer.dominantLanguage {
            let name = Locale.current.localizedString(forIdentifier: language.rawValue) ?? language.rawValue

            let hypotheses = recognizer.languageHypotheses(withMaximum: 3)
            let details = hypotheses
                .sorted { $0.value > $1.value }
                .map { (lang, confidence) in
                    let langName = Locale.current.localizedString(forIdentifier: lang.rawValue) ?? lang.rawValue
                    return "\(langName): \(Int(confidence * 100))%"
                }
                .joined(separator: "\n")

            detectedLanguage = "Dominant: \(name)\n\nTop Hypotheses:\n\(details)"
        } else {
            detectedLanguage = "Unable to detect language"
        }
    }
    
    func tokenizeText() {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = inputText
        //itterates and prints out the tokenized string
        tokenizer.enumerateTokens(in: inputText.startIndex..<inputText.endIndex) { tokenRange, _ in
            print(inputText[tokenRange])
            return true
        }
    }
}

#Preview {
    ContentView()
}
