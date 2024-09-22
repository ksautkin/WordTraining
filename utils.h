#pragma once

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT

public:
    explicit    Utils(QObject* parent = nullptr);

    Q_INVOKABLE bool        stringComparison(const QString& enteredWord, const QString& word);
    Q_INVOKABLE QList<bool> wordComparisonByLetters(const QString& enteredWord, const QString& word);

    Q_INVOKABLE QStringList importVocabulary(QString urlPath);
    Q_INVOKABLE void        exportVocabulary(QString urlPath, const QStringList& words);
};
