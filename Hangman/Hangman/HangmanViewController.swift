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
    var wrongTimes = 0
    var phrase: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        phraseAsArray = [Character](phrase!.characters)
        phraseLength = phrase?.characters.count
        correctPos = [Bool](repeating: false, count: phraseLength!)
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
            
            if (allLetters.contains(guess!)) {
                
                for index in 0...phraseLength!-1 {
                    if guess == String(phraseAsArray![index]) {
                        correctPos![index] = true
                    }
                }
                if (testIfWon()) {
                    let alertController = UIAlertController(
                        title: "Congratulations! You Won!",
                        message: "Let's play a new game",
                        preferredStyle: .alert)
                    let newGameAction = UIAlertAction(title: "OK", style: .default) {
                        action in self.reset()
                    }
                    alertController.addAction(newGameAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else {
                if !wrongGuesses.contains(String(guess!)) {
                    
                    wrongGuesses.insert(String(guess!))
                    if wrongTimes < 7 {
                        wrongTimes += 1
                        let imageName = "hangman" + String(wrongTimes) + ".gif"
                        HangmanImage.image = UIImage(named: imageName)
                    }
                    if wrongTimes > 6{
                        let alertController = UIAlertController(
                            title: "You Lost!",
                            message: "Let's try again",
                            preferredStyle: .alert)
                        let newGameAction = UIAlertAction(title: "OK", style: .default) {
                            action in self.reset()
                        }
                        alertController.addAction(newGameAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    wrongGuessList.text = String(describing: wrongGuesses)
                }
            }
        }
        letterGuessing.text = ""
        alertSingelChar.text = "Please only input one character at a time."
        displayGuess()
    }
    
    func reset() {
        self.wordCorrespondance.text = ""
        self.allLetters = Set<String>()
        self.wrongGuesses = Set<String>()
        self.wrongTimes = 1
        let hangmanPhrases = HangmanPhrases()
        self.phrase = hangmanPhrases.getRandomPhrase()
        self.phraseAsArray = [Character](self.phrase!.characters)
        self.phraseLength = self.phrase!.characters.count
        self.correctPos = [Bool](repeating: false, count: self.phraseLength!)
        for c in self.phraseAsArray! {
            self.allLetters.insert(String(c))
        }
        let imageName = "hangman" + String(wrongTimes) + ".gif"
        HangmanImage.image = UIImage(named: imageName)
        wrongGuessList.text = ""
        self.displayGuess()
    }
    func testIfWon() -> Bool{
        for x in correctPos! {
            if (x == false) {
                return false
            }
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
