<cfquery name="Mission" 
		datasource="appsworkorder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization.dbo.Organization 
			WHERE OrgUnit = '#url.org#'
</cfquery>

<cfquery name="Customer" 
		datasource="appsworkorder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 20 *, (SELECT OrgUnitCode 
			                   FROM  Organization.dbo.Organization 
							   WHERE OrgUnit = Customer.OrgUnit) as orgUnitCode
			FROM  Customer		
			WHERE OrgUnit = '#url.org#' 	
			ORDER BY CustomerName
</cfquery>

<cfinvoke component="Service.Presentation.Presentation" 
	      method="highlight" 
		  returnvariable="stylescroll"/>

<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td><font face="Verdana" size="2"><b>Service Inventory</font></td></tr>
<tr><td height="4"></td></tr>

<cfif customer.recordcount gt "1">
	
	<cfoutput query="Customer">
		
		<tr #stylescroll#>
		<td height="18"  width="100%" id="box#customerid#">
		
			<table  width="100%" cellspacing="0" cellpadding="0" onclick="ColdFusion.navigate('#SESSION.root#/system/organization/customer/CustomerEdit.cfm?portal=#url.portal#&customerid=#Customer.CustomerId#&id4=appsWorkOrder','detail',mycallBack,myerrorhandler)">
				<tr>
				<td rowspan="2" height="18" width="20"><img src="#SESSION.root#/images/pointer.gif" height="9" alt="" border="0"></td>
				<td oncontextmenu="viewOrgUnit('#orgunit#')"><font color="0080FF">
				#CustomerName# <cfif OrgUnit neq "">[#OrgUnitCode#]</cfif></font></td>
				</td>
				</tr>			
			</table>
			
		</tr>
	
	</cfoutput>
	
</cfif>

<tr><td class="line" style="color : silver; height : 1px;"></td></tr>

<tr><td id="detail">
	
	<cfset url.customerid = customer.customerid>
	<cfset url.height = "full">
	<cfset url.mode   = "view">	
	<cfset url.portal = "1">		
	<cfset url.mission = mission.mission>		
	<cfinclude template="../../../System/Organization/Customer/CustomerEdit.cfm">

</td></tr>



