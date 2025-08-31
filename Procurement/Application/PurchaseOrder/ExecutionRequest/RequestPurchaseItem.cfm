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
<cfparam name="url.executionid" default="">
<cfparam name="url.access" default="view">

<cfquery name="Purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Purchase
	WHERE     PurchaseNo = '#URL.PurchaseNo#'	
</cfquery>

<cfquery name="Currency" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      PurchaseLine
	WHERE     PurchaseNo = '#URL.PurchaseNo#'	
</cfquery>

<cfquery name="Item" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    P.ExecutionId, 
	          P.PurchaseNo, 
			  P.Description, 
			  P.ListingOrder, 
			  P.Amount, 
			  
			  (SELECT SUM(RequestAmount) 
			   FROM PurchaseExecutionRequest 
			   WHERE PurchaseNo = P.PurchaseNo and ExecutionId = P.ExecutionId 
			   AND ActionStatus != '9') 
			   AS Requested,
			  
			  (SELECT SUM(Amount)
			   FROM InvoicePurchaseExecution 
			   WHERE PurchaseNo = P.PurchaseNo and ExecutionId = P.ExecutionId 
			   AND   InvoiceId NOT IN (SELECT InvoiceId FROM Invoice WHERE ActionStatus = '9')
			   ) AS Invoiced			 
			  
	FROM      PurchaseExecution P 
	WHERE     P.PurchaseNo = '#URL.PurchaseNo#'		
	<cfif URL.ExecutionId neq "" and url.access eq "view">
	    AND   P.ExecutionId = '#url.executionid#' 
	</cfif>		
	ORDER BY P.Description
</cfquery>

<cf_divscroll>
<cfif URL.ExecutionId eq "">
<table width="98%" align="left" cellspacing="0" cellpadding="0" border="0"  class="formpadding">
<cfelse>
<table width="98%" align="left"  cellspacing="0" cellpadding="0" border="0" class="formpadding">
</cfif>

<tr><td height="4"></td></tr>
<tr class="labelmedium line">
	<cfif URL.ExecutionId eq "" or Access eq "Edit">
		<td width="25"></td>
		<td width="1"></td>
	<cfelse>
		<td width="120" style="padding-left:3px">Program</td>
		<td width="100" style="padding-left:3px">No</td>	
	</cfif>
	<td width="320" style="padding-left:3px">Item</td>
	<td width="60"  align="center" style="padding-left:3px">Curr.</td>
	<td width="110" align="right" style="padding-left:3px">Obligated</td>
	<td width="110" align="right" style="padding-left:3px">Requested</td>
	<td width="110" align="right" style="padding-left:3px">Balance</td>
	<td width="110" align="right" style="padding-left:3px">Invoiced</td>
</tr>

<!--- check view access --->
<cfoutput query ="Item">
	
	<tr class="labelmedium linedotted" bgcolor="white">
	
	<cfif URL.ExecutionId eq "" or url.access eq "edit">
	
		<td align="center" width="25">
		<cfif Amount gte Requested>
		    <input type="radio" style="height:14px width:14px" class="radiol" name="executionid" id="radio#currentrow#" value="#ExecutionId#" <cfif url.executionid eq executionid>checked</cfif>>
        </cfif>  
		</td>
		<td></td>
		
	<cfelse>
	
		<td>
		
			<cfquery name="Program" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT DISTINCT Pr.ProgramName
				FROM   Purchase P INNER JOIN
		    	       PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
		        	   RequisitionLineFunding F ON PL.RequisitionNo = F.RequisitionNo INNER JOIN
			           Program.dbo.Program Pr ON F.ProgramCode = Pr.ProgramCode
				WHERE  P.PurchaseNo = '#PurchaseNo#'			
			</cfquery>		
			
			<table cellspacing="0" cellpadding="0">
			<cfloop query="Program">
			<tr><td>
				#ProgramName#
			</td></tr>
			</cfloop>
			</table>	  
	
		</td>
		
		<!--- check access --->
		
		<cfinvoke component        = "Service.Access"  
				   method          = "ProcApprover" 
				   orgunit         = "#Purchase.OrgUnit#"
				   returnvariable  = "POAccess">
					   
		<cfif POAccess eq "EDIT" or POAccess eq "ALL">		   
				
			<td width="80" align="center">
				<a href="javascript:ProcPOEdit('#purchaseno#','view')"><font color="0080FF">#PurchaseNo#</a>
			</td>
		
		<cfelse>
		
			<td width="80" align="center">
				#PurchaseNo#
			</td>
		
		</cfif>	
				
	</cfif>
	
	<td width="320" height="18" style="cursor: pointer;" onclick="radio#currentrow#.click()"
	    style="padding-left: 3px;">#Description#</td>
	<td align="center">#Currency.Currency#</td>	
	<td align="right">#numberformat(Amount,"__,__.__")#&nbsp;</td>
	<td align="right">#numberformat(Requested,"__,__.__")#&nbsp;</td>
	<td align="right"><cfif Requested neq "">#numberformat(Amount-Requested,"__,__.__")#<cfelse>#numberformat(Amount,"__,__.__")#</cfif>&nbsp;</td>
	<td  align="right">#numberformat(Invoiced,"__,__.__")#&nbsp;</td>
	</tr>
	
</cfoutput>	

</table>
</cf_divscroll>

<script>
	$('#line').show();
</script>