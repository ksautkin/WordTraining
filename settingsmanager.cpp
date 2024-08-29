#include "settingsmanager.h"
#include <QStandardPaths>
#include <QSettings>

void SettingsManager::loadSettings()
{
    const QString settingsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.ini";
    const QSettings settingsFile(settingsFilePath, QSettings::IniFormat);
    const QStringList keys = settingsFile.allKeys();

    QString loadKeysValues;
    for (const QString& key : keys)
    {
        loadKeysValues.push_back(QString("{%1:%2} ").arg(key, settingsFile.value(key).toString()));
        m_settingValues.insert(key, settingsFile.value(key));
    }
    qInfo() << QString("Loaded settings: %1").arg(loadKeysValues);
}

void SettingsManager::saveSettings()
{
    const QString settingsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.ini";
    QSettings settingsFile(settingsFilePath, QSettings::IniFormat);

    QString saveKeysValues;
    for (auto iter = m_settingValues.begin(); iter != m_settingValues.end(); ++iter)
    {
        saveKeysValues.push_back(QString("{%1:%2} ").arg(iter.key(), iter.value().toString()));
        settingsFile.setValue(iter.key(), iter.value());
    }
    qInfo() << QString("Saved settings: %1").arg(saveKeysValues);
}

SettingsManager::SettingsManager(QObject *parent)
    : QObject{parent}
{
    loadSettings();
}

SettingsManager::~SettingsManager()
{
    saveSettings();
}

bool SettingsManager::checkBoxValue(const QString &key)
{
    return m_settingValues.value(key, false).toBool();
}

void SettingsManager::setCheckBoxValue(const QString &key, const QString &value)
{
    m_settingValues.insert(key, value);
    qInfo() << QString("Set check box value: {%1:%2}").arg(key, value);
}
