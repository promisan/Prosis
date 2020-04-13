
<cfquery name="Actions" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  #preservesinglequotes(myact)#
  ORDER BY ActionFlowOrder ASC
</cfquery>

<cfset prior    = Object.Created>
<cfset keepdate = Object.Created>

<cfoutput query="Actions">

	<cfif OfficerDate neq "" and prior neq "">	   
						
			<cfset leadtime = DateDiff("n", "#prior#", "#OfficerDate#")>
			<cfset leadtime = numberformat(leadtime/60,"_._")> 
						
			<cfset keepdate = OfficerDate>	
						
			<cfif ActionConcurrent eq "0">			   
				<cfset prior = keepdate>	
			<cfelse>
			    <!--- compare the concurrent action against the last sequence time 
				so we do not change prior --->	
			</cfif>	
			
			<cfif OfficerLeadTime neq LeadTime>
			
					<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					UPDATE OrganizationObjectAction 
					SET    OfficerLeadTime = '#leadtime#'					
					WHERE  ActionId        = '#ActionId#'				
				</cfquery>
				
			</cfif>
											
	</cfif>
	
</cfoutput>