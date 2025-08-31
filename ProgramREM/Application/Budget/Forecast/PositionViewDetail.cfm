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
<cfquery name="Detail" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT R.AuditDate,
		       R.Description AS AuditMonth,
		       FP.PositionParentId,
			   
			   (SELECT     TOP 1 PersonNo
				FROM       Employee.dbo.vwAssignment
				WHERE      DateEffective   <= R.AuditDate 
				AND        DateExpiration  >= R.AuditDate 
				AND        AssignmentClass = 'Regular' <!--- exclude TDY, Loan --->
				AND        AssignmentStatus IN ('0','1') 
				AND        AssignmentType = 'Actual' 
				AND        PositionParentId = '#url.PositionParentId#'
				AND        Incumbency > 0 ) as PersonNo,
				
			   (SELECT     TOP 1 LastName
				FROM       Employee.dbo.vwAssignment
				WHERE      DateEffective   <= R.AuditDate 
				AND        DateExpiration  >= R.AuditDate 
				AND        AssignmentClass = 'Regular' <!--- exclude TDY, Loan --->
				AND        AssignmentStatus IN ('0','1') 
				AND        AssignmentType = 'Actual' 
				AND        PositionParentId = '#url.PositionParentId#'
				AND        Incumbency > 0 ) as Incumbent,
			
		       FP.SalarySchedule,
		       <cfif url.group eq "pi">
				   FP.PayrollItem,
			       PrintDescriptionShort as PayrollItemName,    
			       I.Source,
		       <cfelse>		     
				   FP.ObjectCode,
			       O.Description as ObjectCodeDescription,    
			       O.Resource,
		       </cfif>
		       SUM(ROUND(FP.Amount,2)) AS Amount,
		       SUM(ROUND(FP.AmountCorrection,2)) AS AmountCorrection
			   
		FROM     ProgramPeriodForecastPosition AS FP INNER JOIN Ref_Audit AS R ON FP.AuditId = R.AuditId
		         <cfif url.group eq "pi">
		         INNER JOIN Payroll.dbo.Ref_PayrollItem AS I ON FP.PayrollItem = I.PayrollItem
		         <cfelse>
			     INNER JOIN Ref_Object O ON FP.ObjectCode = O.Code  
		         </cfif>
		WHERE    FP.PositionParentId = '#url.PositionParentId#'
		AND      FP.ProgramCode = '#url.ProgramCode#'
		AND      FP.Period = '#url.Period#'
		GROUP BY R.Description,
		         FP.PositionParentId,
		         R.AuditDate,
		         FP.SalarySchedule,
		         <cfif url.group eq "pi">
				   FP.PayrollItem,
			       PrintDescriptionShort,    
			       I.Source,
		           I.PrintOrder
			     </cfif>
			     <cfif url.group eq "oc">
				   FP.ObjectCode,
			       O.Description,  
			       O.HierarchyCode,
			       O.Resource
			     </cfif>
		ORDER BY R.AuditDate,
				<cfif url.group eq "pi">
		          I.PrintOrder 
		        <cfelse>
				  O.HierarchyCode
			    </cfif>
	
</cfquery>

<table width="100%" align="center" class="formpadding navigation_table">
	<tr class="labelit line">
		<td style="padding-left:10px;">
		
			<cfif url.group eq "pi">
	         <cf_tl id="Item">
	        </cfif>
		    <cfif url.group eq "oc">
			 <cf_tl id="Object">
		    </cfif>
			
		</td>
		
		<td align="right"><cf_tl id="Amount"></td>
		<!---
		<td align="right"><cf_tl id="Correction"></td>
		--->
	</tr>
	<cfset vAmount = 0>
	<cfset vCorrection = 0>
	<cfset prior = "">
	
	<cfoutput query="Detail" group="AuditMonth">
	
		<tr class="labelmedium line navigation_row">
		
			<td colspan="1" style="padding-left:10px">
			<font color="800080">#AuditMonth#</font>
			<cfif Incumbent neq "" and prior neq incumbent>&nbsp;: <a href="javascript:EditPerson('#PersonNo#','','position')">#Incumbent#</a></cfif>
			</td>
			
			<cfquery dbtype="query" name="getMonthTotals">
				SELECT 	SUM(Amount) as Amount, SUM(AmountCorrection) as AmountCorrection
				FROM 	Detail
				WHERE 	AuditMonth = '#AuditMonth#'
			</cfquery>
			
			<td align="right" style="padding-right:4px">#numberFormat(getMonthTotals.AmountCorrection, ",")#</td>
			
		</tr>
		
		<cfoutput>
		
		    <cfif url.group eq "pi">
			
			<tr class="labelit line navigation_row" style="height:20px">
				<td style="padding-left:20px;">
					<cfif url.group eq "pi">
			         #PayrollItem# - #PayrollItemName# #Source#
			        <cfelse>
					 #ObjectCode# - #ObjectCodeDescription# #Resource#
				    </cfif>
				</td>
				
				<td align="right" style="padding-right:14px">#numberFormat(AmountCorrection, ",")#</td>
			</tr>
			
			</cfif>
			<cfset vAmount = vAmount + Amount>
			<cfset vCorrection = vCorrection + AmountCorrection>
			
		</cfoutput>
		
		<cfset prior = incumbent>
		
	</cfoutput>
	<cfoutput>
		<tr style="background-color:e4e4e4" class="labelmedium line">
			<td colspan="1" style="padding-left:60px;font-weight:300;"><cf_tl id="total"></td>
			<!---
			<td align="right" style="font-weight:bold;">#numberFormat(vAmount, ",")#</td>
			--->
			<td align="right" style="padding-right:4px">#numberFormat(vCorrection, ",")#</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxOnLoad("doHighlight")>