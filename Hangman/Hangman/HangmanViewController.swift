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

    override func viewDidLoad() {
        super.viewDidLoad()
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        phraseAsArray = [Character](phrase.characters)
        phraseLength = phrase.characters.count
        print(phrase)
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
    @IBOutlet weak var letterGuessing: UITextField! // Needs action.
    @IBOutlet weak var HangmanImage: UIImageView!
    
    // The action connections to the guess button and the textfield.
    @IBAction func makeGuess(_ sender: UIButton) {
//        wordCorrespondance.text = "worked"
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
