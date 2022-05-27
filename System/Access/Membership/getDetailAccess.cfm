
<cfquery name="AccessDetail"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
    SELECT       OA.AccessId, OA.Mission, OA.OrgUnit, O.OrgUnitName, OA.ClassParameter, OA.GroupParameter, OA.OfficerUserId, OA.OfficerLastName, OA.OfficerFirstName, OA.Created, O.OrgUnitCode
    FROM         OrganizationAuthorization AS OA LEFT OUTER JOIN Organization AS O ON OA.OrgUnit = O.OrgUnit
    WHERE        OA.Mission     = '#url.mission#' 
	AND          OA.Role        = '#url.role#' 
	AND          OA.UserAccount = '#url.useraccount#' 
	AND          OA.AccessLevel = '#url.access#'
	ORDER BY O.HierarchyCode
</cfquery>	

	<cf_divscroll>
	
	<table style="width:97%" align="center" class="navigation_table">
	
	<tr class="fixrow line labelmedium2 fixlengthlist">
	   <td><cf_tl id="Entity"></td>
	   <td><cf_tl id="OrgUnit"></td>
	   <td><cf_tl id="Code"></td>
	   <td><cf_tl id="Parameter"></td>	  
	   <td><cf_tl id="Updated"></td>   
	</tr>
	
	<cfoutput query="AccessDetail" group="OrgUnitCode">
	
		<tr class="line labelmedium2 navigation_row fixlengthlist">
		   <td style="padding-left:5px">#mission#</td>
		   <td title="#OrgUnitName#">#OrgUnitName#</td>
		   <td>#orgUnitCode#</td>
		   <td>
		   <cfoutput>#classParameter# #groupparameter#;&nbsp;</cfoutput>
		   </td>		   
		   <td>#dateformat(created,client.dateformatshow)#</td>   
		</tr>
		
		<cfoutput></cfoutput>
	
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

<cfset ajaxonload("doHighlight")>