#include <QtTest>
#include <QList>
#include "utils.h"
#include "database.h"

class TestCore : public QObject
{
    Q_OBJECT

private:
    Utils m_utils;
    DataBase m_database;

public:
    TestCore() : m_utils(nullptr), m_database(QDir::currentPath(), nullptr)
    {}

    ~TestCore()
    {
        m_database.closeDataBase();
        QFile::remove(QDir::toNativeSeparators(QString("%1/%2").arg(QDir::currentPath(), DataBase::dbName)));
    }

private slots:
    // Сomparison tests
    void testStringComparison_data();
    void testStringComparison();

    // Сomparison by letters tests
    void testWordComparisonByLetters_data();
    void testWordComparisonByLetters();

    // Сheck file format tests
    void testCheckFileFormat_data();
    void testCheckFileFormat();

    // Database tests
    void testConnectToDataBase();

    void testInserWordIntoTable_data();
    void testInserWordIntoTable();

    void testUpdateWordInTable_data();
    void testUpdateWordInTable();

    void testSelectWordsFromTable();

    void testStatisticsWord();

    void testInserStatisticsWord();
};

void TestCore::testStringComparison_data()
{
    QTest::addColumn<QString>("enteredWord");
    QTest::addColumn<QString>("word");
    QTest::addColumn<bool>("result");

    QTest::newRow("upper case") << QString("HELLO WORLD") << QString("HELLO WORLD") << true;
    QTest::newRow("different case") << QString("HELLO WORLD") << QString("hello world") << true;
    QTest::newRow("lower case") << QString("hello world") << QString("hello world") << true;
    QTest::newRow("extra spaces") << QString("  hello world ") << QString(" hello world   ") << true;
    QTest::newRow("empty phrases") << QString("") << QString("") << true;

    QTest::newRow("different phrases") << QString("hello world") << QString("world hello") << false;
    QTest::newRow("without space") << QString("hello world") << QString("helloworld") << false;
    QTest::newRow("letters from different languages") << QString("Hello world") << QString("Неllо wоrld") << false;
    QTest::newRow("second phrase is bigger") << QString("hello world") << QString("hello world123") << false;
}

void TestCore::testStringComparison()
{
    QFETCH(QString, enteredWord);
    QFETCH(QString, word);
    QFETCH(bool, result);

    QCOMPARE(m_utils.stringComparison(enteredWord, word), result);
}

void TestCore::testWordComparisonByLetters_data()
{
    QTest::addColumn<QString>("enteredWord");
    QTest::addColumn<QString>("word");
    QTest::addColumn<QList<bool>>("result");

    QTest::newRow("upper case") << QString("HELLO WORLD") << QString("HELLO WORLD") << QList<bool>{true, true, true, true, true, true, true, true, true, true, true};
    QTest::newRow("different case") << QString("HELLO WORLD") << QString("hello world") << QList<bool>{true, true, true, true, true, true, true, true, true, true, true};
    QTest::newRow("lower case") << QString("hello world") << QString("hello world") << QList<bool>{true, true, true, true, true, true, true, true, true, true, true};
    QTest::newRow("extra spaces") << QString("  hello world ") << QString(" hello world   ") << QList<bool>{true, true, true, true, true, true, true, true, true, true, true};

    QTest::newRow("different phrases") << QString("hello world") << QString("world hello") << QList<bool>{false, false, false, true, false, true, false, false, false, true, false};
    QTest::newRow("without space") << QString("hello world") << QString("helloworld") << QList<bool>{true, true, true, true, true, false, false, false, false, false};
    QTest::newRow("letters from different languages") << QString("Hello world") << QString("Неllо wоrld") << QList<bool>{false, false, true, true, false, true, true, false, true, true, true};
}

void TestCore::testWordComparisonByLetters()
{
    QFETCH(QString, enteredWord);
    QFETCH(QString, word);
    QFETCH(QList<bool>, result);

    QCOMPARE(m_utils.wordComparisonByLetters(enteredWord, word), result);
}

void TestCore::testCheckFileFormat_data()
{
    QTest::addColumn<QString>("urlPath");
    QTest::addColumn<QString>("format");
    QTest::addColumn<bool>("result");

    QTest::newRow("filename test1.ini") << QDir::toNativeSeparators(QDir::currentPath() + "/tests/test1.ini") << QString("CSV") << false;
    QTest::newRow("filename test2.csv") << QDir::toNativeSeparators(QDir::currentPath() + "/tests/test2.csv") << QString("CSV") << true;
    QTest::newRow("filename test3.CSV") << QDir::toNativeSeparators(QDir::currentPath() + "/tests/test3.CSV") << QString("CSV") << true;
}

void TestCore::testCheckFileFormat()
{
    QFETCH(QString, urlPath);
    QFETCH(QString, format);
    QFETCH(bool, result);

    QCOMPARE(m_utils.checkFileFormat(urlPath, format), result);
}

void TestCore::testConnectToDataBase()
{
    QCOMPARE(m_database.connectToDataBase(), true);
}

void TestCore::testInserWordIntoTable_data()
{
    QTest::addColumn<QString>("word");
    QTest::addColumn<QString>("meaningWord");
    QTest::addColumn<bool>("result");

    QTest::newRow("insert - Hello") << QString("Hello") << QString("Привет") << true;
    QTest::newRow("insert - Go on foot") << QString("Go on foot") << QString("Идти пешком") << true;
    QTest::newRow("insert - English") << QString("English") << QString("Английский") << true;
    QTest::newRow("insert - To think") << QString("To think") << QString("Думать") << true;
    QTest::newRow("insert - Freezing") << QString("Freezing") << QString("Замораживание") << true;
}

void TestCore::testInserWordIntoTable()
{
    QFETCH(QString, word);
    QFETCH(QString, meaningWord);
    QFETCH(bool, result);

    QCOMPARE(m_database.inserWordIntoTable(word, meaningWord), result);
}

void TestCore::testUpdateWordInTable_data()
{
    QTest::addColumn<int>("id");
    QTest::addColumn<QString>("word");
    QTest::addColumn<QString>("meaningWord");
    QTest::addColumn<bool>("result");

    QTest::newRow("update - Hello") << 1 << QString("Hello") << QString("Hallo") << true;
    QTest::newRow("update - Go on foot") << 2 <<QString("Go on foot") << QString("Gehen") << true;
    QTest::newRow("update - English") << 3 << QString("English") << QString("Englisch") << true;
    QTest::newRow("update - To think") << 4 << QString("To think") << QString("Denken") << true;
    QTest::newRow("update - Freezing") << 5 <<QString("Freezing") << QString("Einfrieren") << true;
}

void TestCore::testUpdateWordInTable()
{
    QFETCH(int, id);
    QFETCH(QString, word);
    QFETCH(QString, meaningWord);
    QFETCH(bool, result);

    QCOMPARE(m_database.updateWordInTable(id, word, meaningWord), result);
}

void TestCore::testSelectWordsFromTable()
{
    const QStringList selectWordsFromTable = m_database.selectWordsFromTable();

    QCOMPARE(selectWordsFromTable.count(), 15);
    QVERIFY(selectWordsFromTable.contains("Hello"));
    QVERIFY(selectWordsFromTable.contains("Hallo"));
    QVERIFY(selectWordsFromTable.contains("Go on foot"));
    QVERIFY(selectWordsFromTable.contains("Gehen"));
    QVERIFY(selectWordsFromTable.contains("English"));
    QVERIFY(selectWordsFromTable.contains("Englisch"));
    QVERIFY(selectWordsFromTable.contains("To think"));
    QVERIFY(selectWordsFromTable.contains("Denken"));
    QVERIFY(selectWordsFromTable.contains("Freezing"));
    QVERIFY(selectWordsFromTable.contains("Einfrieren"));
    QVERIFY(!selectWordsFromTable.contains("test"));
    QVERIFY(!selectWordsFromTable.contains(""));
}

void TestCore::testStatisticsWord()
{
    QCOMPARE(m_database.statisticsWord(-1).count(), 0);
    QCOMPARE(m_database.statisticsWord(1), QList({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));
    QCOMPARE(m_database.statisticsWord(3), QList({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));
    QCOMPARE(m_database.statisticsWord(5), QList({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));
}

void TestCore::testInserStatisticsWord()
{
    QVERIFY(m_database.inserStatisticsWord(1, QList({false, false, false, false, false})));
    QCOMPARE(m_database.statisticsWord(1), QList({0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1}));
    QVERIFY(m_database.inserStatisticsWord(2, QList<bool>()));
    QCOMPARE(m_database.statisticsWord(2), QList({1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));
    QVERIFY(m_database.inserStatisticsWord(3, QList({true, true, true, true, true, true, true})));
    QCOMPARE(m_database.statisticsWord(3), QList({1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0}));
}

QTEST_APPLESS_MAIN(TestCore)

#include "testcore.moc"
