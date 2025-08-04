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

<cfquery name="Contract" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT *
  FROM   Contract
  WHERE  ContractId = '#URL.ContractId#'
</cfquery>

<table width="100%" bgcolor="ffffff" height="98%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">

<tr><td valign="top">

	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
			
	<cfoutput>
	
	<tr><td>
	
	    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	    <tr class="labelmedium line">
		    <td height="21" style="min-width:250px" width="10%"><cf_tl id="Period">:</b></td>
	        <td>#Dateformat(Contract.DateEffective, CLIENT.DateFormatShow)# - #Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#
			</td>	        
		</tr>					
		<tr class="labelmedium line">
		    <td height="21" style="min-width:120px"><cf_tl id="Unit">:</b></td>
	        <td>#Contract.OrgUnitName#</td>
	    </td>
		</tr>						
		<tr class="labelmedium line">
		    <td height="21" style="min-width:120px"><cf_tl id="Function">:</b></td>
	        <td>#Contract.FunctionDescription#</td>
	    </td>
				
		<cfquery name="Evaluator" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  P.FirstName, P.LastName, P.Gender, CA.RoleFunction
			FROM    ContractActor AS CA INNER JOIN
	                Employee.dbo.Person AS P ON CA.PersonNo = P.PersonNo
			WHERE   CA.ActionStatus = '1' 
			AND     CA.Role = 'Evaluation'
			AND     ContractId = '#URL.ContractId#'
			ORDER BY RoleFunction
		</cfquery>
		
		<cfloop query="Evaluator">
				
			<tr class="labelmedium line">
			    <td height="24" style="min-width:120px"><cf_tl id="#RoleFunction#">:</b></td>	        			
				<td class="labelmedium">#FirstName# #LastName#</TD>	    
			</tr>
		
		</cfloop>
				
		<cfif Contract.Objective neq "">
				
		<tr class="labelmedium line">
		    <td height="24" style="min-width:120px"><cf_tl id="Memo">:</b></td>
	        <td>#Contract.Objective#</td>
	    </td>
		
		</cfif>
					
	    </table>
				
	</td></tr>	
	  
	</table>
	
	</cfoutput>
  
</table>
 

	