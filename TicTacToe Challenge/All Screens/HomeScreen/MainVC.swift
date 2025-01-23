//
//  ViewController.swift
//  TicTacToe Challenge
//
//  Created by Anmol Dhar on 23/01/25.
//

import UIKit

class MainVC: UIViewController {
    
    enum Turn {
        case CROSS
        case ZERO
    }

    @IBOutlet weak var currentTurnLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!

    var firstTurn = Turn.CROSS
    var currentTurn = Turn.CROSS
    
    var CROSS = "X"
    var ZERO = "O"
    
    var board = [UIButton]()
    
    var zeroScore = 0
    var crossScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        initBoard()
        
    }
    
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        
        board.append(b1)
        board.append(b2)
        board.append(b3)
        
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        addToBoard(sender)
        
        if checkForVictory(CROSS){
            crossScore += 1
            presentResultFromBottom(title: "Cross Win!")
        }
        
        if checkForVictory(ZERO){
            zeroScore += 1
            presentResultFromBottom(title: "Zero Win!")
        }
        
        if(fullBoard()){
            presentResultFromBottom(title: "Draw")
        }
        
    }
    
    func checkForVictory(_ s :String) -> Bool{
        // Horizontal Victory
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s){
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s){
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s){
            return true
        }
        
        // Vertical Victory
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s){
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s){
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s){
            return true
        }
        
        // Diagonal Victory
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s){
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s){
            return true
        }
        
        return false
    }
        
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool{
        return button.title(for: .normal) == symbol
    }
    
    func presentResultFromBottom(title: String) {
        let xibViewController = WinnerScreenVC(nibName: "WinnerScreenVC", bundle: nil)
        xibViewController.modalPresentationStyle = .overCurrentContext
        xibViewController.modalTransitionStyle = .coverVertical
        xibViewController.providesPresentationContextTransitionStyle = true
        xibViewController.definesPresentationContext = true
        xibViewController.isModalInPresentation = true
        
        xibViewController.scoreZero = "\(zeroScore)"
        xibViewController.scoreCross = "\(crossScore)"
        xibViewController.winnerText = title
        xibViewController.delegate = self

        present(xibViewController, animated: true, completion: nil)
    }
    
    func resetBoard() {
        
        for button in board{
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        
        if firstTurn == Turn.ZERO{
            firstTurn = Turn.CROSS
            currentTurnLabel.text = CROSS
        }
        else if firstTurn == Turn.CROSS{
            firstTurn = Turn.ZERO
            currentTurnLabel.text = ZERO
        }
        
        currentTurn = firstTurn
        
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if (button.title(for: .normal) == nil) {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil){
            
            if(currentTurn == Turn.ZERO){
                sender.setTitle(ZERO, for: .normal)
                currentTurn = Turn.CROSS
                currentTurnLabel.text = CROSS
            }
            else if(currentTurn == Turn.CROSS){
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.ZERO
                currentTurnLabel.text = ZERO
            }
            
            sender.isEnabled = false
            
        }
    }
    
}

extension MainVC: WinnerScreenDelegate {
    func didTapButtonOnWinnerScreen() {
        resetBoard()
    }
}
