

<cftry>
 <cfdirectory action="CREATE" directory="#SESSION.rootPath#\CFRStage\EmployeePhoto\">
 <cfcatch></cfcatch>
</cftry> 

<cfparam name="session.portalorgunit" default="">

<table style="height:100%;width:100%">

<!---
<tr class="labelmedium line">
	<td style="font-size:16px"><cf_tl id="Select units"></td>
</tr>
--->

<tr><td style="width:100%;height:100%">

	<cf_divscroll>

	<table align="left" style="width:96%" class="navigation_table">
	
	<cfif getAdministrator("#URL.mission#")>
	
		<cfquery name="Units" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization AS O 
				WHERE    O.Mission = '#url.mission#' 			
				AND      O.DateEffective  < '#url.selection#' 
				AND      O.DateExpiration > '#url.selection#'
								
				AND     ( O.OrgUnit IN (SELECT  OrgUnitOperational
									   FROM    Employee.dbo.Position
									   WHERE   Mission = '#url.mission#') OR Hierarchycode LIKE '__')		
				
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
				
				AND      ( O.OrgUnit IN (SELECT  OrgUnitOperational
									   FROM    Employee.dbo.Position
									   WHERE   Mission = '#url.mission#') OR Hierarchycode LIKE '__')	
				
				AND      O.OrgUnit IN (SELECT  OA.OrgUnit
										FROM   OrganizationAuthorization AS OA 
										WHERE  OA.Mission = '#url.mission#' 
										AND    OA.Role    = 'HRAssistant' 
										AND    OA.UserAccount = '#session.acc#' 
										AND    OA.AccessLevel IN ('1', '2'))	
							
				ORDER BY HierarchyCode						
		</cfquery>
	
	</cfif>
			
	<cfoutput query="Units">		
					
			<cfset cnt = "-1">
			<cfloop index="itm" list="#hierarchyCode#" delimiters="."><cfset cnt = cnt+1></cfloop>	
			<cfif cnt eq "0">
				<tr class="labelmedium linedotted" style="height:15px;background-color:f1f1f1">
				<td style="padding-top:2px;padding-bottom:4px;padding-left:1px;font-size:15px;font-weight:bold" align="center" colspan="2">#OrgUnitName#</td>
			<cfelse>		
				<tr class="labelmedium linedotted navigation_row">	
				<td style="padding-left:1px;font-weight:bold;font-size:13px;height:100%;padding-right:4px">				
				<cfloop index="itm" from="1" to="#cnt#"><span style="border:0.5px solid white;border-right:0px;min-width:8px;height:100%;background-color:1A8CFF">&nbsp;&nbsp;</span></cfloop>
			    </td>
				<td style="font-size:12px;padding-top:2px;padding-right:3px">#OrgUnitName#</td>
			</cfif>
				
			<td valign="top" style="padding-left:1px;padding-right:2px">
				<input style="width:17px; cursor:pointer;" 
				   type="checkbox" name="unit" id="unit_#orgunit#" class="clsFilterUnit" value="'#OrgUnit#'" <cfif find(orgunit,session.portalorgunit)>checked</cfif>>
			</td>
		</tr>
	
	</cfoutput>
	
	</table>
	
	</cf_divscroll>
	
</td></tr>	

<tr><td colspan="3" style="padding-top:4px">
    <table class="formspacing" style="width:100%;padding-top:5px">
		<tr><td><button onclick="doFilter()" style="font-size:15px;width:100%;height:30px" class="button10g"><cf_tl id="Show Selected Units"></button></td></tr>
	</table>
</td></tr>

</table>
<cfset ajaxonload("doHighlight")>
