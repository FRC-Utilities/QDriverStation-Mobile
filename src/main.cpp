/*
 * Copyright (c) 2015-2017 Alex Spataru <alex_spataru@outlook.com>
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

#include <LibDS.h>
#include <QJoysticks.h>
#include <EventLogger.h>
#include <DriverStation.h>

#include <QtQml>
#include <QQuickStyle>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

const QString APP_VERSION = "17.05.2";
const QString APP_COMPANY = "Alex Spataru";
const QString APP_DSPNAME = "QDriverStation";
const QString APP_WEBSITE = "http://frc-utilities.github.io/";

int main (int argc, char* argv[])
{
    /* Set application information */
    QGuiApplication::setApplicationName (APP_DSPNAME);
    QGuiApplication::setOrganizationName (APP_COMPANY);
    QGuiApplication::setApplicationVersion (APP_VERSION);
    QGuiApplication::setOrganizationDomain (APP_WEBSITE);
    QGuiApplication::setAttribute (Qt::AA_EnableHighDpiScaling);

    /* Initialize application and DS */
    QGuiApplication app (argc, argv);
    DriverStation* driverstation = DriverStation::getInstance();
    DriverStation::getInstance()->start();
    DriverStation::declareQML();

    /* Use Universal style on Windows Phone */
#if defined Q_OS_WINRT
    bool material = false;
#else
    bool material = true;
#endif

    /* Define if we are working with a mobile OS */
#if defined Q_OS_ANDROID || defined Q_OS_WINRT || defined Q_OS_IOS
    bool mobile = true;
#else
    bool mobile = false;
#endif

    /* Set application style (based on saved settings) */
    QSettings settings;
    material = settings.value ("material", material).toBool();
    QQuickStyle::setStyle (material ? "Material" : "Universal");

    /* Load QML interface */
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty ("DS", driverstation);
    engine.rootContext()->setContextProperty ("IsMobile", mobile);
    engine.rootContext()->setContextProperty ("IsMaterial", material);
    engine.rootContext()->setContextProperty ("AppDspName", APP_DSPNAME);
    engine.rootContext()->setContextProperty ("AppVersion", APP_VERSION);
    engine.rootContext()->setContextProperty ("QJoysticks", QJoysticks::getInstance());
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    /* Exit if QML fails to load */
    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    /* Stop the DS when the application wants to quit */
    QObject::connect (&engine,     SIGNAL (quit()),
                      driverstation, SLOT (quitDS()));

    /* Enter application loop */
    return app.exec();
}
