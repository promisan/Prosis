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
	
<cfquery name="Base" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	  SELECT       ESL.PayrollStart, 
	               month(ESL.PayrollStart) as PayrollMonth,
	               ESL.PaymentCurrency, 
				   ROUND(SUM(ESL.PaymentAmount), 2) AS Amount,
				   COUNT(DISTINCT ES.PersonNo) AS Staff
	  FROM         EmployeeSalary AS ES INNER JOIN
		           EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.Mission = ESL.Mission AND ES.PersonNo = ESL.PersonNo AND 
		           ES.PayrollCalcNo = ESL.PayrollCalcNo
	  WHERE        ES.Mission = '#url.mission#'
	  AND          Year(ESL.PayrollStart) = '#url.id2#'
	  AND          ES.SalarySchedule = '#url.id1#'
	  GROUP BY     ESL.PayrollStart, ESL.PaymentCurrency
	  ORDER BY     ESL.PayrollStart
	  
</cfquery>
	
<cfif Base.recordCount neq "0">

	<table width="98%" height="100%" align="center">

	  <tr><td valign="top" style="border:0px solid silver">
		
			<table width="100%" align="center">
									
			<cfquery name="Group" dbtype="query">
                 SELECT    PayrollStart, 	
				           PayrollMonth,		    
			               PaymentCurrency, 
						   SUM(Amount/1000) as Amount,
						   SUM(Staff) AS Staff
           	     FROM      Base
	   	         GROUP BY  PayrollStart, PayrollMonth, PaymentCurrency
           	     ORDER BY  PayrollStart, PayrollMonth, PaymentCurrency
			 </cfquery>
			   									
			<tr>
				<td align="center" width="35%" valign="top" style="min-width:400px;padding-right:10px; border-right:1px solid Silver;">
				
					<table width="100%" class="navigation_table formpadding"> 
					
						<tr class="line labelmedium2 fixlengthlist">
						    <td>&nbsp;</td>
						    <td style="font-size:16px;font-weight:bold;padding-top:6px"><cf_tl id="Amounts by month" var="1"> <cfoutput>#lt_text#</cfoutput></td>						
							<td align="center"><cf_tl id="Curr"></td>
							<td align="right" style="padding-right:5px"><cf_tl id="Amount">000$</td>
						</tr>
						
						<cfset sum = 0>
						
						<cfoutput query="Group">
							<cfset vLineTotal = "">
							<cfif currentrow eq recordCount>
								<cfset vLineTotal = "line">
							</cfif>
							<tr style="cursor: pointer; height:15px;" class="line navigation_row fixlengthlist labelmedium #vLineTotal#" 
							    onclick="javascript:listing('#url.id#','#url.id1#','#url.id2#','','#PayrollMonth#')">
						        <td>&nbsp;</td>
						        <td style="padding-right:8px;">#dateformat(PayrollStart,"MMMM")#</td>							
								<td align="center">#PaymentCurrency#</td>
								<td align="right" style="padding-right:5px">#NumberFormat(Amount,",.__")#</td>
							</tr>
							<cfset sum = sum + Amount>
						</cfoutput>						
						
						<tr class="labelmedium2">
						    <td>&nbsp;</td>
							<td colspan="2"><cf_tl id="Year to date"></b></td>
							<td align="right" style="padding-right:5px"><b><cfoutput>#NumberFormat(Sum,",.__")#</cfoutput></b></td>
						</tr>
					
					</table>
				
				</td>				
				</tr>						
				
			</table>	
		
		</td>
									
		<td align="center" style="width:650px">
			
				<table width="100%">
								
				<tr><td align="center" valign="middle" style="padding:5px;min-width:300px">
				
				    <cfset ht = (group.recordcount) * 22 + 50>
					
					<cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
								
					<cf_uichart chartheight="#ht#"		          			          
			           seriesplacement = "default"
			           font            = "Calibri"				   
			           fontsize        = "14"							 		         
					   showlabel       = "No"	
					   showvalue       = "No"		
					   Legend          = "Yes"		   
			           tipstyle        = "mouseOver"		         
			           
			           url="javascript:listing('#url.id#','#url.id1#','#url.id2#','','$ITEMLABEL$')">
							   
						<cf_uichartseries
			             type="line"
			             query="#Group#"
			             itemcolumn="PayrollMonth"
			             valuecolumn="Amount"
			             serieslabel="Amount in $000"	            
					     seriescolor="#vcolorlist#"  
			             markerstyle="circle"/>
						 
						 <cf_uichartseries
			             type="line"
			             query="#Group#"
			             itemcolumn="PayrollMonth"
			             valuecolumn="Staff"
			             serieslabel="Staff ##"	            
					     seriescolor="##52B3D9"  
			             markerstyle="circle"/>
						 			
					</cf_uichart>
				
				</td></tr>		
				</table>
			
		</td>
	</tr>
		
	<tr><td colspan="2" height="100%" align="center" style="background-color:f4f4f4;padding:4px;border:1px solid silver" id="listingcontent"></td></tr>
	
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>
<script>
	Prosis.busy('no')
</script>

