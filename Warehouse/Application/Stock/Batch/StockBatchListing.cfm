
<cfparam name="URL.id"                default="0000">
<cfparam name="URL.mission"           default="">

<cfparam name="URL.Group"             default="TransactionDate">
<cfparam name="URL.page"              default="1">
<cfparam name="URL.status"            default="0">
<cfparam name="URL.Fnd"               default="">
<cfparam name="URL.TransactionType"   default="">

<cfoutput>
<input type="hidden" id="warehouseselected" value="#url.warehouse#">
</cfoutput>

<cfif url.status eq "9">
     <cfset suff = "Deny">
<cfelse>
     <cfset suff = "">  
</cfif>

<cfif URL.Page eq "1" and url.transactiontype eq "" and url.fnd eq "">
    <!--- prepare dataset : ItemReceipt_#SESSION.acc# --->
	<cfinclude template="StockBatchPrepare.cfm">
</cfif>

<!--- ensure a refresh of the id on line 210 "b#BatchNo#" --->

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse
	WHERE     Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="SearchResult"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      StockBatch_#SESSION.acc# B
	WHERE     1=1
	<cfif url.transactiontype neq "">
	AND       TransactionType = '#url.transactiontype#'
	</cfif>
	<cfif url.fnd neq "">
	AND (
			(Description LIKE '%#URL.fnd#%' or BatchNo LIKE '%#URL.fnd#%')	 
			OR EXISTS (
				SELECT 'X'
				FROM   Materials.dbo.ItemTransaction#suff# T WITH (NOLOCK) INNER JOIN Materials.dbo.ItemUoM UoM ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM
				WHERE  T.Warehouse          = '#url.warehouse#'
				AND    T.TransactionBatchNo = B.BatchNo
				AND    ( T.ItemNo LIKE '#URL.fnd#%' OR UoM.ItemBarCode LIKE '#URL.fnd#%')
			)					
		)	
	</cfif>		
	ORDER BY  #URL.Group# DESC, Detail DESC, Created DESC
</cfquery>

  
<cfset rows = ceiling((url.height-230)/35)>
<cfset first   = ((URL.Page-1)*rows)+1>
<cfset pages   = Ceiling(SearchResult.recordCount/rows)>
<cfif pages lt '1'>
      <cfset pages = '1'>
</cfif>
	
<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">

<table width="100%" height="100%" align="center">

<tr><td valign="top">
	
	<table width="99%"
	       height="100%"
	       border="0"
		   align="center"
	       cellspacing="0"	   
		   cellpadding="0">
		
	  <cfinvoke component   = "Service.Access"  
		   method          = "RoleAccess" 
		   Role            = "'WhsPick'"
		   Parameter       = "#url.systemfunctionid#"
		   Mission         = "#url.mission#"  	  
		   AccessLevel     = "2"
		   returnvariable  = "FullAccess">				 
	 	   
	  <tr class="line"><td height="5"></td></tr>
	  	 	  	   
	  <tr>
	
		  <td valign="top">
						
				<cfoutput>	
				
				<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr class="line">
				<td width="190px">
				
					<table>
					<tr><td class="labelmedium" style="min-width:80px;padding-left:5px;padding-right:4px"><cf_tl id="Search">:</td>
					<td>
				
						<table cellspacing="0" cellpadding="0" border="0">
						<tr><td>
						
						   <input type="text" name="find" id="find" value="#URL.fnd#" style="border-top:0px;border-bottom:0px;" class="regularxl" size="14" maxlength="25" class="regular3"				   
						     onKeyUp="stockbatchgo('x','#url.systemfunctionid#')">
						   						   
						   <td style="border:0px solid silver;width:50px;padding-left:2px">
						   						   					   
						     <img src="#SESSION.root#/Images/search.png" 
							  alt    = "Search" 
							  name   = "locate" 
							  onMouseOver= "document.locate.src='#SESSION.root#/Images/contract.gif'" 
							  onMouseOut = "document.locate.src='#SESSION.root#/Images/search.png'"
							  style  = "cursor: pointer" 
							  border = "0" 		
							  height = "25"				  
							  align  = "absmiddle" 
							  onclick="Prosis.busy('yes');_cf_loadingtexthtml='';stockbatch('x','#url.systemfunctionid#')">						  
							  
						</td></tr>
						</table>
									
					</td>						
										
					<td class="labelmedium" style="min-width:70px;padding-left:15px;padding-right:4px"><cf_tl id="Type">:</td>
					
					<td>
					
						<cfquery name="ListType"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_TransactionType
								WHERE TransactionType IN (SELECT TransactionType FROM UserQuery.dbo.StockBatch_#SESSION.acc#)
						</cfquery>
					
						<select name="TransactionType" id="transactiontype" size="1" class="regularxl" style="border-top:0px;border-bottom:0px;" onChange="Prosis.busy('yes');_cf_loadingtexthtml='';stockbatch('x','#url.systemfunctionid#')">
							<option value=""><cf_tl id="Any"></option>
						    <cfloop query="ListType">
						        <option <cfif url.transactiontype eq transactiontype>selected</cfif> value="#TransactionType#">#Description#</option>
					    	</cfloop>	 
						</select>   			
						
						</td>
						</tr>
					
					</table>
				
				</td>	
				
				<td align="right" style="padding-left:5px">
					
					<cfif pages lte "1">
					
						<input type="hidden" name="page" id="page" value="1">
					
					<cfelse>
								
					   	<select name="page" id="page" size="1" class="regularxl" style="border-top:0px;border-bottom:0px;" onChange="Prosis.busy('yes');_cf_loadingtexthtml='';stockbatch('x','#url.systemfunctionid#')">
						    <cfloop index="Item" from="1" to="#pages#" step="1">
						        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
					    	</cfloop>	 
						</select>   				
						
					</cfif>	
					
					</td>			
				
				</tr>
				</table>	
				
				</cfoutput>
		  </td>			
	  </tr>
	 	  	 						
	  <TR onKeyUp="navigate()">
	  
		<td height="100%" colspan="2" valign="top" style="padding:1px">		
		
		<cf_divscroll>
						
		<table width="98%" style="min-width:1000px" align="center" class="formpadding navigation_table">	
		
			<cfoutput>			
			<tr class="labelmedium line">
			    <td colspan="2" height="17" style="min-width:80px;padding-left:5px;padding-right:5px"><cf_tl id="Batch"></td>			
				<TD style="min-width:200px"><cf_tl id="Class"></TD>				   
				<TD style="width:100%"><cf_tl id="Location"><br>/<cf_tl id="Customer"></TD>
				<TD style="min-width:100px"><cf_tl id="Delivery"></TD>				
				<TD style="min-width:100px"><cf_tl id="Invoice"></TD>
			    <TD style="min-width:120px"><cf_tl id="Officer"></TD>				
				<td style="min-width:140px"><cf_tl id="Source"><br>/<cf_tl id="Destination"></td>
				<td style="min-width:80px" align="right"><cf_tl id="Lines"></td>
			</TR>						
			</cfoutput>
												
			<cfoutput>
				<input type="hidden" name="pages" id="pages" value="#pages#">
				<input type="hidden" name="total" id="total" value="#rows#">
				<input type="hidden" name="row" id="row"  value="0">
				<input type="hidden" name="topic" id="topic" value="#SearchResult.BatchNo#" onClick="batch('#SearchResult.BatchNo#','#url.Mission#','process','#url.systemfunctionid#')">
			</cfoutput>
				
			<cfset row   = 0>
			<cfset grp   = 1>
			
			<cfset row = first-1>
								
			<cfoutput query="SearchResult" startrow="#first#">						
			
				<cfif currentrow-first lt rows>
								 							   
				  <cfif detail eq "0">
				  					  					  
				   		<cfset row = row+1>
											  				
					    <tr id="r#row#" class="line labelmedium navigation_row" style="cursor:pointer;"
							onclick="selectact('#row#','#BatchNo#')">
					    	
							<td align="center" style="font-size:13px;padding-left:9px">#row#</td>
							
							<TD style="padding-right:5px">
		
								<table cellspacing="0" cellpadding="0">
								    
									<tr style="height:15px" class="labelmedium">										
									<td style="padding-right:6px;padding-left:5px">										
									<cf_img icon="edit" navigation="Yes" onClick="batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#')">											
									</td>
									<td width="6"></td>
									<td style="font-size:16px">#BatchNo#</td>										
									</tr>
								</table>
							
							</TD>
							<TD style="font-size:16px"><cf_tl id="#BatchDescription#"></TD>
							<cfif CustomerId neq "">
							<td style="font-size:16px">#CustomerName#</td>
							<cfelse>
							<td style="font-size:16px">#LocationDescription#</td>
							</cfif>
							<TD style="font-size:16px;"><cfif DeliveryMode eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif></TD>
							<td style="font-size:16px;padding-right:4px">#BatchReference#</td>
							<TD style="font-size:16px">#OfficerFirstName# <font size="1">#timeformat(Created,"HH:MM:SS")#</TD>
							<TD style="font-size:16px">#ContraWarehouse#</TD>
						    <td id="content_#BatchNo#_refresh" onclick="_cf_loadingtexthtml='';ptoken.navigate('../Batch/setBatchProgress.cfm?batchno=#BatchNo#','content_#BatchNo#_refresh')"
							   align="right" style="font-size:16px;padding-right:5px;padding-top:4px">
							   
							    <cfif actionStatus eq "9">
								
									#lines#
								
								<cfelse>
							  
									<cfif cleared lt Lines>
									
										<table>
									 	<tr class="labelmedium">
										   <td style="width:30px;font-size:16px" align="center">#cleared#</td>
										   <td style="font-size:16px">|</td>
										   <td align="center" style="width:30px;font-size:16px">#lines#</td>
									    </tr>
									   </table>
									   
									<cfelse>  
									
										<table>
									 	<tr class="labelmedium">
										   <td style="font-size:16px;color:green" align="center"><cf_tl id="Completed"></td>	  
									    </tr>
									   </table> 
										
									</cfif>
								
								</cfif>
							   
							</td>																
						</TR>																		
					  
				  <cfelse>
				     
					<!---
					  												
					<cfquery name="sum" 
					     dbtype="query">
							SELECT SUM(lines) as Lines,
							       SUM(Amount) as Amount
							FROM   SearchResult	
							WHERE  TransactionDate >= '#Dateformat(TransactionDate, CLIENT.dateSQL)#'	AND TransactionDate < '#Dateformat(TransactionDate+1, CLIENT.dateSQL)#'							
					</cfquery>		
					
					--->
																					 				
					<tr bgcolor="ffffff" class="regular line" height="23">	
											 
						<td colspan="8" valign="bottom" class="labelmedium" style="height:50px;padding-left:6px;font-size:26px;padding-top:3px;padding-bottom:5px">#Dateformat(TransactionDate, "DD/MM/YY DDDDD")#</td>
						<td align="right" valign="bottom" style="padding-top:14px" class="labelit">
						
						<!---																			
						<cfif sum.Amount eq "0" or sum.Amount eq "">							
							<!--- nada --->							
						<cfelse>						
							#NumberFormat(abs(sum.Amount),',.__')#
						</cfif>
						--->
						
						</td>	
						
					</TR>
												
				  </cfif>
				  
	 			</cfif>	
										 									
			</CFOUTPUT>
				
			<cfquery name="sum" dbtype="query">
				SELECT SUM(lines) as Lines,SUM(Amount) as Amount
				FROM   SearchResult								
			</cfquery>
				
			<cfoutput>
				
			<cfif searchresult.recordcount eq "0">
				
				<tr>
				<td colspan="9" style="height:50px" align="center" height="50" class="labelmedium">
				<font color="gray"><cf_tl id="There are no transaction to show in this view"></font>
				</td>
				</tr>
				
			<cfelse>
								
				<tr class="labelmedium">	
							  	
					<td height="20" colspan="8"><cf_tl id="Total"> :</td>
				    <td align="right">
					<cfif sum.Amount eq "0" or sum.Amount eq "">							
										
					<cfelse>
					#NumberFormat(abs(sum.Amount),',.__')#
					</cfif>
					</td>
					
				</tr>
								
			</cfif>
				
			</cfoutput>
				
			</TABLE>
			
			</cf_divscroll>	
					
		</td>
	</tr>
	
	</table>		
	
</td></tr>

</table>

<cfif url.status eq "0" and URL.Page eq "1" and url.transactiontype eq "" and url.fnd eq "">

	<cfinvoke component = "Service.Connection.Connection"  
		   method           = "setconnection"    
		   object           = "WarehouseBatchCenter" 
		   ScopeId          = "#warehouse.MissionOrgUnitId#"		   
		   ScopeFilter      = "B.Warehouse=''#url.warehouse#'' AND B.BatchClass=''WhsSale'' AND B.ActionStatus=''0''"
		   ControllerNo     = "992"
		   ObjectContent    = "#SearchResult#"
		   ObjectIdfield    = "batchno"
		   delay            = "12">	  
		   
</cfif>		   

<cfset ajaxonload("doHighlight")>

<script>
 parent.Prosis.busy('no')
</script>