import QtQuick 2.0
import QtQuick.Window 2.0
import CustomControls 1.0

Window {
    id: root
    visible: true
    x: 0
    y: 0
    width: MyStyle.screenWidth
    height: MyStyle.screenHeight
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    title: qsTr("Innotrans") + cppLinguist.emptyString
    currentMenu: MyStyle.menuStart

    flags: Qt.FramelessWindowHint// | Qt.Window

    property string currentMenu

	signal signalUIParameterChaged(string name, variant value)
	signal signalUIAction(string name, variant value)
    signal signalMessageAnswer(string button);
    signal signalOnEnterMenu(string name)
    signal signalOnExitMenu(string name)

    function showMessage( aDataMap, aButtonsList )
    {
        message.visible = true;
        message.setData(aDataMap, aButtonsList);
        message.currentMenu = currentMenu;
        //currentMenu = "MESSAGE_EXT"
    }

    function hideMessage( )
    {
        //currentMenu = message.currentMenu;
        message.visible = false;
    }

    function clickedMessage( aButton )
    {
        signalMessageAnswer(aButton)
        hideMessage();
    }

    function goTo( aMenuName )
	{
        currentMenu = aMenuName
	}

	function uiParameterChanged(aName,aValue,aData)
	{
		console.log("UIParameterChanged: [",aName,"] [",aValue,"] [",aData,"]")
		signalUIParameterChaged(aName,aValue)
	}

	function uiAction(aName,aValue)
	{
		console.log("UIAction: [",aName,"] [",aValue,"]")
		signalUIAction(aName,aValue)
	}

	Rectangle{
		anchors.fill: parent
		color: "#ff0000"

		Component.onCompleted:
		{
            message.signalUIAction.connect(root.signalUIAction);
            message.signalClicked.connect(root.hideMessage);
			for(var i = 0; i < children.length; ++i)
			{
                if(children[i].objectName == "MENU")
				{
					//console.log(children[i].name);
                    children[i].signalOnExit.connect(root.signalOnExitMenu);
                    children[i].signalOnEnter.connect(root.signalOnEnterMenu);
					children[i].signalGoTo.connect(root.goTo);
					children[i].signalUIAction.connect(root.uiAction);
					children[i].signalUIParameterChaged.connect(root.uiParameterChanged);
				}
			}
		}

		children: [
            TMenuStart				{ id: menuStart; visible: currentMenu == name && !message.visible; enabled: visible},
            TMenuCard				{ id: menuCard; visible: currentMenu == name && !message.visible; enabled: visible },
            TMenuPin				{ id: menuPin; visible: currentMenu == name && !message.visible; enabled: visible },
            TMenuSuccess        	{ id: menuSuccess; visible: currentMenu == name && !message.visible; enabled: visible },
            TMenuError				{ id: menuError; visible: currentMenu == name && !message.visible; enabled: visible },
            TMenuInformation		{ id: menuInformation; visible: currentMenu == name && !message.visible; enabled: visible },
            TMessage                { id: message; visible: false; enabled: visible }
		]
	}
}
