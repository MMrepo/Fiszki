//
//  DebugFontTableViewCell.swift
//  Visuals
//
//  Created by Mateusz Małek on 25.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

class DebugFontTableViewCell: UITableViewCell, NibRegisterable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fontSet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   public func configureWith(title: String, fontName: String, andSize fontSize: CGFloat) {
      let titlePrefix = "UICTFontTextStyle"
      let titleToDisplay = title.hasPrefix(titlePrefix) ? String(title.dropFirst(titlePrefix.count)) : title

      let font = "\(fontName), \(fontSize) pt"
      self.title.text = "\(titleToDisplay):"
      self.fontSet.setTitle(font, for: .normal)
   }
}
