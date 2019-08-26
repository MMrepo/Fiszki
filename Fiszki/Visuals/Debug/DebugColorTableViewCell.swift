//
//  DebugColorCellTableViewCell.swift
//  Visuals
//
//  Created by Mateusz Małek on 25.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import Foundation

class DebugColorTableViewCell: UITableViewCell, NibRegisterable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var color: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   public func configureWith(title: String, andColor color: UIColor) {
      self.title.text = "\(title):"
      self.color.backgroundColor = color
      self.color.layer.borderWidth = 1
      self.color.layer.borderColor = UIColor.black.cgColor
   }
}

private extension DebugColorTableViewCell {
    
    func setUpSubviews() {
        
    }
}

protocol NibRegisterable {
   static var identifier:String {get}
   static var nib:UINib {get}
}

extension NibRegisterable {
   public static var identifier:String {
      return String(describing: self)
   }
   
   public static var nib:UINib {
      print("identifier: \(identifier)")
      let t = Self.self as! AnyClass
      let bundle = Bundle(for: t)
      return UINib(nibName: identifier, bundle: bundle)
   }
}
