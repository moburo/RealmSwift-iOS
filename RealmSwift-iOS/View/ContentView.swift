//
//  ContentView.swift
//  RealmSwift-iOS
//
//  Created by Masatoshi Yamashita on 2022/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var screenWidth = UIScreen.main.bounds.size.width
    @State private var screenHeight = UIScreen.main.bounds.size.height
    @StateObject var modelData = DBViewModel()
    
    @State var loading = false
    @State var isShowAlert = false
    
    @Environment(\.timeZone) var timeZone
    var dateFormat3: DateFormatter {
        let dformat = DateFormatter()
        dformat.locale = Locale(identifier: "ja_JP")
        dformat.dateStyle = .medium
        dformat.timeStyle = .medium
        dformat.dateFormat = "yyyy/M/d"
        dformat.timeZone  = timeZone
        return dformat
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if modelData.cards.count > 0 {
                    ForEach(modelData.cards) { card in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(card.name)
                                .bold()
                                .font(.title2)
                            Text("最終更新日: \(card.date, formatter: dateFormat3)")
                                .font(.title3)
                            let detailString = card.detail
                            if detailString != "" {
                                Text(detailString)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu(menuItems: {
                            Button(action: {
                                if card.phonenum != "" {
                                    let phone = "tel://"
                                    let phoneNumberformatted = phone + card.phonenum
                                    guard let url = URL(string: phoneNumberformatted) else { return }
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("電話する")
                            })
                            
                            Button(action: {
                                modelData.updateObject = card
                                modelData.openNewPage.toggle()
                            }, label: {
                                Text("編集する")
                            })
                            
                            Button(action: {
                                modelData.deleteObject = card
                                isShowAlert.toggle()
                                
                            }, label: {
                                Text("削除する")
                            })
                            
                        })
                        .alert(isPresented: $isShowAlert) {
                            Alert(title: Text("カードを削除する"),
                                  message: Text("このカードを削除します\n削除後は復元できません"),
                                  primaryButton: .default(Text("キャンセル")),
                                  secondaryButton: .default(Text("削除")) {
                                modelData.deleteData()
                            })
                        }
                    }
                    Text("長押しで削除・変更ができます")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("カードが登録されていません")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("タイトル")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                            modelData.openNewPage.toggle()
                        
                    }){
                        HStack{
                            Text("追加")
                            Image(systemName: "plus")
                        }
                    }
                    .disabled(loading)
                }
            }
        }
        .fullScreenCover(isPresented: $modelData.openNewPage, content: {
            AddPageView()
                .environmentObject(modelData)
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

