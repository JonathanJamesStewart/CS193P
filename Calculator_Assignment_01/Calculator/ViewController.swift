//
//  ViewController.swift
//  Calculator
//
//  Created by Jonathan Stewart on 5/5/15.
//  Copyright (c) 2015 Jonathan Stewart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var log: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        set{
            display.text = "\(newValue)"
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (display.text!.rangeOfString(".") == nil && digit == String(".")){
            display.text = display.text! + digit
            userIsInTheMiddleOfTypingANumber = true
            return
        }
        if (display.text!.rangeOfString(".") != nil && digit == "."){
            return
        }
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func backspace(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            var index1 = advance(display.text!.endIndex, -1)
            display.text = display.text!.substringToIndex(index1)
            if count(display.text!) < 1{
                displayValue = 0
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    @IBAction func resetCalc(sender: UIButton) {
        operandStack = Array<Double>()
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        log.text = ""
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        appendToLog(operation + " ")
        
        switch operation{
            case "×":
                performOperation { $0 * $1 }
            case "÷":
                performOperation { $1 / $0 }
            case "+":
                performOperation { $0 + $1 }
            case "−":
                performOperation { $1 - $0 }
            case "√":
                performOperation { sqrt($0) }
            case "sin":
                performOperation { sin($0) }
            case "cos":
                performOperation { cos($0) }
            default: break
        }
    }
    
    @IBAction func invertSign(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            displayValue = displayValue * -1
        }else{
            performOperation { $0 * -1 }
        }
    }
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber{
            userIsInTheMiddleOfTypingANumber = false
            appendToOperandStack(displayValue)
            
        }
    }
    
    func appendToLog(s: String){
        log.text = log.text! + s
    }
    
    func appendToOperandStack(n: Double){
        operandStack.append(n)
        appendToLog("\(n) ")
    }
    
    
    @IBAction func appendPi(sender: UIButton) {
        appendToOperandStack(M_PI)
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            appendToLog("= ")
            appendToOperandStack(displayValue)
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            appendToLog(" = ")
            appendToOperandStack(displayValue)
            enter()
        }
    }
}

