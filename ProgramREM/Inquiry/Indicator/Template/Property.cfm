
<cfinclude template="IndicatorTarget.cfm">

<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.item" default="">
<cfparam name="url.select" default="All">

<!--- customise to show additional details in the left box  --->

<cftry>

	<cfquery name="Probe" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  TOP 1 *
	FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE 1 = 1
	#preservesingleQuotes(OrgFilter)#
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)# 
	</cfif>
	</cfquery>
	
	<cfset tbl = "EmployeeSnapShot.dbo.HRPO_AppStaffingDetail">
	
	<cfcatch>
		<cfset tbl = "userQuery.dbo.#SESSION.acc#Indicator#url.fileNo#">
	</cfcatch>

</cftry>

<cfsavecontent variable="from">
	<cfoutput>
	FROM    #tbl#
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq ""> 
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)# 
	</cfif>
	
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#'
	</cfif>
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	
	</cfoutput>	
</cfsavecontent>

<cfquery name="Position" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  count(*) as Position,
	        count(distinct OrgUnitName) as OrgUnit,
			count(distinct PersonNo) as Person
	#preservesingleQuotes(from)#
</cfquery>  

<cfquery name="PostClass" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  PostClass,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY PostClass
</cfquery>  

<cfquery name="Nationality" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  top 13 Nationality,
	        count(*) as Total
	#preservesingleQuotes(from)#
	AND     Nationality > ''
	GROUP BY Nationality
	ORDER BY Total DESC
</cfquery>  

<cfquery name="Gender" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  Gender,
	        count(*) as Total
	#preservesingleQuotes(from)#	
	AND     PersonNo > ''
	GROUP BY Gender
</cfquery>  

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td colspan="2" height="20" align="center"><input type="button" class="button10g" name="Close" onclick="javascript:ColdFusion.Window.hide('rightpanel')" value="Close"></td></tr>
<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
<tr><td valign="top">
	
	<table width="99%" border="0" bordercolor="silver" align="center" border="0" cellpadding="0" class="formpadding">
	<cfoutput>
	<tr><td colspan="1">#url.item#:</td><td align="right"><b>#URL.Select#</b></td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</cfoutput>
	
	<tr>
	<td>Units:</td>
	<td align="right"><cfoutput>#Position.OrgUnit#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	
	<tr><td><b>Positions:</td>
		<td align="right"><cfoutput><b>#Position.Position#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	<cfoutput query="PostClass">
	<tr><td>#PostClass#</td>
		<td align="right">#Total#</td>
	</tr>
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	<tr><td><b>Gender</td>
		<td align="right"><cfoutput><b>#Position.Person#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<cfoutput query="Gender">
	<tr><td>#Gender#</td>
		<td align="right">#Total#</td>
	</tr>	
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	</table>
	
</td>

<td valign="top">
	<table width="99%" border="0" bordercolor="silver" align="center" border="0" cellpadding="0" class="formpadding">
		<tr><td><b>Staff:</td>
			<td align="right"><cfoutput><b>#Position.Person#</cfoutput></td>
		</tr>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		<cfoutput query="Nationality">
		<tr><td>#Nationality#</td>
			<td align="right">#Total#</td>
		</tr>
		</cfoutput>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</table>
</td>

</tr>
</table>

	