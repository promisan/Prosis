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
<cfparam name="url.date" default="#now()#">
<cf_tl id="Loss Detail" var = "vLabel">

<cf_screentop height="100%" label="#vLabel#" layout="webapp" scroll="yes" banner="gray" user="no">

<cfquery name="UoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	U.*
		FROM  	ItemUoM U
				INNER JOIN ItemWarehouseLocation L
					ON 	U.ItemNo = L.ItemNo
					AND	U.UoM = L.UoM
		WHERE	L.ItemLocationId = '#url.id#'
</cfquery>

<cfquery name="LossClass" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	*
		FROM  	Ref_LossClass
</cfquery>

<!--- calculates the acceptable losses --->

<cf_getLossValue
	id="#url.id#"
	date="#url.date#">
	
<cfoutput>

<table class="formpadding" width="75%" align="center">
    <tr><td></td></tr>
	<tr>
		<td class="labelit"><cf_tl id="Type"></td>					
		<td class="labelit" align="right"><cf_tl id="Value"></td>
	</tr>
	<tr><td class="line" colspan="2"></td></tr>
	<cfif ArrayLen(resultAppliableLosses) eq 0>
		<tr>
			<td colspan="2" align="center" height="30" valign="middle"><b><font color="808080"><cf_tl id="No acceptable losses defined">.</font></b></td>
		</tr>
	</cfif>
	<cfloop array="#resultAppliableLosses#" index="loss">
		<tr class="labelmedium" bgcolor="FFFFFF">
			<td>
				<cfquery name="getLossClass" dbtype="query">
					SELECT 	*
					FROM	LossClass
					WHERE	Code = '#loss[5]#'
				</cfquery>
				#getLossClass.description#
			</td>
			<td align="right">#lsNumberFormat(loss[10],",.__")#</td>
		</tr>
	</cfloop>
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" class="labelmedium" align="center"><cf_tl id="Total Loss">: <b>#lsNumberFormat(resultTotalLoss,",.__")# #uom.uomdescription#</b></td>
	</tr>
</table>

</cfoutput>