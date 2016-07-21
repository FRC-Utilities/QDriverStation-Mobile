/*
 * Copyright (c) 2015-2016 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <QtQml>
#include <QQuickStyle>
#include <QGuiApplication>
#include <DriverStation.h>
#include <QQmlApplicationEngine>

/* They are going to kill me for pulling out this name */
const QString APP_VERSION = "16.07";
const QString APP_COMPANY = "Alex Spataru";
const QString APP_DSPNAME = "Kickass Driver Station";
const QString APP_WEBSITE = "http://frc-utilities.github.io/kickass";

int main (int argc, char* argv[]) {
    QGuiApplication::setApplicationName (APP_DSPNAME);
    QGuiApplication::setOrganizationName (APP_COMPANY);
    QGuiApplication::setApplicationVersion (APP_VERSION);
    QGuiApplication::setOrganizationDomain (APP_WEBSITE);
    QGuiApplication::setAttribute (Qt::AA_EnableHighDpiScaling);

    QGuiApplication app (argc, argv);
    DriverStation* driverstation = DriverStation::getInstance();

#if defined Q_OS_ANDROID
    bool material = true;
#else
    bool material = false;
#endif

    QSettings settings;
    material = settings.value ("material", material).toBool();
    QQuickStyle::setStyle (material ? "Material" : "Universal");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty ("IsMaterial", material);
    engine.rootContext()->setContextProperty ("DriverStation", driverstation);
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    return app.exec();
}
