//
//  SearchBarView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let textLimit: Int
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .padding([.leading, .top, .bottom], 7)
            TextField("Enter city name", text: $searchText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.system(size: 17))
                .onChange(of: searchText) { oldText, newText in
                    newText.count > textLimit ? searchText = oldText : ()
                }
            Button {
                UIApplication.shared.endEditing()
                searchText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .padding(7)
            }
            .tint(.secondary)
            .disabled(searchText.isEmpty)
            .opacity(searchText.isEmpty ? 0 : 1)
            

        }
        .padding(.vertical, 7)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    SearchBarView(searchText: .constant(""), textLimit: 20)
}

