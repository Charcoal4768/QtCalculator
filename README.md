# Calculator in C++ with Qt and QML

This is a basic calculator made using **Qt** with **QML** and **C++**

## Functionality

This calculator app operates on simple bool states and a stack based calculation loop.

An expression is evaluated and scanned for numbers, decimals and operators. Numbers are then placed into one stack and operators in the other. The op stack's top member is checked before a new operator is pushed, if the top member has higher precidence than the current one, the operation stack is first executed on the number stack before the current operator is pushed to the top.

Finally, when all the operators and numbers from our string have been pushed to their stacks, we run through all remaining operations until the result is found.

Due to the precedence check, this algorithm safely follows BODMAS.

Bracket support and scientific features are not implimented.

## Technologies Used:

C++, QML, QT, QTQuick, CMake

### Trivia:

The stack based implimentation used here can also be called a **two-stack algorithm for evaluating infix expressions**. Purely by co-incidence, it is closely related to **Dijkstra’s shunting-yard algorithm**

Both my algorithm and Dijkstra's use an operator stack and precedence rules but Shunting yard usually converts to postfix first, here the operators are applied directly while parsing then drained further at the end.