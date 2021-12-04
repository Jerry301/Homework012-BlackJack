//
//  ViewController.swift
//  Homework012
//
//  Created by Chun-Yi Lin on 2021/11/30.
//

import UIKit
import GameplayKit


class ViewController: UIViewController {
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var oneDallorButton: UIButton!
    @IBOutlet weak var tenDollarButton: UIButton!
    @IBOutlet weak var hundredDollarButton: UIButton!
    @IBOutlet weak var chipLabel: UILabel!
    
    @IBOutlet var playerCardImageView: [UIImageView]!
    @IBOutlet var bankerCardImageView: [UIImageView]!
    
    @IBOutlet weak var bankerSegment: UISegmentedControl!
    
    @IBOutlet weak var bankerPointLabel: UILabel!
    @IBOutlet weak var playerPointLabel: UILabel!
    @IBOutlet weak var playerHoldCardButton: UIButton!
    @IBOutlet weak var cardDeskView: UIView!
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    @IBOutlet weak var startLabel: UILabel!
    
    
    var playerCloseCard = ""
    var bankerCloseCard = ""
    var playerOpenCard = ""
    var bankerOpenCard = ""
    
    var pCards = [String]()
    var bCards = [String]()
    
    let distrubution = GKShuffledDistribution(lowestValue: 0, highestValue: cards.count - 1)
    
    var bankerPoint : Int = 0
    var playerPoint : Int = 0
    
    var bankerTotalPoint : Int = 0
    
    var chip : Int = 1000
    
    var bet : Int = 100
    
    var playerAceCount : Int = 0
    var bankerAceCount : Int = 0
    
    var playHitCount : Int = 2
    
    var superNumber : [Int]?
    var superNumberRandom : Int?
    var whoIsBankerNumber : Int?
    var gambleGod : Int?
    var generalman : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardDeskView.layer.borderColor = CGColor(red: 1, green: 0.9, blue: 0.5, alpha: 1)
        cardDeskView.layer.borderWidth = 3
        cardDeskView.layer.cornerRadius = 5
        hitButton.isHidden = true
        standButton.isHidden = true
        dealButton.isHidden = true
                
    }
    
    @IBAction func closeCardClicked(_ sender: UIButton) {
        playerCardImageView[0].isHighlighted = false
        UIView.transition(with: playerCardImageView[0], duration: 0.2, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        if playerPoint == 21 && pCards.count == 2 {
            hitButton.isEnabled = false
        }
    }
    
    @IBAction func seeCardClicked(_ sender: UIButton) {
        playerCardImageView[0].isHighlighted = true
        playerPointLabel.isHidden = false
        UIView.transition(with: playerCardImageView[0], duration: 0.2, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        hitButton.isEnabled = true
        if playerPoint >= 15 {
            standButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func dealButtonClicked(_ sender: UIButton) {
        
        hitButton.isHidden = false
        standButton.isHidden = false
        oneDallorButton.isHidden = true
        tenDollarButton.isHidden = true
        hundredDollarButton.isHidden = true
                
        if chip >= bet {
            bankerCloseCard = cards[whoIsBankerNumber!]
            playerCloseCard = cards[distrubution.nextInt()]
            playerOpenCard = cards[distrubution.nextInt()]
            bankerOpenCard = cards[distrubution.nextInt()]
            
            pCards += ["\(playerCloseCard)", "\(playerOpenCard)"]
            bCards += ["\(bankerCloseCard)", "\(bankerOpenCard)"]
            
            bankerCardImageView[0].isHidden = false
            playerCardImageView[0].image = UIImage(named: "Image")
            playerCardImageView[0].highlightedImage = UIImage(named: playerCloseCard)
            playerCardImageView[0].isHidden = false
            playerCardImageView[1].image = UIImage(named: playerOpenCard)
            playerCardImageView[1].isHidden = false
            bankerCardImageView[1].image = UIImage(named: bankerOpenCard)
            bankerCardImageView[1].isHidden = false
            
            playerPoint += pointCount(card: playerOpenCard)
            playerPoint += pointCount(card: playerCloseCard)
            if (playerOpenCard.contains("A") || playerCloseCard.contains("A")) && playerPoint > 21 {
                playerPoint -= 10
            }
            
            playerPointLabel.text = "\(playerPoint)"
            
            bankerPoint += pointCount(card: bankerOpenCard)
            bankerPointLabel.text = "\(bankerPoint)"
            bankerPointLabel.isHidden = false
            
            dealButton.isEnabled = false
            playerHoldCardButton.isEnabled = true
//            oneDallorButton.isEnabled = true
//            tenDollarButton.isEnabled = true
//            hundredDollarButton.isEnabled = true
            bankerTotalPoint = bankerPoint + pointCount(card: bankerCloseCard)
            if (bankerOpenCard.contains("A") || bankerCloseCard.contains("A")) && bankerTotalPoint > 21 {
                playerPoint -= 10
            }
            
            for pCard in pCards {
                if pCard.contains("A") {
                    playerAceCount += 1
                }
            }
            for bCard in bCards {
                if bCard.contains("A"){
                    bankerAceCount += 1
                }
            }
        }
//        else{
//            loseMessageAlert()
//        }
        
    }
    
    @IBAction func hitButtonClicked(_ sender: UIButton) {
        var addCard = ""
        addCard = cards[distrubution.nextInt()]
        playerCardImageView[playHitCount].isHidden = false
        playerCardImageView[playHitCount].image = UIImage(named: addCard)
        UIView.transition(with: playerCardImageView[playHitCount], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
        pCards += ["\(addCard)"]
        
        if addCard.contains("A"){
            playerAceCount += 1
        }
        
        playerPoint += pointCount(card: addCard)
        for pCard in pCards {
            if pCard.contains("A") && playerPoint > 21 {
                playerPoint -= 10
                pCards = pCards.filter({(card : String) -> Bool in return !card.contains("A")})
            }
        }
        if addCard.contains("A") && playerAceCount >= 2 {
            pCards += ["\(addCard)"]
        }
        
        playerPointLabel.text = "\(playerPoint)"
        
        if playerPoint >= 15 {
            dealButton.isEnabled = true
        }
        
        if playerPoint == 21 {
            hitButton.isEnabled = false
        }
        
        playHitCount += 1
        
       if (playHitCount == 5 && playerPoint <= 21) && (bankerPoint == 21) {
            loseMessageAlert()
        }else if playerPoint > 21 {
            loseMessageAlert()
        }
    }
    
    @IBAction func standButtonClicked(_ sender: UIButton) {
        
        playerCardImageView[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCardImageView[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerCardImageView[0].image = UIImage(named: bankerCloseCard)
        UIView.transition(with: bankerCardImageView[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerPointLabel.text = "\(bankerTotalPoint)"
        
        playHitCount = 2
        var bankerAddCard = ""
        while (bankerTotalPoint < 17 && playHitCount < 6) || (bankerTotalPoint == 17 && bCards.contains("A") && playHitCount == 2){
            bankerAddCard = cards[distrubution.nextInt()]
            bankerCardImageView[playHitCount].isHidden = false
            bankerCardImageView[playHitCount].image = UIImage(named: bankerAddCard)
            UIView.transition(with: bankerCardImageView[playHitCount], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
            bCards += ["\(bankerAddCard)"]
            
            if bankerAddCard.contains("A"){
                bankerAceCount += 1
            }
            
            bankerTotalPoint += pointCount(card: bankerAddCard)
            for bCard in bCards {
                if bCard.contains("A") && bankerTotalPoint > 21 {
                    bankerTotalPoint -= 10
                    bCards = bCards.filter({(card : String) -> Bool in return !card.contains("A")})
                }
            }
            if bankerAddCard.contains("A") && bankerAceCount >= 2 {
                bCards += ["\(bankerAddCard)"]
            }
            
            bankerPointLabel.text = "\(bankerTotalPoint)"
            playHitCount += 1
        }
        if bankerTotalPoint == 21 && bCards.count == 2 {
            bankerPointLabel.text = "\(bankerTotalPoint)"
            loseMessageAlert()
        }else if playerPoint == 21 && pCards.count <= 2{
            winMessageAlert()
        }else if bankerTotalPoint > 21 || playerPoint > bankerTotalPoint {
            winMessageAlert()
        }else if bankerTotalPoint > playerPoint {
            loseMessageAlert()
        }else if bankerTotalPoint == playerPoint {
            tieMessageAlert()
        }
        
    }
    
    func loseMessageAlert(){
        playerCardImageView[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCardImageView[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let alert = UIAlertController(title: "YOU LOSE", message: "Your point is \(playerPoint)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Next round", style: .default, handler: {
            action in
            self.chip -= self.bet
            self.chipLabel.text = "$ \(self.chip)"
            self.nextRound()
            if self.chip == 0 {
                let loseAllMoneyAlert = UIAlertController(title: "OMG", message: "You lose all MONEY", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default, handler: {
                    action in
                    self.chip = 1000
                    self.chipLabel.text = "$ \(self.chip)"
                })
                loseAllMoneyAlert.addAction(action)
                self.show(loseAllMoneyAlert, sender: nil)
            }
        })
        alert.addAction(action)
        show(alert, sender: nil)
    }
    
    func winMessageAlert () {
        let alert = UIAlertController(title: "YOU WIN", message: "Your point is \(playerPoint) and Banker's point is \(bankerTotalPoint)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Next round", style: .default, handler: {
            action in
            self.chip += self.bet
            self.chipLabel.text = "$ \(self.chip)"
            self.nextRound()
        })
        alert.addAction(action)
        show(alert, sender: nil)
    }
    
    func tieMessageAlert () {
        let alert = UIAlertController(title: "TIE", message: "Your point is \(playerPoint) and Banker's point is \(bankerTotalPoint)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Next round", style: .default, handler: {
            action in
            self.nextRound()
        })
        alert.addAction(action)
        show(alert, sender: nil)
    }
    
    @IBAction func oneDollarAdded(_ sender: UIButton) {
        if (chip - bet) >= 1 {
            bet += 1
            betLabel.text = "\(bet)"
        }else {
            bet += 0
        }
    }
    @IBAction func tenDollarAdded(_ sender: UIButton) {
        if (chip - bet) >= 10  {
            bet += 10
            betLabel.text = "\(bet)"
        }else {
            bet += 0
        }
    }
    @IBAction func hundredDollarAdded(_ sender: UIButton) {
        if (chip - bet) >= 100  {
            bet += 100
            betLabel.text = "\(bet)"
        }else {
            bet += 0
        }
    }
    
    func nextRound () {
        playerCardImageView[0].isHidden = true
        playerCardImageView[1].isHidden = true
        playerCardImageView[2].isHidden = true
        playerCardImageView[3].isHidden = true
        playerCardImageView[4].isHidden = true

        bankerCardImageView[0].isHidden = true
        bankerCardImageView[1].isHidden = true
        bankerCardImageView[2].isHidden = true
        bankerCardImageView[3].isHidden = true
        bankerCardImageView[4].isHidden = true
        
        bankerCardImageView[0].image = UIImage(named: "Image")
        
        bankerPoint = 0
        bankerTotalPoint = 0
        playerPoint = 0
        bankerPointLabel.text = "0"
        playerPointLabel.text = "0"
        bankerPointLabel.isHidden = true
        playerPointLabel.isHidden = true
        pCards.removeAll()
        bCards.removeAll()
        
        dealButton.isEnabled = true
        hitButton.isEnabled = false
        standButton.isEnabled = false
        playerHoldCardButton.isEnabled = false
        
        playerCloseCard = ""
        playerOpenCard = ""
        bankerCloseCard = ""
        bankerOpenCard = ""
        playHitCount = 2
        playerAceCount = 0
        bankerAceCount = 0
        
        bet = 100
        betLabel.text = "\(bet)"
        oneDallorButton.isHidden = false
        tenDollarButton.isHidden = false
        hundredDollarButton.isHidden = false
    }
    
    func pointCount (card: String) -> Int{
        var point = 0
        if card.contains("A") {
            point = 11
        }else if card.contains("2") {
            point = 2
        }else if card.contains("3") {
            point = 3
        }else if card.contains("4") {
            point = 4
        }else if card.contains("5") {
            point = 5
        }else if card.contains("6") {
            point = 6
        }else if card.contains("7") {
            point = 7
        }else if card.contains("8") {
            point = 8
        }else if card.contains("9") {
            point = 9
        }else if card.contains("10") {
            point = 10
        }else if card.contains("J") {
            point = 10
        }else if card.contains("Q") {
            point = 10
        }else if card.contains("K") {
            point = 10
        }
        return point
    }
    @IBAction func bankerChangeSegment(_ sender: UISegmentedControl) {
        startLabel.isHidden = true
        dealButton.isHidden = false
        
        whoIsBankerNumber = sender.selectedSegmentIndex
        
        superNumber = [0, 13, 26, 39]
        superNumberRandom = Int.random(in: 0...3)
        
        gambleGod = self.superNumber![self.superNumberRandom!]
        generalman = distrubution.nextInt()
        
        switch whoIsBankerNumber {
        case 0: gambleGod
        case 1: generalman
        default: break
        }
    }
    
    
}
