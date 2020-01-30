
<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>

<cfif class.recordcount gt 0>
	
	<cfif Class.Parameter eq "Owner">
			
		<cfquery name="OwnerList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_AuthorizationRoleOwner
		</cfquery>
	 
	   <select class="regularxl" name="classparameter" id="classparameter">
		   <option>All</option>
	       <cfoutput query="OwnerList">		    
			     <option value="#Code#">#Code#</option>
		   </cfoutput>	 
	   </select>		
	 
	 <cfelse>
	 
	   <input type="hidden" name="classparameter" id="classparameter">	
	  <table><tr><td class="labelmedium">N/A</td></tr></table>
	 
	 </cfif>	
	 
<cfelse>

	<cf_compression>	 
	 
</cfif>	   