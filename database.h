#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QString>

class DataBase : public QObject
{
    Q_OBJECT

private:
    QSqlDatabase            m_db;
    QString                 m_locationDb;
    bool                    m_isRandomSequence;

public:
    static const QString    dbHostname;
    static const QString    dbName;

    static const QString    tableName;
    static const QString    idColumn;
    static const QString    wordColumn;
    static const QString    meaningWordColumn;
    static const QString    statisticsWordColumn;

private:
    bool            creatDataBase();
    bool            openDataBase();
    void            closeDataBase();

public:
    explicit        DataBase(const QString& locationDb, QObject* parent = nullptr);
    bool            connectToDataBase();

    Q_INVOKABLE  bool           inserWordIntoTable(const QString& word, const QString& meaningWord);
    Q_INVOKABLE  bool           updateWordInTable(const int id, const QString& word, const QString& meaningWord);
    Q_INVOKABLE  bool           deleteWordFromTable(const int id);
    Q_INVOKABLE  QStringList    selectWordsFromTable();
    Q_INVOKABLE  void           enableRandomSequence(bool isRandomSequence);

    // Stats Word
    Q_INVOKABLE  QList<int>     statisticsWord(const int id);
    Q_INVOKABLE  bool           inserStatisticsWord(const int id, const QList<bool>& correctLetters);
};