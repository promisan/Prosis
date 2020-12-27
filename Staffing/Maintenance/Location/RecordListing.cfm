<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cfparam name="url.mission" default="">

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">

<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddLocation", "left=80, top=80, width=560, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditLocation", "left=80, top=80, width=560, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function reload(mis) {    
     ptoken.location('RecordListing.cfm?idmenu=#url.idmenu#&mission=' + mis)
}

</script>	
	
</cfoutput>

<table width="97%" align="center" class="navigation_table">

<tr><td colspan="5" height="20" style="padding-top:4px;padding-bottom:5px">

		<cfquery name="MissionList"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	R.Mission, M.MissionOwner
			FROM 	Ref_ParameterMission R, 
        			Organization.dbo.Ref_Mission M
			WHERE	R.Mission = M.Mission
			AND		R.Mission in (SELECT Mission FROM Location WHERE Mission = R.Mission) 
			
			<cfif getAdministrator("*") eq "0">
			AND     R.Mission IN (SELECT Mission 
			                      FROM   Organization.dbo.OrganizationAuthorization 
								  WHERE  AccessLevel > '0' AND UserAccount = '#session.acc#'
								  AND   Role IN ('HRPosition','OrgUnitManager'))
			</cfif>
			
			ORDER BY MissionOwner,R.Mission
		</cfquery>	
		
		<cfif MissionList.recordcount eq "0">
		
		<table align="center">
			<tr><td style="height:40" align="center" class="labelmedium">No access has been granted to maintain this lookup table</td></tr>
		</table>
		<cfabort>
		
		</cfif>
		
		<cfform>
	
		<cfselect name     = "Mission" 
		          group    = "missionowner" 
				  query    = "missionlist" 
				  value    = "mission" 
				  class="regularxl"
				  display  = "mission" 				 
				  selected = "#url.mission#" 
		          visible  = "Yes" 
				  enabled  = "Yes" 
				  queryposition="below" 
				  onchange = "reload(this.value)">
				<option value="">-- Any --
		 </cfselect>
		 
		 </cfform>
	   
	  </td>
</tr>	

<tr><td height="1" colspan="9" class="linedotted"></td></tr>

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Name	
			 FROM   System.dbo.Ref_Nation 
			 WHERE  Code = L.Country) as CountryName,
			(SELECT Description	
			 FROM   Payroll.dbo.Ref_PayrollLocation 
			 WHERE  LocationCode = L.ServiceLocation) as ServiceLocationDescription
	FROM 	Location L
	WHERE 	1=1
	<cfif url.mission neq "">
	AND		Mission = '#url.mission#'
	</cfif>
	<cfif getAdministrator("*") eq "0">
			AND     Mission IN (SELECT Mission 
			                      FROM   Organization.dbo.OrganizationAuthorization 
								  WHERE  AccessLevel > '0' AND UserAccount = '#session.acc#'
								  AND   Role IN ('HRPosition','OrgUnitManager'))
			</cfif>
	ORDER BY Mission, ListingOrder, LocationName 
</cfquery>   
	  
<tr class="labelmedium line">
    <td></td>
    <td>Code</td>
	<td>Location name</td>
	<td align="center">Effective</td>
	<td align="center">Expiration</td>
	<td align="center">Service Location</td>
	<td style="width:30px" align="center">S</td>
	<td>Officer</td>
    <td>Entered</td>
  
</tr>

<cfoutput query="SearchResult" group="Mission">

<tr height="30"><td colspan="9" class="labellarge">#Mission#</b></td></tr>
	
	<cfoutput>
	  	
	    <tr style="height:22px" class="cellcontent navigation_row line"> 
		<td width="5%" align="center">
		   <cf_img icon="open" navigation="Yes" onclick="recordedit('#LocationCode#')">
		</td>		
		<td>#LocationCode#</a></td>
		<td>#LocationName# <cfif countryname neq "">/ #CountryName#</cfif></td>
		<td align="center">#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#</td>
		<td align="center">#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#</td>
		<td align="center">#ServiceLocationDescription#</td>
		<td align="center">#ListingOrder#</td>
		<td>#OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
		
	</cfoutput>

</cfoutput>

</table>

</cf_divscroll>
