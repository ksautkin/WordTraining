#include "utils.h"
#include <QCoreApplication>
#include <QFile>
#include <QUrl>
#include <QDir>

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
    return correctLetters;
}

QStringList Utils::importVocabulary(QString urlPath)
{
    QStringList words;
    const QUrl url(urlPath);
    if (url.isLocalFile())
        urlPath = QDir::toNativeSeparators(url.toLocalFile());
    QFile file(urlPath);

    if (!file.open(QFile::ReadOnly | QFile::Text))
    {
        qWarning() << QString("Error import file %1. File not exists").arg(urlPath);
    }
    else
    {
        QTextStream in(&file);
        while (!in.atEnd())
        {
            QString line = in.readLine();
            for (const QString& word : line.split(";"))
            {
                words.append(word);
            }
        }
    }
    return words; // vocabulary[word, meaning, word, meaning, ...]
}

void Utils::exportVocabulary(QString urlPath, const QStringList& words)
{
    const QUrl url(urlPath);
    if (url.isLocalFile())
        urlPath = QDir::toNativeSeparators(url.toLocalFile());
    QFile file(urlPath);

    if (!file.open(QFile::WriteOnly | QFile::Text))
    {
        qWarning() << QString("Error export file %1. File not exists").arg(urlPath);
    }
    else
    {
        QTextStream out(&file);
        for (int i = 0; i < words.size(); i += 2)
        {
            QString meaningWord = words[i + 1];
            meaningWord.replace(QChar('\n'), QChar(' '), Qt::CaseInsensitive);
            out << words[i] << ";" << meaningWord << "\n";
        }
        out.flush();
    }
}

bool Utils::checkFileFormat(QString urlPath, QString format)
{
    return QFileInfo(urlPath).fileName().endsWith(format, Qt::CaseInsensitive);
}
