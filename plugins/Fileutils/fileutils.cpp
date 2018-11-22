#include <QDebug>
#include <QtQml>
#include <QtQml/QQmlContext>
#include "fileutils.h"
#include "plugin.h"


Fileutils::Fileutils() {

}

void Fileutils::speak() {
    qDebug() << "hello world!";
}


void Fileutils::moveImage(QString source, QString destination)
{
    //qDebug() << Q_FUNC_INFO << "Copying" << source << "to" << destination;

    QDir dir(destination);
    if (!dir.exists())
        dir.mkpath(".");

    QFile::copy(source, destination);
}

/*
  Delete an image from a moment
*/
void Fileutils::removeImage(QString source)
{
    if(source.startsWith("file://"))
      source.remove("file://");

    QFile file(source);
    file.remove();
}

/*
   ok: the returned value, depends on the target device :
   '/home/phablet' when running on device
   '/tmp' when on Desktop. NOTE: '/tmp' is a folder inside clickable container, NOT host machine
 */
QString Fileutils::getHomePath()
{
    return QDir::homePath();
}

/*
  Get the list of images owned by a moment
*/
QStringList Fileutils::getMomentImages(QString path)
{
    //qDebug() << "Path" << path;
    QStringList list;

    if(path.isEmpty())
      return list;

    if(path.startsWith("file://"))
       path.remove("file://");

    QDir dir(path);
    list = dir.entryList(QDir::Files);
    //qDebug() << "Files" << list;

    return list;
}

/*
  Remove the moment and his associated images
*/
void Fileutils::deleteMomentFolder(QString path)
{
    QStringList list;

    if(path.startsWith("file://"))
       path.remove("file://");

    QDir dir(path);
    dir.removeRecursively();
    //list = dir.entryList(QDir::Files);
}
