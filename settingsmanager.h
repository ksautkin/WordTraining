#pragma once

#include <QObject>
#include <QVariantHash>

class SettingsManager : public QObject
{
    Q_OBJECT

private:
    QVariantHash m_settingValues;

private:
    void        loadSettings();
    void        saveSettings();

public:
    explicit    SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    Q_INVOKABLE bool    checkBoxValue(const QString& key);
    Q_INVOKABLE void    setCheckBoxValue(const QString& key, const QString& value);
};

