//
//  DiaryEntryView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 03/03/24.
//

import SwiftUI

struct DiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss

    var date: Date = Date.now

    var body: some View {
        Text("This is my diary entry")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .tint(Constants.Colors.backArrowTint)
                    })
                }
            }
    }
}

#Preview {
    DiaryEntryView()
}
