//
//  OpenAIAPIClient.swift
//  TroyLabsHackathon
//
//  Created by Siddarth Rudraraju on 9/12/24.
//

import Foundation

class OpenAIAPIClient {
    static let shared = OpenAIAPIClient()
    
    private init() {}
    
    private let apiKey = "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" 
    
    func getRecommendations(questionsAndAnswers: [String: String], completion: @escaping (String?) -> Void) {
        let prompt = generatePrompt(from: questionsAndAnswers)
        
        let endpoint = "https://api.openai.com/v1/completions"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let parameters: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 150,
            "temperature": 0.7,
            "n": 1
        ]
        
        // Serialize parameters to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error serializing parameters")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in API request: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data in response")
                completion(nil)
                return
            }
            
            do {
                // Parse the response JSON
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let text = choices.first?["text"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Invalid response format")
                    completion(nil)
                }
            } catch {
                print("Error parsing response: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    private func generatePrompt(from qa: [String: String]) -> String {
        var prompt = "Based on the following user preferences, recommend a suitable makeup product from the list provided and explain why it is suitable:\n\n"
        for (question, answer) in qa {
            prompt += "\(question) \(answer)\n"
        }
        prompt += "\nList of products:\n"
        prompt += """
        - Radiant Glow Foundation
        - Silky Smooth Lipstick
        - Luminous Blush
        - Volumizing Mascara
        - Nourishing Face Serum
        - Hydrating Primer
        - Matte Finish Setting Spray
        - Brightening Eye Cream
        - Shimmer Eyeshadow Palette
        - Creamy Concealer
        - Revitalizing Night Cream
        - SPF 30 Sunscreen Lotion
        """
        prompt += "\n\nRecommendation:"
        return prompt
    }
}
