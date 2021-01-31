
<cfoutput>
					
	<cfsavecontent variable="myquery">		
	   
		SELECT *, 
		CASE 
			WHEN GETDATE() >= DATEADD(hh,-EventDisplayDuration, EventDateEffective) AND GETDATE() <= EventDateExpiration THEN 'Ongoing'
			WHEN GETDATE() > EventDateExpiration THEN 'Previous'
			WHEN GETDATE() < DATEADD(hh,-EventDisplayDuration, EventDateEffective) THEN 'Future'
		END Status
		FROM   SystemEvent
				
	</cfsavecontent>							

</cfoutput>
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
				
<cfset itm = itm+1>						
<cf_tl id="Title" var="vTitle">
<cfset fields[itm] = {label       = "#vTitle#",                  
					  field       = "Title",					
					  search      = "text"}>	
					  
<cfset itm = itm+1>
<cf_tl id="Type" var="vType">
<cfset fields[itm] = {label       = "#vType#",
					  field       = "Type",	
					  filtermode  = "2",				
					  search      = "text"}>						
							
<cfset itm = itm+1>						
<cf_tl id="Layout" var="vLayout">
<cfset fields[itm] = {label       = "#vLayout#",
					  field       = "Layout",		
					  filtermode  = "2",
					  search      = "text"}>						
	   
<cfset itm = itm+1>						
<cf_tl id="Effective" var="vDateEffective">

<cfset fields[itm] = {label       = "#vDateEffective#",
					  field       = "EventDateEffective",					
					  search      = "date",
					   align      = "center",		
					  formatted   = "DateFormat(EventDateEffective,CLIENT.DateFormatShow)"}>	

<cfset itm = itm+1>					  
<cfset fields[itm] = {label       = "",
					  field       = "EventDateEffective",		
					  align       = "center",										 
					  formatted   = "TimeFormat(EventDateEffective,'HH:MM')"}>						  

<cfset itm = itm+1>						  					
<cf_tl id="Expiration" var="vDateExpiration">
<cfset fields[itm] = {label       = "#vDateExpiration#",
					  field       = "EventDateExpiration",		
					  align       = "center",					
					  search      = "date",
					  formatted   = "DateFormat(EventDateExpiration,CLIENT.DateFormatShow)"}>	
					  
<cfset itm = itm+1>					  
<cfset fields[itm] = {label       = "",
					  field       = "EventDateExpiration",		
					  align       = "center",								 
					  formatted   = "TimeFormat(EventDateExpiration,'HH:MM')"}>							  					

<cfset itm = itm+1>						
<cf_tl id="Duration" var="vDisplay">
<cfset fields[itm] = {label     = "#vDisplay#",
					  field       = "EventDisplayDuration"}>		

<cfset itm = itm+1>						
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label       = "#vStatus#",
					  field       = "Status",					
					  search      = "text",
					  filtermode  = "2"}>		
					  					  
<cfset menu=ArrayNew(1)>	
   				
<cfset newLabel = "New System Event">
		
<cf_tl id="#newLabel#" var="1">
							
<cfset menu[1] = {label = "#lt_text#", script = "addEvent()"}>				 
		
<cf_listing
	    header         = "SystemEvent"
		menu           = "#menu#"
	    box            = "systemnotification"
		link           = "NotificationListing.cfm"
	    html           = "No"
		show           = "40"
		datasource     = "AppsSystem"
		listquery      = "#myquery#"			
		listorder      = "Created"
		listorderfield = "Created"
		listorderdir   = "ASC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Yes"
		excelShow      = "Yes"
		drillmode      = "window"	
		drillargument  = "685;700;true;true"	
		drilltemplate  = "Tools/Notification/NotificationEditTab.cfm?drillid="
		drillkey       = "EventId">