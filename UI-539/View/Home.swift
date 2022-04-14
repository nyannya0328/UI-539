//
//  Home.swift
//  UI-539
//
//  Created by nyannyan0328 on 2022/04/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentTab : String = "BTC"
    @Namespace var animation
    @StateObject var model = AppViewModel()
    var body: some View {
        VStack{
            
            if let coins = model.coins,let coin = model.currentCoin{
                
                HStack(spacing:15){
                    
                   AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65, height: 65)
                    
                    
                    VStack(alignment: .leading, spacing: 13) {
                        Text("BitCoin")
                            .font(.title3)
                        
                        Text("BTC")
                            .font(.caption)
                        
                    }
                    
                    
                }
                .lLeading()
                
                CustomController(coins: coins)
                
                VStack(alignment: .leading, spacing: 13) {
                    
                    
                    Text(coin.current_price.ConvertToCurrency())
                        .font(.largeTitle.weight(.bold))
                    
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption.bold())
                        .foregroundColor(coin.price_change > 0 ? .white : .black)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background{
                            
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("LightGreen").opacity(0.6))
                        }
                    
                    
                }
                .lLeading()
                
                
                GrphView(coin: coin)
                
                Controller()
            }
            else{
                
                ProgressView()
                    .tint(Color("LightGreen"))
            }
            
            
        }
        .padding()
        .maxTop()
    }
    
    @ViewBuilder
    func GrphView(coin : CyptonModel)->some View{
        
        GeometryReader{_ in
            
            LineGraph(data: coin.last_7days_price.price,proFit: coin.price_change > 0)
        }
        
    }
    @ViewBuilder
    func CustomController(coins : [CyptonModel])->some View{
        
      //let coins = ["BTC","ETH","BNB"]
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing:15){
                
                ForEach(coins){coin in
                    
                    Text(coin.symbol.uppercased())
                        .font(.title3)
                        .foregroundColor(currentTab == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,10)
                        .padding(.horizontal,10)
                        .background{
                            
                            if currentTab == coin.symbol.uppercased(){
                                
                                Rectangle()
                                    .fill(Color("Tab"))
                                    .matchedGeometryEffect(id: "SEGNMENT", in: animation)
                            }
                            
                        }
                        .onTapGesture {
                            withAnimation{
                                model.currentCoin = coin
                                currentTab = coin.symbol.uppercased()
                            }
                            
                            
                        }
                    
                    
                }
            }
          
            
        }
        .background{
            
            
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.1),lineWidth: 2)
                
            }
            
        
        .padding(.vertical)
      
        
    }
    
    @ViewBuilder
    func Controller()->some View{
        
        
        HStack(spacing:18){
            
            Button {
                
            } label: {
                
                Text("Sell")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.vertical,15)
                    .padding(.horizontal,20)
                    .lCenter()
                    .background(
                    
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    
                    )
            }
            
            Button {
                
            } label: {
                
                Text("BUY")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.vertical,15)
                    .padding(.horizontal,20)
                    .lCenter()
                    .background(
                    
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("LightGreen"))
                    
                    )
            }

        }
        
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func getRect()->CGRect{
        
        
        return UIScreen.main.bounds
    }
    
    func lLeading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    func lTreading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    func lCenter()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .center)
    }
    
    func maxHW()->some View{
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity)
        
    
    }

 func maxTop() -> some View{
        
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
            
    }
    
}
extension Double{
    
    func ConvertToCurrency()->String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyISOCode
    
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
