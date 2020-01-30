
<td width="12%" align="center" class="labelit">
    <b><font color="red">
	<cfif AccessList.Number gt "1">DENY<cfelse>NONE</cfif>
</td>	

<cfquery name="RoleScope" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_AuthorizationRole 
	WHERE   Role = '#URL.ID#'
</cfquery>

<cfoutput>

	<cfset no = RoleScope.AccessLevels>
	<cfset label = ListToArray(RoleScope.AccessLevelLabelList)>
	<cfloop index="itm" from="1" to="#no#">
		<td width="9%" align="center" class="labelit">
		<cftry>
		<font color="6688aa">
		#label[itm]# <cfcatch>Level #itm#</cfcatch>
		</cftry>
		</td>
	</cfloop>
	
</cfoutput>