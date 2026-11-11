#include "MathEngine.h"

#include <QDebug>
#include <QStringView>
#include <cmath>
#include <limits>

namespace {
class ExpressionParser {
  public:
    explicit ExpressionParser(QStringView expression) : expression(expression) {}

    bool parse(double &result) {
        if (!parseExpression(result)) {
            return false;
        }

        skipWhitespace();
        if (position != expression.size()) {
            return fail("Unexpected character");
        }
        return true;
    }

    QString error() const { return errorMessage; }

  private:
    QStringView expression;
    qsizetype position = 0;
    QString errorMessage;

    void skipWhitespace() {
        while (position < expression.size() && expression.at(position).isSpace()) {
            ++position;
        }
    }

    bool consume(QChar expected) {
        skipWhitespace();
        if (position < expression.size() && expression.at(position) == expected) {
            ++position;
            return true;
        }
        return false;
    }

    bool fail(const QString &message) {
        if (errorMessage.isEmpty()) {
            errorMessage = message;
        }
        return false;
    }

    bool parseExpression(double &result) {
        if (!parseTerm(result)) {
            return false;
        }

        while (true) {
            if (consume(u'+')) {
                double rhs = 0.0;
                if (!parseTerm(rhs)) {
                    return false;
                }
                result += rhs;
            } else if (consume(u'-')) {
                double rhs = 0.0;
                if (!parseTerm(rhs)) {
                    return false;
                }
                result -= rhs;
            } else {
                return true;
            }
        }
    }

    bool parseTerm(double &result) {
        if (!parseUnary(result)) {
            return false;
        }

        while (true) {
            skipWhitespace();
            const QChar op = position < expression.size() ? expression.at(position) : QChar();
            if (op != u'*' && op != u'x' && op != u'X' && op != u'/' && op != u'÷') {
                return true;
            }
            ++position;

            double rhs = 0.0;
            if (!parseUnary(rhs)) {
                return false;
            }

            if (op == u'/' || op == u'÷') {
                if (rhs == 0.0) {
                    return fail("Division by zero");
                }
                result /= rhs;
            } else {
                result *= rhs;
            }
        }
    }

    bool parseUnary(double &result) {
        if (consume(u'+')) {
            return parseUnary(result);
        }
        if (consume(u'-')) {
            if (!parseUnary(result)) {
                return false;
            }
            result = -result;
            return true;
        }
        return parsePrimary(result);
    }

    bool parsePrimary(double &result) {
        skipWhitespace();
        if (consume(u'(')) {
            if (!parseExpression(result)) {
                return false;
            }
            if (!consume(u')')) {
                return fail("Missing closing parenthesis");
            }
            return true;
        }

        const qsizetype start = position;
        bool hasDigit = false;
        bool hasDecimalPoint = false;
        while (position < expression.size()) {
            const QChar ch = expression.at(position);
            if (ch >= u'0' && ch <= u'9') {
                hasDigit = true;
                ++position;
            } else if (ch == u'.' && !hasDecimalPoint) {
                hasDecimalPoint = true;
                ++position;
            } else {
                break;
            }
        }

        if (!hasDigit) {
            return fail("Expected a number or '('");
        }

        bool converted = false;
        result = expression.mid(start, position - start).toString().toDouble(&converted);
        if (!converted || !std::isfinite(result)) {
            return fail("Invalid or out-of-range number");
        }
        return true;
    }
};
} // namespace

MathEngine::MathEngine(QObject *parent) : QObject(parent) {}

double MathEngine::eval(const QString &expression) const {
    ExpressionParser parser{QStringView(expression)};
    double result = 0.0;
    if (!parser.parse(result)) {
        qWarning() << "Could not evaluate expression:" << expression << parser.error();
        return std::numeric_limits<double>::quiet_NaN();
    }
    if (!std::isfinite(result)) {
        qWarning() << "Expression result is out of range:" << expression;
        return std::numeric_limits<double>::quiet_NaN();
    }
    return result;
}