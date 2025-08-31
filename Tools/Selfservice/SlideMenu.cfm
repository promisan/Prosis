<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="Attributes.functionName" default="Budget">

<cfquery name="Link"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM PortalLinks L,Ref_ModuleControl R
		WHERE L.SystemFunctionId = R.SystemFunctionId	
		AND FunctionName = '#Attributes.FunctionName#' 
		AND L.Class = 'CustomLeft'		
		ORDER BY ListingOrder
	</cfquery>
	
<cfif link.recordcount gte "1">

<script language="JavaScript">
	
	YOffset=150; // no quotes!!
	XOffset=0;
	staticYOffset=30; // no quotes!!
	slideSpeed=30 // no quotes!!
	waitTime=300; // no quotes!! this sets the time the menu stays out for after the mouse goes off it.
	menuBGColor="silver";
	menuIsStatic="no"; //this sets whether menu should stay static on the screen
	menuWidth=180; // Must be a multiple of 10! no quotes!!
	menuCols=2;
	hdrFontFamily="verdana";
	hdrFontSize="1";
	hdrFontColor="white";
	hdrBGColor="#4876c1";
	hdrAlign="left";
	hdrVAlign="center";
	hdrHeight="20";
	linkFontFamily="verdana";
	linkFontSize="1";
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
	barText="Reference"; // <IMG> tag supported. Put exact html for an image to show.
	
	ssmItems[0]=["Reference"] //create header
	
	<cfoutput query="Link">
		
		ssmItems[#currentrow#]=["#Description#", "#LocationURL#","_blank"] //create header
	
	</cfoutput>
		
	buildMenu();

</script>

</cfif>	

