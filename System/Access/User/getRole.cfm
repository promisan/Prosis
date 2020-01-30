
<!--- get role --->

<cfquery name="RoleList" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AuthorizationRole
	WHERE     SystemModule = '#url.systemmodule#'
	ORDER BY ListingOrder,Description
</cfquery>

<!-- <cfform> -->
<cfselect name="Role"	         
	style="width:150px"
    queryposition="below"				  
    query="RoleList"
    value="Role"
    display="Description"
	selected="#url.selected#"
    visible="Yes"
    enabled="Yes"
    class="regularxl enterastab">		
		 <option value="">Any</option>
</cfselect> 			
<!-- </cfform> -->