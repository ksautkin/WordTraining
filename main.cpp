#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QStandardPaths>
#include <QFile>
#include <QTextStream>

#include "database.h"
#include "listmodel.h"
#include "utils.h"
#include "settingsmanager.h"

#ifndef QT_DEBUG
QScopedPointer<QFile>   logFile;

void messageHandler(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    QTextStream out(logFile.data());
    out << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss ");
    switch (type)
    {
    case QtInfoMsg:     out << "Info "; break;
    case QtDebugMsg:    out << "Debug "; break;
    case QtWarningMsg:  out << "Warning "; break;
    case QtCriticalMsg: out << "Critical "; break;
    case QtFatalMsg:    out << "Fatal "; break;
    }
    out << msg << Qt::endl;
}
#endif

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QCoreApplication::setApplicationName("Word Training");
    QCoreApplication::setApplicationVersion("1.0.1");

#ifndef QT_DEBUG
    logFile.reset(new QFile(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
                            "/" + QDateTime::currentDateTime().toString("yyyy-MM-dd") + ".log"));
    logFile->open(QFile::Append | QFile::Text);
    qInstallMessageHandler(messageHandler);
#endif

    QQuickStyle::setStyle("Basic");
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/WordTraining/Main.qml"_qs);

    SettingsManager settingsManager;
    engine.rootContext()->setContextProperty("settingsManager", &settingsManager);

    DataBase database(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    database.connectToDataBase();
    database.enableRandomSequence(settingsManager.checkBoxValue("randomSequence"));
    engine.rootContext()->setContextProperty("database", &database);

    Utils utils;
    engine.rootContext()->setContextProperty("utils", &utils);

    ListModel* model = new ListModel();
    engine.rootContext()->setContextProperty("wordsModel", model);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
