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
<cfparam name="url.mode" default="standard">
<cfparam name="url.workorderid" default="all">

<cfquery name="Get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Item I, Ref_Category R
		WHERE    I.Category = R.Category
		AND      I.ItemNo = '#url.ItemNo#'		
</cfquery>	
	
<cfoutput>
						
	<script language="JavaScript">
			
		try { document.getElementById('itemno').value  = "#get.Itemno#"	} catch(e) {}
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getUoM.cfm?mission=#url.mission#&workorderid=#url.workorderid#&itemno=#url.ItemNo#','uombox')		
					
	</script>	
		
	<table width="100%" cellspacing="0" border="0" cellpadding="0">
			
			<cfif url.mode eq "standard">
			<tr>				
			    <td colspan="2" style="height:20px;padding-left:0px;padding-right:3px" class="labelmedium">#get.ItemNo# #get.ItemDescription#</td>				
			</tr>
			</cfif>
			
			<tr>
				<td class="labelmedium" style="height:20px;padding-left:0px;padding-right:3px">#get.Description# / #get.ItemClass#</td>				
			</tr>
									
	</table>			

</cfoutput>

