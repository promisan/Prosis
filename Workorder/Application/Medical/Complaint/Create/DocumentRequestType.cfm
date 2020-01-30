
<cfparam name="url.scope" default="BackOffice">

<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   #CLIENT.LanPrefix#ServiceItem
	WHERE  Code = '#url.serviceitem#'	
</cfquery>


<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Request
	<cfif url.requestid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  Requestid = '#url.requestid#'
	</cfif>		
</cfquery>
	
<cfquery name="RequestType" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   #CLIENT.LanPrefix#Ref_Request		
		WHERE  Code IN (SELECT RequestType 
		                FROM   Ref_RequestWorkflow 
						WHERE  ServiceDomain = '#serviceitem.servicedomain#'
						<cfif url.requestid neq "00000000-0000-0000-0000-000000000000">																	
							AND    isAmendment = 1
							<!--- hardcoded exclude new service --->
							AND    RequestType != '001'  						
						<cfelseif url.scope eq "Portal">
							<!--- limit to only new service --->						
							AND    isAmendment = 0
						</cfif>
						)
		AND    Operational = 1
		
</cfquery>

	
<cfset requesttypesel = RequestType.Code>

<cfoutput>
		
	<select name     = "requesttype" 
	        id       = "requesttype" class="regularxl"
			style    = "width:200px;color:black" 
	        onchange = "ColdFusion.navigate('../Create/DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype='+this.value+'&domain=#serviceitem.servicedomain#&serviceitem=#url.serviceitem#','requestaction')">
			<cfloop query="RequestType">
		        <option value="#Code#" <cfif Request.requesttype eq code>selected</cfif>>#Description#</option>
				<cfif Request.Requesttype eq Code>
					<cfset requesttypesel = Request.requesttype>
				</cfif>
			</cfloop>	
	</select>
	<script>

	  ColdFusion.navigate('../Create/DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype=#RequestType.Code#&domain=#serviceitem.servicedomain#&serviceitem=#url.serviceitem#','requestaction')	  
	</script>
	
</cfoutput>	