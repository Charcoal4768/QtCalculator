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

    bool isOperator(QChar c);
    QString exprCleanup(QString expr);
    int precedence(QChar op);
    double applyOp(double a, double b, QChar op);
    void exprStackSolver(QString expr);

  public:
    explicit MathEngine(QObject *parent = nullptr);
    Q_INVOKABLE float eval(const QString &message);
};