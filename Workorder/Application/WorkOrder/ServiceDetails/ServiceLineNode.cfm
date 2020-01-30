
<cfparam name="url.OrgUnit" default="">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderLine     = '#url.workorderline#'	
		 AND     WorkOrderId       = '#url.workorderid#'
</cfquery>

<cfif url.OrgUnit neq "">
		
		<cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnit = '#url.orgunit#'	
		</cfquery>
	
<cfelse>
	
	<cfquery name="OrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#Line.OrgUnit#'	
	</cfquery>
	
</cfif>

<table width="300" cellspacing="0" cellpadding="0"><tr><td>
	
	<cfoutput query="OrgUnit">
		<input type="hidden" name="OrgUnit" id="OrgUnit" value="#OrgUnit.OrgUnit#">
		<input type="hidden" name="Name" id="Name" value="#OrgUnit.OrgUnitName#" class="regular3">				
		
	</cfoutput>
	
	</td>

	<td class="labelmedium" style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:24px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput query="OrgUnit">
		#OrgUnitName#
	</cfoutput>
	</td>
	
</tr></table>
