//
//  TokenEditForm.swift
//  Authenticator
//
//  Created by Matt Rubin on 8/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//


class TokenEditForm: NSObject, TokenForm {
    weak var delegate: TokenFormDelegate?

    lazy var issuerCell: OTPTextFieldCell = {
        return OTPTextFieldCell.issuerCellWithDelegate(self)
    }()
    lazy var accountNameCell: OTPTextFieldCell = {
        OTPTextFieldCell.nameCellWithDelegate(self, returnKeyType: .Done)
    }()

    var issuer: String? {
        get { return issuerCell.textField.text }
        set { issuerCell.textField.text = newValue }
    }
    var accountName: String? {
        get { return accountNameCell.textField.text }
        set { accountNameCell.textField.text = newValue }
    }

    var cells: [[UITableViewCell]] {
        return [
            [
                issuerCell,
                accountNameCell,
            ]
        ]
    }

    func focusFirstField() {
        self.issuerCell.textField.becomeFirstResponder()
    }

    var numberOfSections: Int {
        return cells.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if section < cells.startIndex { return 0 }
        if section >= cells.endIndex { return 0 }
        return cells[section].count
    }

    func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        if indexPath.section < cells.startIndex { return nil }
        if indexPath.section >= cells.endIndex { return nil }
        let sectionCells = cells[indexPath.section]
        if indexPath.row < sectionCells.startIndex { return nil }
        if indexPath.row >= sectionCells.endIndex { return nil }
        return sectionCells[indexPath.row]
    }

    var isValid: Bool {
        return !issuerCell.textField.text.isEmpty ||
            !accountNameCell.textField.text.isEmpty
    }
}

extension TokenEditForm: OTPTextFieldCellDelegate {
    func textFieldCellDidChange(textFieldCell: OTPTextFieldCell) {
        delegate?.formValuesDidChange(self)
    }

    func textFieldCellDidReturn(textFieldCell: OTPTextFieldCell) {
        if textFieldCell == issuerCell {
            accountNameCell.textField.becomeFirstResponder()
        } else if textFieldCell == accountNameCell {
            accountNameCell.textField.resignFirstResponder()
            delegate?.formDidSubmit(self)
        }
    }
}