<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Retrieve the UID --->
<cfinclude template="../../../getUID.cfm">
<!--- Load App Vars from Memory --->
<cfmodule template="../../../serializeAttributes.cfm" method="load" uid="#uid#">

<cfif find("MSIE",cgi.user_agent)>
	<cfset browser="ie">
<cfelse>
	<cfset browser="gecko">
</cfif>

<cfoutput>
##outerContainer {
	position:relative;
	width:#attributes.width#px;
	height:#attributes.height#px;
	background-color:buttonface;
	border-bottom:1px solid ##848284;
	border-right:1px solid ##848284;
	border-top:1px solid white;
	border-left:1px solid white;
	padding:5px;
}

##fileUploadList {
	position:relative;
	background-color:white;
	border-top:1px solid ##848284;
	overflow:auto;
	<cfif browser eq "ie">margin:5px;</cfif>
	border-left:1px solid ##848284;
	border-bottom:1px solid white;
	border-right:1px solid white;
	height:<cfif browser eq "gecko">#evaluate(attributes.height-120)#<cfelse>#evaluate(attributes.height-80)#</cfif>px;
}

##buttonContainer {
	position:relative;
}

##uploadButtonContainer {
	position:relative;
	float:right;
}

##cancelButtonContainer {
	position:relative;
	float:left;
}

.aRow {
 border-bottom:1px solid buttonface;
 padding-left:2px;
}

##inputContainer {
	position:relative;
	padding:5px;
	height:40px;
}

.hiddenInput {
	width:0px;
	position:absolute;
	top:5px;
	left:<cfif browser eq "gecko">#evaluate(attributes.width-105)#<cfelse>#evaluate(attributes.width-98)#</cfif>px;
	height:23px;
}

.hidingDiv {
	background-color:buttonface;
	position:absolute;
	top:5px;
	left:1px;
	width:<cfif browser eq "gecko">#evaluate(attributes.width-77)#<cfelse>#evaluate(attributes.width-95)#</cfif>px;
	height:25px;
	z-Index:100;
	font-size:12px;
	padding-top:5px;
	font-family:arial;
	vertical-align:middle;
}

marquee {
	border:		1px solid ButtonShadow;
	background:	Window;
	height:		12px;
	font-size:	1px;
	margin:		1px;
	width:		300px;
	-moz-binding:	url("marquee-binding.xml##marquee");
	-moz-box-sizing:	border-box;
	display:		block;
	overflow:		hidden;
}

marquee span {
	height:			18px;
	margin:			1px;
	width:			8px;
	background:		Highlight;
	float:			left;
	font-size:		1px;
}

.progressBarHandle-0 {
	filter:		alpha(opacity=20);
	-moz-opacity:	0.20;
}

.progressBarHandle-1 {
	filter:		alpha(opacity=40);
	-moz-opacity:	0.40;
}

.progressBarHandle-2 {
	filter:		alpha(opacity=60);
	-moz-opacity:	0.6;
}

.progressBarHandle-3 {
	filter:		alpha(opacity=80);
	-moz-opacity:	0.8;
}

.progressBarHandle-4 {
	filter:		alpha(opacity=100);
	-moz-opacity:	1;	
}

##uploadFrame {
	position:absolute;
	top:1px;
	left:1px;
	visibility:hidden;
}
</cfoutput>