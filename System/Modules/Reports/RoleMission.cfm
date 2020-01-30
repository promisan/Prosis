
<cfoutput>
<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>

<cfif class.recordcount eq "0">

	<cf_compression>	 

<cfelse>
	
	<cfif Class.OrgUnitLevel neq "Global">
				   
		   <select name="missionsel" id="missionsel"
	        multiple
	        style="width:120; font-size: xx-small;">
		   
			   <option selected>Any</option>				   
			   
				<cfquery name="MissionList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_Mission 	
					WHERE Operational = 1	
					
				</cfquery>
			   
	           <cfloop query="MissionList">		
			   	     <option value="#Mission#">#Mission#</option>
			   </cfloop>	
			    
		   </select>	
		   
	   <cfelse>
	   
	   	 <input type="hidden" name="missionsel" id="missionsel">N/A   
		 
	   </cfif>		
   
</cfif>   

   </cfoutput> 

