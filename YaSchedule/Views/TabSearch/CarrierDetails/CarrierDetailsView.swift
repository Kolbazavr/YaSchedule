//
//  CarrierDetailsView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 20.10.2025.
//

import SwiftUI
import Kingfisher

struct CarrierDetailsView: View {
    @StateObject private var vm = CarrierDetailsVM()
    
    let carrier: Components.Schemas.Carrier
    private let contactsExtractor: ContactsExtractor = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            KFImage(URL(string: carrier.logo ?? ""))
                .placeholder {
                    Image(systemName: "wake.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.mint)
                        
                }
                .resizable()
                .scaledToFit()
                .padding(8)
                .background(.ypWhiteUni)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity, maxHeight: 104, alignment: .center)
                .padding(16)
            
            Text(carrier.title?.uppercased() ?? "Carrier")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.ypBlack)

            emailSection()
                .frame(minHeight: 60)
            phoneSection()
                .frame(minHeight: 60)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .onAppear {
            vm.extractContacts(from: carrier)
        }
    }
    
    @ViewBuilder
    private func emailSection() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("E-mail")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.ypBlack)
            ForEach(vm.carrierEmails, id: \.self) { email in
                Button {
                    if let url = URL(string:"mailto:\(email)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(email)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlue)
                }
                .padding(.bottom, vm.carrierEmails.last == email ? 0 : 8)
            }
        }
    }
    
    @ViewBuilder
    private func phoneSection() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Телефон")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.ypBlack)
            ForEach(vm.carrierPhones, id: \.self) { phone in
                Button {
                    let cleanedPhone = "tel://\(contactsExtractor.cleanPhoneNumber(phone))"
                    guard let url = URL(string: cleanedPhone) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Text(phone)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlue)
                }
                .padding(.bottom, vm.carrierPhones.last == phone ? 0 : 8)
            }
        }
    }
}

#Preview {
    CarrierDetailsView(
        carrier: .init(
            code: 26,
            contacts: "Центр информации и бронирования: 647-0-647 +7 (495) 223-55-55,  +7 (800) 444-55-55, 8-800-200-000-7, 9880447, (495) 3644111. <br>\r\ne-mail: callcenter@aeroflot.ru",
            url: "http://www.aeroflot.ru/",
            title: "Аэрофлот",
            phone: "",
            address: "Москва, Ленинградский пр., д.37, корп.9",
            logo: "https://yastat.net/s3/rasp/media/data/company/logo/aeroflot_logo_ru.gif",
            email: "info@rzd.ru",
            codes: nil
        )
    )
}
