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

<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- ----------------------------- --->

<!--- End Prosis template framework --->

<cfset per = "'#URL.Period#'">

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfset st = "2">

<!--- define reservations --->
<cfquery name="Reservation" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    R.*, 
          I.Description as ItemMasterDescription, 
		  L.Percentage, 
		  R.RequestAmountBase AS ReservationAmount
FROM      RequisitionLine R, 
          RequisitionLineBudget L, ItemMaster I
WHERE     R.Period IN (#preservesingleQuotes(per)#) 
AND       R.Mission       = '#URL.Mission#'
AND       R.RequisitionNo = L.RequisitionNo
AND       I.Code          = R.ItemMaster
AND       L.ProgramCode   = '#URL.ProgramCode#'
<cfif url.fund neq "">
AND       L.Fund          = '#URL.Fund#'
</cfif>
AND       L.ObjectCode    = '#URL.ObjectCode#'
AND       R.ActionStatus > '#st#' and R.ActionStatus < '3' 
AND       L.Status <> '9'
ORDER BY R.Period 
</cfquery>

<!--- define obligations --->
<cfquery name="Obligation" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    R.*, 
          I.Description as ItemMasterDescription, 
		  L.Percentage, 
		  P.OrderAmountBaseObligated AS ObligationAmount, 
		  P.PurchaseNo
FROM      RequisitionLine R, 
          RequisitionLineBudget L,
          PurchaseLine P, ItemMaster I
WHERE     R.Period IN (#preservesingleQuotes(per)#) 
AND       R.Mission       =  '#Mission#'
AND       R.RequisitionNo =  L.RequisitionNo
AND       R.RequisitionNo =  P.RequisitionNo
AND       I.Code          =  R.ItemMaster
AND       L.ProgramCode   = '#URL.ProgramCode#'
<cfif url.fund neq "">
AND       L.Fund          = '#URL.Fund#'
</cfif>
AND       L.ObjectCode    = '#URL.ObjectCode#'
AND       R.ActionStatus = '3' 
AND       P.ActionStatus != '9'
AND       L.Status <> '9'
ORDER BY R.Period
</cfquery>

<cf_dialogProcurement>

<cfif Reservation.recordcount+Obligation.recordcount gt "30">
	    <div style="position:relative;overflow: auto; height:200; scrollbar-face-color: F4f4f4;">
</cfif>

<cfset cl = "fafafa">

<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
<tr><td>

<table width="100%" border="1" bgcolor="ffffff" cellspacing="0" cellpadding="0" class="formpadding" align="right" 
  bordercolor="DFDFDF" rules="none">
    
 <cfif Reservation.recordcount neq "0">
 
 <tr>
     <td colspan="4"><b><font color="gray">&nbsp;<cf_tl id="Pre-encumbered"></b></td>
 </tr>
 <tr><td colspan="4" bgcolor="E5E5E5"></td></tr>
   
 <cfoutput query="Reservation" group="Period">
 
	   <cfquery name="Check"
		         dbtype="query">
		SELECT    DISTINCT Period
		FROM      Reservation		
	  </cfquery>
 	  
	  <cfif check.recordcount gte "2">
	  
		   <cfquery name="Total"
			         dbtype="query">
			SELECT    sum(ReservationAmount) as Amount
			FROM      Reservation
			WHERE     Period = '#Period#'
		  </cfquery>
	 
		  <tr bgcolor="#cl#">
			   
			   <td width="10%"><b>#Period#</b></td>
			   <td></td>
			   <td width="10%"></td>
			   <td align="right"><b>#NumberFormat(Total.Amount,",__.__")#</b></td>			 
		  </tr>
		  <tr><td height="1" colspan="4" bgcolor="d7d7d7"></td></tr>
		  
	  </cfif>
	    
	 <cfoutput>
	 
		 <tr bgcolor="#cl#">
		  
		   <td width="10%">&nbsp;&nbsp;<a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">#Reference#</a></td>
		   <td colspan="2"><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">#ItemMasterDescription#:#RequestDescription#</a></td>
		   <td align="right">#NumberFormat(ReservationAmount,",__.__")#</td>
		 		  
		 </tr>
		 <cfif CurrentRow neq Reservation.recordcount>
		 <tr><td colspan="4" bgcolor="E5E5E5"></td></tr>
		 </cfif>
	 
	 </cfoutput>
	 
	 <!---
	 </cfif>
	 --->
	 
 </cfoutput>
 
 </cfif>
 
 <cfif Obligation.recordcount neq "0">
 
 	
	 <tr>
	     <td width="2%" colspan="4"><b><font color="gray">&nbsp;Obligated</b></td>
	 </tr>
	 <tr><td colspan="5" bgcolor="E5E5E5"></td></tr>
	 
	 <cfoutput query="Obligation"  group="Period">
	 
	   <cfquery name="Check"
		         dbtype="query">
		SELECT    DISTINCT Period
		FROM      Obligation		
	  </cfquery>
 
	  <cfif Check.recordcount gte "2">
	 
		  <cfquery name="Total"
			         dbtype="query">
			SELECT    sum(ObligationAmount) as Amount
			FROM      Obligation
			WHERE     Period = '#Period#'
		  </cfquery>
	 
		  <tr bgcolor="#cl#">
			   <td width="10%"><b>#Period#</td>
			   <td></td>
			   <td width="10%"></td>
			   <td align="right"><b>#NumberFormat(Total.Amount,",__.__")#</b></td>
			   
		 </tr>
		 <tr><td colspan="4" bgcolor="E5E5E5"></td></tr>
	 
	 </cfif>	
		 
		 <cfoutput>
			 <tr>
			   <td width="10%">&nbsp;&nbsp;<a href="javascript:ProcPOEdit('#PurchaseNo#','view')" 
				      title="Open Purchase order">#PurchaseNo#</a></td>
			   <td>#RequestDescription#</td>
			   <td width="10%">#ItemMaster#</td>
			   <td align="right">#NumberFormat(ObligationAmount,",__.__")#</td>
			   			  
			 </tr>
			 <cfif CurrentRow neq #recordcount#>
			 <tr><td colspan="4" bgcolor="E8E8E8"></td></tr> 
			 </cfif>
		  </cfoutput>	
		   
	  </cfoutput>
 
 </cfif>
   
</table>
</td></tr>
</table>