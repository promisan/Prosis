
<cfparam name="FORM.Account" default="">

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cf_wait1>

<cfif ParameterExists(Form.Purge)> 
	
	<!--- define org structure --->
	
	<cfparam name="Form.AccessId" default="''">
	
	<cfloop index="acc" list="#PreserveSingleQuotes(FORM.Account)#" delimiters="' ,">
	
		<cfquery name="getUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   UserNames
			WHERE  Account = '#ACC#'
		</cfquery>
		
		<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnit = '#URL.ID#'
		</cfquery>
		
		<cfoutput>
		
			<cfsavecontent variable="condition">
			   UserAccount  = '#acc#' 
			   AND Role = '#URL.ID4#'
			   AND 
			   
			   <!--- we remove by default the hierarchy --->
			      (
			      
				  (OrgUnit IN (  SELECT OrgUnit
								 FROM   Organization
								 WHERE  Mission   = '#Org.Mission#'
								 AND    MandateNo = '#Org.MandateNo#'
								 AND    HierarchyCode LIKE (SELECT HierarchyCode 
								                            FROM   Organization 
															WHERE  OrgUnit = '#URL.ID#')+'%')
															
				)
				
			   <!--- ----------------------------------------------------------------- --->	
			   <!--- we also remove any access for which this orgunit is the inheriter --->
			   <!--- ----------------------------------------------------------------- --->
			   
			   OR   (OrgUnitInherit = '#url.id#') 	
															
			   OR	(OrgUnit = '#URL.ID#' AND Mission = '#URL.Mission#')													
			   OR	(OrgUnit is NULL AND Mission = '#URL.Mission#')											
			   OR   (OrgUnit is NULL AND Mission is NULL)
			   
			   )
		    </cfsavecontent>
		
		</cfoutput>
		
		<cf_assignid>
		    					
	    <cfinvoke component="Service.Access.AccessLog"  
		  method               = "DeleteAccess"
		  Logging              = "1"
		  ActionId             = "#rowguid#"
		  ActionStep           = "Batch removal"
		  ActionStatus         = "9"
		  UserAccount          = "#acc#"
		  Condition            = "#condition#"
		  AddDeny              = "1"
		  AddDenyCondition     = "Source != 'Manual'">	 
	
		 <cfif getUser.AccountType eq "Group">
		 
		 	 <!--- sync the group as well --->	 
			 <cfinvoke component="Service.Access.AccessLog"  
			  method       = "SyncGroup"
			  UserGroup    = "#acc#"
			  UserAccount  = ""
			  Role         = "#URL.ID4#">	
			  
		 </cfif>	  
		  
	 </cfloop>
	   
	<cfoutput>
			
	<script language="JavaScript">
		window.location = "OrganizationListing.cfm?ID0=#URL.ID#&Id1=#URL.ID1#&ID2=#URL.ID2#&ID4=#URL.ID4#&Mission=#URL.Mission#"
	</script>
	
	</cfoutput>
 
</cfif>      



