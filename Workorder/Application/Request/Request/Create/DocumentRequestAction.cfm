		
<!--- prepopulate so ajax is not bother in case of refresh --->		

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Request								
		<cfif url.requestid eq "">
		WHERE 1= 0
		<cfelse>
		WHERE  RequestId   = '#url.requestid#'		
		</cfif>
		
</cfquery>		

<cfquery name="RequestLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ValueFrom as Serviceitem
		FROM   RequestWorkorderDetail
		WHERE  Amendment = 'ServiceItem'
		<cfif url.requestid eq "">
		AND 1=0
		<cfelse>
		AND  Requestid   = '#url.requestid#'
		</cfif>		
</cfquery>

<cfif RequestLine.recordcount eq "0">

	<!--- this should not occur --->
	
	<cfquery name="RequestLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   RequestLine
		<cfif url.requestid eq "">
		WHERE 1=0
		<cfelse>
		WHERE  Requestid   = '#url.requestid#'		
		</cfif>				
	</cfquery>

</cfif>

<cfquery name="RequestAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_RequestWorkflow								
		WHERE  RequestType   = '#url.requesttype#'
		AND    ServiceDomain = '#url.domain#'
		AND    Operational = 1
		ORDER BY ListingOrder
</cfquery>


<cfif RequestAction.recordcount eq "1">

	<script language="JavaScript">
       document.getElementById('rowaction').className = "hide"
	</script>

<cfelse>

	<script language="JavaScript">
     document.getElementById('rowaction').className = "regular"
	</script>

</cfif>

<cfoutput>

<select name="requestaction" id="requestaction" class="regularxl"
 onchange="loadcustomform('#url.requestid#',document.getElementById('requesttype').value,'#url.serviceitem#','edit',document.getElementById('workorderlineid').value,this.value)"
   style="color:black;width:300">
	<cfloop query="RequestAction">
        <option value="#RequestAction#" <cfif Request.RequestAction eq RequestAction>selected</cfif>>#RequestActionName#</option>				
	</cfloop>	
</select>

</cfoutput>
