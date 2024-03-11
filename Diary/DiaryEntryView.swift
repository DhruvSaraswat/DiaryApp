//
//  DiaryEntryView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 03/03/24.
//

import SwiftUI

struct DiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: DiaryEntryViewModel
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            TextField("", text: $viewModel.title, prompt: Text("Title").font(.title), axis: .vertical)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: -10, trailing: 0))
                .font(.title)

            Divider()
                .padding()

            TextField("", text: $viewModel.story, prompt: Text("Tell your story ...").font(.title2), axis: .vertical)
                .padding(EdgeInsets(top: -10, leading: 20, bottom: 0, trailing: 0))
                .font(.title3)

            Spacer()

            Button(action: {
                viewModel.saveDiaryEntry(userId: authenticationViewModel.getUserId())
            }, label: {
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
                Text("\(viewModel.diaryDate.getTitleDisplayDate())")
                    .foregroundStyle(Constants.Colors.backArrowTint)
            }
        }
    }
}

#Preview {
    DiaryEntryView()
        .environmentObject(DiaryEntryViewModel(title: "", story: "", diaryDate: Date.now, createdAtDate: Date.now, lastEditedAtDate: Date.now))
}
