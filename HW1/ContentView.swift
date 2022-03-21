//
//  ContentView.swift
//  HW1
//
//  Created by 賴冠宏 on 2022/3/13.
//

import SwiftUI
import UIKit
import Metal
import AVFoundation
struct ContentView: View {
    @State private var chesscolor = "whitechess"
    @State private var site = Array(repeating: 0, count: 42)
    @State private var who = 0 //輪到誰
    @State private var y_chess = 21
    @State private var r_chess = 21
    @State private var y_win = 0
    @State private var r_win = 0
    @State private var a = 42
    @State private var b = 43
    @State private var c = 44
    @State private var d = 45
    @State private var e = 46
    @State private var f = 47
    @State private var g = 48
    @State private var endGame = 0 //判斷遊戲是否結束
    let player = AVPlayer()

    var body: some View {
        VStack{
            ZStack{
                Image("bg")
                    .resizable()
                    .frame(width: 380, height: 380)
                HStack{
                    let columns = Array(repeating: GridItem(), count: 6)
                    LazyVGrid(columns: columns){
                        ForEach(0..<site.count){ item in
                            Image("\(changeColor(colorNum: site[item]))")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(100)
                                .onTapGesture {
                                    var num = 0 //記錄當前棋子位置
                                    
                                    if endGame == 1{
                                        resetGame()
                                        endGame = 0
                                    }
                                    
                                    if site[item] == 0{
                                        num = underBottom(siteNum: item)
                                        site[num] = getColor(who: who)
                                        if getColor(who: who)==1{
                                            y_chess -= 1
                                        }
                                        else{
                                            r_chess -= 1
                                        }
                                        who += 1
                                        print(whoWin(nowChess: item))
                                    }

                                    if whoWin(nowChess: num)==777{
                                        endGame = 1
                                        //彈出視窗
                                        var winPlayer = "white"
                                        if getColor(who: who-1)==1{
                                            winPlayer = "黃方"
                                            y_win += 1
                                        }
                                        else{
                                            winPlayer = "紅方"
                                            r_win += 1
                                        }
                                        let controller = UIAlertController(title: "\(winPlayer)獲勝！\n", message: "點擊即開啟新一輪對戰或按下reset重置遊戲", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        controller.addAction(okAction)
                                        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
                                        //讓遊戲結束當下的now玩家為獲勝玩家
                                        who -= 1
                                    }
                                    if whoWin(nowChess: num)==42{
                                        endGame = 1
                                        
                                        //彈出視窗
                                        let controller = UIAlertController(title: "平手！\n", message: "點擊即開啟新一輪對戰或按下reset重置遊戲", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        controller.addAction(okAction)
                                        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
                                    }
                                    print(item)
                                }
                        }
                    }
                    
                }
                
                Text("Now :")
                    .font(.title)
                    .padding()
                    .offset(x: -35, y: -250)
                Image("\(changeColor(colorNum: getColor(who: who)))")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .offset(x: 35, y: -250)
                
                Text("\(y_chess)")
                    .font(.title3)
                    .padding()
                    .offset(x: -100, y: -300)
                Image("yellowchess")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .offset(x: -150, y: -320)
                Text("\(r_chess)")
                    .font(.title3)
                    .padding()
                    .offset(x: 100, y: -300)
                Image("redchess")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .offset(x: 150, y: -320)
                Text("\(y_win):\(r_win)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .offset(x: 0, y: -300)
                    
                  
            }
            //reset chess
            Button{
                for i in 0..<42{
                    site[i] = 0
                }
                a = 42
                b = 43
                c = 44
                d = 45
                e = 46
                f = 47
                g = 48
                who = 0
                y_chess = 21
                r_chess = 21
                y_win = 0
                r_win = 0
            }label:{
                Text("reset")
                    .font(.title)
            }.offset(x: 150, y:-430)
            
        }
        .onAppear {
            let fileUrl = Bundle.main.url(forResource: "BGM", withExtension: "mp4")!
                            let playerItem = AVPlayerItem(url: fileUrl)
                            self.player.replaceCurrentItem(with: playerItem)
                            self.player.play()
        }
    }
    
    //傳入陣列內的值給函式判斷該為什麼顏色並回傳
    func changeColor(colorNum: Int) -> String{
        if colorNum == 0{
            return "whitechess"
        }
        else if colorNum == 1{
            return "yellowchess"
        }
        else if colorNum == 2{
            return "redchess"
        }
        else if colorNum == 3{
            return "bingo"
        }
        return "whitechess"
    }
    //得知是輪到誰下要變什麼顏色
    func getColor(who: Int) -> Int{
        if who%2 == 0{
            return 1
        }
        else{
            return 2
        }
    }
    //從最下開始放
    func underBottom(siteNum: Int) -> Int{
        if siteNum%6 == 0{
            //0 6 12 18 24 30 36
            a -= 6
            return a
        }
        else if siteNum%6 == 1{
            //1 7 13 19 25 31 37
            b -= 6
            return b
        }
        else if siteNum%6 == 2{
            //2 8 14 20 26 32 38
            c -= 6
            return c
        }
        else if siteNum%6 == 3{
            //3 9 15 21 27 33 39
            d -= 6
            return d
        }
        else if siteNum%6 == 4{
            //4 10 16 22 28 34 40
            e -= 6
            return e
        }
        else if siteNum%6 == 5{
            //5 11 17 22 28 34 41
            f -= 6
            return f
        }
        return -1
    }
    //輸贏判斷
    func whoWin(nowChess: Int) -> Int{
        var x = 0
        
        //直
        if nowChess <= 23{
            for i in 1..<4{
                if site[nowChess] == site[nowChess + (6*i)]{
                    if site[nowChess + (6*i)] != 0{
                        x += 1
                    }
                }
            }
        }
        if x == 3{
            site[nowChess] = 3
            for i in 1..<4{
                site[nowChess + (6*i)] = 3
            }
            return 777
        }
        //橫
        if nowChess%6 == 0{
            var y0 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y0 += 1
                    }
                }
            }
            if y0 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess + i] = 3
                }
                return 777
            }
        }
        if nowChess%6 == 1{
            var y11 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y11 += 1
                    }
                }
            }
            if y11 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess + i] = 3
                }
                return 777
            }
            var y12 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y12 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess-1]{
                if site[nowChess-1] != 0{
                    y12 += 1
                }
            }
            if y12 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess + i] = 3
                }
                site[nowChess-1] = 3
                return 777
            }
        }
        if nowChess%6 == 2{
            var y20 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y20 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess+1]{
                if site[nowChess+1] != 0{
                    y20 += 1
                }
            }
            if y20 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess - i] = 3
                }
                site[nowChess+1] = 3
                return 777
            }
            var y21 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y21 += 1
                    }
                }
            }
            if y21 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess + i] = 3
                }
                return 777
            }
            var y22 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y22 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess-1]{
                if site[nowChess-1] != 0{
                    y22 += 1
                }
            }
            if y22 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess + i] = 3
                }
                site[nowChess-1] = 3
                return 777
            }
        }
        if nowChess%6 == 3{
            var y30 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y30 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess+1]{
                if site[nowChess+1] != 0{
                    y30 += 1
                }
            }
            if y30 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess - i] = 3
                }
                site[nowChess+1] = 3
                return 777
            }
            var y31 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y31 += 1
                    }
                }
            }
            if y31 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess - i] = 3
                }
                return 777
            }
            var y32 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess+i]{
                    if site[nowChess+i] != 0{
                        y32 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess-1]{
                if site[nowChess-1] != 0{
                    y32 += 1
                }
            }
            if y32 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess + i] = 3
                }
                site[nowChess-1] = 3
                return 777
            }
        }
        if nowChess%6 == 4{
            var y41 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y41 += 1
                    }
                }
            }
            if y41 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess - i] = 3
                }
                return 777
            }
            var y42 = 0
            for i in 1..<3{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y42 += 1
                    }
                }
            }
            if site[nowChess] == site[nowChess+1]{
                if site[nowChess+1] != 0{
                    y42 += 1
                }
            }
            if y42 == 3{
                site[nowChess] = 3
                for i in 1..<3{
                    site[nowChess - i] = 3
                }
                site[nowChess+1] = 3
                return 777
            }
        }
        if nowChess%6 == 5{
            var y5 = 0
            for i in 1..<4{
                if site[nowChess] == site[nowChess-i]{
                    if site[nowChess-i] != 0{
                        y5 += 1
                    }
                }
            }
            if y5 == 3{
                site[nowChess] = 3
                for i in 1..<4{
                    site[nowChess - i] = 3
                }
                return 777
            }
        }
        //斜
        var r1 = 0
        for i in 1..<4{
            if nowChess-(5*i)>=0 && ((nowChess-(5*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess-(5*i)]{
                    if site[nowChess-(5*i)] != 0{
                        r1 += 1
                    }
                }
            }
        }
        if r1 == 3{
            site[nowChess] = 3
            for i in 1..<4{
                site[nowChess-(5*i)] = 3
            }
            return 777
        }
        var r2 = 0
        for i in 1..<3{
            if nowChess-(5*i)>=0 && ((nowChess-(5*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess-(5*i)]{
                    if site[nowChess-(5*i)] != 0{
                        r2 += 1
                    }
                }
            }
        }
        if nowChess+5<=41 && nowChess%6 != 0{
            if site[nowChess] == site[nowChess+5] {
                if site[nowChess+1] != 0{
                    r2 += 1
                }
            }
        }
        
        if r2 == 3{
            site[nowChess] = 3
            site[nowChess+5] = 3
            for i in 1..<3{
                site[nowChess-(5*i)] = 3
            }
            return 777
        }
        var r3 = 0
        for i in 1..<3{
            if nowChess+(5*i)<=41 && ((nowChess+(5*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess+(5*i)]{
                    if site[nowChess+(5*i)] != 0{
                        r3 += 1
                    }
                }
            }
        }
        if nowChess-5>=0 && nowChess%6 != 5{
            if site[nowChess] == site[nowChess-5] {
                if site[nowChess+1] != 0{
                    r3 += 1
                }
            }
        }
        
        if r3 == 3{
            site[nowChess] = 3
            site[nowChess-5] = 3
            for i in 1..<3{
                site[nowChess+(5*i)] = 3
            }
            return 777
        }
        var r4 = 0
        for i in 1..<4{
            if nowChess+(5*i)<=41 && ((nowChess+(5*(i-1)))%6) != 0 {
                if site[nowChess] == site[nowChess+(5*i)]{
                    if site[nowChess+(5*i)] != 0{
                        r4 += 1
                    }
                }
            }
        }
        if r4 == 3{
            site[nowChess] = 3
            for i in 1..<4{
                site[nowChess+(5*i)] = 3
            }
            return 777
        }
        var l1 = 0
        for i in 1..<4{
            if nowChess-(7*i)>=0 && ((nowChess-(7*(i-1)))%6) != 0 {
                if site[nowChess] == site[nowChess-(7*i)]{
                    if site[nowChess-(7*i)] != 0{
                        l1 += 1
                    }
                }
            }
        }
        if l1 == 3{
            site[nowChess] = 3
            for i in 1..<4{
                site[nowChess-(7*i)] = 3
            }
            return 777
        }
        var l2 = 0
        for i in 1..<3{
            if nowChess-(7*i)>=0 && ((nowChess-(7*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess-(7*i)]{
                    if site[nowChess-(7*i)] != 0{
                        l2 += 1
                    }
                }
            }
        }
        if nowChess+7<=41 && nowChess%6 != 0{
            if site[nowChess] == site[nowChess+7] {
                if site[nowChess+1] != 0{
                    l2 += 1
                }
            }
        }
        if l2 == 3{
            site[nowChess] = 3
            site[nowChess+7] = 3
            for i in 1..<3{
                site[nowChess-(7*i)] = 3
            }
            return 777
        }
        var l3 = 0
        for i in 1..<3{
            if nowChess+(7*i)<=41 && ((nowChess+(7*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess+(7*i)]{
                    if site[nowChess+(7*i)] != 0{
                        l3 += 1
                    }
                }
            }
        }
        if nowChess-7>=0 && nowChess%6 != 5{
            if site[nowChess] == site[nowChess-7] {
                if site[nowChess+1] != 0{
                    l3 += 1
                }
            }
        }
        if l3 == 3{
            site[nowChess] = 3
            site[nowChess-7] = 3
            for i in 1..<3{
                site[nowChess+(7*i)] = 3
            }
            return 777
        }
        var l4 = 0
        for i in 1..<4{
            if nowChess+(7*i)<=41 && ((nowChess+(7*(i-1)))%6) != 5 {
                if site[nowChess] == site[nowChess+(7*i)]{
                    if site[nowChess+(7*i)] != 0{
                        l4 += 1
                    }
                }
            }
        }
        if l4 == 3{
            site[nowChess] = 3
            for i in 1..<4{
                site[nowChess+(7*i)] = 3
            }
            return 777
        }
        var tie = 0
        for i in 0..<42{
            if site[i] != 0{
                tie += 1
            }
        }
        return tie
    }
    //reset game
    func resetGame(){
        for i in 0..<42{
            site[i] = 0
        }
        a = 42
        b = 43
        c = 44
        d = 45
        e = 46
        f = 47
        g = 48
        who = 0
        y_chess = 21
        r_chess = 21
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

