import Foundation
import UIKit



extension UIView {
    func applyCardStyle(cornerRadius: CGFloat = 20, corners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], shadow: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = corners
        self.clipsToBounds = true
        if shadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 5)
            self.layer.masksToBounds = false
        }
        
    }
    
    func pinToTop(of parent: UIView) {
            self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0),
        ])
    }
    
    func tableViewConstraints(for vc:UIView, from navbar: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 25),
            self.leadingAnchor.constraint(equalTo: vc.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: vc.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: vc.bottomAnchor)
        ])
    }
}

