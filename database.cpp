#include "database.h"
#include <QFile>
#include <QSqlQuery>
#include <QSqlError>

const QString DataBase::dbHostname              = "VocabularyBase";
const QString DataBase::dbName                  = "Vocabulary.db";

const QString DataBase::tableName               = "Words";
const QString DataBase::idColumn                = "id";
const QString DataBase::wordColumn              = "Word";
const QString DataBase::meaningWordColumn       = "MeaningWord";
const QString DataBase::statisticsWordColumn    = "StatisticsWord";

bool DataBase::creatDataBase()
{
    if (openDataBase())
    {
        QSqlQuery query;
        query.prepare(QString("CREATE TABLE %1 (id INTEGER PRIMARY KEY AUTOINCREMENT, "
                              "%2 VARCHAR(255) NOT NULL, "
                              "%3 VARCHAR(255) NOT NULL, "
                              "%4 VARCHAR(255) NOT NULL)").arg(tableName, wordColumn, meaningWordColumn, statisticsWordColumn));
        if(query.exec())
        {
            qInfo() << QString("Database is created");
            return true;
        }
    }

    qWarning() << QString("Database is not created");
    return false;
}

bool DataBase::openDataBase()
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setHostName(dbHostname);
    m_db.setDatabaseName(QString("%1/%2").arg(m_locationDb, dbName));
    if (m_db.open())
    {
        qInfo() << QString("Database %1/%2 is open").arg(m_locationDb, dbName);
        return true;
    }

    qWarning() << QString("Database %1/%2 is not open").arg(m_locationDb, dbName);
    return false;
}

void DataBase::closeDataBase()
{
    m_db.close();
}

DataBase::DataBase(const QString& locationDb, QObject* parent)
    : m_locationDb{locationDb},
    QObject{parent}
{
}

bool DataBase::connectToDataBase()
{
    if (QFile(QString("%1/%2").arg(m_locationDb, dbName)).exists())
        return openDataBase();

    qWarning() << QString("Database %1/%2 doesn't exist").arg(m_locationDb, dbName);
    return creatDataBase();
}

bool DataBase::inserWordIntoTable(const QString& word, const QString& meaningWord)
{
    if (!m_db.isOpen())
    {
        qWarning() << QString("Error inserting into table. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return false;
    }

    QSqlQuery query;
    query.prepare(QString("INSERT INTO %1 ("
                          "%2, "
                          "%3,"
                          "%4) "
                          "VALUES (:word, :meaningWord, :statisticsWord)").arg(tableName, wordColumn, meaningWordColumn, statisticsWordColumn));
    query.bindValue(":word", word);
    query.bindValue(":meaningWord", meaningWord);
    QString statistics;
    for (int i = 0; i <= word.length(); ++i)
        statistics.append("0;0;");                      // statistics[for whole word countCorrect;countWrong; for ever letter countCorrect;countWrong;...]
    query.bindValue(":statisticsWord", statistics);

    if (query.exec())
        return true;

    qWarning() << QString("Error inserting into table. %1").arg(query.lastError().text());
    return false;
}

bool DataBase::updateWordInTable(const int id, const QString& word, const QString& meaningWord)
{
    if (!m_db.isOpen())
    {
        qWarning() << QString("Error updating a row in table. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return false;
    }

    QSqlQuery query;
    query.prepare(QString("UPDATE %1 SET "
                          "%2 = :word, "
                          "%3 = :meaningWord, "
                          "%4 = :statisticsWord "
                          "WHERE %5 = :id").arg(tableName, wordColumn, meaningWordColumn, statisticsWordColumn, idColumn));
    query.bindValue(":word", word);
    query.bindValue(":meaningWord", meaningWord);
    query.bindValue(":id", id);
    QString statistics;
    for (int i = 0; i <= word.length(); ++i)
        statistics.append("0;0;");                      // statistics[for whole word countCorrect;countWrong; for ever letter countCorrect;countWrong;...]
    query.bindValue(":statisticsWord", statistics);

    if (query.exec())
        return true;

    qWarning() << QString("Error updating a row in table. %1").arg(query.lastError().text());
    return false;
}

bool DataBase::deleteWordFromTable(const int id)
{
    if (!m_db.isOpen())
    {
        qWarning() << QString("Error deleting a row from table. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return false;
    }

    QSqlQuery query;
    query.prepare(QString("DELETE FROM %1 "
                          "WHERE %2 = :id").arg(tableName, idColumn));
    query.bindValue(":id", id);

    if (query.exec())
        return true;

    qWarning() << QString("Error deleting a row from table. %1").arg(query.lastError().text());
    return false;
}

QStringList DataBase::selectWordsFromTable()
{
    if (!m_db.isOpen())
    {
        qWarning() << QString("Error selecting rows from table. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return {};
    }

    qInfo() << QString("Random sequence is %1").arg(m_isRandomSequence ? "enable" : "disable");
    QSqlQuery query;
    if (m_isRandomSequence)
        query.prepare(QString("SELECT %1, %2, %3 "
                              "FROM %4 "
                              "ORDER BY RANDOM()").arg(idColumn, wordColumn, meaningWordColumn, tableName));
    else
        query.prepare(QString("SELECT %1, %2, %3 "
                              "FROM %4").arg(idColumn, wordColumn, meaningWordColumn, tableName));

    if (query.exec())
    {
        QStringList data;
        while (query.next())
        {
            data.append(query.value(0).toString());
            data.append(query.value(1).toString());
            data.append(query.value(2).toString());
        }
        qInfo() << QString("Selected rows %1 from table").arg(QString::number(data.size()));
        return data;
    }

    qWarning() << QString("Error selecting rows from table. %1").arg(query.lastError().text());
    return {};
}

void DataBase::enableRandomSequence(bool isRandomSequence)
{
    m_isRandomSequence = isRandomSequence;
}

QList<int> DataBase::statisticsWord(const int id)
{
    if (!m_db.isOpen())
    {
        qWarning() << QString("Error get statistics of word. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return {};
    }

    QSqlQuery query;
    query.prepare(QString("SELECT %1 "
                          "FROM %2 "
                          "WHERE %3 = :id").arg(statisticsWordColumn, tableName, idColumn));
    query.bindValue(":id", id);

    if (query.exec())
    {
        query.next();
        QList<int> statistics;
        for(const QString& str : query.value(0).toString().split(';'))
        {
            if (str.length() == 0)
                continue;
            statistics.append(str.toInt());
        }
        qInfo() << QString("Selected statistics word: %1").arg(query.value(0).toString());
        return statistics;
    }

    qWarning() << QString("Error get statistics of word. %1").arg(query.lastError().text());
    return {};
}

bool DataBase::inserStatisticsWord(const int id, const QList<bool>& correctLetters)
{
    QList<int> statistics = statisticsWord(id);
    for (int i = 2, j = 0; i < statistics.size() && j < correctLetters.size(); i += 2, ++j)
    {
        if (correctLetters[j])
        {
            ++statistics[i];
        }
        else
        {
            ++statistics[i + 1];
        }
    }

    if (correctLetters.contains(false))  // for whole word countCorrect statistics[0];countWrong statistics[1]
        ++statistics[1];
    else
        ++statistics[0];

    if (!m_db.isOpen())
    {
        qWarning() << QString("Error insert statistics of word. Database %1/%2 is not open").arg(m_locationDb, dbName);
        return false;
    }

    QSqlQuery query;
    query.prepare(QString("UPDATE %1 SET "
                          "%2 = :statisticsWord "
                          "WHERE %3 = :id").arg(tableName, statisticsWordColumn, idColumn));
    query.bindValue(":id", id);
    QString newStatistics;
    for (int i = 0; i < statistics.length(); i+=2)
        newStatistics.append(QString("%1;%2;").arg(statistics[i]).arg(statistics[i+1]));
    query.bindValue(":statisticsWord", newStatistics);

    if (query.exec())
        return true;

    qWarning() << QString("Error insert statistics of word. %1").arg(query.lastError().text());
    return false;
}
