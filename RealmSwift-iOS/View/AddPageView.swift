//
//  AddPageView.swift
//  RealmSwift-iOS
//
//  Created by Masatoshi Yamashita on 2022/12/25.
//

import SwiftUI

struct AddPageView: View {
    @EnvironmentObject var modelData : DBViewModel
    @Environment(\.presentationMode) var presentaion
    @State private var screenWidth = UIScreen.main.bounds.size.width
    @State private var screenHeight = UIScreen.main.bounds.size.height
    
    @FocusState var focus:Bool
    
    var body: some View {
        NavigationView {
            VStack{
                if modelData.notification != "" {
                    Text(modelData.notification)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                List {
                    Section(header: Text("名前")) {
                        HStack {
                            TextField("名前を入力", text: $modelData.name)
                                .focused(self.$focus)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()         // 右寄せにする
                                        Button("閉じる") {
                                            self.focus = false  //  フォーカスを外す
                                        }
                                    }
                                }
                        }
                    }
                    
                    //最終更新時間にするなら非表示で良い
                    /*
                    Section(header: Text("日付・時間")) {
                        
                        DatePicker("Pick a date:", selection: $modelData.date, in: Date().addingTimeInterval(60 * 30)...)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .datePickerStyle(.graphical)
                            /*.onChange(of: nowDate){ newValue in
                                modelData.date  = nowDate
                            }*/
                        
                    }
                     */
                    Section(header: Text("電話番号")) {
                        
                        TextField("01234567890", text: $modelData.phonenum)
                            .keyboardType(.phonePad)
                            .focused(self.$focus)
                    }
                    Section(header: Text("備考")) {
                        
                        TextField("メモを入力", text: $modelData.detail)
                            .focused(self.$focus)
                    }
                }
            }
            .onAppear(){
                modelData.setUpInitialData()
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(modelData.updateObject == nil ? "カードを追加" : "カードを編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {modelData.addData(presentation: presentaion)}, label: {
                        Text("保存する")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {presentaion.wrappedValue.dismiss()}, label: {
                        Text("キャンセル")
                    })
                }
            }
        }
        .onDisappear{
            modelData.deInitData()
        }
    }
}

struct AddPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddPageView()
    }
}

