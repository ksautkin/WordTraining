#include "utils.h"
#include <QCoreApplication>

Utils::Utils(QObject* parent)
    : QObject{parent}
{
}

bool Utils::stringComparison(const QString& enteredWord, const QString& word)
{
    return QString::compare(enteredWord.trimmed(), word, Qt::CaseInsensitive) == 0;
}

QList<bool> Utils::wordComparisonByLetters(const QString& enteredWord, const QString& word)
{
    QList<bool> correctLetters;
    QString enteredWordTrimmed = enteredWord.trimmed();
    for (int i = 0; i < word.length(); ++i)
    {
        if (i < enteredWordTrimmed.length())
            correctLetters.append(enteredWordTrimmed[i].toLower() == word[i].toLower());
        else
            correctLetters.append(false);
    }
    qInfo()<<correctLetters;
    return correctLetters;
}
