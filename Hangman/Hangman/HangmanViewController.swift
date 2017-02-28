//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    // Declaration of all vars used in the class.
    var phraseLength: Int?
    var correctPos: [Bool]?
    var phraseAsArray: [Character]?
    var wrongGuesses = Set<String>()
    var allLetters = Set<String>()
    var wrongTimes = 1
    var phrase: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase) // delete later
        phraseAsArray = [Character](phrase!.characters)
        phraseLength = phrase?.characters.count
        correctPos = [Bool](repeating: false, count: phraseLength!)
        HangmanImage.image = UIImage(named: "hangman1.gif")
        for letter in phraseAsArray! {
            allLetters.insert(String(letter)) // Initialize the set of all letters with legal bag of letters.
        }
        for index in 0...phraseLength!-1 {
            if (String(phraseAsArray![index]) == " ") {
                correctPos![index] = true // when a space occurs, does not need '_'
            }
        }
        displayGuess()
    }
    
    // Update the display of the wordCorrespondance label on the guessBox.
    func displayGuess() {
        wordCorrespondance.text = ""
        for index in 0...phraseLength!-1 {
            if correctPos![index] {
                wordCorrespondance.text?.append(String(phraseAsArray![index]) + " ")
            } else {
                wordCorrespondance.text = wordCorrespondance.text! + "_ "
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The outlet connections to the storyboard.
    @IBOutlet weak var wordCorrespondance: UILabel!
    @IBOutlet weak var GuessButton: UIButton! // Needs action.
    @IBOutlet weak var wrongGuessList: UILabel!
    @IBOutlet weak var letterGuessing: UITextField! // Capitalization enabled.
    @IBOutlet weak var HangmanImage: UIImageView!
    @IBOutlet weak var alertSingelChar: UILabel!
    
    // The action connections to the guess button and the textfield.
    @IBAction func makeGuess(_ sender: UIButton) {
//        wordCorrespondance.text = "worked"
        let guess = letterGuessing.text
        
        if guess!.characters.count == 1 {
            alertSingelChar.text = ""
            
            if (allLetters.contains(guess!)) {
                
                for index in 0...phraseLength!-1 {
                    if guess == String(phraseAsArray![index]) {
                        correctPos![index] = true
                    }
                }
                if (HangmanPhrases().testWin(_positions: correctPos!)) {
                    let alertController = UIAlertController(
                        title: "You Won!",
                        message: "Start a new game?",
                        preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default) {
                        action in self.reset()})
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else {
                if !wrongGuesses.contains(String(guess!)) {
                    wrongGuesses.insert(String(guess!))
                    wrongTimes += 1
                    let imageName = "hangman" + String(wrongTimes) + ".gif"
                    HangmanImage.image = UIImage(named: imageName)
                    if wrongTimes > 6 {
                        let alertController = UIAlertController(
                            title: "Game Over",
                            message: "Start a new game?",
                            preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default) {
                            action in self.reset()})
                        self.present(alertController, animated: true, completion: nil)
                    }
                    wrongGuessList.text = String(describing: wrongGuesses)
                }
            }
            letterGuessing.text = ""
            displayGuess()
            return
        }
        letterGuessing.text = ""
        alertSingelChar.text = "Please only input one character at a time."
        displayGuess()
    }
    
    // A helper method to reset the view to initial state. Only activated at end of game.
    func reset() {
        wordCorrespondance.text = ""
        wrongTimes = 1
        let hangmanPhrases = HangmanPhrases()
        phraseLength = self.phrase!.characters.count
        correctPos = [Bool](repeating: false, count: self.phraseLength!)
        allLetters = Set<String>()
        wrongGuesses = Set<String>()
        phrase = hangmanPhrases.getRandomPhrase()
        phraseAsArray = [Character](self.phrase!.characters)
        for c in self.phraseAsArray! {
            allLetters.insert(String(c))
        }
        HangmanImage.image = UIImage(named: "hangman1.gif")
        wrongGuessList.text = ""
        displayGuess()
    }
    
}
