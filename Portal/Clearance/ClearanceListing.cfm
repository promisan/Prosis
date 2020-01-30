<cf_screentop html="no">

<cfoutput>

<table width="100%" border="1" bordercolor="000000">
<tr><td>
   <table width="100%" border="0" bordercolor="000000">
   <tr>
      <td height="23" class="BannerXLN">&nbsp;<b>For my action</b>&nbsp;</td>
      <td height="23" align="right" valign="bottom" class="bannerN">
	  <a href="../Portal.cfm"><font face="Trebuchet MS" color="FFFFFF">Home</font></a>&nbsp;
	  </td>
   </tr>
       
   </table>
</td></tr>
</table>

<table><tr><td height="5"></td></tr></table>

</cfoutput>

<cfparam name="URL.ID" default="">
<cfset CLIENT.Review = "#URL.ID#">
<cfparam name="URL.Sorting" default="">

<cfflush>

<!--- Check attendance --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_SystemModule
WHERE SystemModule = 'Attendance'
AND Operational = '1'
</cfquery>

<cfif SearchResult.recordCount eq "1">

    <cfinclude template="Leave/SubListing.cfm">

</cfif>

<!--- disabled Hanno 15/04/2005

<!--- Check program --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_SystemModule
WHERE SystemModule = 'Program'
AND Operational = '1'
</cfquery>

<cfif SearchResult.recordCount eq "1">

    <cfinclude template="Program/ProgramSubListing.cfm">

</cfif>

--->

<!--- delete code 

<!--- Check budget --->

<!--- check authorization.  If Overall budget manager '3003' then all orgunits available
if not, then get org list of where budget manager and select allotments
that are pending from that list --->

<cfinvoke component="Service.Access"
	Method="function"
	SystemFunctionID="3003"
	ReturnVariable="ManagerAccess">	
		
<CFIF #ManagerAccess# is "GRANTED">
	<cfset BudgetCond = "">
<cfelse>
	<cfset BudgetCond = "AND P.OrgUnit in (Select OrgUnit from Organization.dbo.OrganizationAuthorization O Where O.UserAccount = '#SESSION.acc#' AND O.Role = 'BudgetManager')">
</cfif>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PendingAllotments"> 
	
<cfquery name="PendingAllotments" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Distinct PAD.ProgramCode, P.ProgramName, P.ParentCode, O.OrgUnit, O.HierarchyCode
    INTO UserQuery.dbo.#SESSION.acc#PendingAllotments
	FROM ProgramAllotmentDetail PAD, Program P, ProgramPeriod PP, Organization.dbo.Organization O
	Where PAD.Status = 0
		AND PAD.ProgramCode = P.ProgramCode
		AND P.ProgramCode = PP.ProgramCode
		AND PP.RecordStatus !=9
		AND P.OrgUnit = O.OrgUnit
	   #PreserveSingleQuotes(BudgetCond)# 				
</cfquery>

<!--- done just to get recordcount.  Ask Hanno about this --->
<cfquery name="PendingAllotments" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * From #SESSION.acc#PendingAllotments		
</cfquery>
		
<cfif PendingAllotments.recordCount gt "0">

    <cfinclude template="Budget/BudgetSubListing.cfm">

</cfif>

--->

<!--- Check warehouse --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_SystemModule
WHERE SystemModule = 'Warehouse'
AND Operational = '1'
</cfquery>

<cfif SearchResult.recordCount eq "1">

        <!---retrieving records initial clearance --->

		<!--- Identify pending records --->
		<cfset IDStatus = "i">
		<cfset StatusNext = "1">
		<cfparam name="URL.Sorting" default="RequestDate">
		<cfset action = "Unit chief requisition clearance">
		<cfset role = "ReqClear">
		
		<cfif URL.Sorting eq "">
		    <cfset URL.Sorting = "RequestDate">
			<cfset ord = "ORDER BY RequestDate">
		<cfelse>
			<cfset ord = "ORDER BY #URL.Sorting#">
		</cfif>
		
		<cfif getAdministrator("*") eq "0">
		
			<cfquery name="SearchResult" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT L.*, A.UnitOfMeasure, A.ItemPrecision, A.ItemDescription, Org.Mission, Org.OrgUnitName, Org.HierarchyCode
			FROM  OrganizationAuthorization O, 
			      Organization Org, 
				  Materials.dbo.Request L, 
				  Materials.dbo.Item A
			WHERE O.UserAccount = '#SESSION.acc#'
			AND   O.AccessLevel IN ('0','1','2')
			AND   O.Role = 'ReqClear'
			AND   L.OrgUnit = O.OrgUnit
			AND   Org.OrgUnit = O.OrgUnit
			AND   L.ItemNo = A.ItemNo
			AND   L.Status = '#IDStatus#' 
			#ord#
			</cfquery>
		
		<cfelse>
		
				<cfquery name="SearchResult" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT L.*, A.UnitOfMeasure, A.ItemPrecision, A.ItemDescription, Org.Mission, Org.OrgUnitName, Org.HierarchyCode
			FROM  Organization Org, 
				  Materials.dbo.Request L, 
				  Materials.dbo.Item A
			WHERE   L.OrgUnit = Org.OrgUnit
			AND   L.ItemNo = A.ItemNo 
			AND   L.Status = '#IDStatus#'
			#ord#
			</cfquery>
		
		</cfif>	
				

       <cfinclude template="Warehouse/ClearanceSubListing.cfm">
	   
	   <!--- retrieving records warehouse clearer --->
	   
	   <!--- Identify pending records --->
		<cfset IDStatus = "1">
		<cfset StatusNext = "2">
		<cfparam name="URL.Sorting" default="RequestDate">
		<cfset action = "Warehouse requisition clearance">
		<cfset role = "WhsClear">
		
		<cfif URL.Sorting eq "">
		    <cfset URL.Sorting = "RequestDate">
			<cfset ord = "ORDER BY RequestDate">
		<cfelse>
			<cfset ord = "ORDER BY #URL.Sorting#">
		</cfif>
						
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT L.*, A.UnitOfMeasure, A.ItemPrecision, A.ItemDescription, Org.Mission, Org.OrgUnitName, Org.HierarchyCode
		FROM  OrganizationAuthorization O, 
		      Materials.dbo.Warehse W, 
		      Materials.dbo.Request L, 
			  Organization Org, 
			  Materials.dbo.Item A
		WHERE O.UserAccount = '#SESSION.acc#'
		AND   O.AccessLevel IN ('0','1','2')
		AND   O.Role = 'WhsClear'
		AND   W.OrgUnit = O.OrgUnit
		AND   W.Warehouse = L.Warehouse
		AND   L.OrgUnit = Org.OrgUnit 
		AND   L.ItemNo = A.ItemNo
		AND   L.Status = '#IDStatus#'
		#ord#
		</cfquery>
		
		<cfinclude template="Warehouse/ClearanceSubListing.cfm">
		
		   <!--- retrieving records receiver --->
	   
	   <!--- Identify pending records --->
		<cfset IDStatus = "1">
		<cfset StatusNext = "2">
		<cfparam name="URL.Sorting" default="Req.RequestDate">
		<cfset action = "Confirm the receipt of warehouse items">
		<cfset role = "ReqReceipt">
		
		<cfif URL.Sorting eq "">
		    <cfset URL.Sorting = "RequestDate">
			<cfset ord = "ORDER BY RequestDate">
		<cfelse>
			<cfset ord = "ORDER BY #URL.Sorting#">
		</cfif>
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
		        l.TransactionRecordNo,
				L.ShippingItemNo as ItemNo,
				L.TransactionUoM as UnitOfMeasure,
				L.TransactionQuantity as RequestedQuantity,
				L.TransactionPrice as StandardCost,
				L.TransactionValue as RequestedAmount,
				L.ItemDescription, Org.Mission, Org.OrgUnitName, Org.HierarchyCode,
				Req.RequestDate,
				L.RequestId,
				L.Status,
				L.Reference
		FROM  OrganizationAuthorization O, 
		      Organization Org, 
		      Ref_AuthorizationRole R, 
			  Materials.dbo.Shipping L,
			  Materials.dbo.Request Req
		WHERE O.UserAccount = '#SESSION.acc#'
		AND   O.AccessLevel IN ('0','1','2')
		AND   R.Role = 'ReqClear'
		AND   R.Role = O.Role
		AND   L.OrgUnit = O.OrgUnit
		AND   Org.OrgUnit = O.OrgUnit
		AND   L.Status = '#IDStatus#'
		AND   L.RequestId = Req.RequestId
		#ord#
		</cfquery>
	
		<cfinclude template="Warehouse/ClearanceSubListing.cfm">

</cfif>


</body>
</html>
