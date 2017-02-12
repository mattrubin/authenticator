//
//  TokenScanner.swift
//  Authenticator
//
//  Copyright (c) 2017 Authenticator authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import OneTimePassword

struct TokenScanner: Component {
    private var tokenFound: Bool

    // MARK: Initialization

    init() {
        tokenFound = false
    }

    // MARK: View

    struct ViewModel {
        var isScanning: Bool
    }

    var viewModel: ViewModel {
        return ViewModel(isScanning: !tokenFound)
    }

    // MARK: Update

    enum Action {
        case Cancel
        case BeginManualTokenEntry
        case ScannerDecodedText(String)
        case ScannerError(ErrorType)
    }

    enum Effect {
        case Cancel
        case BeginManualTokenEntry
        case SaveNewToken(Token)
        case ShowErrorMessage(String)
    }

    mutating func update(action: Action) -> Effect? {
        switch action {
        case .Cancel:
            return .Cancel

        case .BeginManualTokenEntry:
            return .BeginManualTokenEntry

        case .ScannerDecodedText(let text):
            // Attempt to create a token from the decoded text
            guard let url = NSURL(string: text),
                let token = Token(url: url) else {
                    // Show an error message
                    return .ShowErrorMessage("Invalid Token")
            }
            tokenFound = true
            return .SaveNewToken(token)

        case .ScannerError(let error):
            print("Error: \(error)")
            return .ShowErrorMessage("Capture Failed")
        }
    }
}