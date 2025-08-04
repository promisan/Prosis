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

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Category 
	WHERE  Category = '#URL.ID1#' 
</cfquery>

<cfquery name="Ledger" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AreaGledger
	ORDER BY AccountClass, ListingOrder
</cfquery>

<cfform action="Financials/FinancialsSubmit.cfm?idmenu=#url.idmenu#&category=#url.id1#" method="POST" name="categoryFinancials">

<table width="95%" align="center">

<tr><td height="5"></td></tr>
<tr>
	<td colspan="2"> <font face="Calibri" size="3" color="808080">*&nbsp;&nbsp;&nbsp;In order to make this category available for item;, you must define a valid Stock Level General ledger Account below.</b></font></td>
</tr>
<tr>
	<td colspan="2" class="labelit"><font face="Calibri" size="3" color="red">** It is <b>not</b> recommended to change the Stock level account prior to consultation with Promisan bv.</b></font></td>
</tr>
<tr><td height="10"></td></tr>

	<cfoutput query="Ledger" group="AccountClass">
	
	<tr>
		   <td style="font-size:24px;height:50px;padding-top:10px" class="labellarge"><cfif AccountClass eq "Balance">Balance and AP/AR accounts<cfelse>Result (Income and Costs)</cfif>:</td>
		   <td></td>
	</tr>	   
	
	<cfoutput>
	
		<tr class="line">
		   <td class="labelmedium" style="padding-left:10px"><cf_tl id="#Description#"><font size="1">[#area#]</font>
		   <cfif area eq "receipt"><font color="FF00FF">[Same for all categories]</cfif>
		   </td>
		   <td>		   
		   
		   		<table><tr><td style="width:20px">
				
				<cfquery name="Account" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_CategoryGLedger A, 
				           Accounting.dbo.Ref_Account B
					WHERE  A.GLAccount = B.GLAccount
					AND    Category  = '#URL.ID1#'	   
					AND    Area      = '#Area#'
				</cfquery>
				
				<cfif area eq "Stock" 
				    or area eq "Receipt" 
					or area eq "Interoffice" 					
					or area eq "InterOut" or area eq "shipped">
					
				   <cfset filter = "balance">
				   <cfset field = "AccountClass">						   
				<cfelseif area neq "receipt">  
				   <cfset filter = "result">
				   <cfset field = "AccountClass">
				<cfelse>
				   <cfset filter = "">
				   <cfset field = "">
				</cfif>
				
				<cfif area eq "Stock">
				
					<!--- check if we have stock posted for this account --->
				
					<cfquery name="check" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT TOP 1 *
						FROM   Accounting.dbo.TransactionLine L, 
						       Accounting.dbo.TransactionHeader H,
							   Materials.dbo.ItemTransaction T
						WHERE  GLAccount = '#Account.GLAccount#'					
						AND    L.Journal = H.Journal
						AND    L.JournalSerialNo = H.JournalSerialNo
						AND    H.ReferenceId = T.TransactionId
						AND    T.ItemCategory = '#url.id1#'
					</cfquery>		
					
					<cfif check.recordcount eq "0">
					
					 <img src="#SESSION.root#/Images/contract.gif" alt="Select GL Account" name="img3#area#" 
						onMouseOver="document.img3#area#.src='#SESSION.root#/Images/button.jpg'" 
						onMouseOut="document.img3#area#.src='#SESSION.root#/Images/contract.gif'"
						style="cursor: pointer;" width="16" height="18" border="0" align="absmiddle" 
						onClick="selectaccountgl('','#field#','#filter#','','applyaccount','#area#');">
										
					</cfif>		
				
				<cfelse>
							
			    <img src="#SESSION.root#/Images/contract.gif" alt="Select GL Account" name="img3#area#" 
					onMouseOver="document.img3#area#.src='#SESSION.root#/Images/button.jpg'" 
					onMouseOut="document.img3#area#.src='#SESSION.root#/Images/contract.gif'"
					style="cursor: pointer;" width="16" height="18" border="0" align="absmiddle" 
					onClick="selectaccountgl('','#field#','#filter#','','applyaccount','#area#');">
					
				</cfif>	
				
				</td>
				
				<cfset vReq = "No">	
				<cfif lcase(area) eq "stock">
					<cfset vReq = "Yes">
				</cfif>
				
				<td>
			    <cfinput type="text"  
				      name="#area#glaccount"  
					  size="14" value="#Account.GLAccount#"  
					  class="regularxl" 
					  readonly 
					  style="text-align: left;border-bottom:0px;border:0px;border-left:1px solid silver" 
					  message="Please, enter a valid account for #area# area." 
					  required="#vReq#">
				</td>
				
				<td>
			    <input type="text"     name="#area#gldescription" id="#area#gldescription"  value="#Account.Description#" 
				  class="regularxl" size="40" readonly style="text-align: left;border:0px;border-left:1px solid silver;border-right:1px solid silver">
			   	<input type="hidden"   name="#area#debitcredit"   id="#area#debitcredit">
				
				</td></tr>
				</table>
			   	   
		   </td>
		</tr>
		
		<cfif area eq "receipt">
				   
			   <cfquery name="Check" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT A.GLAccount
					FROM   Ref_CategoryGLedger A, 
				           Accounting.dbo.Ref_Account B
					WHERE  A.GLAccount = B.GLAccount
					AND    Category = '#URL.ID1#'	   
					AND    Area IN ('Stock','Receipt')
				</cfquery>
				
				<cfif Check.recordcount eq "1">
				
				<tr><td></td>
				<td>
				
				<font color="FF0000">Problem, Receipt contra-account MUST be different from the stock account.</font>
				</td>
				</tr>
				
				</cfif>
					
		</cfif>
		
	</cfoutput>	
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" style="height:40px">
		
		<input class="button10g" type="submit" name="save" id="save" value=" Save " style="width:240px">
	
	</td></tr>
	   
</table>

</cfform>