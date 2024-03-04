//
//  DiaryEntryView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 03/03/24.
//

import SwiftUI

struct DiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss

    @State var date: Date
    @State var title: String
    @State var story: String

    var body: some View {
        VStack {
            TextField("", text: $title, prompt: Text("Title").font(.title), axis: .vertical)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: -10, trailing: 0))
                .font(.title)

            Divider()
                .padding()

            TextField("", text: $story, prompt: Text("Tell your story ...").font(.title2), axis: .vertical)
                .padding(EdgeInsets(top: -10, leading: 20, bottom: 0, trailing: 0))
                .font(.title3)

            Spacer()

            Button(action: {}, label: {
                Text("Save")
                    .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                    .foregroundStyle(Color.white)
                    .background(Color.brown, in: Capsule())
            })
            .padding()
        }
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

            ToolbarItem(placement: .principal) {
                Text("\(date.getTitleDisplayDate())")
                    .foregroundStyle(Constants.Colors.backArrowTint)
            }
        }
    }
}

#Preview {
    DiaryEntryView(date: Date.now, title: "", story: "")
}
