<!--- 
19/11/03 - Fixed filter on for 'all' or 'only' display for organization
			If URL.View - 'ALL' process sub units, else 'only' do top level:  KRW
--->

<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>View by Organization</TITLE>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</HEAD><body onLoad="window.focus()">

<!--- Query returning search results --->

<cfif #URL.ID# eq "ORG">

	<cfinvoke component="Service.AccessGlobal"
    Method="global"
  	Role="AdminProgram"
	ReturnVariable="ManagerAccess">	

  <cfif #ManagerAccess# is "EDIT" OR #ManagerAccess# is "ALL">

		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT distinct O.*
		    FROM #CLIENT.LanPrefix#Organization O
			WHERE O.Mission   = '#URL.Mission#' 
			  AND O.MandateNo = '#URL.Mandate#'
			#preserveSingleQuotes(cond)#
		ORDER BY O.Mission, TreeOrder
		</cfquery>
		
		<cfelse>
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT distinct O.*
		    FROM #CLIENT.LanPrefix#Organization O, OrganizationAuthorization P
			WHERE O.OrgUnit = P.OrgUnit
			AND P.Role      = 'ProgramOfficer'
			AND P.UserAccount = '#SESSION.acc#'
			AND O.Mission   = '#URL.Mission#' 
			AND O.MandateNo = '#URL.Mandate#'
			#preserveSingleQuotes(cond)#
		ORDER BY O.Mission, TreeOrder
		</cfquery>

   </cfif>

</cfif>

<cfif #URL.ID# eq "ORG">
<cfset cond = ''>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#8EA4BB" style="border-collapse: collapse">

<TR bgcolor="#6688AA">
    <td width="7%"></td>
    <TD width="10%" class="top"><cf_tl id="Code"></TD>
    <td width="40%" colspan="2" class="top"><cf_tl id="Program Name"></td>
    <TD width="15%" class="top"><cf_tl id="Reference"></TD>
    <TD width="15%" class="top"><cf_tl id="Entered by"></TD>
    <TD width="8%" class="top"><cf_tl id="Date">&nbsp;</TD>
	<TD width="20" class="top"></TD>

</TR>

<tr><td height="10"></td></tr>

<cfoutput query="SearchResult" group="TreeOrder" startrow=#first# maxrows=#No# >

<cfoutput>

<tr bgcolor="FCFED3">
   <td class="regular">&nbsp;
    <a href="javascript:editOrgUnit('#OrgUnit#')">
    <img src="../../../../images/view.gif" alt="" width="14" height="15" border="0" align="middle">
   </a>
     </td>
	   <td class="regular"><b>#OrgUnitCode#</b></td>
       <td colspan="4" class="regular"><b>#OrgUnitName#</b></td>
       <TD colspan="2" class="regular"><b>#OrgUnitClass#&nbsp;</b></TD>
	 </TR>
		
	<cfquery name="ProgramLevel00" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, Pe.ProgramId
     FROM   #CLIENT.LanPrefix#Program P, ProgramPeriod Pe
	 WHERE  Pe.OrgUnit = '#SearchResult.OrgUnit#'
	 AND    P.ProgramCode = Pe.ProgramCode
	 AND	Pe.RecordStatus != 9
	 AND    Pe.Period = '#URL.Period#'
	 AND   (P.ParentCode = '' OR P.ParentCode Is NULL)
	 ORDER BY ListingOrder
    </cfquery>
		
	<cfloop query="ProgramLevel00">
				
	<cfinclude template="ProgressViewOrganizationDetail.cfm">  
	   
    </cfloop>
	     
</CFOUTPUT>

<tr><td height="10" colspan="5" ></td></tr>

</CFOUTPUT>

</TABLE>

</BODY></HTML>