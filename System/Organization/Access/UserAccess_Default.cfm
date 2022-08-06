
<cfparam name="currentrow" default="1">
	
<cfif tree eq "1">
		
	 <cfquery name="AccessList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.ClassParameter, RecordStatus, AccessLevel, Number
		FROM    userQuery.dbo.#SESSION.acc#TreeAccess A
		<cfif Role.GrantAllTrees eq "0">
		WHERE   A.Mission = '#URL.Mission#' 		
		</cfif>		
	 </cfquery>	 
	 	
<cfelse>
		  
   <cfquery name="AccessList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT A.ClassParameter, 
			MAX(A.RecordStatus) as RecordStatus,
			MAX(A.AccessLevel) as AccessLevel, count(*) as Number
		FROM    OrganizationAuthorization A
		WHERE   A.AccessLevel < '8'
		AND     ((A.OrgUnit     = '#URL.ID2#') 
		 OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
		 OR (A.OrgUnit is NULL and A.Mission is NULL))
		AND     A.UserAccount = '#URL.Acc#' 
		AND     A.Role        = '#URL.ID#'
		GROUP BY A.ClassParameter 
	</cfquery>
			
</cfif>	    		  
		  
<table width="100%" class="formpadding">
	
	<cfif currentrow eq "1">
	
	<tr class="line">
		<td></td>
		<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
	
	</cfif>
		
	<cfset AccessLevel = AccessList.AccessLevel>
	
	<cfoutput>	
	
		<input type="hidden" name="#ms#_classparameter_1" id="#ms#_classparameter_1" value="Default">
				
		<!--- hide the main selection screen for the entity as it is just need needed for this access level --->
		
		<!---			  
		<script>
		 try {
		 document.getElementById('#Mission#selected').className = "hide" } catch(e) {}
		</script>	
		--->

						
		<tr class="line labelmedium2">
		  <td style="padding-left:20px;width:100%">
		  <cfif mission eq "undefined">
		  <cf_tl id="Select">
		  <cfelse>
		  #Mission#
		  </cfif>
		  </td>
		  
		  <!--- ---------------------------------------------------------- --->
		  <!--- this will put the additional <td> with the selection value --->
		  <!--- ---------------------------------------------------------- --->
		 
		  <cfset row = 1>	
		  	  	  			    
		  <cfinclude template="UserAccessSelect.cfm">			  
		  	  
		   <script>
		     try { document.getElementById("s_#missionname#").className = "regular" } catch(e) {}
		  </script>
	  				  
	  </cfoutput>
	   
	</tr>
							
</table>
			
<cfset class = "1">