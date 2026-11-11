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
        } else {
            return QString(); // return empty string if invalid character is found
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
            ErrorMessage = "Error: Division by zero.";
            return 0;
        }
        return a / b;
    default:
        qDebug() << "Error: Unknown operator" << op;
        ErrorMessage = "Error: Unknown operator " + QString(op);
        return 0;
    }
}

void MathEngine::exprStackSolver(QString expr) {
    double tempStore = 0.0;
    bool decimalPointEncountered = false;
    bool digitEncountered = false;
    double decimalPlace = 0.1;
    for (auto &letter : expr) {
        if (letter.isDigit() || letter == '.') {
            // keep reading until we hit an operator or the end of the string
            // keep storing the number in temp
            // finally, push temp to the numStack
            if (letter == '.') {
                if (decimalPointEncountered) {
                    qDebug() << "Error: Multiple decimal points in a number.";
                    ErrorMessage = "Error: Multiple decimal points in a number.";
                    errorOccurred = true;
                    return;
                }
                decimalPointEncountered = true;
                continue;
            } else {
                digitEncountered = true;
            }
            double digitVal = letter.digitValue();
            if (decimalPointEncountered) {
                tempStore += digitVal * decimalPlace;
                decimalPlace *= 0.1;
            } else {
                tempStore = tempStore * 10 + digitVal;
                decimalPlace = 0.1;
            }
        } else if (isOperator(letter)) {
            if (digitEncountered)
                numStack.push(tempStore);
            tempStore = 0.0;
            digitEncountered = false;
            decimalPointEncountered = false;
            decimalPlace = 0.1;
            if (numStack.size() < 1) {
                qDebug() << "Error: Not enough operands in the stack.";
                ErrorMessage = "Error: Not enough operands in the stack.";
                errorOccurred = true;
                return;
            }
            if (precedence(letter) >
                precedence(opStack.empty() ? QChar() : opStack.top())) {
                opStack.push(letter);
            } else {
                while (!opStack.empty() &&
                       precedence(letter) <= precedence(opStack.top())) {
                    if (numStack.size() < 2) {
                        qDebug() << "Error: Not enough operands in the stack.";
                        return;
                    }
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
    if (digitEncountered) {
        numStack.push(tempStore);
    }

    // Now apply remaining operators in the stack
    while (!opStack.empty()) {
        if (numStack.size() < 2) {
            qDebug() << "Error: Not enough operands in the stack.";
            return;
        }
        double num1 = numStack.top();
        numStack.pop();
        double num2 = numStack.top();
        numStack.pop();
        double result = applyOp(num2, num1, opStack.top());
        numStack.push(result);
        opStack.pop();
    }
}

void MathEngine::resetState() {
    while (!opStack.empty()) {
        opStack.pop();
    }
    while (!numStack.empty()) {
        numStack.pop();
    }
    ErrorMessage.clear();
    errorOccurred = false;
}

float MathEngine::eval(const QString &message) {

    // clear old leftovers
    resetState();

    qDebug() << "Received from QML:" << message;
    QString cleanedExpr = exprCleanup(message);
    qDebug() << "Cleaned up expression:" << cleanedExpr;
    if (cleanedExpr.isEmpty()) {
        if (debug) {
            qDebug() << "Error: Expression is empty or contains invalid characters.";
        }

        ErrorMessage = "Error: Expression is empty or contains invalid characters.";
        errorOccurred = true;
        return 0.0;
    }
    exprStackSolver(cleanedExpr);
    if ((numStack.size() == 1) && opStack.empty()) {
        if (debug) {
            qDebug() << "Final result:" << numStack.top();
        }
        return numStack.top();
    } else {
        if (debug) {
            qDebug() << "Error: Invalid expression.";
        }
        ErrorMessage = "Error: Invalid expression.";
        errorOccurred = true;
        return 0.0;
    }
    // placeholder for now
    return 4.2;
}

QString MathEngine::error() { return ErrorMessage; }