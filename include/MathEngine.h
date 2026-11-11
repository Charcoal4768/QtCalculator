#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <QString>

class MathEngine : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

  public:
    explicit MathEngine(QObject *parent = nullptr);

    Q_INVOKABLE double eval(const QString &expression) const;
};
