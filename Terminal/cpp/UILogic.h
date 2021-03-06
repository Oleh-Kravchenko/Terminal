#ifndef UILOGIC_H
#define UILOGIC_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include "UIMessenger.h"

class QQuickWindow;
class QQmlApplicationEngine;
class UIAssistant;
class UIBackend;
class VideoPlayer;

typedef std::function<void(QVariant const&)> Handler;
typedef QMap<QString,Handler> HandlerMap;

class UILogic : public QObject
{
    Q_OBJECT

public:
    explicit UILogic(QQmlApplicationEngine* apEngine, VideoPlayer* apUIPlayer, UIAssistant* apUIAssistant, UIBackend* apUIBackend = nullptr, QObject *parent = nullptr);

    QVariant getQMLProperty(QString const& aParamID);
    void setQMLProperty(QString const& aParamID, QVariant const& aValue);
    void setContextProperty(const QString &aName, QObject *aValue);    

    QString showMessage(UIMessenger::MessageType aType, const QString aText, int aWaitingTime = -1, bool isNeedToWaitAnswer = true);
    QString showMessage(const QString& aIcon, const QString aCaption, const QString& aText, const QList<MessageButton> aButtons, int aWaitingTime = -1, bool isNeedToWaitAnswer = true);
    void hideMessage();

signals:
    void signalUICreated();

protected:
    QQmlApplicationEngine* mpEngine;
    UIAssistant* mpUIAssistant;
    UIBackend* mpUIBackend;
    UIMessenger* mpMessenger;
    VideoPlayer* mpUIPlayer;
    QQuickWindow* mpQuickWindow;
    HandlerMap  mActionHandlers;
    HandlerMap  mParamHandlers;

    virtual void defaultHandler(QString aParam, QVariant aValue);
    void executeHandler(HandlerMap& aHandlers, QString aParam, QVariant aValue);

    virtual void initializeProperties();
    virtual void initializeConnections();
    virtual void initializeHandlers();

private slots:
    void slotUIParameterChanged(QString aParam, QVariant aValue);
    void slotUIAction(QString aParam, QVariant aValue);    
};

#endif // UILOGIC_H
