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
<cfparam name="url.year" default="#year(now()+60)#">

<cfparam name="url.customerid" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Charges"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">

		SELECT     W.Unit,
		           W.UnitDescription, 
				   u.SelectionDate, 
				   u.Currency, 
				   ROUND(SUM(isnull(S.Amount,0)),4) AS Total
		FROM
		
		(
			SELECT ServiceItemUnit,SelectionDate, workorderid, serviceItem, Currency
			FROM (
					SELECT DISTINCT ServiceItemUnit
					FROM skWorkOrderCharges C
					WHERE C.WorkorderId = '#url.workorderid#'
					AND YEAR(C.SelectionDate)= '#url.year#' 
				) A 
				
			CROSS JOIN 
				(
					SELECT DISTINCT workorderid, selectiondate, serviceItem, Currency
					FROM   skWorkOrderCharges 
					WHERE  WorkorderId = '#url.workorderid#'
					AND    YEAR(SelectionDate)= '#url.year#'
				) B
		) U		LEFT OUTER JOIN  
				
				skWorkOrderCharges AS s ON U.ServiceItemUnit = S.ServiceItemunit and U.SelectionDate = S.SelectionDate and U.workorderid = S.workorderid
				INNER JOIN ServiceItemUnit AS W ON W.serviceitem = U.ServiceItem AND W.unit = U.ServiceItemUnit
		
		WHERE      YEAR(u.SelectionDate) = '#url.year#'   
		AND        u.WorkorderId = '#url.workorderid#'	  
		
		GROUP BY   w.Unit, 
		           w.UnitDescription, 
				   u.SelectionDate,
				   u.Currency		  
		ORDER BY   u.SelectionDate DESC, 
		           w.Unit 		     


</cfquery>



<table width="100%" cellspacing="0" cellpadding="0" align="center">

	<cfoutput>
	
	<tr>
	<td width="92%" colspan="2" class="labelmedium" style="padding-right:10px">
		<cfloop index="yr" from="#year(now()+60)#" to="#year(now()-800)#" step="-1">
			<font size="2">
			<cfif yr eq url.year><b><font size="4"><cfelse><font size="2"></b></cfif>		
			<a href="javascript:ptoken.navigate('../ServiceDetails/Charges/ChargesWorkorder.cfm?workorderid=#URL.workorderId#&year=#yr#','billingsummary')">
			<font color="0080FF">#yr#</font></a>&nbsp;		
		</cfloop>
	</td>
	</tr>			
	</cfoutput>
	
	<tr><td colspan="2">	
		<cfinclude template="../../Header/WorkOrderAgreement.cfm">	
	</td></tr>
		
	<tr>
					
	<td style="border-top:1px solid silver;padding-left:0px;" colspan="2" valign="top" width="70%">	
					
		<table width="100%" cellpadding="0" border="0">
			
		<tr height="20" class="labelit line">
		   <td style="padding-left:3px"><cf_tl id="Month"></td>
		   <td><cf_tl id="Unit"></td>
		   <td><cf_tl id="Currency"></td>
		   <td align="right"><cf_tl id="Charges"></td>
		   <td align="right" style="padding-right:3px"><cf_tl id="Year-to-date"></td>
		</tr>		
		
		<cfif charges.recordcount eq "0">
			<tr><td colspan="5" class="labelit" align="center"><cf_tl id="No history found"></td></tr>	
			<tr><td colspan="5" class="line"></td></tr>	
		</cfif>
	
		<cfoutput query="Charges" group="SelectionDate">
						
			<cfset cnt = 0>
						
			<cfset YearToDate = "0">
			
			<cfoutput>
			
			<cfset cnt=cnt+1>		
			
			<tr style="height:12px;" class="labelit line">
			   <td style="padding-left:4px"><cfif cnt eq "1">#dateFormat(selectiondate,"MMMM")#</cfif></td>
			   <td>#UnitDescription#</td>	 
			   <td>#Currency#</td>	 
			   <td align="right">#numberformat(total,",.__")#</td>	
			   
				<cfquery name="CumCharges"        
		         dbtype="query">
					SELECT    SUM(Total) AS Total
		   			FROM       Charges
		   			WHERE      Unit = '#Unit#'
		   			AND        SelectionDate >= '01/01/#url.year#' 
		   			AND        SelectionDate <= '#selectiondate#'	
		  		</cfquery>	   
			    
			   <td align="right">#numberformat(CumCharges.total,",.__")#</td>	
			</tr>
					
			<cfset YearToDate = YearToDate + CumCharges.total>
			
			</cfoutput>	
			
			<cfif cnt gt "1">
			
				<cfquery name="CumCharges"        
			         dbtype="query">
						SELECT    SUM(Total) AS Total
			   			FROM       Charges
			   			WHERE      SelectionDate = '#selectiondate#'	
			  		</cfquery>	   
					
				<cfquery name="Total"        
			         dbtype="query">
						SELECT    SUM(Total) AS Total
			   			FROM      Charges
			   			WHERE     SelectionDate >= '01/01/#url.year#' 
			   			AND       SelectionDate <= '#selectiondate#'	
			  		</cfquery>	   	
				
				<tr class="labelit">
				   <td></td>
				   <td></td>	 
				   <td></td>	 
				   <td style="border-top: solid gray 1px" align="right"><b>#numberformat(CumCharges.total,",.__")#</td>	 
				   <td style="border-top: solid gray 1px" align="right"><b>#numberformat(Total.Total,",.__")#</td>				   
				</tr>
			
			</cfif>
						
			<cfquery name="Billing"
			   datasource="AppsLedger"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			    SELECT    Journal, JournalSerialNo, 
				          JournalTransactionNo, 
						  Currency, 
						  Amount, 
						  TransactionDate, 
						  JournalBatchDate
				FROM      TransactionHeader
				WHERE     ReferenceId  = '#workorderid#' 
				AND       DocumentDate = '#selectiondate#'
				AND       ActionStatus <> '9' 
				AND       RecordStatus <> '9'
			</cfquery>	
						
			<cfloop query="Billing">
			<tr class="line">			
			<td align="right"><cfif currentrow eq "1"><cf_tl id="Billing Cycle"></cfif></td>
			<td style="padding-left:4px">#Journal# #JournalSerialNo# : #dateFormat(JournalBatchDate,"YYYY/MM")#</td>
			<td>#Currency#</td>
			<td align="right">#numberformat(Amount,",.__")#</td>	
			<td></td>					
			</tr>			
			</cfloop>
		
		</cfoutput>
		
		</table>
	
	</td>
	</tr>

</table>

