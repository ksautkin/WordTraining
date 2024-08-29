#include "listmodel.h"
#include "database.h"

ListModel::ListModel(QObject *parent)
    : QSqlQueryModel{parent}
{
    updateModel();
}

QVariant ListModel::data(const QModelIndex& item, int role) const
{
    QModelIndex modelIndex = QSqlQueryModel::index(item.row(), role - Qt::UserRole - 1);
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> ListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]           = "id";
    roles[WordRole]         = "word";
    roles[MeaningWordRole]  = "meaningWord";
    return roles;
}

int ListModel::count()
{
    return rowCount();
}

void ListModel::updateModel()
{
    qInfo() << QString("Update model");
    setQuery(QString("SELECT %1, %2, %3 "
                     "FROM %4 ").arg(DataBase::idColumn, DataBase::wordColumn, DataBase::meaningWordColumn, DataBase::tableName));
}

int ListModel::getId(int row)
{
    qInfo() << QString("Get id: %1").arg(QString::number(row));
    return data(QSqlQueryModel::index(row, 0), IdRole).toInt();
}

QString ListModel::getWord(int row)
{
    qInfo() << QString("Get row: %1").arg(QString::number(row));
    return data(QSqlQueryModel::index(row, 0), WordRole).toString();
}


