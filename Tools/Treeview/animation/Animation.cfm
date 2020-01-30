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