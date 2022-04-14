//
//  LineGraph.swift
//  UI-538
//
//  Created by nyannyan0328 on 2022/04/13.
//

import SwiftUI

struct LineGraph: View {
    var data : [Double]
    
    @GestureState var isDragging : Bool = false
    @State var currentPlot : String = ""
    
    @State var offset : CGSize = .zero
    
    
    @State var showPlot : Bool = false
    @State var translation : CGFloat = 0
    
    @State var proFit : Bool = false
    
    @State var progress : CGFloat = 0
    var body: some View {
        GeometryReader{proxy in
            
            let height = proxy.size.height
            let widht = (proxy.size.width) / CGFloat(data.count - 1)
            let maxPoint = data.max() ?? 0
            let minPoint = data.min() ?? 0
            
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                let pathWidh = widht * CGFloat(item.offset)
                
                return CGPoint(x: pathWidh, y: -pathHeight + height)
                
            }
            
            ZStack{
                
                AnimatedGraphPath(progress: progress, points: points)
             
                .fill(
              
                    LinearGradient(colors: [
                    
                    
                        proFit ? Color("Profit") : Color("Loss"),
                        proFit ? Color("Profit") : Color("Loss")
                    
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                
                FillBG()
                    .clipShape(
                    
                        
                        Path{path in
                            
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(points)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    
                    )
                    .opacity(progress)
                
                
                
                
                
            }
            .overlay(alignment: .bottomLeading, content: {
                
                
                VStack(spacing:0){
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background(
                            
                            Capsule()
                                .fill(Color("Gradient1")))
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay {
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        }
                    
                    
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                    
                    
                    
                        
                    
                }
                .frame(width: 80, height: 170)
                .offset(offset)
                .offset(y: 70)
                .opacity(showPlot ? 1 : 0)
              
                
            })
            .contentShape(Rectangle())
            .gesture(
            
                DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    
                    withAnimation{showPlot = true}
                    
                    let traslation = value.location.x - 20
                    
                    let index = max(min(Int((traslation / widht).rounded() + 1), data.count - 1)
                                    , 0)
                    currentPlot = "$\(data[index])"
                    
                    self.translation = traslation
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                    
                   
                    
                }).onEnded({ value in
                    
                    withAnimation{showPlot = false}
                })
                
                
                
            
            
            )
            
           
        }
      
        .overlay(alignment: .leading, content: {
            
            
            VStack(alignment: .leading, spacing: 13) {
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
          
                Text(max.ConvertToCurrency())
                    .font(.caption.bold())
                
                
                Spacer()
                
                Text("Last 7 Days")
                    .foregroundColor(.gray)
                
                Text(min.ConvertToCurrency())
                    .font(.caption.bold())
                
            }
            
            
        })
        .padding(.horizontal,10)
        .onAppear(perform: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                withAnimation(.easeOut(duration: 1.2)){
                    
                    progress = 1
                    
                    
                }
            }
        })
        .onChange(of: data) { newValue in
            
            progress = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                withAnimation(.easeOut(duration: 1.2)){
                    
                    progress = 1
                    
                    
                }
            }
            
        }
    }
    @ViewBuilder
    func FillBG()->some View{
        
        let color = proFit ? Color("Profit") : Color("Loss")
        
        LinearGradient(colors: [
            
         
            
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1),
            color.opacity(0.3),
        
        
        
        
        ] + Array(repeating: Color("Gradient1").opacity(0.1), count: 4) + Array(repeating: .clear.opacity(0.1), count: 2) , startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct AnimatedGraphPath : Shape{
    
    var progress : CGFloat
    var points : [CGPoint]
    
    var animatableData: CGFloat{
        
        get{return progress}
        set{progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        
    }
}
