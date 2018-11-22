/****************************************************************************
** Meta object code from reading C++ file 'fileutils.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../plugins/Fileutils/fileutils.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'fileutils.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Fileutils_t {
    QByteArrayData data[11];
    char stringdata0[110];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Fileutils_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Fileutils_t qt_meta_stringdata_Fileutils = {
    {
QT_MOC_LITERAL(0, 0, 9), // "Fileutils"
QT_MOC_LITERAL(1, 10, 9), // "moveImage"
QT_MOC_LITERAL(2, 20, 0), // ""
QT_MOC_LITERAL(3, 21, 6), // "source"
QT_MOC_LITERAL(4, 28, 11), // "destination"
QT_MOC_LITERAL(5, 40, 11), // "removeImage"
QT_MOC_LITERAL(6, 52, 15), // "getMomentImages"
QT_MOC_LITERAL(7, 68, 4), // "path"
QT_MOC_LITERAL(8, 73, 18), // "deleteMomentFolder"
QT_MOC_LITERAL(9, 92, 11), // "getHomePath"
QT_MOC_LITERAL(10, 104, 5) // "speak"

    },
    "Fileutils\0moveImage\0\0source\0destination\0"
    "removeImage\0getMomentImages\0path\0"
    "deleteMomentFolder\0getHomePath\0speak"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Fileutils[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    2,   44,    2, 0x02 /* Public */,
       5,    1,   49,    2, 0x02 /* Public */,
       6,    1,   52,    2, 0x02 /* Public */,
       8,    1,   55,    2, 0x02 /* Public */,
       9,    0,   58,    2, 0x02 /* Public */,
      10,    0,   59,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    3,    4,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::QStringList, QMetaType::QString,    7,
    QMetaType::Void, QMetaType::QString,    7,
    QMetaType::QString,
    QMetaType::Void,

       0        // eod
};

void Fileutils::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Fileutils *_t = static_cast<Fileutils *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->moveImage((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 1: _t->removeImage((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 2: { QStringList _r = _t->getMomentImages((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 3: _t->deleteMomentFolder((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: { QString _r = _t->getHomePath();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 5: _t->speak(); break;
        default: ;
        }
    }
}

const QMetaObject Fileutils::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Fileutils.data,
      qt_meta_data_Fileutils,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *Fileutils::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Fileutils::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Fileutils.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Fileutils::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
