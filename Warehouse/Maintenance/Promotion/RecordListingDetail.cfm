<cfparam name="url.fmission" default="">
<cfparam name="url.filter" default="active">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	P.*
	FROM 	Promotion P
	WHERE	1=1
	<cfif url.fmission neq "">
		AND Mission = '#url.fmission#'
	</cfif>
	<cfif url.filter eq "active">
		AND	(DateExpiration >= getDate() OR DateExpiration IS NULL)
	</cfif>
	<cfif url.filter eq "expired">
		AND DateExpiration < getDate()
	</cfif>
	ORDER BY Mission ASC, DateEffective DESC, DateExpiration DESC
</cfquery>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="line">
    
    <TD style="padding-left:14px" align="left" class="labelmedium">Code</TD>
	<TD align="left" class="labelmedium">Promotion Name</TD>
	<TD align="left" class="labelmedium">Effective</TD>
	<TD align="left" class="labelmedium">Expiration</TD>
	<TD align="left" class="labelmedium">Priority</TD>
	<TD align="center" class="labelmedium">Enabled</TD>
	<TD align="right" class="labelmedium">Created</TD>
	<TD align="left" class="labelmedium"></TD>
</TR>

<cfset vCols = 8>

<cfif SearchResult.recordCount eq 0>

	<tr><td height="25" class="labelmedium" colspan="<cfoutput>#vCols#</cfoutput>" align="center">No promotions recorded<cfif url.fmission neq ""> for <cfoutput>#url.fmission#</cfoutput></cfif></td></tr>
	<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
	
</cfif>

<cfoutput query="SearchResult" group="Mission">

	<tr class="line"><td colspan="#vCols#" style="padding-bottom:3px;face:Calibri;font-size:17px;">#Mission#</td></tr>
			
		<cfoutput>
			    
		    <TR class="labelmedium line navigation_row" style="<cfif operational eq 0>font-style:italic; color:808080;</cfif>"> 
				
				<TD style="padding-left:14px" align="left">#PromotionNo#</TD>
				<TD>#Description#</TD>
				<TD>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")# - #Timeformat(DateEffective, "HH:mm")#</TD>
				<cfif DateExpiration neq "">
					<TD>
						#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")# - #Timeformat(DateExpiration, "HH:mm")#
					</TD>
				<cfelse>
					<TD style="color:808080;">[Not defined]</TD>
				</cfif>	
				<td>#Priority#</td>
				<TD align="center">
					<cfif operational eq 1>
						Yes
					<cfelseif operational eq 0>
						<b>No</b>
					</cfif>
				</TD>
				<TD align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
				
				<td align="center" style="padding-top:3px">
					<table cellspacing="0" cellpadding="0">
						<tr>
						    <td style="padding-right:5px"><cf_img icon="edit" navigation="Yes" onclick="recordedit('#PromotionId#');"></td>
							<td><cf_img icon="delete" onclick="recordpurge('#PromotionId#','#url.fmission#');"></td>								
						</tr>
					</table>
				</td>
		    </TR>
	
		</cfoutput>
	
</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>