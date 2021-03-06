//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
  @IBOutlet weak var profileImage : UIImageView!
  @IBOutlet weak var backgroundImage : UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
    self.profileImage.clipsToBounds = true
    self.profileImage.layer.borderWidth = 1
    self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
    self.profileImage.setRandomDownloadImage(80, height: 80)
    self.backgroundImage.setRandomDownloadImage(Int(self.frame.size.width), height: 160)
  }
}