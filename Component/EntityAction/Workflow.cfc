
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Workflow Status Inquiry Component">
		
	<cffunction name="wfPending"
             access="remote"
             returntype="string"
             displayname="Workflow Pending">
		
			<cfargument name="EntityCode"   type="string" required="true">
		    <cfargument name="ObjectkeyValue1" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue2" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue3" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue4" type="string" required="false" default="">
		
			<!--- Check if object has a pending workflow
			Result will be answer Yes or No
			--->	
			
			<cfset status = "NO">

			<cfquery name="doc" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT * FROM Ref_Entity
				 WHERE EntityCode = '#EntityCode#' 
			</cfquery>
						
			<cfif doc.recordcount eq "1">
			
				<cfquery name="Check" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT ObjectId 
					 FROM OrganizationObject
					 WHERE 1=1 
					 <cfif ObjectkeyValue1 neq "">
					 AND ObjectKeyValue1 = '#ObjectKeyValue1#'
					 </cfif>
					 <cfif ObjectkeyValue2 neq "">
					 AND ObjectKeyValue2 = '#ObjectKeyValue2#'
					 </cfif>
					 <cfif ObjectkeyValue3 neq "">
					 AND ObjectKeyValue3 = '#ObjectKeyValue3#'
					 </cfif>
					 <cfif ObjectkeyValue4 neq "">
					 AND ObjectKeyValue4 = '#ObjectKeyValue4#'
					 </cfif> 
					 AND Operational = 1
				</cfquery>
				
				<!--- there isa pending workflow object --->
		
				<cfif check.recordcount gte "1">
					
						<cfquery name="Pending"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT   TOP 1 ActionStatus
							FROM     OrganizationObjectAction
							WHERE    ObjectId = '#Check.ObjectId#'
							ORDER BY ActionFlowOrder DESC
						</cfquery>
						
						<!--- last step of the workflow exisits and is pending 0, 1--->	
											
						<cfif pending.actionStatus lte "1" and pending.recordcount gte "1">
																			
							<cfset status = "YES">
						
						</cfif>
						
				</cfif>	
			
			</cfif>

			<cfreturn Status>
	
	</cffunction>
	
</cfcomponent>	