<!--- Create Criteria string for query from data entered thru search form --->

<CF_Droptable dbName="AppsQuery" tblName="#SESSION.acc#EditionPeriod">	
	
<cfquery name="Used"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    EditionId,Period,SUM(Amount) as Amount 
	INTO      userQuery.dbo.#SESSION.acc#EditionPeriod
	FROM      ProgramAllotmentdetail  
	WHERE     Status != '9' 
	GROUP BY  EditionId,Period
</cfquery>

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    L.*, P.Period as PlanningPeriod, P.Amount
FROM      Ref_AllotmentEdition L LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#EditionPeriod P ON L.EditionId = P.EditionId
ORDER BY  L.Mission,L.EditionClass,L.Version,L.Period,P.Period
</cfquery>

<CF_Droptable dbName="AppsQuery" tblName="#SESSION.acc#EditionPeriod">	

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	
	
</cfoutput>

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	   
<tr class="labelit">
    <td width="30"></td>   
    <td></td>  
	<td>Id</td>
	<td>Execution</td> 
	<td>Fund</td>
	<td>Description</td>
	<td>Vw</td>
	<td>Mode</td>
	<td>Status</td>
	<td>Registered by</td>
    <td>Date</td>
	<td align="right">Amount Recorded for edition per planning period</td>
</tr>

<tr><td colspan="12" class="line"></td></tr>

<cfoutput query="SearchResult" group="Mission">

    <tr class="linedotted">
    	<td colspan="12" style="font-size:25px; height:40" class="labellarge">
		<img src="#SESSION.root#/Images/org_unit.gif" alt="" border="0" align="absmiddle">&nbsp;
		#Mission#</td>
    </tr>

<cfoutput group="EditionClass">

    <!---
    <tr class="linedotted">
		<td bgcolor="ffffef"></td>
    	<td colspan="12" height="20" class="cellcontent" bgcolor="ffffef"><b>&nbsp;#EditionClass#</b></td>
    </tr>
	--->

<cfoutput group="Version">

	<cfif version neq "">
	
		<cfquery name="Version"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_AllotmentVersion
		WHERE   Code = '#version#' 
		</cfquery>
	
	    <tr class="line">
			<td bgcolor="E2F2FA"></td>
		    <td colspan="11" bgcolor="E2F2FA" class="labellarge cellcontent" style="height:30px;padding-left:20px">#Version.Description#</b>&nbsp;(#Version.ObjectUsage#)</b></td>
		</tr>
		
	</cfif>

<cfoutput group="Period">
 
<cfoutput group="EditionId">
    
	<tr class=" cellcontent navigation_row line">
	<td></td>
	<td align="center" style="padding-top:3px" height="20" width="25" class="navigation_action" onclick="recordedit('#EditionId#')">
	   <cf_img icon="select">	
	</td>
	<td style="padding-tight:3px">#EditionId#.</td>
	<td>
	<cfif Period eq "">All&nbsp;Periods<cfelse>#Period#</cfif>
	</td>
	<td><a href="javascript:recordedit('#EditionId#')">
	
	<cfquery name="Funds" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT R.*
				FROM   Ref_AllotmentEditionFund R, Ref_Fund F
				WHERE  R.Fund = F.Code
				AND    EditionId = '#editionid#'	
				ORDER BY ListingOrder
							
			</cfquery>
	
	<cfif Funds.recordcount eq "0">
		<font color="FF0000">No fund</font>
	<cfelse>
		<cfloop query="Funds">
		<cfif FundDefault eq "1">
		<font color="0080FF">#Fund#</font><cfelse>#Fund#</cfif><cfif currentrow neq recordcount>,</cfif>
		<cfif currentrow eq "5"><br></cfif>
		<cfif currentrow eq "10"><br></cfif>
		</cfloop>
	</cfif>
	
	</a></td>
	<td>#Description#</td>
	<td><cfif ControlView eq "1">Yes<cfelse>No</cfif></td>
	<td><cfif budgetEntryMode eq "1">Detailed<cfelse>Snapshot<cfif EntryMethod eq "Snapshot"><cfelse>[tr]</cfif></cfif></td>
	<td>
	
	<cfif Status eq "1">
	<img src="#SESSION.root#/Images/alert_good.gif" 
	    style="cursor: pointer;" 
		alt="Edition can be edited"  
		border="0" 
		align="absmiddle">
	<cfelseif Status eq "3">	
	<img src="#SESSION.root#/Images/logon.gif" 
	    style="cursor: pointer;" 
		height="13" width="13"
		alt="Edition has been locked for entry by the budget officer"  
		border="0" 
		align="absmiddle">	
	<cfelseif Status eq "9">
	<img src="#SESSION.root#/Images/alert_stop.gif" 
	    style="cursor: pointer;" 
		alt="Edition has been locked for execution"  
		border="0" 
		align="absmiddle">
	</cfif></td>
	
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		
	<td align="right"
    bgcolor="E7F5FA"
    style="border-left: 1px solid Silver;">
		<table width="200" cellspacing="0" cellpadding="0" class="formpadding">		
		<cfoutput>	
		<cfif planningperiod neq "">
		<tr class="line">
		   <td width="80" class="cellcontent">#PlanningPeriod#</td>
		   <td align="right" style="padding-right:3px" class="cellcontent">#numberFormat(Amount,",__")#</td>
		</tr>   
		</cfif>
		</cfoutput>
		</table>
	</td>
    </tr>
			
</cfoutput>		
</cfoutput>		
</cfoutput>		
</cfoutput>		
</cfoutput>		
</table>


</cf_divscroll>

</BODY></HTML>