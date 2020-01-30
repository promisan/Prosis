	
<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

 SELECT *
 FROM (

	SELECT O.Mission,
	       O.MissionOrgUnitId, 
		   MAX(O.HierarchyCode) as orgUnitHierarchy,
		   MAX(O.OrgUnitCode) as orgUnitCode, 
		   MAX(O.OrgUnitName) as OrgUnitName,
		   C.ConditionValue
	FROM   UserModuleCondition C RIGHT OUTER JOIN
           Organization.dbo.Organization O ON C.ConditionValue = O.MissionOrgUnitId 
			AND C.SystemFunctionId = '#URL.ID#'
			AND C.Account          = '#SESSION.acc#'
			AND C.ConditionField   = 'Implementer'
			
	WHERE   O.Mission IN (SELECT Mission 
                          FROM Organization.dbo.Ref_MissionModule 
					      WHERE SystemModule = 'WorkOrder')
						
	<!--- has income recorded in the workorder table --->						
	
	AND    (
	
			O.OrgUnit IN (SELECT   OrgUnit 
	                      FROM     WorkOrder.dbo.WorkOrderLineCharge 
				   	      WHERE    OrgUnit = O.OrgUnit) 
						 
			OR
						 
			O.OrgUnit IN (SELECT   WL.OrgUnitImplementer 
						  FROM     WorkOrder.dbo.WorkOrder AS W INNER JOIN
                                   WorkOrder.dbo.WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                           WorkOrder.dbo.Ref_ServiceItemDomainClass AS R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
						  WHERE    WL.OrgUnitImplementer = O.OrgUnit
						  AND      R.PointerSale = 1)
						  
			)							 						 					
	
	<cfif session.isAdministrator neq "Yes">
		
	AND    ( 
	
			O.Mission IN (
	                   SELECT Mission 
	                   FROM   Organization.dbo.OrganizationAuthorization
	                   WHERE  UserAccount = '#SESSION.acc#'
					   AND    Role IN (SELECT Role 
									   FROM   Organization.dbo.Ref_AuthorizationRole 
							           WHERE  SystemModule = 'WorkOrder')									   
					  )	
			
			<cfif SESSION.isLocalAdministrator neq "No">
				OR Mission IN (#preservesingleQuotes(SESSION.isLocalAdministrator)#)	
			</cfif>
			
			)
			 

	</cfif>
	
	GROUP BY Mission, MissionOrgUnitId, ConditionValue
	
	) as sub
	
	
	
	ORDER BY Mission, orgUnitHierarchy, OrgUnitName
						 				 
</cfquery>



<cfparam name="URL.Mode" default="Portal">

<cfform action="../Topics/TopicsEditSubmit.cfm?mode=#url.mode#" method="POST">

<cfoutput>
<input type="hidden" name="SystemFunctionId" value="#URL.ID#">
<input type="hidden" name="ConditionField"   value="Implementer">
</cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">

<tr><td>

<table width="100%" cellspacing="0" cellpadding="0">

<TR>
    <td height="26" colspan="3" style="padding-left:5px" class="labelit">Select one or more Revenue Centers</td>
</TR>
<tr><td colspan="3" class="linedotted"></td></tr>

<cfset module = "">

<cfoutput query="List" group="Mission">

   <tr><td colspan="2" style="padding-left:4px" class="labelmedium"><b>#Mission#</td></tr>
	
	<cfoutput>		
		
		<cfif ConditionValue is ''>
		   <tr class="regular" class="navigation_row linedotted">
		<cfelse>
		   <tr class="highLight" class="navigation_row linedotted">
		</cfif>   
		   
		    <td style="padding-left:10px" width="10%" align="center">
			<cfif ConditionValue is ''>
			<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#MissionOrgUnitId#">
			<cfelse>
			<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#MissionOrgUnitId#" checked>
			</cfif>
		    </td>
		    <td width="14%" class="labelmedium">#OrgUnitCode#</td>
			<TD class="labelmedium">#OrgUnitName#</TD>
		 
		</TR>
		
	
	</cfoutput>

</cfoutput>

<cfoutput>
	<input type="hidden" name="number" value="#List.recordcount#">
</cfoutput>

<tr><td colspan="3" height="35" align="center">   
   <input type="submit" class="button10g" name="Update" value="Save">
</td></tr>

</table>

</td></tr>

</table>
	
</CFFORM>

<cfset ajaxOnLoad("doHighlight")>
