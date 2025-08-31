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
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Release">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Obligation">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Requisition">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Invoice">

<cfquery name="Total" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    PAD.Fund,
	          PAD.ObjectCode, 
	          PA.ProgramCode,
			  SUM(PAD.AmountBase) AS Total <!--- base finance currency --->
	INTO      userQuery.dbo.#SESSION.acc#Release
	FROM      ProgramAllotment PA INNER JOIN
              ProgramAllotmentDetail PAD ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
	WHERE     PA.Period    = '#URL.period#'
	AND       PA.EditionId = '#Edition.EditionId#'
	GROUP BY PAD.Fund, PAD.ObjectCode, PA.ProgramCode  
</cfquery>

<cfquery name="Reservation" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Fund,
	          ObjectCode, 
			  ProgramCode, SUM(L.Percentage * R.RequestAmountBase) AS ReservationAmount
	INTO      userQuery.dbo.#SESSION.acc#Requisition
	FROM      RequisitionLine R INNER JOIN
	          RequisitionLineBudget L ON R.RequisitionNo = L.RequisitionNo
	WHERE     R.Mission      = '#URL.Mission#'
	AND       R.Period IN (#preservesingleQuotes(persel)#) 
	<!---
	AND       R.RequisitionNo   != '#URL.ID#' 
	--->
	AND       R.ActionStatus    > '2' <!--- funding clearance and later --->
	AND       R.ActionStatus    < '3' 
	AND       L.Status != '9'
	GROUP BY  Fund,ProgramCode,ObjectCode
</cfquery>

<cfquery name="Obligation" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Fund,
	          ObjectCode, 
			  ProgramCode, 
			  SUM(L.Percentage * P.OrderAmountBaseObligated) AS ObligationAmount
	INTO      userQuery.dbo.#SESSION.acc#Obligation
	FROM      RequisitionLine R INNER JOIN
	          RequisitionLineBudget L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
	          PurchaseLine P ON R.RequisitionNo = P.RequisitionNo
	WHERE     R.Mission        = '#URL.Mission#'
	AND       R.Period IN (#preservesingleQuotes(persel)#) 
	AND       P.PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE ObligationStatus = 1)
	<!---
	AND       R.RequisitionNo != '#URL.ID#' 
	--->
	AND       R.ActionStatus   = '3' 
	AND       P.ActionStatus  != '9'	
	AND       L.Status != '9'
	GROUP BY  Fund,ProgramCode,ObjectCode
</cfquery>

<cfoutput>

<cfparam name="SelectBase.EditionId" default="">
<cfparam name="ed" default="">
	
<tr bgcolor="E4F3FC">
	
	<td colspan="2" width="200" class="labelit" height="22">
	<cf_UIToolTip  tooltip="This information is shown only for reference, the amounts below do not necessarily add up to this amount">
	&nbsp;Overall #URL.Mission# #URL.Period# in 000</b></td>
	</cf_UIToolTip>
	<td colspan="1" align="right" style="border-left: 1px solid Gray;padding: 1;">	
	
		<cfquery name="Total" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    SUM(Total) AS Total 
		FROM      userQuery.dbo.#SESSION.acc#Release	
		</cfquery>	
		
		<cfif Total.total eq "">
		  <cfset all = 0>
		<cfelse>
		  <cfset all =  Total.total>
		</cfif>
		
		<cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="22">
	
	</td>
	<td colspan="1" align="right" style="border-left: 1px solid Gray;padding: 1;">
	
		<!--- define reservations --->
		<cfquery name="Reservation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SUM(ReservationAmount) as ReservationAmount 
		FROM     #SESSION.acc#Requisition
		</cfquery>
		
		<cfif Reservation.ReservationAmount eq "">
		  <cfset res = 0>
		<cfelse>
		  <cfset res =  Reservation.ReservationAmount>
		</cfif>
			
		<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="22">
	
	</td>
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">
		
		<!--- define obligations --->
		<cfquery name="Obligation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SUM(ObligationAmount) as ObligationAmount 
		FROM     #SESSION.acc#Obligation		
		</cfquery>
		
		<cfif Obligation.ObligationAmount eq "">
		  <cfset obl = 0>
		<cfelse>
		  <cfset obl =  Obligation.ObligationAmount>
		</cfif>
	
		<cf_space align="right" label="#numberformat(obl/1000,"_,_._")#" spaces="22">
		
		
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray;padding: 1;">
	
	<cf_space align="right" label="#numberformat((Obl+res)/1000,"_,_._")#" spaces="22">
	
	</td>
	
</tr>

</cfoutput>