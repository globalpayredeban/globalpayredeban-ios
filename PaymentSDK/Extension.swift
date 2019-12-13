//
//  Extension.swift
//  paymentSDK
//
//  Created by Gustavo Sotelo on 05/09/17.
//  
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: PaymentCard.self), value: "", comment: "")
    }
}

