//
//  RecommendationModalView.swift
//  TroyLabsHackathon
//
//  Created by Siddarth Rudraraju on 9/12/24.
//

import Foundation
import SwiftUI

struct RecommendationModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var answers: [String: String] = [:]
    @State private var isSubmitting = false
    @State private var recommendation: String?
    
    @State private var navigateToProduct = false
    @State private var selectedProduct: String?

    // Sample questions
    let questions = [
        "What is your skin type? (e.g., oily, dry, combination, sensitive)",
        "What is your primary skin concern? (e.g., acne, aging, dryness)",
        "What kind of makeup finish do you prefer? (e.g., matte, dewy, natural)",
        "Do you have any allergies or ingredients to avoid?",
        "What is your preferred makeup product? (e.g., foundation, lipstick, mascara)",
        "What coverage level do you prefer? (e.g., light, medium, full)"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if let recommendation = recommendation {
                    ScrollView {
                        Text(recommendation)
                            .font(.body)
                            .padding()
                        
                        NavigationLink(
                            destination: ProductDetailView(productName: selectedProduct ?? "Radiant Glow Foundation"),
                            isActive: $navigateToProduct
                        ) {
                            EmptyView()
                        }
                        
                        Button("Go to Product Page") {
                            navigateToProduct = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    // Display questions
                    Form {
                        ForEach(questions, id: \.self) { question in
                            Section(header: Text(question)) {
                                TextField("Your answer", text: Binding(
                                    get: { self.answers[question] ?? "" },
                                    set: { self.answers[question] = $0 }
                                ))
                            }
                        }
                    }
                    
                    // Submit Button
                    Button(action: {
                        submitAnswers()
                    }) {
                        Text(isSubmitting ? "Submitting..." : "Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isSubmitting ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(isSubmitting)
                    .padding()
                }
            }
            .navigationBarTitle("Product Recommendation", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func submitAnswers() {
        isSubmitting = true

        print("Submitting answers: \(answers)")

        OpenAIAPIClient.shared.getRecommendations(questionsAndAnswers: answers) { response in
            DispatchQueue.main.async {
                if let recommendation = response {
                    print("Received recommendation: \(recommendation)")
                    self.recommendation = recommendation
                    self.selectedProduct = extractProduct(from: recommendation) 
                } else {
                    print("No recommendation received, providing default recommendation.")
                    self.recommendation = self.generateDefaultRecommendation()
                    self.selectedProduct = "Radiant Glow Foundation"
                }
                self.isSubmitting = false
            }
        }
    }
    
    func generateDefaultRecommendation() -> String {
        // Simple logic to generate a recommendation
        if let preferredProduct = answers["What is your preferred makeup product? (e.g., foundation, lipstick, mascara)"]?.lowercased() {
            switch preferredProduct {
            case "foundation":
                selectedProduct = "Radiant Glow Foundation"
                return "Based on your preferences, we recommend our Radiant Glow Foundation. It's suitable for various skin types and offers a beautiful finish."
            case "lipstick":
                selectedProduct = "Silky Smooth Lipstick"
                return "Try our Silky Smooth Lipstick for a rich color and smooth application."
            case "mascara":
                selectedProduct = "Volumizing Mascara"
                return "Our Volumizing Mascara will give your lashes the lift and volume you desire."
            default:
                selectedProduct = "Radiant Glow Foundation"
                return "We recommend exploring our top-rated products to find the perfect match."
            }
        } else {
            selectedProduct = "Radiant Glow Foundation"
            return "We recommend exploring our top-rated products to find the perfect match."
        }
    }

    func extractProduct(from recommendation: String) -> String {
        let products = [
            "Radiant Glow Foundation", "Silky Smooth Lipstick", "Luminous Blush",
            "Volumizing Mascara", "Nourishing Face Serum", "Hydrating Primer",
            "Matte Finish Setting Spray", "Brightening Eye Cream",
            "Shimmer Eyeshadow Palette", "Creamy Concealer",
            "Revitalizing Night Cream", "SPF 30 Sunscreen Lotion"
        ]
        
        for product in products {
            if recommendation.contains(product) {
                return product
            }
        }
        return "Radiant Glow Foundation"
    }
}

