import SwiftUI

struct HomeView: View {
    let brandDescription = """
    BiotechBeauty leverages bioengineered breakthrough ingredients, so we don’t have to compromise between wearing great makeup, improving our skin health, and caring for the planet along the way.
    """
    
    let ingredients = [
        "Hyaluronic Acid",
        "Vitamin C",
        "Retinol",
        "Niacinamide",
        "Peptides",
        "Ceramides",
        "Alpha Hydroxy Acids",
        "Beta Hydroxy Acids",
        "Squalane",
        "Green Tea Extract",
        "Probiotics",
        "Collagen"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 100)
                    .padding(.top)
                
                Text(brandDescription)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            IngredientCardView(ingredientText: ingredient)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Learn which product is right for you")
                    .font(.headline)
                    .padding(.top)
                
                NavigationLink(destination: ProductPageView()) {
                    Text("Click to find the product you should use")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250) // Adjusted width
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct IngredientCardView: View {
    var ingredientText: String
    
    var body: some View {
        VStack {
            Text(ingredientText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: 150, height: 100)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
