//
//  CustomTextField.swift
//  PlaceFinder
//
//  Created by Abdul on 5/4/16.
//  Copyright © 2016 Virtual Employee Pvt Ltd. All rights reserved.
//

class CustomTextField: UITextField {

    @IBInspectable var placeholderColor: UIColor = UIColor.white {
        didSet {
            let canEditPlaceholderColor = self.responds(to: #selector(setter: UITextField.attributedPlaceholder))
            
            if (canEditPlaceholderColor) {
                self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): placeholderColor]))
            }
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
