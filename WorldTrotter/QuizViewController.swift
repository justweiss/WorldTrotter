//
//  QuizViewController.swift
//  WorldTrotter
//
//  Created by Justin Weiss on 2/18/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    
    //@IBOutlet var questionLabel: UILabel!
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var answerLabel: UILabel!
    var currentQuestionIndex: Int = 0
    
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
    
    //Next question button
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        let question: String = questions[currentQuestionIndex]
        //questionLabel.text = question
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    //Shows answer button
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    func animateLabelTransitions() {
        
        //Force any outstanding layout changes to occur
        view.layoutIfNeeded()
        
        //Animate the alpha
        // and the center X constraints
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: {
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                        
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                        
                        swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
                        
                        self.updateOffScreenLabel()
        })
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = screenWidth
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set the label's initial alpha
        nextQuestionLabel.alpha = 0
    }
    
    //Loads first question on start up
    override func viewDidLoad() {
        super.viewDidLoad()
        //questionLabel.lineBreakMode = .byWordWrapping
        //questionLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.numberOfLines = 0
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        updateOffScreenLabel()
    }
}
