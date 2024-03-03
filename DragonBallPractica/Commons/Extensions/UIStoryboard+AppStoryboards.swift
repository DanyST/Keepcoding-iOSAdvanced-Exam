import UIKit

extension UIStoryboard {
    
    /// The uniform place where we state all the storyboard we have in our application
    enum AppStoryboard: String {
        case splash
        case login
        case heroes
        case heroDetail
        
        var filename: String {
            return rawValue.firstLetterCapitalized
        }
    }
    
    
    // MARK: - Convenience Initializers
    convenience init(storyboard: AppStoryboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    
    // MARK: - Class Functions
    class func storyboard(_ storyboard: AppStoryboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
}

