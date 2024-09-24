//
//  CustomAnimation.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-24.
//

import UIKit

class CustomAnimation: UIView {
    var dialogTitle: NSString = "Item Added"
    var dialogFillColour = UIColor.green
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = 100
        let height: CGFloat = 150
        
        let viewRect = CGRect(x: round(bounds.size.width - width) / 2, y: round(bounds.size.height - height) / 2, width: width, height: height)
        let insideRect = UIBezierPath(roundedRect: viewRect, cornerRadius: 5)
        dialogFillColour.setFill()
        insideRect.fill()
        
        guard let image = UIImage(systemName: "movieclapper")?.withTintColor(.black) else { return }
        image.draw(in: CGRect(x: center.x - 15, y: center.y - 30, width: 30, height: 30))
        
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        
        let textSize = dialogTitle.size(withAttributes: attributes)
        let textPoint = CGPoint(x: center.x - (textSize.width/2), y: center.y - (textSize.height/2) + height / 4)
        
        dialogTitle.draw(at: textPoint, withAttributes: attributes)
    }
    
    func showDialog(){
        alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0.8,
                       options: .transitionCrossDissolve, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
    }
}
