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

<cfparam name="criteria" default="">

<cfif Form.Crit1_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">
	
</cfif>	
	
<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>

<cfif Form.Crit3_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit3_FieldName#"
	    FieldType="#Form.Crit3_FieldType#"
	    Operator="#Form.Crit3_Operator#"
	    Value="#Form.Crit3_Value#">
	
</cfif>	

<cfif Form.Crit4_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit4_FieldName#"
	    FieldType="#Form.Crit4_FieldType#"
	    Operator="#Form.Crit4_Operator#"
	    Value="#Form.Crit4_Value#">
	
</cfif>	

<cfset link    = replace(url.link,"||","&","ALL")>
   

<!--- Query returning search results --->

<cfparam name="Form.ObjectUsage" default="">

<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   count(*) as Total
	FROM     WarehouseBatch R 
			 INNER JOIN Customer 
			 	ON R.CustomerId = Customer.CustomerId 
			 INNER JOIN (SELECT CustomerId, CustomerName AS CustomerInvoice FROM Customer) CI
			 	ON R.CustomerIdInvoice = CI.CustomerId
			 INNER JOIN Warehouse 
			 	ON R.Warehouse = Warehouse.Warehouse
			
	WHERE    R.Warehouse = '#url.filter1value#' 
	
	<!--- valid sales transaction --->
	AND      R.BatchId IN
                          (SELECT   TransactionSourceId
                            FROM    Accounting.dbo.TransactionHeader
                            WHERE   Mission = R.Mission 
							AND     TransactionSource = 'SalesSeries')
	AND	   	R.actionStatus != '9'	
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>							
	
</cfquery>

<cf_pagecountN show="70" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   TOP #last# *, 
	
			(SELECT     TOP (1) THA.ActionReference1
		     FROM       Accounting.dbo.TransactionHeader AS TH INNER JOIN
		                Accounting.dbo.TransactionHeaderAction AS THA ON TH.Journal = THA.Journal AND TH.JournalSerialNo = THA.JournalSerialNo
		     WHERE      TH.TransactionSourceId = R.BatchId 
			 AND        TH.TransactionCategory = 'Receivables' 
			 AND        THA.ActionCode = 'Invoice'
		     ORDER BY   THA.ActionDate DESC) as InvoiceReference
	
	FROM     WarehouseBatch R 
			 INNER JOIN Customer 
			 	ON R.CustomerId = Customer.CustomerId 
			 INNER JOIN (SELECT CustomerId, CustomerName AS CustomerInvoice FROM Customer) CI
			 	ON R.CustomerIdInvoice = CI.CustomerId
			 INNER JOIN Warehouse 
			 	ON R.Warehouse = Warehouse.Warehouse
		
	WHERE    R.Warehouse = '#url.filter1value#' 
	<cfif criteria neq "">
	AND    	#preserveSingleQuotes(criteria)# 	
	</cfif>
	AND	   	R.actionStatus != '9'	
	
	ORDER BY R.Created DESC

</cfquery>

<table height="100%" width="100%">

<tr class="hide"><td id="search1"></td></tr>
<tr class="line"><td height="14">						 
	 <cfinclude template="SaleNavigation.cfm">	 				 
</td></tr>

<tr><td height="100%">

<cf_divscroll style="height:100%" overflowy="scroll">

	<table width="99%" class="navigation_table">
				   
		<tr class="labelmedium2 line fixrow fixlengthlist">	  
		    <td></td>
			<td><cf_tl id="Sale"></td>
			<TD><cf_tl id="Date"></TD>		
			<td><cf_tl id="Tax No"></td>
			<td><cf_tl id="Customer"></td>
			<td><cf_tl id="Customer Invoice"></td>
			
			<TD><cf_tl id="Sales Person"></TD>		
			<TD><cf_tl id="Posted"></TD>
			<TD><cf_tl id="Status"></TD>			
		</tr>  		 
			
		<cfoutput query="SearchResult">
				
		<cfif currentrow gte first>
				
				<cfif actionStatus eq "9">
				   <cfset cl = "FAA0AE">
				   <cf_tl id="Voided" var="1">
				<cfelseif actionStatus eq "0">   
				   <cfset cl = "FFFF00">
				   <cf_tl id="In process" var="1">
			    <cfelse>
				   <cfset cl = "FFFFFF">
				   <cf_tl id="Completed" var="1">
				</cfif>
						
			<tr class="navigation_row labelmedium2 line fixlengthlist" title="<cfif ParentBatchNo neq "">Reposted from Sales No.: #ParentBatchNo#</cfif>">		  
			    <td align="center" style="padding-top:2px;background-color:###cl#80">	
							
				   <!--- sales that relate to issuance/inventory/issuance batch can not be edited here, we support opening the batch --->
				   
				   <cfif BatchClass eq "" or BatchClass eq "WhsSale">		   
					   <cf_img icon="select" 
					           navigation="Yes" 
							   onclick="window['fnCBDialogSaleClose'] = function(){ ProsisUI.closeWindow('dialog#url.box#') }; ptoken.navigate('#link#&action=insert&#url.des1#=#batchid#','#url.box#1','fnCBDialogSaleClose','','POST','');">
				   </cfif>	
				</td>
				<td style="color:##1983E0;"><a href="javascript:batch('#BatchNo#','#mission#','process','')">#BatchNo#</a></td>
				<td>#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>		
				<td>#InvoiceReference# </td>
				<td>#CustomerName#</td>
				<td><cfif CustomerName neq CustomerInvoice>#CustomerInvoice#<cfelse>..</cfif></td>
								
				<td>#ActionOfficerFirstName# #ActionOfficerLastName#</td>
				<td>
				<cfif datediff("d",TransactionDate,Created) eq "0">
				#timeformat(Created,"HH:MM")#
				<cfelse>
				#dateformat(Created,CLIENT.DateFormatShow)# #timeformat(Created,"HH:MM")#
				</cfif> 
				</td>
				<td style="padding-left:4px;background-color:###cl#80">#lt_text#</td>	
			</tr>
			
			<cfif BatchMemo neq "">
			
			<tr class="navigation_row_child labelmedium2 line fixlengthlist">		  
			    <td colspan="2" align="center" style="padding-top:2px;background-color:###cl#80"></td>
				<td colspan="7">#BatchMemo#</td>				
			</tr>
			
			
			</cfif>
			
			<cfif ParentBatchNo neq "">
			
				<cfquery name="detail" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT   *
					FROM     WarehouseBatch R 
							 INNER JOIN Customer 
							 	ON R.CustomerId = Customer.CustomerId 
							 INNER JOIN (SELECT CustomerId, CustomerName AS CustomerInvoice FROM Customer) CI
							 	ON R.CustomerIdInvoice = CI.CustomerId
							 INNER JOIN Warehouse 
							 	ON R.Warehouse = Warehouse.Warehouse
					WHERE	 BatchNo = '#ParentBatchNo#'
					ORDER BY R.Created DESC
				
				</cfquery>
				
				<cfloop query="detail">
					<tr style="height:20px" class="navigation_row_child labellarge fixlengthlist ">
					    <td height="18" align="center" style="padding-top:3px">
							<img src="#SESSION.root#/images/join.gif" align="absmiddle">
						</td>
						<td style="padding-left:2px" bgcolor="FFD7D8">#BatchNo#</td>
						<TD bgcolor="FFD7D8">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</TD>		
						<td bgcolor="FFD7D8">#BatchReference#</td>
						<td bgcolor="FFD7D8" style="padding-left:4px">#CustomerName#</td>
						<td bgcolor="FFD7D8" style="padding-left:4px">#CustomerInvoice#</td>
						
							
						<td bgcolor="FFD7D8">#ActionOfficerFirstName# #ActionOfficerLastName#</td>		
						<TD bgcolor="FFD7D8">
						<cfif datediff("d",TransactionDate,Created) eq "0">
						#dateformat(Created,CLIENT.DateFormatShow)#
						</cfif> #timeformat(Created,"HH:MM")#</TD>
						<TD bgcolor="FFD7D8"><cfif actionStatus eq "9"><cf_tl id="Voided"><cfelse><cf_tl id="Active"></cfif></TD>	
					</tr>
				</cfloop>
			
			</cfif>
			
		</cfif>	
				     
		</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td></tr>

<tr class="line"><td height="30" colspan="11">						 
	 <cfinclude template="SaleNavigation.cfm">	 				 
</td></tr>
 
</table> 

<cfset ajaxonLoad("doHighlight")>
