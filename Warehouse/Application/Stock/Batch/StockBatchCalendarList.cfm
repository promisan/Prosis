
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

<table width="98%" align="center">
	   
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
		
		<tr class="line labelmedium fixrow fixlengthlist">
		    <td style="width:40"></td>
		    <td height="17"><cf_tl id="Batch"></td>	
			<TD><cf_tl id="Time"></TD>		
			<TD><cf_tl id="Receipt"></TD>			
			<TD><cf_tl id="Class"></TD>				   
			<TD><cf_tl id="Location"></TD>							
			<TD><cf_tl id="Usage"></TD>
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
						
							<cfset cl = "ffffff">
							
						<cfelse>
						
							<cfset cl = "ffffcf">
						
						</cfif>
						
						<tr bgcolor="#cl#" class="navigation_row labelmedium line fixlengthlist" style="height:20px">
											    	
							<td height="19">#row#</td>
							
							<TD class="navigation_action">
		                     <a href="javascript:batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#')">#BatchNo#</a>								
							
							</TD>
							<TD>
							<cfif dateformat(TransactionDate,client.dateformatshow) neq dateformat(created,dateformatshow)>
							#dateformat(created,dateformatshow)#
							</cfif>#timeformat(created,"HH:MM")#</TD>
							<TD>#BatchReference#</TD>
							<TD><cf_tl id="#BatchDescription#"></TD>
							<td>#LocationDescription#</td>							
							<TD>#Category#</TD>
							<TD>#OfficerLastName#</TD>
							<TD align="left">
							<cfif ContraWarehouse neq "- internal -" and ContraWarehouse neq getWarehouse.WarehouseName>
							#ContraWarehouse# -> #getWarehouse.WarehouseName#<cfelse>#ContraWarehouse#
							</cfif>
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
									<tr class="labelit fixlengthlist" style="height:10px">
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
	