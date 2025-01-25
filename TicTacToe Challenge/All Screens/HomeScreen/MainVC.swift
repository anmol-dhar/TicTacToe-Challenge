//
//  ViewController.swift
//  TicTacToe Challenge
//
//  Created by Anmol Dhar on 23/01/25.
//

import UIKit
import ICConfetti
import AVFoundation

class MainVC: UIViewController {
    
    enum Turn {
        case CROSS
        case ZERO
    }
    
    var icConfetti: ICConfetti!
    var audioPlayer: AVAudioPlayer?
    var winningLine: UIView?

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
            return
        }
        
        if checkForVictory(ZERO){
            zeroScore += 1
            return
        }
        
        if(fullBoard()){
            playDrawSound()
            presentResultFromBottom(title: "Draw")
        }
        
    }
    
    func checkForVictory(_ s: String) -> Bool {
        // Horizontal Victory
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) {
            drawWinningLine(from: a1, to: a3) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) {
            drawWinningLine(from: b1, to: b3) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) {
            drawWinningLine(from: c1, to: c3) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }

        // Vertical Victory
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) {
            drawWinningLine(from: a1, to: c1) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) {
            drawWinningLine(from: a2, to: c2) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) {
            drawWinningLine(from: a3, to: c3) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }

        // Diagonal Victory
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) {
            drawWinningLine(from: a1, to: c3) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) {
            drawWinningLine(from: a3, to: c1) {
                self.presentResultFromBottom(title: "\(s) Wins!")
            }
            playWinSound()
            startRaining()
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
        
        stopRaining()
        winningLine?.removeFromSuperview()
        
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
    
    func drawWinningLine(from startButton: UIButton, to endButton: UIButton, completion: @escaping () -> Void) {
        // Remove any existing line
        winningLine?.removeFromSuperview()

        // Calculate the starting and ending points in the view's coordinate system
        let startPoint = view.convert(startButton.center, from: startButton.superview)
        let endPoint = view.convert(endButton.center, from: endButton.superview)

        // Create the line as a UIView
        let line = UIView()
        line.backgroundColor = .red // You can change the color as needed
        view.addSubview(line)

        // Calculate the line's initial frame (width 0 for animation)
        let lineWidth: CGFloat = 5.0 // Thickness of the line
        line.frame = CGRect(x: startPoint.x, y: startPoint.y, width: 0, height: lineWidth)
        line.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5) // Set anchor point for scaling
        line.center = startPoint

        // Rotate the line to the target angle
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        line.transform = CGAffineTransform(rotationAngle: angle)

        // Save the line reference for future removal
        winningLine = line

        // Animate the line drawing
        UIView.animate(withDuration: 0.5, animations: {
            let distance = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
            line.bounds.size.width = distance
        }, completion: { _ in
            completion() // Call the completion handler after the animation
        })
    }
    
    func startRaining() {
        icConfetti = ICConfetti()
        icConfetti.colors = [.red, .green, .yellow, .blue]
        icConfetti.velocities = [100, 128, 144, 512]
        icConfetti.rain(in: self.view)
    }
    
    func stopRaining() {
        
        if let confetti = icConfetti {
            confetti.stopRaining()
        }
    
    }
    
    func playWinSound() {
        if let soundURL = Bundle.main.url(forResource: "win_sound", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
    func playDrawSound() {
        if let soundURL = Bundle.main.url(forResource: "draw_sound", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
}

extension MainVC: WinnerScreenDelegate {
    func didTapButtonOnWinnerScreen() {
        resetBoard()
    }
}
