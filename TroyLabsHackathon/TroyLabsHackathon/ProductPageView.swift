//
//  ProductPageView.swift
//  TroyLabsHackathon
//
//  Created by Siddarth Rudraraju on 9/12/24.
//

import Foundation
import SwiftUI

struct ProductPageView: View {
    let products = [
        "Radiant Glow Foundation",
        "Silky Smooth Lipstick",
        "Luminous Blush",
        "Volumizing Mascara",
        "Nourishing Face Serum",
        "Hydrating Primer",
        "Matte Finish Setting Spray",
        "Brightening Eye Cream",
        "Shimmer Eyeshadow Palette",
        "Creamy Concealer",
        "Revitalizing Night Cream",
        "SPF 30 Sunscreen Lotion"
    ]
    
    @State private var showRecommendationModal = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Decide what product is right for you")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.top)

            Button(action: {
                showRecommendationModal = true
            }) {
                Text("Get Product Recommendations")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .sheet(isPresented: $showRecommendationModal) {
                RecommendationModalView()
            }
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(products, id: \.self) { product in
                        NavigationLink(destination: ProductDetailView(productName: product)) {
                            ProductCardView(productName: product)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Products")
    }
}


struct ProductCardView: View {
    var productName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(productName)
                .font(.headline)
                .padding()

            
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

import SwiftUI

struct ProductDetailView: View {
    let productName: String
    
    @State private var customerReview: String = ""
    @State private var reviews: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            Text(productName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("This is a detailed description of \(productName). It is one of our top-rated products known for its amazing features and benefits.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            VStack {
                Text("Add a Customer Review:")
                    .font(.headline)
                    .padding(.bottom, 5)

                TextField("Write your review here...", text: $customerReview)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if !customerReview.isEmpty {
                        reviews.append(customerReview)
                        saveReviews()
                        customerReview = ""
                    }
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 5)
            }
            .padding(.horizontal)

            if !reviews.isEmpty {
                Text("Customer Reviews:")
                    .font(.headline)
                    .padding(.top)

                ScrollView {
                    ForEach(reviews, id: \.self) { review in
                        Text(review)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .navigationBarTitle(Text(productName), displayMode: .inline)
        .padding()
        .onAppear(perform: loadReviews)
    }

    func saveReviews() {
        UserDefaults.standard.set(reviews, forKey: productName)
    }

    func loadReviews() {
        if let savedReviews = UserDefaults.standard.array(forKey: productName) as? [String] {
            reviews = savedReviews
        }
    }
}



