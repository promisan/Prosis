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

<cfoutput>

<table width="100%">
<tr><td style="height:40px;color:white" align="center">

<table class="formpadding formspacing"><tr>

<cfloop index="status" list="0,0a,0b,0d,1,9">

		<cfswitch expression="#Status#">
								
			<cfcase value="0">
			    <cfset ti = "New">
			    <cfset cl = "yellow">
			</cfcase>								
			<cfcase value="0a">
			    <cfset ti = "Posting start">
			    <cfset cl = "00FFFF">
			</cfcase>
			<cfcase value="0b">
			     <cfset ti = "Posting end">
			    <cfset cl = "lime">
			</cfcase>
			<cfcase value="0d">
			     <cfset ti = "Action">
			    <cfset cl = "silver">
			</cfcase>
			<cfcase value="1">
			     <cfset ti = "Completed">
			    <cfset cl = "green">
			</cfcase>
			<cfcase value="9">
		     <cfset ti = "Cancelled">
			    <cfset cl = "red">
			</cfcase>
		
		</cfswitch>		
								
		<td class="labelmedium" style="border-radius:6px;border:1px solid gray;text-align:center;width:100px;background-color:#cl#">#ti#</td>	

</cfloop>

</tr></table>

</td></tr>

</table>

</cfoutput>

<!---

<cfquery name="SearchResult"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *,
	          (SELECT count(*) FROM Materials.dbo.ItemTransaction WHERE TransactionBatchNo = B.Batchno) as Lines
	FROM      StockBatch_#SESSION.acc# B
	WHERE     TransactionDate = '#dateformat(url.selecteddate,client.dateSQL)#'		
	ORDER BY  Created DESC
</cfquery>

<cfquery name="getWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse
	WHERE     Warehouse = '#url.warehouse#'	
</cfquery>

<table width="98%"	      
       border="0"
	   align="center"
       cellspacing="0"	   
	   cellpadding="0">
	   
  <tr><td height="4">
    <cfoutput>	
    	<input type="hidden"
	       id="calendarrefresh"
	       value="testing"
	       onClick="calendarrefresh('#day(url.selecteddate)#','#URLEncodedFormat(url.selecteddate)#')">
	</cfoutput>
  </td></tr>	   
			  	 						
  <TR>
  
	<td height="100%" colspan="2" valign="top" style="padding:1px">		
					
	<table width="100%" align="center" class="navigation_table">
	
		<cfoutput>
		
		<tr class="line labelmedium fixrow">
		    <td style="width:40"></td>
		    <td height="17" style="padding-right:5px"><cf_tl id="Batch"></td>	
			<TD><cf_tl id="Time"></TD>		
			<TD><cf_tl id="Receipt"></TD>			
			<TD><cf_tl id="Class"></TD>				   
			<TD><cf_tl id="Location"></TD>							
			<TD style="padding-right:4px"><cf_tl id="Usage"></TD>
		    <TD><cf_tl id="Processed"></TD>
			<TD><cf_tl id="Facility"></TD>				
			<td><cf_tl id="Item"></td>		
		</TR>
				
		</cfoutput>
		
		<cfset pages = "99">
		<cfset rows  = "99">
		<cfset first = "1">
													
		<cfoutput>
			<input type="hidden" name="pages" id="pages" value="#pages#">
			<input type="hidden" name="total" id="total" value="#rows#">
			<input type="hidden" name="row"   id="row"   value="0">
			<input type="hidden" name="topic" id="topic" value="#SearchResult.BatchNo#" onClick="batch('#SearchResult.BatchNo#','#url.Mission#','process','#url.systemfunctionid#')">
		</cfoutput>
			
		<cfset row   = 0>
		<cfset grp   = 1>
							
			<cfoutput query="SearchResult" startrow="#first#">
			
				<cfif currentrow-first lt rows>
								 							   
				 				  					  					  
				   		<cfset row = row+1>
						
						<cfif ContraWarehouse neq "" and ContraWarehouse neq getWarehouse.WarehouseName>
						
							<cfset cl = "ffffcf">
							
						<cfelse>
						
							<cfset cl = "ffffff">
						
						</cfif>
						
						<tr bgcolor="#cl#" class="navigation_row labelmedium line" style="height:20px">
											    	
							<td style="padding-left:5px;padding-right:5px;" height="19">#row#</td>
							
							<TD style="padding-right:5px" class="navigation_action">
		                     <a href="javascript:batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#')">#BatchNo#</a>								
							
							</TD>
							<TD style="min-width:90px">
							<cfif dateformat(TransactionDate,client.dateformatshow) neq dateformat(created,dateformatshow)>
							#dateformat(created,dateformatshow)#
							</cfif>#timeformat(created,"HH:MM")#</TD>
							<TD style="min-width:90px">#BatchReference#</TD>
							<TD><cf_tl id="#BatchDescription#"></TD>
							<td>#LocationDescription#</td>							
							<TD>#Category#</TD>
							<TD>#OfficerFirstName# #OfficerLastName#</TD>
							<TD align="left">
							<cfif ContraWarehouse neq "" and ContraWarehouse neq getWarehouse.WarehouseName>#ContraWarehouse# to #getWarehouse.WarehouseName#<cfelse>#ContraWarehouse#</cfif>
							</TD> 							
							<td align="right" style="padding-top:2px">
									
								<cfif Lines gte 5>
								
									#lines#
								
								<cfelse>						
								
									<cfquery name="getQuantity"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    ItemDescription, 
												  <cfif TransactionType eq "2">
										          SUM(TransactionQuantity*-1) AS Quantity
												  <cfelse>
												  SUM(TransactionQuantity) AS Quantity
												  </cfif>
										FROM      ItemTransaction
										WHERE     TransactionBatchNo = '#BatchNo#'
										AND       TransactionType    = '#TransactionType#'
										<cfif TransactionType eq "8">
										AND       TransactionQuantity > 0 
										</cfif>									
										GROUP BY ItemDescription
									</cfquery>
								
									<table width="100%">
									<cfloop query="getQuantity">
									<tr class="labelmedium" style="height:10px">
									<td>#ItemDescription#</td>
									<td align="right">#numberformat(Quantity,"._")#</td>
									</tr>
									</cfloop>
									</table>		
									
								</cfif>	
							
							</td>	
							
						</TR>
															
					  
				 
				  
	 			</cfif>	
										 									
			</CFOUTPUT>
			
			<cfquery name="sum" dbtype="query">
				SELECT SUM(lines) as Lines,
				       SUM(Amount) as Amount
				FROM SearchResult								
			</cfquery>
			
			<cfoutput>
			
			<cfif searchresult.recordcount eq "0">
			
			<tr>
			<td colspan="9" style="height:30px;padding-top:30" align="center" height="50" class="labelmedium">
				<font color="808080"><cf_tl id="There are no transaction to show in this view"></font>
			</td>
			</tr>
										
			</cfif>
			
			</cfoutput>
			
		</TABLE>
				
	</td>
</tr>
</table>		

<cfset AjaxOnLoad("doHighlight")>	

<script>Prosis.busy('no')</script>

--->
	