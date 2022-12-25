//
//  DBViewModel.swift
//  RealmSwift-iOS
//
//  Created by Masatoshi Yamashita on 2022/12/25.
//

import SwiftUI
import RealmSwift

class DBViewModel: ObservableObject {
    
    //シートの表示・非表示管理
    @Published var openNewPage = false
    
    //カードの記載事項
    @Published var name = ""
    @Published var date = Date()
    @Published var phonenum = ""
    @Published var detail = ""
    
    //カードのモデルを持ってくる
    @Published var cards : [Card] = []
    
    //上書き用情報
    @Published var updateObject : Card?
    @Published var updateBool = false
    @Published var dateNotSetList = ["","",""]
    //削除用情報
    @Published var deleteObject : Card?
    
    //２回目以降の表示の際の項目の初期化用
    @Published var dateNotSetObject : Card?
    
    //記載事項に不備があった場合の通知用
    @Published var notification = ""
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        
        guard let dbRef = try? Realm() else { return }
        
        //カードを日付順にソート
        let results = dbRef.objects(Card.self)
            .sorted(byKeyPath: "date") // orderの数値で並び替え
            .reversed()
        
        self.cards = results.compactMap({(card) -> Card? in
            return card
        })
    }
    func addData(presentation: Binding<PresentationMode>) {
        
        if name == "" {
            notification = "名前を入力して下さい"
            return
        }
        
        let card = Card()
        card.name = name
        card.date = Date()
        //card.date = date
        card.phonenum = phonenum
        card.detail = detail
        
        guard let dbRef = try? Realm() else { return }
        
        try? dbRef.write {
            
            guard let availableObject = updateObject else {
                dbRef.add(card)
                
                return
            }
            availableObject.name = name
            availableObject.date = Date()
            //availableObject.date = date
            availableObject.phonenum = phonenum
            availableObject.detail = detail
        }
        
        fetchData()
        presentation.wrappedValue.dismiss()
    }
    
    func deleteData() {
        guard let dbRef = try? Realm() else{ return }
        
        guard let deleteData = deleteObject else { return }
        
        try? dbRef.write {
            dbRef.delete(deleteData)
            fetchData()
        }
    }
    
    func setUpInitialData() {
        if dateNotSetList[0] != "" {
            name = dateNotSetList[0]
            phonenum = dateNotSetList[2]
            detail = dateNotSetList[1]
        }
        
        guard let updateData = updateObject else { return }
        
        if updateData.name != "" {
            updateBool = true
        }
        
        name = updateData.name
        date = updateData.date
        phonenum = updateData.phonenum
        detail = updateData.detail
        
    }
    
    func deInitData() {
        // 今回は不要
        /*
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        
        var compornets = DateComponents()
        let dateInst = Date()
        let modifiedDate_a = Calendar.current.date(byAdding: .hour, value: -1, to: dateInst)!
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: modifiedDate_a)!
        compornets.year = calendar.component(.year, from: modifiedDate)
        compornets.month = calendar.component(.month, from: modifiedDate)
        compornets.day = calendar.component(.day, from: modifiedDate)
        compornets.hour = calendar.component(.hour, from: modifiedDate)
        compornets.minute = calendar.component(.minute, from: modifiedDate)
        compornets.second = 0
        */
        
        updateObject = nil
        dateNotSetObject = nil
        dateNotSetList = ["","",""]
        updateBool = false
        name = ""
        date = Date()
        //date = calendar.date(from: compornets)!
        phonenum = ""
        detail = ""
        notification = ""
    }
}
