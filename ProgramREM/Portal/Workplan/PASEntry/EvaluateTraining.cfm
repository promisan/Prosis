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
<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="SearchResult" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  T.*, 'Activity' AS Class, '' as DescriptionName, B.ActivityDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractActivity B ON T.ContractId = B.ContractId AND T.ActivityId = B.ActivityId 
	WHERE   T.ContractId = '#URL.ContractId#'		
	UNION
    SELECT  T.*, 'Behavior' AS Class, R.BehaviorName AS DescriptionName, B.BehaviorDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractBehavior B ON T.ContractId = B.ContractId AND T.BehaviorCode = B.BehaviorCode INNER JOIN
            Ref_Behavior R ON B.BehaviorCode = R.Code
	WHERE   T.ContractId = '#URL.ContractId#'			
	ORDER BY Class, Description		
	</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
     <cfoutput>
	   <td width="60" height="25" align="center">
	      <img src="#SESSION.root#/Images/goaltrain.jpg" 
			   alt="<cf_interface cde='TrainingPlan'>#Name#" align="absmiddle" border="0">
	   </td>
	   <td class="labelit" style="color:##808080;">
	      <cf_interface cde="TrainingPlan"><b>#Name#</b>
	   </td>
	</tr>
	</cfoutput>

<tr><td colspan="2" valign="top">

	<table width="92%" align="right" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfset task = 0>
		
	<tr>
		<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">		
		
		 <cfoutput>
		 <tr class="labelit">
			 <td width="5%"></td>
			 <td width="30%"><cf_interface cde="TrainingReason"><b>#Name#</td>
			 <td width="30%"><cf_interface cde="Training"><b>#Name#</td>
			 <td width="15%"><cf_interface cde="TrainingTarget"><b>#Name#</td>
			 <td width="25%"><cf_interface cde="TrainingReference"><b>#Name#</td>
		 </tr>
		 <tr><td colspan="5" class="line"></td></tr>
		 </cfoutput>
	
		<cfoutput query="SearchResult" group="Class">
	
	    <tr><td height="22" colspan="5" class="labelit"><cf_interface cde="#Class#"><b>#Name#:</b></td></tr>
		
		<cfoutput>
		
		 <cfset task = task+1>
		
		 <tr><td colspan="5" class="line"></td></tr>
		 <tr><td align="center" width="30" class="labelit">#CurrentRow#.</td><td colspan="4" class="labelit">#DescriptionName#</tr>
		 <tr class="labelit">
			 <td></td>
			 <td>#TrainingReason#</td>
			 <td>#TrainingDescription#</td>
			 <td>#DateFormat(TrainingTarget, CLIENT.DateFormatShow)#</td>
			 <td>#TrainingReference#</td>
		 </tr>
		</cfoutput>
		
		</cfoutput>
	
		</table>
		
	</table>
	
</table>	
	