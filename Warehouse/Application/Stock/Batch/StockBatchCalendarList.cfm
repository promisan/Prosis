
<cfquery name="SearchResult"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *,
	          (SELECT count(*) FROM Materials.dbo.ItemTransaction WHERE TransactionBatchNo = B.Batchno) as Lines
	FROM      StockBatch_#SESSION.acc# B
	WHERE     TransactionDate = '#dateformat(url.selecteddate,client.dateSQL)#'		
	ORDER BY  TransactionDate, Detail DESC
</cfquery>

<cfquery name="getWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse
	WHERE     Warehouse = '#url.warehouse#'	
</cfquery>

<table width="100%"	      
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
								 							   
				  <cfif detail eq "0">
				  					  					  
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
									<td align="right">#numberformat(Quantity,"__._")#</td>
									</tr>
									</cfloop>
									</table>		
									
								</cfif>	
							
							</td>	
							
						</TR>
															
					  
				  <cfelse>			  
				  		  
				   				     												
					<cfquery name="sum" 
					     dbtype="query">
							SELECT count(*) as counted,
							       SUM(lines) as Lines,
							       SUM(Amount) as Amount
							FROM   SearchResult	
							WHERE  TransactionDate = '#Dateformat(TransactionDate, CLIENT.dateSQL)#'	
							AND    Detail = '0'						
					</cfquery>					
											 				
					<tr bgcolor="ffffff" class="regular line" height="20"					 					 
						 onMouseOver="if (this.className=='regular') {this.className='highlight4'}" 
						 onMouseOut="if (this.className=='highlight4') {this.className='regular'}">	
											 
						<td colspan="6" class="labelmedium" style="padding-left:4px;padding-top:4px;padding-bottom:4px">#Dateformat(TransactionDate, "DDDD DD MMMM YYYY")#</td>
						<td align="right" class="labelmedium" colspan="3" style="padding-top:4px;padding-bottom:4px;padding-right:3px;" class="labelmediumcl">
						<b>#sum.counted#</b> <cfif sum.counted eq "1"><cf_tl id="transaction"><cfelse><cf_tl id="transactions"></cfif>					
						</td>	
						
					</TR>
																
				  </cfif>
				  
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
	