
//  ContentView.swift
//  Shared
//  Created by ananya  on 1/18/22.
//

import SwiftUI
import SwiftUI

// Our main view - everything that will happen in the UI!
struct ContentView: View {
    
    // 2D Array of the rows & buttons on each row of the calculator
       
    let buttons = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "−"],
        [".", "0", "=", "+"]
    ]
    
  
    // state variables that will constantly be updated
    
    @State var noBeingEntered: String = ""
    
    @State var finalValue:String = "acm-w calculator"
    
    @State var mathEquation: [String] = []
    
    var body: some View {
        VStack {
            VStack {
                
                // final value of the calculator!
                Text(self.finalValue)
                    .font(Font.custom("HelveticaNeue-Thin", size: 78))
                        // Make the alignment to the center
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                        // Make the color of the text white so it pops!
                    .foregroundColor(Color.white)
                
                Text(flattenTheExpression(equation: mathEquation)) //Text("Math Equation")
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                    .foregroundColor(Color.white)
                
                Spacer()
            }
            // This formats the VStack
                
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                
            .background(Color.purple)
            
            
           
            VStack {
                Spacer(minLength: 48)
                

                VStack {
                    
                    
                    ForEach(buttons, id: \.self) { row in // will go through each row
                        
                            // Will go through each button in the row horizontally
                        HStack(alignment: .top, spacing: 0) {
                            // We'll add a little space at the beginning of each row
                            Spacer(minLength: 13)
                            
                            // loop through each column in the row
                            ForEach(row, id: \.self) { column in
                                // Add a button for each row!
                                Button(action: {
                                    
                                    // Figure out what to do when each button is pressed
                                    if column == "=" {
                                        self.mathEquation = []
                                        self.noBeingEntered = ""
                                        return
                                    } else if checkIfOperator(str: column)  {
                                        self.mathEquation.append(column)
                                        self.noBeingEntered = ""
                                    } else {
                                        self.noBeingEntered.append(column)
                                        if self.mathEquation.count == 0 {
                                            self.mathEquation.append(self.noBeingEntered)
                                        } else {
                                            if !checkIfOperator(str: self.mathEquation[self.mathEquation.count-1]) {
                                                self.mathEquation.remove(at: self.mathEquation.count-1)
                                            }

                                            self.mathEquation.append(self.noBeingEntered)
                                        }
                                    }

                                    // Set the final value to the value calculated by the math expression
                                    self.finalValue = processExpression(equation: self.mathEquation)
                                    
                                    // Reset the math equation so it's always in terms of two
                                    if self.mathEquation.count > 3 {
                                        self.mathEquation = [self.finalValue, self.mathEquation[self.mathEquation.count - 1]]
                                    }

                                }, label: {
                                    // This will label the buttons
                                    Text(column)
                                        // Figure out the font size for each button
                                    .font(.system(size: getFontSize(btnTxt: column)))
                                        // Size of each button
                                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                }
                                )
                                // Color of the text
                                .foregroundColor(Color.white)
                                // Button background color
                                .background(getBackground(str: column))
                            }
                        }
                    }
                }
            }
            // Background color of the second v stack
            .background(Color.black)
            // Set the height of this v stack to be 1/2 the screen
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
        }
        // Background of this view is black (gets rid of white bar)
        .background(Color.black)
        // Ignore the safe area around the edges (makes things bigger)
        .edgesIgnoringSafeArea(.all)
    }
}

// Formatting for buttons!
// Background of numbers vs operators
func getBackground(str:String) -> Color {
    
    if checkIfOperator(str: str) {
        return Color.purple
    }
    return Color.black
}

// Font size of numbers vs operators
func getFontSize(btnTxt: String) -> CGFloat {
    
    if checkIfOperator(str: btnTxt) {
        return 42
    }
    return 24
    
}

// Check if the button pressed is an operator
func checkIfOperator(str:String) -> Bool {
    
    if str == "÷" || str == "×" || str == "−" || str == "+" || str == "=" {
        return true
    }
    
    return false
    
}

// Make the array of strings for the math equation into a single string
func flattenTheExpression(equation: [String]) -> String {
    var mathEquation = ""
    for expression in equation {
        mathEquation.append(expression)
    }
    
    return mathEquation
}

// Actual calculations!
func processExpression(equation:[String]) -> String {
    
    if equation.count < 3 {
        return "0.0"
    }
    
    var a = Double(equation[0])
    var c = Double("0.0")
    let expressionSize = equation.count
   
    for i in (1...expressionSize-2) {
        
        c = Double(equation[i+1])
        
        // Depending on the operator, do the correct operator
        switch equation[i] {
            case "+":
                a! += c!
            case "−":
                a! -= c!
            case "×":
                a! *= c!
            case "÷":
                a! /= c!
        default:
            print("skipping the rest")
        }
    }
    
    // Return a string of this specific format
    return String(format: "%.1f", a!) // has point precision! We're rounding to the nearest tenth!
}

// This is the function that lets us show the preview on the righthand side!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // We're showing the preview of ContentView(). So, any code in content view will be previewed on the right
    }
}
