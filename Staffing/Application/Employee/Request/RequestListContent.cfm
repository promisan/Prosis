
<!--- generate the listing for the presentation --->

<cfoutput>

<cfsavecontent variable="myquery">

    SELECT *
	FROM (

		SELECT     R.RequisitionNo, 
		           R.Mission, 
				   R.Period, 
				   R.PersonNo, 
				   R.Reference, 
				   R.RequestQuantity, 
				   R.QuantityUOM, 
				   R.RequestCostPrice, 
				   R.RequestAmountBase, 
				   
				   (SELECT    OrderAmount
	                FROM      PurchaseLine
	                WHERE     RequisitionNo = R.RequisitionNo
					AND       ActionStatus != '9') AS Obligated,	
				   
				   (SELECT    SUM(AmountMatched)
	                FROM      InvoicePurchase
	                WHERE     RequisitionNo = R.RequisitionNo) AS Invoiced,
				   
	               R.OfficerLastName, 
				   R.OfficerFirstName, 
				   R.Created, 
				   S.StatusDescription, 
				   R.OrgUnit, 
				   R.RequestDate, 
				   R.ActionStatus
		FROM         RequisitionLine AS R INNER JOIN
	                      Status AS S ON R.ActionStatus = S.Status AND S.StatusClass = 'Requisition'
		WHERE     (R.PersonNo = '#URL.ID#' 
		             OR RequisitionNo IN (SELECT  PurchaseLine.RequisitionNo
						  			      FROM    Purchase INNER JOIN
				                                  PurchaseLine ON Purchase.PurchaseNo = PurchaseLine.PurchaseNo
									      WHERE   Purchase.PersonNo = '#URL.ID#')
		          )
		AND       R.ActionStatus NOT IN ('0','0z','9')
	
	) as R
	

	
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = "1">

<cfset fields[itm] = {label      = "No",                   			
					field      = "Reference",
					alias      = "R",
					search     = "text"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Mission",                 
					field      = "Mission", 					
					alias      = "R",
					search     = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Period",                 
					field      = "Period", 					
					alias      = "R",
					search     = "text"}>											
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Status", 					
					field      = "StatusDescription",					
					alias      = ""}>					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Qty", 					
					field      = "RequestQuantity",					
					alias      = "R"}>
<cfset itm = itm+1>									
<cfset fields[itm] = {label      = "UoM", 					
					field      = "QuantityUOM",					
					alias      = "R"}>			
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Price", 					
					field      = "RequestCostPrice",	
					formatted  = "numberformat(RequestCostPrice,'__,__')",
					align      = "right",				
					alias      = "R"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Requested", 					
					field      = "RequestAmountBase",	
					formatted  = "numberformat(RequestAmountBase,'__,__')",
					align      = "right",				
					alias      = "R"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Obligated", 					
					field      = "Obligated",	
					formatted  = "numberformat(Obligated,'__,__')",
					align      = "right",				
					alias      = "R"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Invoiced", 					
					field      = "Invoiced",	
					formatted  = "numberformat(Invoiced,'__,__')",
					align      = "right",				
					alias      = "R"}>																		
<!---																	
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Officer", 					
					field      = "OfficerLastName",					
					alias      = "R",
					filtermode = "2",
					search     = "text"}>	
					
																
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Recorded",   					
					field      = "Created",
					alias      = "R",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>				
					--->
					
<cfset itm = itm+1>	
<cfset fields[itm] = {label      = "No",                   
					Display    = "0",				
					field      = "RequisitionNo",
					alias      = "A"}>					
	

<!--- embed|window|dialogajax|dialog|standard --->

<table width="100%" height="99%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td width="100%" height="100%">						
	
	<cf_listing header  = "Requisition"
	    box           = "actiondetail"
		link          = "#SESSION.root#/Staffing/Application/Employee/Request/RequestListContent.cfm?id=#url.id#"
	    html          = "No"		
		datasource    = "AppsPurchase"
		listquery     = "#myquery#"
		listorder     = "Created"
		listorderdir  = "ASC"
		listorderalias = "R"
		headercolor   = "ffffff"				
		tablewidth    = "99%"
		listlayout    = "#fields#"
		FilterShow    = "Yes"
		ExcelShow     = "Yes"
		drillmode     = "window" 
		drillargument = "1000;1100"	
		drilltemplate = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?add=1&header=1&id="
		drillkey      = "RequisitionNo">	
		
	</td></tr>

</table>		