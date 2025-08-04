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
<cfquery name="Items" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  I.*,
				(SELECT Description FROM Ref_Category WHERE Category = I.Category) as CategoryDescription,
				(SELECT CategoryItemName FROM Ref_CategoryItem WHERE Category = I.Category AND CategoryItem = I.CategoryItem) as CategoryItemName
        FROM    PromotionElementItem I
		WHERE	1=1
		<cfif url.id1 neq "">
		AND		I.PromotionId = '#url.id1#'
		AND		I.ElementSerialNo = '#url.serial#'
		<cfelse>
		AND		1=0
		</cfif>
		ORDER BY I.Category, I.CategoryItem
</cfquery>

<table width="100%" align="center">
	<tr>
		
		<td>
			<table cellspacing="0" cellpadding="0">
				<cfset cnt = 0>
				<cfset cols = 8>
				<cfif Items.recordCount eq 0>
					<tr>
						<td colspan="2" style="color:808080;">[<cf_tl id="No items recorded">]</td>
					</tr>
				<cfelse>
					<cfoutput query="Items" group="Category">
						<tr>
						<td style="padding-right:20px" colspan="1" class="labelmedium"><b>#CategoryDescription#:</td>
						<td>
						
						    <cfoutput>
								
								<cfset cnt = cnt + 1>
																								
								<td class="labelit" style="border:0px dotted ##C0C0C0;">#trim(CategoryItemName)#&nbsp;;&nbsp;</td>
								
								<cfif cnt eq cols>
									<cfset cnt = 0>
									</tr>
									<tr>
									<td width="10"></td>
								</cfif>
								
							</cfoutput>
						
						</td>						
						</tr>
							
					</cfoutput>
				</cfif>
			</table>
		</td>
	</tr>	
</table>