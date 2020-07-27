
<table style="width:90%">

<tr class="labelmedium line">
	<td colspan="3" style="font-size:16px"><cf_tl id="Select units"></td>
</tr>

<cfif getAdministrator("#URL.mission#")>

	<cfquery name="Units" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 19 *
			FROM     Organization AS O 
			WHERE    O.Mission = '#url.mission#' 			
			AND      O.DateEffective  < '#url.selection#' 
			AND      O.DateExpiration > '#url.selection#'
			ORDER BY O.HierarchyCode
			
	</cfquery>

<cfelse>
	
	<cfquery name="Units" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 20 *
			FROM     Organization AS O 
			WHERE    O.Mission = '#url.mission#' 			
			AND      O.DateEffective  < '#url.selection#' 
			AND      O.DateExpiration > '#url.selection#'
			AND      O.OrgUnit IN (SELECT  OA.OrgUnit
									FROM   OrganizationAuthorization AS OA 
									WHERE  OA.Mission = '#url.mission#' 
									AND    OA.Role    = 'HRAssistant' 
									AND    OA.UserAccount = '#session.acc#' 
									AND    OA.AccessLevel IN ('1', '2'))		
			AND       O.OrgUnit IN (SELECT OrgUnitOperational FROM Employee.dbo.Position WHERE Mission = '#url.mission#')	
			ORDER BY HierarchyCode						
	</cfquery>

</cfif>

<cfoutput query="Units">
	
	<tr class="labelmedium line" style="height:15px">
		
		<cfset cnt = "-1">
		<cfloop index="itm" list="#hierarchyCode#" delimiters="."><cfset cnt = cnt+1></cfloop>	
		<cfif cnt eq "0">
			<td style="padding-left:1px;" colspan="2">
			<label for="unit_#orgunit#" style="font-size:14px; font-weight:normal; cursor:pointer;">#OrgUnitName#</label>
			</td>
		<cfelse>			
			<td style="padding-left:1px;" valign="top">
			<label for="unit_#orgunit#" style="font-size:14px; font-weight:normal; cursor:pointer;">
			<cfloop index="itm" from="1" to="#cnt#"><font size="3">.&nbsp;</font></cfloop></label>
		    </td>
			<td style="padding-top:2px;padding-right:3px"><label for="unit_#orgunit#" style="font-size:14px; font-weight:normal; cursor:pointer;">#OrgUnitName#</label></td>
		</cfif>
			
		<td valign="top" style="padding-left:3px">
			<input style="height:17px; width:17px; cursor:pointer;" type="checkbox" name="unit" id="unit_#orgunit#" class="clsFilterUnit" value="'#OrgUnit#'" <cfif currentrow eq 1>checked</cfif>>
		</td>
	</tr>

</cfoutput>

<tr><td colspan="3" style="padding-top:4px" align="center">
    <table class="formspacing"><tr>
	<td>
	<button onclick="doFilter()" style="width:200px;height:30px" class="button10g"><cf_tl id="Show Selected Units"></button>
	</td>
	<!---
	<td>
	<button onclick="doEvent()" style="width:100px;height:30px" class="button10g"><cf_tl id="HR Events"></button>
	</td>
	--->
	</tr></table>
</td></tr>

</table>
