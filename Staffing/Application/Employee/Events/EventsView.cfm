<cfparam name="url.scope" default="backoffice">

<cfif url.scope eq "inquiry" or url.scope eq "unit" or url.scope eq "personal">
	<cfset url.portal = 1>
</cfif>	

<cf_screentop label="Events and Actions"
    	height="100%" 
		scroll="yes" 
		html="No" 
		menuaccess="context" 
		actionobject="Person"
		actionobjectkeyvalue1="#url.id#"
		jQuery="Yes">
			
<cf_actionListingScript>
<cf_dialogPosition>
<cf_filelibraryscript>
<cf_calendarscript>

<cfinclude template="EventsScript.cfm">

<cfparam name="url.id"     default="">

<cfif url.id eq "">

	<cfquery name="qPersonEvent"
		datasource="AppsEmployee"		 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT * 
		FROM   PersonEvent
		WHERE  EventId = '#URL.eventId#'
	</cfquery>	

	<cfset URL.Id = qPersonEvent.PersonNo>

</cfif>

<table height="100%" width="99%" align="center" border="0">		
      
       	<cfif url.scope eq "backoffice">
		
			<tr style="height:10px"><td>		
			    <cfset ctr = "1">
				<cfset openmode = "show">
				<cfinclude template="../PersonViewHeaderToggle.cfm">
			</td></tr>
						
			<tr><td valign="top" style="padding-left:10px;padding-right:10px;height:100%">
				<cf_securediv id="eventdetail" bind="url:EventsListing.cfm?scope=#url.scope#&id=#url.id#" style="height:100%">
			</td></tr>   
						
		<cfelse>	
		
			<tr><td valign="top" style="padding-left:10px;padding-right:10px;height:100%">
			<cf_securediv id="eventdetail" bind="url:SelfService.cfm?scope=#url.scope#&id=#url.id#" style="height:100%">
		</td></tr>   			
		
		</cfif>
		
     	
</table>	
