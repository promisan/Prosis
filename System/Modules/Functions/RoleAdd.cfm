

<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRole  
	WHERE  Role = '#URL.Role#'
</cfquery>

<table cellspacing="0" cellpadding="0">
<tr>
<cfif role.recordcount eq "1">
	
	<cfset label = ListToArray(Role.AccessLevelLabelList)>
		   
	<cfoutput>
	  <cfloop index="lvl" from="0" to="#role.accessLevels-1#">
	      <cftry><td class="labelmedium">#label[lvl+1]#:<cfcatch>l:#lvl#</cfcatch></td></cftry>
		  <td style="padding-left:4px;padding-right:12px"><input class="radiol" type="checkbox" name="AccessLevelList" id="AccessLevelList" checked value="#lvl#"></td>
	  </cfloop>
	</cfoutput>

	<script>
		document.getElementById("add").className = "button10g"
	</script>
	
<cfelse>

	<script>
		document.getElementById("add").className = "hide"
	</script>
	
</cfif>
</tr>
</table>