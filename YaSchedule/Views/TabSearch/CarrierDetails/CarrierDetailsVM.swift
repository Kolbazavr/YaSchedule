//
//  CarrierDetailsVM.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 14.11.2025.
//

import Foundation

@MainActor
final class CarrierDetailsVM: ObservableObject {
    @Published var carrierPhones: [String] = []
    @Published var carrierEmails: [String] = []
    
    private let contactsExtractor = ContactsExtractor()
    
    func extractContacts(from carrier: Components.Schemas.Carrier) {
        let phoneFromPhoneField = carrier.phone ?? ""
        let emailFromEmailField = carrier.email ?? ""
        
        if emailFromEmailField.isEmpty || phoneFromPhoneField.isEmpty {
            let (phones, emails) = contactsExtractor.extractContacts(from: carrier.contacts ?? "")
            carrierPhones = phoneFromPhoneField.isEmpty ? phones : [phoneFromPhoneField]
            carrierEmails = emailFromEmailField.isEmpty ? emails : [emailFromEmailField]
        } else {
            carrierPhones = [phoneFromPhoneField]
            carrierEmails = [emailFromEmailField]
        }
    }
}
