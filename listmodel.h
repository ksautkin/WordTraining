#pragma once

#include <QObject>
#include <QSqlQueryModel>
#include <QSortFilterProxyModel>

class ListModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    enum Roles
    {
        IdRole = Qt::UserRole + 1,      // id
        WordRole,                       // word
        MeaningWordRole,                // meaning word
    };

public:
    explicit                 ListModel(QObject* parent = nullptr);
    QVariant                 data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE int          count();
    Q_INVOKABLE void         updateModel();
    Q_INVOKABLE int          getId(int row);
    Q_INVOKABLE QString      getWord(int row);

protected:
    QHash<int, QByteArray>   roleNames() const override;
};
