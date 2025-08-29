<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<tr class="line labelmedium2">
    
    <TD style="padding-left:14px" align="left">Code</TD>
	<TD align="left">Promotion Name</TD>
	<TD align="left">Effective</TD>
	<TD align="left">Expiration</TD>
	<TD align="left">Priority</TD>
	<TD align="center">Enabled</TD>
	<TD align="right">Created</TD>
	<TD align="left"></TD>
</TR>

<cfset vCols = 8>

<cfif SearchResult.recordCount eq 0>

	<tr><td height="25" class="labelmedium" colspan="<cfoutput>#vCols#</cfoutput>" align="center">No promotions recorded<cfif url.fmission neq ""> for <cfoutput>#url.fmission#</cfoutput></cfif></td></tr>
	<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
	
</cfif>

<cfoutput query="SearchResult" group="Mission">

	<tr class="line"><td colspan="#vCols#" style="height:26px;padding-bottom:3px;face:Calibri;font-size:21px;">#Mission#</td></tr>
			
		<cfoutput>
			    
		    <TR class="labelmedium2 line navigation_row" style="<cfif operational eq 0>font-style:italic; color:808080;</cfif>"> 
				
				<TD style="padding-left:14px" align="left">#PromotionNo#</TD>
				<TD>#Description#</TD>
				<TD>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")# - #Timeformat(DateEffective, "HH:mm")#</TD>
				<cfif DateExpiration neq "">
					<TD>#dateformat(DateExpiration, "#CLIENT.DateFormatShow#")# - #Timeformat(DateExpiration, "HH:mm")#</TD>
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
						    <td style="padding-right:5px"><cf_img icon="open" navigation="Yes" onclick="recordedit('#PromotionId#');"></td>
							<td><cf_img icon="delete" onclick="recordpurge('#PromotionId#','#url.fmission#');"></td>								
						</tr>
					</table>
				</td>
		    </TR>
	
		</cfoutput>
	
</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>