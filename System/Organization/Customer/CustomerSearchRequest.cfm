
<!--- show only domains to which a user has access via the service item access he/she has been
granted --->
  
<cfquery name="DomainSet" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ServiceItemDomain
			
		    <cfif getAdministrator(url.mission) eq "0">	 
			WHERE Code IN (
			               SELECT ServiceDomain 
			               FROM   ServiceItem 
						   WHERE  Code IN (SELECT ServiceItem FROM ServiceItemMission WHERE Mission = '#URL.Mission#')
						   AND    Code IN (SELECT ClassParameter
								           FROM   Organization.dbo.OrganizationAuthorization
										   WHERE  UserAccount = '#SESSION.acc#'
										   AND    Role IN ('WorkOrderProcessor','ServiceRequester')
										   )	
						  )	
			<cfelse>		
				
			WHERE	
			      Code IN (SELECT ServiceDomain 
			               FROM   ServiceItem 
						   WHERE  Operational = 1
						   AND    Code IN (SELECT ServiceItem FROM ServiceItemMission WHERE Mission = '#URL.Mission#')) 
						   
						  
			</cfif>			
			
			
					   
								  											
</cfquery>

<!--- check --->

<cfquery name="Check" dbtype="query">
    SELECT *
	FROM   DomainSet
	WHERE  Code = '#url.domain#'
</cfquery>

<cfif check.recordcount eq "0">
  <cfset url.domain = domainset.code>
<cfelse>
  <cfparam name="url.domain" default="#domainset.code#">	  
</cfif>

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td height="20" colspan="2" align="center" style="padding:3px">
			
		<select name="domain" id="domain" class="regularxl"
		   onchange="ColdFusion.navigate('CustomerSearchRequestTree.cfm?mission=#url.mission#&domain='+this.value,'findmereq')"
           style="width:100%; color:black; font:14px; font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;">				
			<cfloop query="DomainSet">
			<option value="#Code#" <cfif url.domain eq code>selected</cfif>>#Description#</option>			
			</cfloop>
		</select>
			
	</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>	
			
	<tr><td colspan="2" height="100%" style="padding:3px">
    <cf_divscroll id="findmereq">	
	
	   <!--- initial value --->	    
	   <cfinclude template="CustomerSearchRequestTree.cfm">
	</cf_divscroll>
	</td></tr>
	
</table>

</cfoutput>
