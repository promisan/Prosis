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
<cfquery name="getMandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	Ref_Mandate
		WHERE	Mission = '#url.mission#'
		AND		Operational = 1
		AND		MandateDefault = 1
		ORDER BY Created DESC
</cfquery>
		
<cfoutput>	
			
    <table><tr class="labelmedium"><td>
    
	<cf_img icon="add" 
	  onClick="selectOrgUnitOwner('#url.costId#','webdialog','orgunit','orgunitcode','mission2','orgunitname','orgunitclass', '#url.mission#', '#getMandate.MandateNo#');">
	
	</td>
	
	<td style="padding-left:3px">
	<cfif url.costId neq "">
		<a href="javascript:selectOrgUnitOwner('#url.costId#','webdialog','orgunit','orgunitcode','mission2','orgunitname','orgunitclass', '#url.mission#', '#getMandate.MandateNo#');" style="color:4A81F7;">
			<cf_tl id="Limit rate to implementer">
		</a>
	</cfif>
	
	</td>
	
	<cfset vShow = "hidden">
	<cfif url.costId eq "">
		<cfset vShow = "text">
	</cfif>
	
	<td>
	<input type="#vShow#" 	name="orgunitcode" 	id="orgunitcode"  	value="" class="regularxl" size="5" readonly>
	</td>
	<td>
	<input type="#vShow#" 	name="orgunitname" 	id="orgunitname" 	value="" class="regularxl" size="35" readonly>
	</td>
	<input type="hidden" 	name="orgunit" 		id="orgunit"      	value="">
	<input type="hidden" 	name="mission2" 	id="mission2"      	value="">
	<input type="hidden" 	name="orgunitclass" id="orgunitclass"	value="" class="disabled" size="20" maxlength="20" readonly>
	
	</tr>
	</table>
			
</cfoutput>