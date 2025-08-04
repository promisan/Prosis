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

<!--- item Uom header --->

<cfset mode = "Mission">

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#URL.ID#'		
		AND      Operational = 1		
		ORDER BY UoM
</cfquery>	

<cfform method="POST" name="uomform">

<table width="98%" align="center">

	<cfoutput query="ItemUoM"> 	
	
	<tr class="labemedium2"><td style="height:35px;font-weight:bold;font-size:20px" colspan="3">#UoMDescription#</td></tr>
	
	<tr class="labemedium2"><td colspan="3">
	
	    <cfset row = currentrow>
		<cfset mis = url.mission>
		<cfinclude template="ItemUoMTopic.cfm">
		
		</td>
	</tr>
		
	</cfoutput>
				
	<tr>
		<td colspan="2" align="center" style="height:40px">
			<input type="button" style="width:140px" class="button10g" name="Save" id="Save" value="Save" onclick="itmtopicsubmit()">
		</td>
	</tr>

</table>

</cfform>