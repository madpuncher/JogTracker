import UIKit

typealias VoidClosure = (() -> ())

enum AlertFactory {
    
    static func createAlert(with descriptor: AlertDescriptor) -> UIAlertController {
        
        let viewController = UIAlertController(title: descriptor.title,
                                               message: descriptor.message,
                                               preferredStyle: descriptor.style)

        descriptor.actions.forEach { action in
            
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.closure?()
            }

            viewController.addAction(alertAction)
        }

        return viewController
    }
}

extension AlertFactory {
    
    struct AlertDescriptor {
        
        public let title: String?
        public let message: String?
        public let style: UIAlertController.Style
        public let actions: [AlertAction]

        public init(title: String? = nil,
                    message: String? = nil,
                    style: UIAlertController.Style = .alert,
                    actions: [AlertAction] = []) {

            self.title = title
            self.message = message
            self.style = style
            self.actions = actions
        }
    }

    final class AlertAction {
        
        let title: String
        let style: UIAlertAction.Style
        let closure: VoidClosure?

        public init(title: String,
                    style: UIAlertAction.Style = .default,
                    closure: VoidClosure? = nil) {

            self.title = title
            self.style = style
            self.closure = closure
        }
    }
}

