import Foundation

extension String {
    var firstLetterCapitalized: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}
