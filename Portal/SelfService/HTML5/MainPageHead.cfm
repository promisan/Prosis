<head>

    <title><cfoutput>#Portal.FunctionMemo#</cfoutput></title>
	<!--- Sets the viewport zoom to 100% and disables the resizing --->
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
	
	<!--- Hides the address bar in iOS devices --->
	<meta name="apple-mobile-web-app-capable" content="yes" />
	
	<!--- Sets the latest mode for IE --->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	
	<cfoutput>
		<!--- FavIcon --->
		<link href="#parameterImgFavIcon#" rel="shortcut icon" type="image/x-icon"/>
	
		<!--- CSS --->
		<link rel="stylesheet" charset="utf-8" href="#session.root#/Portal/Backoffice/HTML5/css/HTML5/portal.css?ts=#gettickcount()#" id="mainStyle" />
		
		<cfif qCustomCSS.recordCount eq 1>
			<cfif trim(qCustomCSS.functionDirectory) neq "" and trim(qCustomCSS.functionPath) neq "">
				<!--- Custom CSS --->
				<link rel="stylesheet" charset="utf-8" href="#session.root#/#qCustomCSS.functionDirectory##qCustomCSS.functionPath#?ts=#gettickcount()#" id="customStyle" />
			</cfif>
		</cfif>
		
		<!--- Preventing cache for security --->
		<cf_preventCache>
		
		<!--- Scripts --->
		<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/jQuery/jquery.js"></script>
	    <script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/Modernizr/modernizr.js"></script>
		<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/Hammer/jquery.hammer.js"></script>
		<script type="text/javascript" charset="utf-8" src="#session.root#/Portal/SelfService/HTML5/Scripts/login.js"></script>
		
		<cf_systemScript>
		<cf_pictureProfileStyle>

	</cfoutput>
	
</head>