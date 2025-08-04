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
<cfquery name="actions" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	AssetItemAction
		WHERE	ActionDate = '#dateformat(url.calendardate,client.dateSQL)#'
</cfquery>

<!---- 
	AND     ActionCategory = '#url.mission#'
--->		

<cfif actions.recordcount EQ 0>										  						   
	
<cfelse>	
   													
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
																			
		<cfoutput query="actions">		
		<tr>								
		  <td align="center" >
				<span style="line-height:10px; font-size:10px;">xx</span>
		  </td>
		</tr>
		</cfoutput>

	</table>
																
</cfif>
							