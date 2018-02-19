//
//  QuizViewController.swift
//  WorldTrotter
//
//  Created by Justin Weiss on 2/18/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    //String for question
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont?",
        "What is cognac made from?",
        "How many balls are there on a pool table?",
        "When did the first Thanksgiving occur?",
        "What was the population of boston in 1776?",
        "How many shipwrecks are on the ocean floor?",
        "What is the highest score in football?",
        "Why are pencils painted yellow?",
        "How many people have stood on the moon?",
        "When was the first search engine invented?"
        
    ]
    //String for answers
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes",
        "16 Balls",
        "1623",
        "15,000 people",
        "over three million shipwrecks",
        "72-41 on November 27, 1966",
        "tell people they contained Chinese graphite",
        "12 men",
        "Archie, created in 1990 by Alan Emtage"
    ]
    
    var currentQuestionIndex: Int = 0
    
    //Next question button
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    //Shows answer button
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    //Loads first question on start up
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
}
