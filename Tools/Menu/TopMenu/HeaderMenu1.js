/*
   Deluxe Menu Data File
   Created by Deluxe Tuner v2.0
   http://deluxe-menu.com
*/


// -- Deluxe Tuner Style Names
var itemStylesNames=[];
var menuStylesNames=[];
// -- End of Deluxe Tuner Style Names

//--- Common
var isHorizontal=1;
var smColumns=1;
var smOrientation=0;
var smViewType=0;
var dmRTL=0;
var pressedItem=-2;
var itemCursor="pointer";
var itemTarget="_self";
var statusString="link";
//--- var blankImage="testing1.files/blank.gif";

//--- Dimensions
var menuWidth="";
var menuHeight="";
var smWidth="";
var smHeight="";

//--- Positioning
var absolutePos=0;
var posX="0";
var posY="0";
var topDX=0;
var topDY=1;
var DX=1;
var DY=0;

//--- Font
var fontStyle="normal 10px Verdana";
var fontColor=["002350","#002350"];
var fontDecoration=["none","none"];
var fontColorDisabled="#AAAAAA";

//--- <font color="#D9EDFF"></font>

//--- Appearance
var menuBackColor   = "#f6f6f6";
var menuBackImage   = "";
var menuBackRepeat  = "repeat";
var menuBorderColor = "#f0f0f0";
var menuBorderWidth = 0;
var menuBorderStyle = "solid";

//--- Item Appearance
var itemBackColor   = ["e9e9e9","D9EDFF"];
var itemBackImage   = ["",""];
var itemBorderWidth = 1;
var itemBorderColor = ["silver","gray"];
var itemBorderStyle = ["solid","solid"];
var itemSpacing     = "2";
var itemPadding     = "2";
var itemAlignTop    = "left";
var itemAlign       = "left";
var subMenuAlign    = "right";

//--- Icons
var iconTopWidth=16;
var iconTopHeight=16;
var iconWidth=16;
var iconHeight=16;
var arrowWidth=8;
var arrowHeight=8;
//--- var arrowImageMain=["testing1.files/arrv_red_1.gif","testing1.files/arrv_white_1.gif"];
//--- var arrowImageSub=["testing1.files/arr_red_1.gif","testing1.files/arr_white_1.gif"];

//--- Separators
//--- var separatorImage="testing1.files/sep_grey.gif";
var separatorWidth="100%";
var separatorHeight="1";
var separatorAlignment="left";
var separatorVImage="";
var separatorVWidth="3";
var separatorVHeight="100%";
var separatorPadding="0px";

//--- Floatable Menu
var floatable=0;
var floatIterations=6;
var floatableX=1;
var floatableY=1;

//--- Movable Menu
var movable=0;
var moveWidth=12;
var moveHeight=20;
var moveColor="#DECA9A";
var moveImage="";
var moveCursor="move";
var smMovable=0;
var closeBtnW=15;
var closeBtnH=15;
var closeBtn="";

//--- Transitional Effects & Filters
var transparency="99";
var transition=5;
var transOptions="";
var transDuration=100;
var transDuration2=50;
var shadowLen=3;
var shadowColor="#B0B0B0";
var shadowTop=0;

//--- CSS Support (CSS-based Menu)
var cssStyle=0;
var cssSubmenu="";
var cssItem=["",""];
var cssItemText=["",""];

//--- Advanced
var dmObjectsCheck=0;
var saveNavigationPath=1;
var showByClick=0;
var noWrap=1;
//--- var pathPrefix_img="";
var pathPrefix_link="";
var smShowPause=200;
var smHidePause=1000;
var smSmartScroll=1;
var smHideOnClick=1;
var dm_writeAll=0;

//--- AJAX-like Technology
var dmAJAX=0;
var dmAJAXCount=0;

//--- Dynamic Menu
var dynamic=0;

//--- Keystrokes Support
var keystrokes=1;
var dm_focus=1;
var dm_actKey=113;
 
/*
var menuItems = [

    ["Home","", , , , , , , , ],
    ["Product Info","", , , , , , , , ],
        ["|What's New","", , , , , , , , ],
        ["|Features","", , , , , , , , ],
            ["||Easy Installation and Customization","", , , , , , , , ],
            ["||Dynamic Menu (Modifications 'On-The-Fly')","", , , , , , , , ],
            ["||Keystrokes Support","", , , , , , , , ],
            ["||Cross-frame Support","", , , , , , , , ],
            ["||Popup Mode (Contextual Menus)","", , , , , , , , ],
            ["||Smart Scrollable Submenus","", , , , , , , , ],
            ["||CSS Support (CSS-Based Menus)","", , , , , , , , ],
            ["||Objects Overlapping","", , , , , , , , ],
            ["||Filters and Transitional Effects","", , , , , , , , ],
            ["||Individual Styles","", , , , , , , , ],
            ["||Movable & Floatable Menus","", , , , , , , , ],
            ["||Multilevel & Multicolumn Menus","", , , , , , , , ],
            ["||Several Menus on One Page","", , , , , , , , ],
            ["||etc.","", , , , , , , , ],
        ["|Documentation","", , , , , , , , ],
            ["||Description of Files","", , , "Different .js files are loaded according to selected menu features.", , , , , ],
            ["||Parameters Info","", , , "A lot of flexible parameters get you a fully customizable appearance of your menus.", , , , , ],
            ["||How To Setup","", , , "Add several rows of code within html page - your menu is ready! Use Deluxe Tuner - visual interface that allows you to create your menus easily and in no time.", , , , , ],
            ["||JavaScript API","", , , "Special JavaScript API for changing menu 'on-the-fly', without page reloading!", , , , , ],
        ["|Browsers List","", , , , , , , , ],
            ["||Internet Explorer","", , , , , , , , ],
            ["||Firefox","", , , , , , , , ],
            ["||Mozilla","", , , , , , , , ],
            ["||Netscape","", , , , , , , , ],
            ["||Opera","", , , , , , , , ],
            ["||Safari","", , , , , , , , ],
            ["||Konqueror","", , , , , , , , ],
        ["|-","", , , , , , , , ],
        ["|Deluxe Tuner Application","", , , "Deluxe Tuner is a powerful application that gives you the full control over creation and customization of Deluxe Menu. It has a user-friendly interface that allows you to create your menus easily and in no time.", , , , , ],
    ["Menu Samples","", , , , , , , , ],
        ["|Sample 1","", , , , , , , , ],
        ["|Sample 2 (disabled)","", , , , "_", , , , ],
        ["|Sample 3","", , , , , , , , ],
        ["|Sample 4","", , , , , , , , ],
        ["|Sample 5","", , , , , , , , ],
        ["|Sample 6","", , , , , , , , ],
        ["|Sample 7","", , , , , , , , ],
        ["|Sample 8","", , , , , , , , ],
        ["|Sample 9","", , , , , , , , ],
    ["Purchase","", , , , "_blank", , , , ],
        ["|Single Website License","", , , "Single website license allows you to use the menu on one Internet or Intranet site.", , , , , ],
        ["|Multiple Website License","", , , "Multiple website license allows you to use the menu on any Internet or Intranet sites.", , , , , ],
        ["|Developer License","", , , "Developer license allows you to use the menu on any Internet or Intranet sites and redistribute as a part of your own applications.", , , , , ],
        ["|-","", , , , , , , , ],
        ["|Free Non-Profit License","", , , "Non-profit license allows you to use the menu on 1 NON-PROFIT INTERNET website (NOT Intranet/local website).", , , , , ],
    ["Contacts","", , , , , , , , ],
];
*/

dm_init();