<!--
    Copyright © 2025 Promisan

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
<cfquery name="Category" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	C.*,
			(SELECT Category FROM Ref_AssetActionCategory WHERE Category = C.Category AND ActionCategory = '#URL.ID1#') as Selected
	FROM	Ref_Category C
	ORDER BY Created
</cfquery>

<table class="hide">
	<tr><td><iframe name="processCategoryMetric" id="processCategoryMetric" frameborder="0"></iframe></td></tr>
</table>

<cfform action="MetricSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="post" name="frmCategoryMetric" target="processCategoryMetric">

<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	

	<cfloop query="Category">
	<cfset vcategory = replace('#category#',' ', '', 'ALL')>
	
	<cfoutput>
	
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF" id="rowcat_#vcategory#" <cfif selected neq "">style="background-color:E1EDFF"</cfif>>		
			<td width="20"></td>
			<td>			
				<input type="checkbox" name="cat_#vcategory#" id="cat_#vcategory#" value="#category#" onclick="javascript: selectCategory('detail_#vcategory#', 'rowcat_#vcategory#', this);" <cfif selected neq "">checked</cfif>>
			</td>
			<td width="90%" class="labelit">#Category# - #Description#</td>		
		</tr>
		
		<tr id="detail_#vcategory#" style="<cfif selected eq "">display:none</cfif>">
			<td width="20"></td>
			<td colspan="2">
		
	</cfoutput>
			<cfset numberOfColumns = 4>
			<table width="93%" cellspacing="0" cellpadding="0" align="center">
										
				<cfquery name="Metric" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	M.*,
							(SELECT Metric FROM Ref_AssetActionMetric WHERE Metric = M.Code AND Category = '#category#' AND ActionCategory = '#URL.ID1#') as Selected
					FROM	Ref_Metric M
					ORDER BY Measurement, Created
				</cfquery>				
				
					<cfset metricCount = 0>
					<cfoutput query="Metric">
					<td height="14" class="labelit" id="rowmet_#vcategory#_#code#" <cfif selected neq "">style="background-color:D9FBDF"</cfif>>						
						<input type="checkbox" name="met_#vcategory#_#code#" id="met_#vcategory#_#code#" value="#code#" onclick="javascript: selectMetric('rowmet_#vcategory#_#code#', this);" <cfif selected neq "">checked</cfif>>
						</td>
						<td class="labelit" style="padding-left:4px">#code# - #Description#
						<cfset metricCount = metricCount + 1>
					</td>
					<cfif metricCount eq numberOfColumns>
						</tr>
						<tr>
						<cfset metricCount = 0>
					</cfif>
					</cfoutput>
					</tr>				
							
			</table>
		</td>
	</tr>
		
	</cfloop>
	<tr><td height="4"></td></tr>	
	<tr><td colspan="3" align="center"><input class="button10g" type="submit" name="Update" id="Update" value="Update"></td></tr>
</table>

</cfform>