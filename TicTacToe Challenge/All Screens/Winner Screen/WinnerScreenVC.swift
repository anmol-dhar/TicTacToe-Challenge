//
//  WinnerScreenVC.swift
//  TicTacToe Challenge
//
//  Created by Anmol Dhar on 23/01/25.
//

import UIKit


protocol WinnerScreenDelegate: AnyObject {
    func didTapButtonOnWinnerScreen()
}

class WinnerScreenVC: UIViewController {
    
    weak var delegate: WinnerScreenDelegate?
    
    var scoreZero: String?
    var scoreCross: String?
    var winnerText: String?
    
    @IBOutlet weak var WinnerText: UILabel!
    @IBOutlet weak var ZeroScore: UILabel!
    @IBOutlet weak var CrossScore: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var continueBtnRef: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.roundCorner()
        continueBtnRef.roundCorner()
        
        ZeroScore.text = scoreZero
        CrossScore.text = scoreCross
        WinnerText.text = winnerText
        
    }

    @IBAction func continueBtn(_ sender: UIButton) {
        delegate?.didTapButtonOnWinnerScreen()
        dismiss(animated: true, completion: nil)
    }
}
