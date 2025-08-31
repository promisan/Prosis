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
<cfquery name="qFinal"
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Payroll.dbo.EmployeeSettlement ES INNER JOIN 
	  			 Person P ON ES.PersonNo = P.PersonNo INNER JOIN 
				 Payroll.dbo.SalarySchedule R ON ES.SalarySchedule = R.SalarySchedule
	  WHERE      ES.PaymentFinal = '1'
	  AND        ES.PersonNo     = '#url.id#'    	                   
</cfquery> 
			
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
		
		<tr class="labelmedium line">
			<td></td>
			<td><cf_tl id="Entity"></td>
			 <td><cf_tl id="Schedule"></td>		
			<td><cf_tl id="Class"></td>
		   	
			<td><cf_tl id="Unit"></td>
			<td><cf_tl id="Cycle"></td>			
			<td><cf_tl id="Status"></td>
			<td><cf_tl id="Officer"></td>
			<td><cf_tl id="Created"></td>
		</tr>
			
		<cfoutput query="qFinal">
			<TR style="height:19px" class="labelmedium navigation_row line">
			
			    <td style="padding-left:8px"><cf_img icon="open" navigation="yes" onclick="openfinal('#settlementid#','#url.systemfunctionid#')"></td>
				<td>#Mission#</td>
				<td>#Description#</td>		
				<td><cfif source eq "Standard"><cf_tl id="Final Payment"><cfelse><cf_tl id="Off-cycle"></cfif></td>										
				<td>
				
				<cfquery name="Unit"
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
					SELECT  TOP 1 O.OrgUnitName
					FROM    PersonAssignment PA INNER JOIN
		                    Position P ON PA.PositionNo = P.PositionNo INNER JOIN
		                    Organization.dbo.Organization O ON P.OrgUnitOperational = O.OrgUnit
					WHERE   PA.PersonNo = '#personno#' 
					AND     PA.AssignmentStatus in ('0','1') 
					AND     PA.Incumbency > 0
					AND     P.Mission = '#mission#'
					AND     PA.DateEffective <= '#dateformat(PaymentDate,client.dateSQL)#'
					ORDER BY PA.DateEffective DESC
				</cfquery>
				
				#Unit.OrgUnitName#		
								
				</td>
				<td>#dateformat(PaymentDate,"YYYY/MM")#</td>
				
				<td>
				
				<cf_wfActive entitycode="FinalPayment" objectkeyvalue4="#settlementid#">	
				
				<cfif wfexist eq "0"> 
				<font color="red"><cf_tl id="Pending"></font>
				<cfelseif wfstatus eq "closed">
				<font color="008000"><cf_tl id="Completed"></font>
				<cfelseif actionStatus eq "0"><font color="FF0000"><cf_tl id="On Hold"></font>
				<cfelseif actionStatus eq "1"><font color="gray"><cf_tl id="Released"></font>
				</cfif>
				
				</td>
				<td>#OfficerLastName#</td>
				<td>#dateformat(Created,client.dateformatshow)#</td>
			</TR>	
			
	</cfoutput>	

</table>


<cfset ajaxonload("doHighlight")>



