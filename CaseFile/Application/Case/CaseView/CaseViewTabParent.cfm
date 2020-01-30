<cfparam name="wf" default="1">
<cfparam name="URL.ID" default="">
<cfparam name="URL.TabNo" default="1">
<cfparam name="URL.TabName" default="1">

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<!--- determine overall access --->
	 
<cfinvoke component = "Service.Access"  
	    method           = "CaseFileManager" 
		mission          = "#Claim.Mission#" 	
		claimtype        = "#Claim.ClaimType#"   
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

<cfif accessLevel eq "EDIT" or accessLevel eq "ALL">
    <cfset mode = "Edit">
<cfelse>
	<cfset mode = "View">
</cfif>   

<cfoutput>

<table width="100%" height="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" frame="hsides">
								
		<tr><td width="100" valign="top" bgcolor="EAF4FF" style="border-right:1px dotted silver;border-left:1px dotted silver">
				
			<table width="100" cellspacing="0" cellpadding="0" class="formpadding">			
			
			<tr>		
								 		  
			  <cfset wd = "20">
			  <cfset ht = "20">		  
						
			  <cfset itm = 1>		
							
				</tr>	
			
			     <cfquery name="myTabs" 
						datasource="AppsCaseFile" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ClaimTypeTab
						WHERE    Code = '#Claim.ClaimType#'	
						AND      TabName != 'Control'
						AND      Mission = '#Claim.mission#'
						AND      (ClaimTypeClass is NULL or ClaimTypeClass = '#claim.ClaimTypeClass#')
						AND      Operational = 1
						
						<!--- hardcoded --->					
						AND      TabNameParent = '#url.tabname#'
						
						ORDER BY TabOrder				    
				</cfquery>	
																				 
				<cfloop query="mytabs">
							
					<!--- ----------------------------------------------------------- --->
					<!--- define if the tab will be shown based on the value 0, 1, 2- --->
					<!--- ----------------------------------------------------------- --->
					
					<cfif accessgranted gte accesslevelread and accessgranted neq "">		
					
						<cfset itm = itm+1>
						
						<tr>
						
						<cfif tabtemplate eq "element">
						
							<cf_menutab base       = "subtab_#url.tabno#"
							            item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#"
										source     = "../../Element/Listing/ElementView.cfm?tabname=#itm#&claimId=#URL.claimId#&elementclass=#TabElementClass#">
						
						<cfelseif ModeOpen eq "Bind">
							
							<cf_menutab base       = "subtab_#url.tabno#"
										item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#"
										source     = "#TabTemplate#?tabname=#itm#&claimId=#URL.claimId#">
										
						<cfelse>
							
							<cf_menutab base       = "subtab_#url.tabno#"
										item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#">
												
						</cfif>		
							
						</tr>	
										
					</cfif>		
					
			
				</cfloop>
							 
			  </table>
			  </td>		  
		  
		  	  <td height="100%" valign="top">
		  		 		  
			  <table height="100%" width="99%" align="center">			  
			  			  					  
				  <cfset itm = 1>
				  
				  <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="regular">
				  
				  
				  <cf_menucontainer>
				  
				  <cfif accessGranted gte "1">
				  				  
				 	 <cfset itm = itm+1>
				 	 <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">
				  
				  </cfif>
			  
				  <cfloop query="mytabs">
				  					
						<cfif accessgranted gte accesslevelread and accessgranted neq "">		
																				
							<cfset itm = itm+1>
							
							<cfif tabtemplate neq "Embed">						
								<cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">					
							<cfelse>								
							    <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">					
									<cfinclude template="#TabTemplate#">
								</cf_menucontainer>						
							</cfif>
						
						</cfif>
										
				</cfloop>
								
				</table>
		  		  
		  </td>
		  </tr>
		
	
</table>	
	
</cfoutput>	
				


