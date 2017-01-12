//
//  CalcMode.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

//decide if you want to compute.  

//When I hit, say, an operator button from the screen, the VC will know about that.  I will essentially run a method

//Things to do:
//Get the simple calc so it works like the git example, with the operator as a calcOp.
//Set up the arrays.
//Set up the functions within the CalcStruct for the buttons to call when they're pressed.
//Set up the methods for +/- and %
//Set up the conditioning for the calcDisplay.

//TMR - what's up with the mutating and escaping?

//COMPUTE
//If the last operator in the stack is + or - and the current operator is * or /, do not compute.
//If there are at least two values on the stack, compute.  Repeat.

//rt = valueArray.last
//valueArray.removeLast

//lt = valueArray.last
//valueArray.removeLast

//op = opArray.last
//opArry.removeLast

//result = op(lt,rt)
//valueArray.add = result


//When I hit a number  (Set an Entry mode?) - might help to do things during modes or transitions of modes
    //If the value stack is empty, create a calc instance (is this necessary?  maybe just do the next step.)
    //If calc.currentEntry is empty put the number in it
    //If there is a calc.current entry, append it
    //If the last button pressed was =, clear the stacks and dispose of calc instance. (Because the stack is empty, a calc instance is created.)

//If an operator is hit   (Set a Calc mode?)
    //If the last button was an operator (already in Calc mode?), then pop the last value off the operator stack, and put this one on.  Compute if you can.
    //If the last button was not an operator:
        //If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
        //OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
        //Compute if you can.
        //Add this operator to the stack.

//When equal is hit  (Set a Result mode?)
    //If the last button pressed was not equals
        //If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
        //If there is exactly one value in the operator stack and exactly one in the value stack, move the last value entry to the value stack.
        //Compute if you can.
    //If the last button pressed was equals
        //If the value stack is not empty, move the last value entry to the value stack and the last operator to the operator stack.
        //Compute

//Hitting the clear button
    //Hitting the clear button when it says "C" pops the last value off of the stack, and changes the button display from "C" to "AC"
    //Hitting the clear button when it says "AC" destroys the calc instance.
    //when a calc instance is created, the clear button changes from "AC" to "C"

//Display
    //Shows the current entry if there is one.  If there is not a current entry, show the top value of the stack.

//+/- and %
    //If there is a current value, apply to the current value.  Need to do this as seperate functions, and then return the current value to itself.
    //If there is not a current value, need to apply to the top stack value.  Need to do this as seperate functions, and then return the value to itself.






//3     create calc instance.  Set current entry to this value.
//4     append to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this entry operator stack.
//-     Two ops in a row, pop last value off operator stack.  Put this value on operator stack.
//4     Set to current entry
//=     Put current entry on value stack.  Compute.  (Perform computation with operator precedence until operator stack is empty.  Value in the value stack is your result.)

//If I hit equal again, I think I move the last entry into the value stack, and put the last operator on the operator stack, and perform the computation. I have to know the last operator and last entry.  Maybe I can do these with operator observers.  If I hit equal, and there's no value in the operator stack, do above.
//If I type another number after equals, I need to clear my stacks.
//If I hit an operator after equals, I put that operator in the operator stack.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this entry operator stack.
//=     How do I execute the stack in this case?  If I have an operator and only one item on the value stack, I add the last stack value to the end of the stack, and I compute.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//*     Two ops in a row, pop last value off operator stack.  Put this value on operator stack.
//7     Set to current entry
//+     {Answer is 23.}  Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//*     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//4     Set to current entry
//=     {Answer is 13.}  Put current entry on value stack.  Compute.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//*     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//4     Set to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!




//Test cases.
//=*
//2=*
//2+=*
//2+==*
//2+3=*
//2+3==*
//2+=*=

//Cases for OPTIONAL operator case.
//+3+     //3
//+3==    //6
//+3+6=   //9

