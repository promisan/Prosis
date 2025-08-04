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

<cfquery name="Ledger" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<table class="formspacing">

	<cfoutput query="Ledger">
	
		<tr>
		   <td class="labelit" style="padding-left:5px"><cf_tl id="#Description#">:<cf_space spaces="40"></td>
		   <td>
		   
				<cfquery name="Account" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     WorkOrderGLedger A
						     INNER JOIN Accounting.dbo.Ref_Account B ON A.GLAccount = B.GLAccount
							 INNER JOIN Ref_AreaGledger G ON G.Area   = A.Area 
					WHERE    A.WorkorderId = '#URL.workorderid#'						
					AND      A.Area   = '#Area#'
					ORDER BY ListingOrder
				</cfquery>
				
				<cfif account.recordcount eq "0">
				
				<!--- inherit from the mission --->
				
					<cfquery name="Account" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ParameterMissionGLedger A
						         INNER JOIN Accounting.dbo.Ref_Account B ON A.GLAccount = B.GLAccount
								 INNER JOIN Ref_AreaGledger G ON G.Area   = A.Area 
						WHERE    A.Mission IN (SELECT Mission 
						                       FROM   WorkOrder 
											   WHERE  WorkOrderId = '#URL.workorderid#')							  
						AND      A.Area   = '#Area#'
						ORDER BY ListingOrder
					</cfquery>		
					
					<!--- apply to table --->
					
					<cfif Account.GLAccount neq "">
					
						<cfquery name="Insert" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO WorkOrderGledger
							(WorkorderId,Area,GLAccount)
							VALUES ('#url.WorkOrderId#','#area#','#Account.GLAccount#')
						</cfquery>		
					
					</cfif>		
				
				</cfif>
				
				<cfif area neq "Income" and area neq "Return" and BillingEntry eq "0">
				   <cfset filter = "balance">
				   <cfset field = "AccountClass">		   				   
				<cfelse>  
				   <cfset filter = "result">
				   <cfset field = "AccountClass">				
				</cfif>
			
			    <img src="#SESSION.root#/Images/search.png" alt="Select" name="img3#area#" 
					onMouseOver="document.img3#area#.src='#SESSION.root#/Images/contract.gif'" 
					onMouseOut="document.img3#area#.src='#SESSION.root#/Images/search.png'" style="cursor: pointer;border:0px solid silver;border-radius:3px;"
					width="24" height="25" border="0" align="absmiddle" 
					onClick="selectaccountgl('#get.mission#','#field#','#filter#','','applyaccount','#area#');">
					
				</td>

				<cfset vReq = "No">	
				<cfif lcase(area) eq "stock">
					<cfset vReq = "Yes">
				</cfif>
				
				<td>
			    <cfinput type="text"   name="#area#glaccount"  id="#area#glaccount" 
				  size="13" 
				  value="#Account.GLAccount#"  
				  class="regularxl" readonly style="text-align: left;" message="Please, enter a valid account for #area# area." required="#vReq#">
				</td>
				
				<td>
			    <input type="text"     name="#area#gldescription" id="#area#gldescription"  value="#Account.Description#" class="regularxl" size="40" readonly style="text-align: left;">
				</td>
			   	<input type="hidden"   name="#area#debitcredit"   id="#area#debitcredit">
			   	   
		   </td>
		</tr>		
							
	</cfoutput>
	
	<tr><td colspan="2" class="line">
	<table><tr><td style="height:30px">
	<cfoutput>
	<input type="button" 
	     id="glprocess" 
		 class="button10g"
		 style="width:100px"
		 value="Save"
		 onclick="ptoken.navigate('../GLedger/GledgerSubmit.cfm?workorderid=#url.workorderid#','ledgerbox','','','POST','workorderform')">
	</cfoutput>	 
	</td><td id="ledgerbox"></td></tr></table>
	</td></tr>
		   
</table>
