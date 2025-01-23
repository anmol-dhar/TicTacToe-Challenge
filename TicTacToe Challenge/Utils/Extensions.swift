//
//  Extensions.swift
//  TicTacToe Challenge
//
//  Created by Anmol Dhar on 23/01/25.
//

import Foundation
import UIKit

extension UIView{
    func roundCorner(){
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}
