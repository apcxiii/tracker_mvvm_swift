//
//  RouteCell.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
      super.awakeFromNib()
      self.contentView.backgroundColor = .systemGray
      
      self.nameLabel.font = .boldSystemFont(ofSize: 22)
      self.nameLabel.textColor = .white
      
      self.timestampLabel.font = .systemFont(ofSize: 18)
      self.timestampLabel.textColor = .white
      
      self.distanceLabel.font = .systemFont(ofSize: 18)
      self.distanceLabel.textColor = .white      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      if selected {
        backgroundColor = .darkGray
      } else {
        backgroundColor = .systemGray
      }
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
      super.setHighlighted(highlighted, animated: animated)
      if highlighted {
        backgroundColor = .darkGray
      } else {
        backgroundColor = .systemGray
      }
    }
  
  func configure(withModel viewModel: RouteRepresentable){
    self.nameLabel.text = viewModel.name
    self.distanceLabel.text = viewModel.distance
    self.timestampLabel.text = viewModel.timestamp
  }
    
}
