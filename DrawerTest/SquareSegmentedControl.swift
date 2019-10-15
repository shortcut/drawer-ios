//
//  SquareSegmentedControl.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class SquareSegmentedControl: UISegmentedControl {
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 0
  }
}
