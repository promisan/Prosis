
<cfquery name="Request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM RequestHeader		
	WHERE  RequestHeaderid = '#url.ajaxid#'	
</cfquery>

<cfquery name="RequestType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Request		
	WHERE  Code = '#Request.RequestType#'	
</cfquery>
	
<cfparam name="url.action" default="">	

<cfif url.action eq "cancel">				
			   
	<!--- set status to cancel --->	
	
	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM RequestHeader		
		WHERE  RequestHeaderid = '#url.ajaxid#'		
	</cfquery>   
		   
	<cfquery name="Purge" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE RequestHeader
		SET    ActionStatus = '9'
		WHERE  RequestHeaderid = '#url.ajaxid#'		
	</cfquery>
	
	<cfquery name="PurgeLines" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Request
		SET    Status = '9'
		WHERE  Mission   = '#get.Mission#'		
		AND    Reference = '#get.Reference#'
	</cfquery>
	
	<!--- close the workflow --->
	
	<cfquery name="ArchiveFlow" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Organization.dbo.OrganizationObjectAction
			SET    ActionStatus     = '2',
			       ActionMemo       = 'Closed through cancellation',
			       OfficerUserId    = '#SESSION.acc#',
				   OfficerLastName  = '#SESSION.last#',
				   OfficerFirstName = '#SESSION.first#',									   
				   OfficerDate      = getDate()					   		
			WHERE  ObjectId IN (SELECT ObjectId 
			                    FROM   Organization.dbo.OrganizationObject 
								WHERE  ObjectKeyValue4 = '#url.ajaxid#')
			AND    ActionStatus = '0'			
	</cfquery>		
	
	<cfif url.action eq "cancel">
	<cfoutput>
	<script>
	    try {
	    opener.document.getElementById('treerefresh').click() } catch(e) {}
		ColdFusion.navigate('DocumentLines.cfm?drillid=#url.ajaxid#','requestlines')
	</script>
	</cfoutput>
	</cfif>   
			
</cfif>
			
<table width="100%" cellspacing="0" cellpadding="0">
	
<cfoutput>
			
	<cfif Request.ActionStatus lte "2" and url.action neq "cancel">
	
	    <cfset Reset = "Yes">
	
		<tr><td align="left" id="cancel">
		
		<input type    = "button" 
		       name    = "Cancel"
			   id      = "Cancel" 			  
			   class   = "button10g" 
			   style   = "height:25px;width:150"
			   value   = "Cancel" 			   
			   onclick = "ColdFusion.navigate('DocumentWorkflow.cfm?action=cancel&ajaxid=#url.ajaxid#','#url.ajaxid#')">
			   
		</td></tr>		
		<tr><td height="2"></td></tr>
				
	<cfelse>
	
	    <cfset Reset = "Limited">
		
	</cfif>
	
</cfoutput>

<cfquery name="RequestLine" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.LocationName
	FROM      Request R INNER JOIN
              RequestDetail RD ON R.RequestId = RD.RequestId INNER JOIN
              WarehouseLocation WL ON RD.ShipToWarehouse = WL.Warehouse AND RD.ShipToLocation = WL.Location INNER JOIN
              Location L ON WL.LocationId = L.Location	
	WHERE     R.Mission   = '#Request.Mission#' 
	AND       R.Reference = '#Request.Reference#'
</cfquery>	

<cfset wflink = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=#url.ajaxid#">
					
<cf_ActionListing 
	EntityCode       = "WhsRequest"
	EntityClass      = "#Request.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Request.mission#"
	OrgUnit          = "#Request.orgunit#"		
	PersonEMail      = "#Request.EmailAddress#"
	ObjectReference  = "#Request.Reference#"
	ObjectReference2 = "Deliver to: <b>#RequestLine.LocationName#</b>"						
	ObjectKey4       = "#url.ajaxid#"
	AjaxId           = "#url.ajaxid#"
	ObjectURL        = "#wflink#"
	Reset            = "#reset#"
	Show             = "Yes"
	ToolBar          = "Yes">
			
</table>