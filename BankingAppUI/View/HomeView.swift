//
//  HomeView.swift
//  BankingAppUI
//
//  Created by nakamura motoki on 2022/02/10.
//

import SwiftUI

struct HomeView: View {
    // MARK: Smaple Colors
    // 色を配列で管理
    @State var colors: [ColorGrid] = [
        ColorGrid(hexValue: "#1565348", color: Color("Green")),
        ColorGrid(hexValue: "#DAA4FF", color: Color("Violet")),
        ColorGrid(hexValue: "#FFD90A", color: Color("Yellow")),
        ColorGrid(hexValue: "#FE9EC4", color: Color("Pink")),
        ColorGrid(hexValue: "#FB3272", color: Color("Orange")),
        ColorGrid(hexValue: "#4460EE", color: Color("Blue")),
    ]
    
    //MARK: Animation Properties
    // Instead of making each boolean for separate animation making it as a array to avoid multiple lines of code
    //各アニメーションを配列内の番号で管理する
    @State var animations: [Bool] = Array(repeating: false, count: 10)
    
    // MatchedGeometry Namespace
    @Namespace var animation
    
    // Card Color
    // クレジットカードの色を管理
    // 最初はピンク色で表示
    // 画面下のGridViewをタップするとカードの色を変更するために状態変数にしている
    @State var selectedColor: Color = Color("Pink")
    var body: some View {
        VStack{
            HStack{
                Button{
                    
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }//Button
                .hLeading()
                // プロフィールボタン
                Button{
                    
                }label: {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }//Button
            }//HStack 矢印とプロフィール画像を横並び
            .padding([.horizontal, .top])
            .padding(.top, 5)
            
            // MARK: Using Geometry Reader for Setting Offset
            // The card will arrive from the top of the screen, in order do that we need to push the card to the top of the screen simply using geometry Reader to push the view to top
            GeometryReader{ proxy in
                
                let maxY = proxy.frame(in: .global).maxY
                
                //　カードの表示
                CreditCard()
                // MARK: 3D Rotation
                //カードが画面上部から降りてくるようと同時にカードを回転させる
                    .rotation3DEffect(.init(degrees: animations[0] ? 0 : -270), axis: (x: 1, y: 0, z: 0), anchor: .center)
                // カードが画面上部から降りてくるように設定
                    .offset(y: animations[0] ? 0 : -maxY)
                
                
            }// GeometryReader
            .frame(height: 250)
            
            HStack{
                Text("Choose a color")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .hLeading()
                // 画面左端から文字を登場させる
                    .offset(x: animations[1] ? 0 : -200)
                Button{
                    
                }label: {
                    Text("View all")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Pink"))
                        .underline()
                }
                // 画面右端から文字を登場させる
                .offset(x: animations[1] ? 0 : 200)
            }//HStack Text("Choose a color")
            .padding()
            
            GeometryReader{ proxy in
                
                let size = proxy.size
                
                ZStack{
                    
                    Color.black
                    // 画面下の黒い背景の角を丸くする
                        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 40))
                        .frame(height: animations[2] ? nil : 0)
                        .vBottom()
                    ZStack{
                        // MARK: Initial Grid View
                        ForEach(colors){colorGrid in
                            
                            // Hiding the source Onces
                            if !colorGrid.removeFromView{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorGrid.color)
                                    .frame(width: 150, height: animations[3] ? 60 : 150)
                                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
                                // MARK: Rotating Cards
                                    .rotationEffect(.init(degrees: colorGrid.rotateCards ? 180 : 0))
                            }
                        }// ForEach
                    }// ScrollView
                    // MARK: Applying Opacity with Scale Animation
                    // To Avoid This Creating a BG Overlay and hiding it
                    // So that it will look like the whole stack is Applying Opacity Animation
                    .overlay(
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("BG"))
                            .frame(width: 150, height: animations[3] ? 60 : 150)
                            .opacity(animations[3] ? 0 : 1)
                    )
                    // Scale Effect
                    .scaleEffect(animations[3] ? 1 : 2.3)
                }// ZStack
                .hCenter()
                .vCenter()
                
                // MARK: ScrollView with Color Grids
                ScrollView(.vertical, showsIndicators: false){
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 15){
                        ForEach(colors){colorGrid in
                            
                            GridCardView(colorGrid: colorGrid)
                        }// ForEach
                    }// LazyVGrid
                    .padding(.top, 40)
                }// ScrollView
                .cornerRadius(40)
            }// GeometryReader
            .padding(.top)
        }//VStack
        .vTop()
        .hCenter()
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color("BG"))
        // 画面が表示されたときにanimateScreenメソッドを呼び出してアニメーションを起動する
        .onAppear(perform: animateScreen)
    }// body
    
    // MARK: Grid Card View
    @ViewBuilder
    func GridCardView(colorGrid: ColorGrid) -> some View{
        VStack{
            if colorGrid.addToGrid{
                // Displaying With Matched Geometry Effect
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorGrid.color)
                    .frame(width: 150, height: 60)
                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
                // When Animated Grid Card is Dasplayed Displaying the Color Text
                    .onAppear{
                        if let index = colors.firstIndex(where: { color in
                            return color.id == colorGrid.id
                        }){
                            withAnimation{
                                colors[index].showText = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.11){
                                withAnimation{
                                    colors[index].removeFromView = true
                                }
                            }
                        }
                    }// .onAppear
                    .onTapGesture {
                        withAnimation{
                            selectedColor = colorGrid.color
                        }
                    }
            }
            else{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(width: 150, height: 60)
            }
            
            Text(colorGrid.hexValue)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.white)
                .hLeading()
                .padding([.horizontal, .top])
                .opacity(colorGrid.showText ? 1: 0)
        }// VStack
    }// GridCardView()
    
    // アニメーションについてまとめたメソッド
    func animateScreen(){
        
        // MARK: Animating Screen
        // First Animation of Credit Card
        // Delaying First Animation after the second Animation
        // delay(0.3)はアニメーションの速度を指定
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.3)){
            animations[0] = true
        }
        
        // Second Animating the HStack with View All Button
        withAnimation(.easeInOut(duration: 0.7)){
            animations[1] = true
        }
        
        // Third Animation Makin The Bottom to Slide up eventually
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.3)){
            animations[2] = true
            
            // Third Animation Making The Bottom to Slide up eventually
            withAnimation(.easeInOut(duration: 0.8)){
                animations[3] = true
            }
            
            // Final Grid Forming Animation
            for index in colors.indices{
                
                // Animating after the opacity animation has Finished its job
                // Rotating One Card another with a time delay of 0.1sec
                // 0.1秒かけてGridを回転させる
                let delay: Double = (0.9 + (Double(index) * 0.1))
                
                // Last card is rotating first since we're putting in ZStack
                // To avoid this recalulate index from back
                let backIndex = ((colors.count - 1) - index)
                
                withAnimation(.easeInOut.delay(delay)){
                    colors[backIndex].rotateCards = true
                }
                
                // After rotation adding it to grid view one after another
                // Since .delay() will not work on if...else
                // So using DispatchQueue delay
                DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                    withAnimation{
                        colors[backIndex].addToGrid = true
                    }
                }
            }
        }
    }// animateScreen()
    
    // MARK: Animated Credit Card
    @ViewBuilder
    func CreditCard() -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
            // カードの色　最初はピンク
                .fill(selectedColor)
            
            VStack{
                HStack{
                    // 左上の4つの丸を作成
                    ForEach(1...4, id: \.self){ _ in
                        Circle()
                        // 色を白に
                            .fill(.white)
                            .frame(width: 4, height: 4)
                    }
                    Text("7864")
                        .foregroundColor(.white)
                        .font(.callout)
                        .fontWeight(.semibold)
                }//HStack
                .hLeading()
                //spacing: -12で二つの円を話すのではなく重ねる
                HStack(spacing: -12){
                    
                    Text("Jenna Ezarik")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .hLeading()
                    
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 30, height: 30)
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 30, height: 30)
                }//HStack
                .vBottom()
            }//VStack
            .padding(.vertical, 20)
            .padding(.horizontal)
            .vTop()
            .hLeading()
            
            // MARK: Top Ring
            Circle()
                .stroke(Color.white.opacity(0.5),lineWidth: 18)
                .offset(x: 130, y: -120)
        }// ZStack
        // カードの大きさを調整
        .clipped()
        .padding()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: Extensions for Making UI Design Faster
// Viewの位置を決める関数
extension View{
    func hLeading() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    func vCenter() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .center)
    }
    func vTop() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
    func vBottom() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
}
