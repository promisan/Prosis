<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	*
		FROM  	Ref_EntryClass
		WHERE 	1=1
		<cfif url.fmission neq "">
		AND   	Code IN (
							SELECT DISTINCT EntryClass
							FROM   ItemMaster I, ItemMasterMission IM
							WHERE  I.Code = IM.ItemMaster
							AND    I.Operational = 1
							AND    IM.Mission = '#url.fmission#' 
						) 
		</cfif>
		ORDER BY ListingOrder
			
</cfquery>

<cfloop query="SearchResult">

	  <!--- used for creating a workflow per class : bidding etc. --->	
		<cf_insertEntityClass  
	      Code        = "ProcJob"   
          Class       = "#Code#" 
   		  Description = "#Description#">	
			
</cfloop>	

<table width="100%" align="center" class="navigation_table">

<tr><td height="8"></td></tr>
<tr class="line labelmedium">
	<TD width="5%">&nbsp;</TD>
    <TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Description"></TD>
	<TD align="center"><cf_tl id="Sort"></TD>	
	<td><cf_tl id="Interface"></td>
	<TD><cf_tl id="Officer"></TD>
    <TD><cf_tl id="Entered"></TD>
</TR>

<cfif SearchResult.recordCount eq 0>
	<tr>
		<td height="35" colspan="8" align="center">
			<font face="Calibri" color="gray" size="3"><i>No entry classes recorded<cfif url.fmission neq ""><cfoutput> for the entity #url.fmission#</cfoutput></cfif>
		</td>
	</tr>
	<tr><td colspan="7" class="linedotted"></td></tr>
</cfif>

<cfoutput query="SearchResult">
	
    <TR class="navigation_row labelmedium line"> 
		<TD height="18" align="center" style="padding-top:2px">
		    <cf_img icon="select" navigation="yes" onclick="recordedit('#Code#','#url.fmission#')">
		</TD>
		<TD><a href="javascript:recordedit('#Code#','#url.fmission#')">#Code#</a></TD>
		<TD>#Description#</TD>
		<TD align="center">#ListingOrder#</TD>
		<td><cfif CustomDialog eq "">None<cfelse>#CustomDialog#</cfif></td>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
		
</CFOUTPUT>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>	