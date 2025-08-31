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
<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT COUNT(*) 
	           FROM   Item 
			   WHERE  Category = C.Category) as Counted
	FROM   #CLIENT.LanPrefix#Ref_Category C
	ORDER BY StockControlMode, Category
</cfquery>	

<table width="98%" class="navigation_table">

	<tr class="fixrow labelmedium2 fixlengthlist">
	   
	    <td height="20" width="5%"></TD>
	    <td style="padding-left:4px"><cf_tl id="Code"></TD>		
		<td><cf_tl id="Description"></TD>
		<td><cf_tl id="Mode"></TD>
		<td align="center"><cf_tl id="Tab"></td>
		<td><cf_tl id="Icon"></td>
		<td title="Requested items need to be cleared by Warehouse manager">Review</TD>
		<td><cf_tl id="FP"></TD>
		<td><cf_tl id="Sensitive"></td>   
		<td><cf_tl id="Officer"></td>
		<td style="text-align:right;padding-right:8px"><cf_tl id="Entered"></TD>
		
	</tr>
	
	<cfoutput query="SearchResult" group="StockControlMode">
	
		<tr class="line  labelmedium2"><td style="height:40px;font-size:25px" colspan="11">#StockControlMode#</td></tr>
	    
		<cfoutput>
	    <TR class="navigation_row line labelmedium2 fixlengthlist"> 	
			
		<td>
			  		
				<table>
					<tr>
						
						<td style="padding-right:10px padding-top:21x;padding-left:3px">
							<cf_img icon="open" navigation="Yes" onclick="recordedit('#Category#');">
						</td>
						<td style="padding-left:6px; padding-top:1px;">
							<cfif counted eq 0>
								<cf_img icon="delete" onclick="recordpurge('#Category#');">
							</cfif>
						</td>
					</tr>
				</table>
				
			</td>
			<TD style="padding-left:4px">#Category#</TD>		
			<TD>#Description#</TD>
			<TD>#stockControlMode#</TD>
			<td align="center">#tabOrder#</td>
			<td><cfif trim(tabIcon) neq ""><img src="#SESSION.root#/Custom/#tabIcon#" height="18" width="18" alt="#SESSION.root#/Custom/#tabIcon#" border="0" align="absmiddle"></cfif></td>
			<TD><cfif initialreview eq "1">Yes</cfif></TD>
			<TD><cfif FinishedProduct eq "0"><cfelse>Yes</cfif></TD>
			<td><cfif SensitivityLevel eq "0">Low<cfelse>High</cfif></td>
			<TD>#OfficerLastName#</TD>
			<TD align="right" style="padding-right:8px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
			
	    </TR>
		
		</cfoutput>
	
	</CFOUTPUT>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	