
<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_ModuleControl
		  WHERE    SystemModule  = 'Portal'
		  AND      FunctionClass = 'Portal'
		  AND      FunctionName  = 'Pending Support Tickets'  
	</cfquery> 

<cfif get.recordcount gte "1">
	
	<cf_screentop html="No" jquery="yes">
	
	<table width="96%" height="100%" align="right" class="formpadding">
	
	<tr><td  class="labellarge" style="font-size:35px;padding-right:10px;font-weight:200">Support ticket center <font size="3" color="0080FF"></b>&nbsp;&nbsp;&nbsp;<u><a href="TicketOpen.cfm">Pending tickets</a></font></td></tr>
	<tr><td></td></tr>
	
	<tr><td style="padding-right:4px" height="100%">
	
	<cfinclude template="../../../System/Modification/ModificationTicketListing.cfm">
		
	</td></tr>
	
	</table>

</cfif>