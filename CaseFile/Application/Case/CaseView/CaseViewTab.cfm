
<cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim
		WHERE ClaimId = '#URL.claimid#'	
</cfquery>	

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM  OrganizationObject
		WHERE ObjectKeyValue4 = '#URL.claimid#'	
</cfquery>
			
<cfquery name="myTabs" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ClaimTypeTab
		WHERE    Code = '#Claim.ClaimType#'	
		AND      TabName != 'Control'
		AND      Mission = '#url.mission#'					
		<!--- AND      (ClaimTypeClass is NULL OR ClaimTypeClass = '#claim.ClaimTypeClass#')
		--->
		AND      TabNameParent is NULL
		AND      Operational = 1
		ORDER BY TabOrder				    
</cfquery>				

<!--- Dtermine tab width: 100/ ( General tab + Workflow + Elemen tabs ) --->
<cfset width = 100 \ ( 1 + 1 + myTabs.recordcount ) & "%">
			
<table width="100%"
       border="0" 
       cellspacing="0"
       cellpadding="0"
       align="center"><tr> 
	   
   <input type="hidden" 
	   name="workflowlink_<cfoutput>#url.claimid#</cfoutput>" 
	   id="workflowlink_<cfoutput>#url.claimid#</cfoutput>" 	   
	   value="DetailWorkflow.cfm">		
	   
	<cfset ht = client.height-192>
	
	<!--- determine overall access --->
	 
	<cfinvoke component = "Service.Access"  
		    method           = "CaseFileManager" 
			mission          = "#claim.Mission#" 
		    claimtype        = "#claim.ClaimType#"   
		    returnvariable   = "accessLevel">	
			
	<!--- ------------------------------------------------------------------------------ --->
	<!--- check if access to the tabs is granted based on the fly access settings in wf- --->
	<!--- ------------------------------------------------------------------------------ --->
					
	<cfif accesslevel eq "NONE">
		
		<cfset accessgranted = "">
												
		<cfif Object.ObjectId neq "">
								
			<cfinvoke component = "Service.Access"  
		    method           = "AccessEntityFly" 	   
			ObjectId         = "#Object.Objectid#"
		    returnvariable   = "accessgranted">	
					
			<!--- return NULL, 0 (collaborator), 1 (processor) --->
				
		</cfif>
				
	<cfelse>
			
			<cfset accessgranted = "2">
			
	</cfif>									
	
	<cfif accessgranted eq "">
	
		<cf_tl id="You do no longer have access to this document">
	
	<cfelse>	
										
			<!--- ------------------------ --->
			<!--- show only to a processor --->
			<!--- ------------------------ --->
			
			<cfset wd = "48">
			<cfset ht = "48">
			
			<cfset itm = 0>
			
			<cfif accessgranted gte "1">
			
			    <cfset itm = itm+1>
			
				<cf_tl id ="Case" var="1">

				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/CaseFile/Case.png" 
							iconwidth  = "#wd#" 
							width      = "#width#"
							iconheight = "#ht#" 							
							name       = "#lt_text#">
			
			    <!--- check if workflow exists --->
				
				<cfquery name="Class" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_ClaimTypeClass
					WHERE ClaimType = '#claim.claimtype#'
					AND   Code      = '#claim.claimtypeclass#'			
				</cfquery>
				
				<cfif class.entityclass neq "">
				
					<cfset itm = itm+1>
					
					<cf_tl id ="Case Workflow" var="1">
										
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workflow.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
									width  = "#width#"
								name       = "#lt_text#"
								source     = "DetailWorkflow.cfm?ajaxid=#URL.claimId#&mission=#url.mission#">
								
				</cfif>			
												
			</cfif>				

			<cf_getMid>                         
											 
			<cfloop query="mytabs">
						
				<!--- ----------------------------------------------------------- --->
				<!--- define if the tab will be shown based on the value 0, 1, 2- --->
				<!--- ----------------------------------------------------------- --->
				
				<cfif accessgranted gte accesslevelread and accessgranted neq "">		
				
				     <!--- check the filter --->
					 
					 <cfquery name="hasFilter" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   ClaimTypeClass
					FROM     Ref_ClaimTypeTabClass
					WHERE    Code           = '#Code#'	
					AND      TabName        = '#TabName#'
					AND      Mission        = '#mission#'								    
					</cfquery>			
				
					<cfquery name="CheckThis" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   ClaimTypeClass
					FROM     Ref_ClaimTypeTabClass
					WHERE    Code           = '#Code#'	
					AND      TabName        = '#TabName#'
					AND      Mission        = '#mission#'
					AND      ClaimTypeClass = '#claim.ClaimTypeClass#'					    
					</cfquery>		
					
					<cfif hasFilter.recordcount gte "1" and CheckThis.recordcount eq "0">
						
					   <!--- hidden --->
										
					<cfelse>	
					
						<cfset itm = itm+1>						
						
						<cfif tabtemplate eq "element">
						
							<cf_menutab item       = "#itm#" 
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										width      = "#width#"
										name       = "#TabLabel#"
										source     = "../../Element/Listing/ElementView.cfm?tabno=#itm#&tabname=#TabName#&claimId=#URL.claimId#&elementclass=#TabElementClass#&tabname=#TabName#">
						
						<cfelseif ModeOpen eq "Bind">

							<cf_menutab item       = "#itm#" 
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										width      = "#width#"
										iconheight = "#ht#" 
										name       = "#TabLabel#"
										source     = "#TabTemplate#?tabno=#itm#&tabname=#TabName#&claimId=#URL.claimId#">
										
						<cfelse>
													
							<cf_menutab item       = "#itm#" 
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										width      = "#width#"
										iconheight = "#ht#" 
										name       = "#TabLabel#">
												
						</cfif>		
						
					</cfif>
						
									
				</cfif>					
		
			</cfloop>
	
	</cfif>
		
</tr>
</table>			