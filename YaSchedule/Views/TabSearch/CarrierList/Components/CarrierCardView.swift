//
//  CarrierCardView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 17.10.2025.
//

import SwiftUI
import Kingfisher

struct CarrierCardView: View {
    let departureTime: String
    let arrivalTime: String
    let duration: Int
    let carrierImage: String?
    let carrierName: String
    let transferPoint: String?
    let tripDate: String
    let hasTransfers: Bool
    
    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top) {
                KFImage(URL(string: carrierImage ?? ""))
                    .placeholder {
                        Image(systemName: "wake.circle.fill")
                            .foregroundStyle(.mint)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading) {
                    Text(carrierName)
                        .font(.system(size: 17))
                        .foregroundStyle(.ypBlackUni)
                    if hasTransfers {
                        Text("С пересадкой хз где")
                            .font(.system(size: 12))
                            .foregroundStyle(.ypRed)
                    }
                }
                Spacer()
                Text(tripDate)
                    .font(.system(size: 12))
                    .foregroundStyle(.ypBlackUni)
            }
            HStack {
                Text(departureTime)
                    .font(.system(size: 17))
                    .foregroundStyle(.ypBlackUni)
                Rectangle().frame(height: 1).foregroundColor(.ypGrayUni)
                Text("\(duration) hours")
                    .font(.system(size: 12))
                    .foregroundStyle(.ypBlackUni)
                Rectangle().frame(height: 1).foregroundColor(.ypGrayUni)
                Text(arrivalTime)
                    .font(.system(size: 17))
                    .foregroundStyle(.ypBlackUni)
            }
        }
        .padding(14)
        .background(.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    CarrierCardView(
        departureTime: "22:30",
        arrivalTime: "08:15",
        duration: 20,
        carrierImage: "https://yastat.net/s3/rasp/media/data/company/logo/logorus_1.jpg",
        carrierName: "Аэрофлот",
        transferPoint: nil,
        tripDate: "14 января",
        hasTransfers: true
    )
}
