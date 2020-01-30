
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
	
	<cfif Class.Parameter eq "Owner">
			
		<cfquery name="OwnerList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_AuthorizationRoleOwner
		</cfquery>
	 
	   <select style="width:80" name="classparameter" id="classparameter">
		   <option>All</option>
	       <cfoutput query="OwnerList">		    
			     <option value="#Code#">#Code#</option>
		   </cfoutput>	 
	   </select>		
	 
	 <cfelse>
	 
	   <input type="hidden" name="classparameter" id="classparameter">	
	 
	   N/A
	 
	 </cfif>	
	 
	 
</cfif>	   