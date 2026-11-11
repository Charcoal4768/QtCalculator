#pragma once
#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <stack>

class MathEngine : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

  private:
    std::stack<QChar> opStack;
    std::stack<double> numStack;
    QString ErrorMessage;
    bool errorOccurred = false;

    bool isOperator(QChar c);
    QString exprCleanup(QString expr);
    int precedence(QChar op);
    double applyOp(double a, double b, QChar op);
    void exprStackSolver(QString expr);
    void resetState();

  public:
    bool debug = false;
    Q_INVOKABLE QString error();
    explicit MathEngine(QObject *parent = nullptr);
    Q_INVOKABLE float eval(const QString &message);
};