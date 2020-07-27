

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

<cfinclude template="StockBatchPrepare.cfm">

<cfoutput>
<cfsavecontent variable="myquery">

	SELECT    *
	FROM      StockBatch_#SESSION.acc# B
	WHERE     1=1
	
</cfsavecontent>
</cfoutput>

<!--- old query 

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

--->

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="BatchNo" var="vBatchNo">
<cfset fields[itm] = {label         = "#vBatchNo#", 
					  field         = "BatchNo",
				      searchfield   = "BatchNo",
					  filtermode    = "0",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Class" var="vBatchClass">
<cfset fields[itm] = {label         = "#vBatchClass#", 
					  field         = "BatchDescription",
				      searchfield   = "BatchDescription",
					  filtermode    = "2",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Warehouse" var="vDestination">
<cfset fields[itm] = {label         = "#vDestination#", 
					  field         = "ContraWarehouse",
				      searchfield   = "ContraWarehouse",
					  filtermode    = "2",
					  search        = "text"}>							  					  	

<cfset itm = itm+1>		
<cf_tl id="Customer Name" var="vCustomer">
<cfset fields[itm] = {label         = "#vCustomer#", 
					  field         = "CustomerName",
					  searchfield	= "CustomerName",
  					  filtermode    = "0",
					  search		= "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Invoice" var="vInvoice">
<cfset fields[itm] = {label         = "#vInvoice#", 
					  field         = "BatchReference",
					  searchfield	= "BatchReference",
  					  filtermode    = "0",
					  search		= "text"}>							  
					  
<cfset itm = itm+1>		
<cf_tl id="Location" var="vLocation">
<cfset fields[itm] = {label         = "#vLocation#", 
					  field         = "LocationDescription",
					  searchfield	= "LocationDescription",
  					  filtermode    = "2",
					  search		= "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Del" var="vDelivery">
<cfset fields[itm] = {label         = "#vDelivery#", 
					  field         = "DeliveryMode",
					  searchfield	= "DeliveryMode",
  					  filtermode    = "2",
					  search		= "text"}>		
					  
				  					  						  

<cfset itm = itm+1>		
<cf_tl id="Name" var="vFirst">
<cfset fields[itm] = {label         = "#vFirst#", 
					  field         = "OfficerFirstName",
				      searchfield   = "OfficerFirstName",
					  filtermode    = "2",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label         = "#vDate#", 
					  field         = "TransactionDate",
				      searchfield   = "TransactionDate",
					  filtermode    = "0",
					  formatted     = "dateformat(TransactionDate,client.dateformatshow)",
					  search        = "date"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Time" var="vTime">
<cfset fields[itm] = {label         = "#vTime#", 
					  field         = "Created",
				      searchfield   = "Created",
					  filtermode    = "0",
					  formatted     = "timeformat(Created,'HH:MM')",
					  search        = "text"}>	
					  

<cfset itm = itm+1>			
<cf_tl id="Status" var="vStatus">			
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "#vStatus#",				
					field         = "ProcessStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>	
										  
						  				  
				  					  					  

<cfif url.status eq "0">
	<cfset sl = "Hide">
<cfelse>
	<cfset sl = "Yes">
</cfif>					  
					  
<cf_listing
    header         = "BatchListing"
    box            = "batch"
	link           = "#session.root#/warehouse/application/stock/batch/stockbatchlisting.cfm?status=#url.status#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"
    html           = "Yes"
	show           = "40"
	datasource     = "AppsQuery"
	listquery      = "#myquery#"		
	listorderalias = ""	
	listorder      = "BatchNo"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "#sl#"
	excelShow      = "Yes"
	drillmode      = "tab"	
	drillstring    = "mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mode=process"
	drilltemplate  = "warehouse/application/stock/batch/BatchView.cfm?batchno="
	drillkey       = "BatchNo">	

<!---
   
						
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
																
				  </cfif>
				  
	 			</cfif>	
		
		--->

<!--- rework the refresh --->

<cfif url.status eq "0">

	<cfquery name="searchresult"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		SELECT    *
		FROM      StockBatch_#SESSION.acc# B
		WHERE     1=1
	
	</cfquery>
	
	<cfquery name="warehouse"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Warehouse WHERE Warehouse = '#url.warehouse#'
	</cfquery>		

	<cfinvoke component = "Service.Connection.Connection"  
		   method           = "setconnection"    
		   object           = "WarehouseBatchCenter" 
		   ScopeMode        = "listing"
		   ScopeId          = "#warehouse.MissionOrgUnitId#"		   
		   ScopeFilter      = "B.Warehouse=''#url.warehouse#'' AND B.BatchClass=''WhsSale'' AND B.ActionStatus=''0''"
		   ControllerNo     = "992"
		   ObjectContent    = "#SearchResult#"
		   ObjectIdfield    = "batchno"
		   delay            = "12">	  
		   
</cfif>		   





