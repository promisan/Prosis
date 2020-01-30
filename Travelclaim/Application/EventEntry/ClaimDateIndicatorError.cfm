
<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cf_message 
message="Problem. Portal could not determine your DSA entitlements. Please contact your administrator <br> Error code: #URL.id#" 
return="No">
	