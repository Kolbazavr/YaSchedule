//
//  ContactsExtractor.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.10.2025.
//

import Foundation

struct ContactsExtractor {
    private let phonePatterns = [
        // +7 (495) 223-55-55, +7(495)223-55-55
        #"\+7\s?\(\d{3}\)\s?\d{3}-\d{2}-\d{2}"#,
        
        // +7 495 223 55 55, +7 495 223-55-55
        #"\+7\s?\d{3}\s?\d{3}[-\s]?\d{2}[-\s]?\d{2}"#,
        
        // 8 (495) 223-55-55, 8(495)223-55-55
        #"8\s?\(\d{3}\)\s?\d{3}-\d{2}-\d{2}"#,
        
        // 84952235555, 89501234567
        #"8\d{10}"#,
        
        // +74952235555, +79501234567
        #"\+7\d{10}"#,
        
        // Universal
        #"(\+7|8)[\s\-]?\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{2}[\s\-]?\d{2}"#,
        
        // 1234567 (TvExpress 2nd phone)
        #"\b\d{7}\b"#,
        
        // 123-4-567 (Rossia)
        #"\b\d{3}-\d{1}-\d{3}\b"#,
        
        // 8-800-XXX-XXX-X (Toll-free numbers?)
        #"8-800-\d{3}-\d{3}-\d{1}"#,
        
        // 8-wtf-number
        #"8[\s\-]?800[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d"#,
        
        // 8-even-more-wtf-number
        #"8[\s\-]?800[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{1}"#
    ]
    
    private let emailPattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
    
    func extractContacts(from text: String) -> (phones: [String], emails: [String]) {
        let cleanedText = text
            .replacingOccurrences(of: "<br>", with: " ")
            .replacingOccurrences(of: "\r\n", with: " ")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        let phones = extractPhones(from: cleanedText)
        let emails = extractEmails(from: cleanedText)
        return (phones, emails)
    }
    
    private func extractPhones(from text: String) -> [String] {
        guard !text.isEmpty else { return ["Не указан"] }
        
        var phones: [String] = []
        
        for pattern in phonePatterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern)
                let nsString = text as NSString
                let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
                for result in results {
                    let phone = nsString.substring(with: result.range)
                    let cleanedPhone = cleanPhoneNumber(phone)
                    if !phones.contains(cleanedPhone) { phones.append(cleanedPhone) }
                }
            } catch {
                print("Regex error with pattern \(pattern): \(error)")
            }
        }
        return phones.isEmpty ? ["Не указан"] : phones
    }
    
    private func extractEmails(from text: String) -> [String] {
        guard !text.isEmpty else { return ["Не указан"] }
        
        var emails: [String] = []
        
        do {
            let regex = try NSRegularExpression(pattern: emailPattern, options: [.caseInsensitive])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for result in results {
                let email = nsString.substring(with: result.range)
                if !emails.contains(email) {
                    emails.append(email)
                }
            }
        } catch {
            print("Email regex error: \(error)")
        }
        
        return emails.isEmpty ? ["Не указан"] : emails
    }
    
    func cleanPhoneNumber(_ phone: String) -> String {
        guard !phone.isEmpty else { return "" }
        var cleaned = phone
        cleaned = phone.replacingOccurrences(of: #"[\D]"#, with: "", options: .regularExpression)
        if cleaned.count == 7 { cleaned = "+7495" + cleaned }
        if cleaned.hasPrefix("+7") && cleaned.count == 12 { return cleaned }
        cleaned = phone.replacingOccurrences(of: #"[^\d+]"#, with: "", options: .regularExpression)

        if cleaned.hasPrefix("8") {
            if cleaned.hasPrefix("8800") && cleaned.count == 11 { return cleaned }
            else if cleaned.count == 11 { cleaned = "+7" + String(cleaned.dropFirst()) }
        } else if cleaned.hasPrefix("7") && cleaned.count == 11 {
            cleaned = "+" + cleaned
        }
        return cleaned
    }
}

struct PatternTester {
    func test() {
        let extractor = ContactsExtractor()
        
        let testCases = [
            // +7 formats
            "+7 (495) 223-55-55",
            "+7(495)223-55-55",
            "+7 495 223-55-55",
            "+7 495 223 55 55",
            "+74952235555",
            
            // 8 formats
            "8 (495) 223-55-55",
            "8(495)223-55-55",
            "8 495 223-55-55",
            "8 495 223 55 55",
            "84952235555",
            
            // Mixed formats
            "+7 (495) 2235555",
            "8 (495) 2235555",
            "+7-495-223-55-55",
            "8-495-223-55-55",
            
            // Short
            "1234567",
            "123-4-567"
        ]
        
        for testCase in testCases {
            print("Testing: \(testCase)")
            let contacts = extractor.extractContacts(from: testCase)
            print("Contacts: \(contacts)")
            print("---")
        }
    }
}
