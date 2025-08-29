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
<!DOCTYPE HTML> 
<html>
	<head>
		<meta charset="utf-8" />
		
		<!--- Stylesheet --->
		<link rel="stylesheet" charset="utf-8" href="Styles/Animation.css" id="defaultStyle">
		
		<!--- jQuery and modernizr --->
		<cfoutput>
		   	<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/JQuery/JQuery.js"></script>
			<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/Modernizr/modernizr.js"></script>
		</cfoutput>
		
	</head>
	
	<body>
		
		<div class="clsCurtain">
			<div class="clsCurtainTextBottom">
				<cfquery name="Init" 
					datasource="AppsInit">
					SELECT * 
					FROM   Parameter
					WHERE  HostName = '#cgi.http_host#'		
				</cfquery>

				<cfoutput>
					<span style="font-weight:bold;">#ucase(SESSION.welcome)# - #ucase(CLIENT.Servername)#</span><br>
					<cf_tl id="Release"> #Init.ApplicationRelease#
				</cfoutput>
			</div>
		</div>

		<div class="clsLogo" style="background-image:url(Images/logowhite.png);"></div>

		<div class="clsElement">
			<div class="clsElementImage" style="background-image:url(Images/eye.gif);"></div>
		</div>
		<div class="clsElementText"></div>
		
		<div class="clsElement">
			<div class="clsElementImage" style="background-image:url(Images/profile.gif);"></div>
		</div>
		<div class="clsElementText">
			<cf_tl id="Human Resources">
		</div>
		
		<div class="clsElement">
			<div class="clsElementImage" style="background-image:url(Images/truck.gif);"></div>
		</div>
		<div class="clsElementText">
			<cf_tl id="Supply Chain Management">
		</div>
		
		<div class="clsElement">
			<div class="clsElementImage" style="background-image:url(Images/money.gif);"></div>
		</div>
		<div class="clsElementText">
			<cf_tl id="Financials">
		</div>
		
		<div class="clsElement">
			<div class="clsElementImage" style="background-image:url(Images/calendar.gif);"></div>
		</div>
		<div class="clsElementText">
			<cf_tl id="Project Management">
		</div>
			
		<!--- Initialization --->
		<script type="text/javascript" charset="utf-8" src="Scripts/Animation.js"></script>
		
	</body>
	
</html>