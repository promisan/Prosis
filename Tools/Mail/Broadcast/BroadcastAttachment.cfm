
<cfquery name="Broadcast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE BroadcastId = '#URL.ID#'
</cfquery>

<cfparam name="box" default="1">
<cfparam name="attributes.ajaxid" default="">

<cfif Broadcast.BroadcastStatus eq "1">
	
		<cf_filelibraryN
				DocumentPath  = "Broadcast"
				SubDirectory  = "#URL.ID#" 
				Filter        = ""
				LoadScript    = "No"
				AttachDialog  = "Yes"
				Width         = "100%"
				Box           = "a1"
				rowheader     = "No"
				Insert        = "no"
				Remove        = "no">	
	
	<cfelse>	
	
		<cf_filelibraryN
				DocumentPath  = "Broadcast"
				SubDirectory  = "#URL.ID#" 
				Filter        = ""
				LoadScript    = "No"
				AttachDialog  = "Yes"				
				Width         = "100%"
				Box           = "a1"
				Insert        = "yes"
				Remove        = "yes">	
			
</cfif>		