<cfparam name="url.scope" default="backoffice">

<cfif url.scope eq "portal">
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
      
        <cfset vShowHeader = "">
      	<cfif url.scope neq "backoffice">
			<cfset vShowHeader = "display:none;">
		</cfif>
        <tr style="height:10px"><td style="<cfoutput>#vShowHeader#</cfoutput>">		
		    <cfset ctr = "1">
			<cfset openmode = "show">
			<cfinclude template="../PersonViewHeaderToggle.cfm">
		</td></tr>
		
		<tr><td valign="top" style="padding-left:10px;padding-right:10px;height:100%">
			<cf_securediv id="eventdetail" bind="url:EventsListing.cfm?id=#url.id#" style="height:100%">
		</td></tr>   		
</table>	
