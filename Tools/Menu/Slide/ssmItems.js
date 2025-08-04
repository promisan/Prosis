/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
<!--

/*
Configure menu styles below
NOTE: To edit the link colors, go to the STYLE tags and edit the ssm2Items colors
*/
YOffset=150; // no quotes!!
XOffset=0;
staticYOffset=30; // no quotes!!
slideSpeed=30 // no quotes!!
waitTime=200; // no quotes!! this sets the time the menu stays out for after the mouse goes off it.
menuBGColor="silver";
menuIsStatic="yes"; //this sets whether menu should stay static on the screen
menuWidth=150; // Must be a multiple of 10! no quotes!!
menuCols=2;
hdrFontFamily="calibri";
hdrFontSize="2";
hdrFontColor="white";
hdrBGColor="#4876c1";
hdrAlign="left";
hdrVAlign="center";
hdrHeight="20";
linkFontFamily="calibri";
linkFontSize="2";
linkBGColor="white";
linkOverBGColor="#FFFF99";
linkTarget="_top";
linkAlign="Left";
barBGColor="#305186";
barFontFamily="calibri";
barFontSize="1";
barFontColor="white";
barVAlign="center";
barWidth=15; // no quotes!!
barText="More Views"; // <IMG> tag supported. Put exact html for an image to show.

///////////////////////////

// ssmItems[...]=[name, link, target, colspan, endrow?] - leave 'link' and 'target' blank to make a header
ssmItems[0]=["Menu"] //create header
ssmItems[1]=["Dynamic Drive", "http://www.dynamicdrive.com", ""]
ssmItems[2]=["What's New", "http://www.dynamicdrive.com/new.htm",""]
ssmItems[3]=["What's Hot", "http://www.dynamicdrive.com/hot.htm", ""]
ssmItems[4]=["Message Forum", "http://www.codingforums.com", "_new"]
ssmItems[5]=["Submit Script", "http://www.dynamicdrive.com/submitscript.htm", ""]
ssmItems[6]=["Link to Us", "http://www.dynamicdrive.com/link.htm", ""]

ssmItems[7]=["FAQ", "http://www.dynamicdrive.com/faqs.htm", "", 1, "no"] //create two column row
ssmItems[8]=["Email", "http://www.dynamicdrive.com/contact.htm", "",1]

ssmItems[9]=["External Links", "", ""] //create header
ssmItems[10]=["JavaScript Kit", "http://www.javascriptkit.com", ""]
ssmItems[11]=["Freewarejava", "http://www.freewarejava.com", ""]
ssmItems[12]=["Coding Forums", "http://www.codingforums.com", ""]

buildMenu();

//-->