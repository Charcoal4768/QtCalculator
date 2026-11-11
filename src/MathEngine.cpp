#include "MathEngine.h"

#include <QDebug>

MathEngine::MathEngine(QObject *parent) : QObject(parent) {}

bool MathEngine::isOperator(QChar c) {
    return c == '+' || c == '-' || c == '*' || c == '/';
}

QString MathEngine::exprCleanup(QString expr) {
    // remove any letters, spaces and punctuation
    QString newExpr;
    for (auto &letter : expr) {
        if (letter.isDigit() || isOperator(letter) || letter == '.') {
            newExpr.append(letter);
        }
    }
    return newExpr;
}

int MathEngine::precedence(QChar op) {
    if (op == '+' || op == '-') {
        return 1;
    } else if (op == '*' || op == '/') {
        return 2;
    }
    return 0;
}

double MathEngine::applyOp(double a, double b, QChar op) {
    switch (op.toLatin1()) {
    case '+':
        return a + b;
    case '-':
        return a - b;
    case '*':
        return a * b;
    case '/':
        if (b == 0) {
            qDebug() << "Error: Division by zero.";
            return 0;
        }
        return a / b;
    default:
        qDebug() << "Error: Unknown operator" << op;
        return 0;
    }
}

void MathEngine::exprStackSolver(QString expr) {
    double tempStore = 0.0;
    bool decimalPointEncountered = false;
    for (auto &letter : expr) {
        if (letter.isDigit() || letter == '.') {
            // keep reading until we hit an operator or the end of the string
            // keep storing the number in temp
            // finally, push temp to the numStack
            if (letter == '.') {
                decimalPointEncountered = true;
                continue; // Skip the decimal point for now
            }
            double digitVal = letter.digitValue();
            if (decimalPointEncountered) {
                // Handle decimal part
                static double decimalPlace = 0.1;
                tempStore += digitVal * decimalPlace;
                decimalPlace *= 0.1; // Move to the next decimal place
            } else {
                tempStore = tempStore * 10 + digitVal;
            }
        } else if (isOperator(letter)) {
            numStack.push(tempStore);
            tempStore = 0.0;
            if (numStack.size() < 1) {
                qDebug() << "Error: Not enough operands in the stack.";
                return;
            }
            int currentPrecedence = precedence(letter);
            int topPrecedence = opStack.empty() ? 0 : precedence(opStack.top());
            if (currentPrecedence > topPrecedence) {
                opStack.push(letter);
            } else {
                while (!opStack.empty() && currentPrecedence <= topPrecedence) {
                    if (numStack.size() < 2) {
                        qDebug() << "Error: Not enough operands in the stack.";
                        return;
                    }
                    currentPrecedence = precedence(letter);
                    topPrecedence = opStack.empty() ? 0 : precedence(opStack.top());
                    double num1 = numStack.top();
                    numStack.pop();
                    double num2 = numStack.top();
                    numStack.pop();
                    double result = applyOp(num2, num1, opStack.top());
                    numStack.push(result);
                    opStack.pop();
                }
                opStack.push(letter);
            }
        }
    }
    // Push any remaining number to the stack
    if (tempStore != 0.0) {
        numStack.push(tempStore);
    }
}

float MathEngine::eval(const QString &message) {

    // clear old leftovers
    while (!opStack.empty())
        opStack.pop();
    while (!numStack.empty())
        numStack.pop();

    qDebug() << "Received from QML:" << message;
    QString cleanedExpr = exprCleanup(message);
    qDebug() << "Cleaned up expression:" << cleanedExpr;
    exprStackSolver(cleanedExpr);
    qDebug() << "Final result:" << numStack.top();
    // placeholder for now
    return 4.2;
}