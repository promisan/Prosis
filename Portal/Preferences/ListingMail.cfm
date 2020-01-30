<cfoutput>
<cfsavecontent variable="myquery">
	SELECT * 
	FROM   UserMail 
	WHERE  Account = '#SESSION.acc#'  
	AND    Source != 'Listing'
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label      = "Source",                 
					field      = "Source",
					search     = "text"}>
					
<cfset fields[2] = {label      = "Address",                  
					field      = "MailAddress", 
					special    = "Mail",
					search     = "text"}>
					
<cfset fields[3] = {label      = "Subject", 					
					field      = "MailSubject",
					search     = "text"}>
					
<cfset fields[4] = {label      = "Sent",  					
					field      = "MailDateSent",
					formatted  = "dateformat(MailDateSent,CLIENT.DateFormatShow)",
					search     = "date"}>
	
							
<cf_listing
	    header        = "<b><font size='2'>Mail Log</font></b>"
	    box           = "setting"
		link          = "#SESSION.root#/Portal/Preferences/ListingMail.cfm"
	    html          = "No"
		listquery     = "#myquery#"
		listorder     = "MailDateSent"
		headercolor   = "ffffff"
		FilterShow    = "Yes"
		ExcelShow     = "Yes"
		listlayout    = "#fields#"
		drillmode     = "embed" <!--- embed|window|dialog|standard --->
		drillargument = "540;600;false;false"	
		drilltemplate = "System/Access/User/Audit/ListingMailDetail.cfm"
		drillkey      = "MailId">	