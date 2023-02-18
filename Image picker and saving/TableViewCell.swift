//
//  TableViewCell.swift
//  Image picker and saving
//
//  Created by Mac on 12.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    var pictureName: UILabel = {
      let lbl = UILabel(frame: CGRect(x: 165, y: 40,
                                      width: 130,
                                      height: 40))
       lbl.text = ""
       lbl.backgroundColor = .white
       lbl.font = UIFont.systemFont(ofSize: 18)
       return lbl
   }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
