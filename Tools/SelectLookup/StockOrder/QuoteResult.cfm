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
<cfparam name="Form.Crit1_Value" default="">
<cfparam name="Form.Crit2_Value" default="">
<cfparam name="Form.Crit3_Value" default="">
<cfparam name="Form.Crit4_Value" default="">
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

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT *
	FROM (

     SELECT      CR.Mission,
	             (SELECT CustomerName     FROM Customer C WHERE CR.CustomerId = C.CustomerId)     as CustomerName,
				 (SELECT CustomerSerialNo FROM Customer C WHERE CR.CustomerId = C.CustomerId) as CustomerSerialNo,	             
				 CR.RequestNo, 
				 CR.RequestClass, 
				 CR.CustomerId, 
				 CR.Warehouse, 
				 W.WarehouseName,
				 CR.BatchNo, 
				 CR.ActionStatus, 
				 CR.Source, 
				 CR.OfficerUserId, 
				 CR.OfficerLastName, 
                 CR.OfficerFirstName, 
				 CR.Created
     FROM        CustomerRequest AS CR INNER JOIN
				 Warehouse AS W ON CR.Warehouse = W.Warehouse
     WHERE       CR.Mission = '#URL.filter1value#' 
	 AND         CR.ActionStatus IN ('0','1') 
	 AND         CR.BatchNo IS NULL <!--- not turned into a sale --->
	 AND         CR.RequestNo NOT IN (SELECT SourceNo FROM WorkOrder.dbo.WorkorderLine WHERE Source = 'Quote' and Sourceno = CR.RequestNo) <!--- not turned into an order --->	 
	 AND         CR.RequestNo NOT IN (SELECT RequestNo FROM CustomerRequestLine        WHERE BatchId is NOT NULL) <!--- was not reloaded for process in POS --->
	 AND         CR.RequestNo IN     (SELECT RequestNo FROM CustomerRequestLine) <!--- has lines --->
	 
	 ) as CR
	 
	 <cfif criteria neq "">
	WHERE  #preserveSingleQuotes(criteria)# 	
	<cfelse>
	WHERE  OfficerUserId = '#session.acc#'
	</cfif>		
	 
	 ORDER BY CR.Created DESC

</cfquery>

<cfif searchResult.recordcount eq "0">

	<table height="100%" width="100%">
	<tr class="labelmedium2"><td align="center"><cf_tl id="No match for your search"></td></tr>
	</table>

<cfelse>
	
	<cfquery name="Total" dbtype="query">
		SELECT     count(*) as Total
		FROM SearchResult
	</cfquery> 
		
	<cf_pagecountN show="100" 
	               count="#Total.Total#">
				   
	<cfset counted  = total.total>	

	<table height="100%" width="100%">
	
	<tr class="hide"><td id="search1"></td></tr>
	<tr class="line"><td height="14">						 
		 <cfinclude template="QuoteNavigation.cfm">	 				 
	</td></tr>
	
	<tr><td height="100%">
	
		<cf_divscroll style="height:100%" overflowy="scroll">
		
			<table width="98%" class="navigation_table">
						   
				<tr class="labelmedium2 line fixrow fixlengthlist">	  
				    
					<td><cf_tl id="Quote"></td>
					<td><cf_tl id="Class"></td>			
					<TD><cf_tl id="Date"></TD>		
					<td><cf_tl id="Customer"></td>
					<td><cf_tl id="Id"></td>
					<td><cf_tl id="Store"></td>
					
					<TD><cf_tl id="Officer"></TD>		
					<TD><cf_tl id="Source"></TD>		
					<TD><cf_tl id="Status"></TD>	
					<td style="width:45px"></td>				
				</tr>  		 
					
				<cfoutput query="SearchResult">
						
					<cfif currentrow gte first>
							
						<cfif actionStatus eq "9">
						   <cfset cl = "FAA0AE">
						   <cf_tl id="Voided" var="1">
						<cfelseif actionStatus eq "0">   
						   <cfset cl = "FFFF00">
						   <cf_tl id="In preparation" var="1">
						<cfelse>
						   <cfset cl = "FFFFFF">
						   <cf_tl id="Prepared" var="1">
						</cfif>
									
						<tr class="navigation_row labelmedium2 line fixlengthlist" id="r#requestNo#">		  
						    <td id="c#requestno#" align="center" style="padding-bottom:2px;padding-top:2px;background-color:###cl#80">	
										
							   <!--- sales that relate to issuance/inventory/issuance batch can not be edited here, we support opening the batch --->
							   
							   <input type="button" class="button10g" style="border:1px solid silver;width:60px;height:23px" value="#RequestNo#"
							   onclick="window['fnCBDialogSaleClose'] = function(){ ProsisUI.closeWindow('dialog#url.box#') }; ptoken.navigate('#link#&action=insert&#url.des1#=#RequestNo#','#url.box#','fnCBDialogSaleClose','','POST','');" >
							   
							</td>
							
							<td>#RequestClass#</td>							
							<td>#dateformat(Created,CLIENT.DateFormatShow)#</td>		
							<td><cfif CustomerName eq ""><i><cf_tl id="Anonymous"><cfelse>#CustomerName#</cfif> </td>
							<td>#CustomerSerialNo#</td>
							<td>#WarehouseName#</td>															
							<td>#OfficerLastName#</td>
							<td>#Source#</td>
							<td style="padding-left:4px;background-color:###cl#80">#lt_text#</td>	
							<td>
							<cfif (actionStatus eq "0" and session.acc eq OfficerUserid) or 
								   (actionstatus neq "1" and getAdministrator eq "1")>
							     <cf_img icon="delete" onclick="ptoken.navigate('#session.root#/tools/selectLookup/stockorder/setQuote.cfm?id=#requestNo#&action=delete','c#requestno#')">
							</cfif>						
							</td>
						</tr>
						
					</cfif>	
						     
				</CFOUTPUT>
			
			</TABLE>
		
		</cf_divscroll>
	
	</td></tr>
	
	<tr class="line"><td height="30" colspan="11">						 
		 <cfinclude template="QuoteNavigation.cfm">	 				 
	</td></tr>
	 
	</table> 
	
</cfif>	

<cfset ajaxonLoad("doHighlight")>
