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
<cfparam name="url.mode" default="view">

<cfquery name="qItemList" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  ItemMasterList
	WHERE ItemMaster = '#URL.id1#'
	ORDER BY ListOrder
</cfquery>

<div id="result"></div>

<cfquery name="MissionList" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_ParameterMission M	
	  WHERE  Mission IN (SELECT Mission FROM ItemMasterMission WHERE Mission = M.Mission)
</cfquery>

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code = '#URL.ID1#'
</cfquery>


<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
<td colspan="2">
	<table width="95%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td class="labelmedium"><cfoutput>#get.Code# #get.Description#</cfoutput></td></tr>
	</table>
</td>
</tr>

<tr><td colspan="2" class="linedotted"></td></tr>

<tr><td colspan="4" class="labelit" style="padding:4px">
	<cf_tl id="Define standard costs to be used for budget preparations" class="message"> <cf_tl id="which effective subdivides the standard costs of the item master into one ore more components" class="message">.
	<cf_tl id="Usually used for payroll definition" class="message"> <cf_tl id="as a salary is a composition of a rate and one or more percentages to be added" class="message">. 
	<cf_tl id="The standard costs defined for the item master or for the list item" class="message"> <cf_tl id="will then be superseded by this standard cost composition" class="message">. <b><cf_tl id="Attention"> : <cf_tl id="This applies to Budget formulation only"></b>
</td></tr>

<tr><td colspan="2" class="linedotted"></td></tr>

<tr><td height="5"></td></tr>

<tr>

	<td valign="top" width="20%">
	    
		<cfform id="fMission" name="fMission">
		
		<cfoutput>
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr height="30px">
			<td colspan="4" class="labelit" style="padding-left:3px"><cf_tl id="Available Entities"></b></td>
			<td>
			<cf_tl id="Add" var="vAdd">
			<input type="button" name="add" value="#vAdd#" class="button10g" style="width:60;height:20" onclick="new_costelement('#url.id1#')">
			</td>
		</tr>
							
			<cfloop query="MissionList">
				<tr>
					<td width="2%"></td>
					<td width="2%"><input type="checkbox" id="MissionList"  name="MissionList" value = "#Mission#"></td>
					<td style="padding-left:4px" class="labelit">#Mission#</td>
				</tr>
			</cfloop>
			
		</table>		
		</cfoutput>
		
		</cfform>
			
	</td>
	
	<td valign="top" width="80%" style="border-left:solid 1px silver">
		<cfoutput>
			<cfdiv bind="url:Budgeting/CostElementList.cfm?id1=#URL.id1#" ID="dExisting"/>
		</cfoutput>
	</td>
	
</tr>

<tr height="60" >
	<td colspan="2" align="center">
		<cf_tl id="Associate" var="vAssociate">
		<cfoutput>
			<input class="button10g" style="width:140;height:25;display:none" type="Button" name="Save" id="Associate" value="#vAssociate#" onclick="">		
		</cfoutput>
	</td>
</tr>
</table>



