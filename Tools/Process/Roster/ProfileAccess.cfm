
<!--- PHP profile access --->

<cfparam name="Attributes.Scope"   default="Backoffice">
<cfparam name="Attributes.Source"  default="">
<cfparam name="Attributes.Owner"   default="">
<cfparam name="Attributes.Section" default="">

<cfset mode = "read">

<cfif attributes.Scope eq "Backoffice">
				
		<cfinvoke component="Service.Access"  
			 	method="roster" 
			 	returnvariable="AccessRoster"
			 	role="'AdminRoster','CandidateProfile'">
				
		<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
		
			<cfset mode = "edit">
			
		</cfif>		
				
<cfelse>


	<!--- in principle a user in the portal has edit rights so we assume his rights are on the level 2,
	so only if we make the level higher in the table he/she will miss this by default --->
	
		<cfinvoke component="Service.Access"  
			 	method="roster" 
			 	returnvariable="AccessRoster"
			 	role="'AdminRoster','CandidateProfile'">			
					
	   <cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
	   
		   	<cfset RosterAccess = "2">
				   
	   <cfelse>
	   
		   	<cfset RosterAccess = "1">
		
	   </cfif>	

	   <cfquery name="qCheckOwnerSection" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ApplicantSectionOwner
			WHERE    Owner = '#Attributes.Owner#'
			AND      Code  = '#Attributes.Section#' 
	   </cfquery>
	   	   	   
	   <!--- define the threshold --->
	   
	   <cfif qCheckOwnerSection.recordcount eq 0>	  
			<cfset AccessLevelEdit = "2">
	   <cfelse>	
	      	<cfset AccessLevelEdit = qCheckOwnerSection.AccessLevelEdit>
	   </cfif>	
		
	   <cfquery name="Source" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_Source 
			WHERE  Source = '#Attributes.source#'
	   </cfquery>
	   	   
	   <cfif Source.operational eq "0" or Source.allowedit eq "0">
	   	   
		   <cfset mode = "read">
		   
	   <cfelse>
	   	   
		  <cfif RosterAccess gte AccessLevelEdit>	   
		  	  
			  	<cfset mode = "edit">
				
		  </cfif>
	   
	   </cfif>	 
	   
</cfif>

<CFSET Caller.AccessMode = mode>	     
	   
	   