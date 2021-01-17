<cfparam name="CLIENT.payables" default="">
<cfparam name="url.filter"      default="">
<cfparam name="url.value"       default="">
<cfparam name="url.init"        default="0">

<cfif url.init eq "0">
	<cfinclude template="InquiryData.cfm">
</cfif>

<cfoutput>

<cfsavecontent variable="myquery">
	
	SELECT	*, TransactionDate
	FROM     dbo.Inquiry_#url.mode#_#session.acc# P		
	
	<cfif url.filter eq "customer">
			
		<cfif findNoCase("WHERE",Client.Payables) lte 0>
			WHERE 1=1
		</cfif>	
		#PreserveSingleQuotes(Client.Payables)# 			
		AND ReferenceName LIKE '#url.value#%'
						
	<cfelse>					
			
		<cfif findNoCase("WHERE",Client.Payables) lte 0>			
			WHERE 1=1
		</cfif>	
		<cfif url.value eq "Upcoming">
			AND		Days <= 0
		</cfif>		
		<cfif url.value eq "1-30d">
			AND		Days >= 1.0 AND Days <= 30
		</cfif>
		<cfif url.value eq "31-60d">
			AND		Days > 31.0 AND Days <= 60
		</cfif>
		<cfif url.value eq "61-90d">
			AND		Days > 61.0 AND Days <= 90
		</cfif>
		<cfif url.value eq "91-180d">
			AND		Days > 91.0 AND Days <= 180
		</cfif>
		<cfif url.value eq "Over 180d">
			AND		Days > 180.0
		</cfif>		
		#PreserveSingleQuotes(Client.Payables)# 		
	
	</cfif>
		
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfif url.mode eq "AP">

	<cf_tl id="Payee" var="vLabel">
	<cfset field = "ReferenceName">		
	
<cfelse>

	<cf_tl id="Creditor" var="vLabel">
	<!---
	<cfset field = "ReferenceOrgUnitName">		
	--->
	<cfset field = "ReferenceName">	
	
</cfif>

<cfset itm = 1>
<cfset fields[itm] = {label       = "#vLabel#",                  
					field         = "#field#",
					search        = "text",
					filtermode    = "3"}>

<cfset itm = itm+1>
<cf_tl id="Batch No" var="vBatchNo">
<cfset fields[itm] = {label       = "#vBatchNo#",
					field         = "JournalTransactionNo",
					search        = "text"}>

<cfset itm = itm+1>				
<cf_tl id="Invoice No" var="vInvoice">		
<cfset fields[itm] = {label       = "#vInvoice#", 					
					field         = "TransactionReference",
					search        = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Account" var="vAccount">			
<cfset fields[itm] = {label       = "#vAccount#", 					
					field         = "GLAccount",					
					search        = "text",
					column        = "common",
					display       = "no",
					filtermode    = "2"}>								
					
<!---						
<cfset itm = itm+1>							
<cfset fields[itm] = {label      = "Subject", 					
					field      = "Description"}>																			
--->

<cfset itm = itm+1>		
<cf_tl id="Posted" var="vPosted">		
<cfset fields[itm] = {label       = "#vPosted#", 					
					field         = "TransactionDate",					
					column        = "month",					
					formatted     = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search        = "date"}>							
					
<cfset itm = itm+1>	
<cf_tl id="Due" var="vDue">			
<cfset fields[itm] = {label       = "#vDue#", 					
					field         = "ActionBefore",
					formatted     = "dateformat(ActionBefore,CLIENT.DateFormatShow)",
					search        = "date"}>							

<cfset itm = itm+1>		
<cf_tl id="Days" var="vDays">	
<cfset fields[itm] = {label       = "#vDays#",
                    align         = "right",                   
					field         = "Days",
					search        = "number"}>		

<cfset itm = itm+1>		
<cf_tl id="Status" var="vSta">							
<cfset fields[itm] = {label       = "#vSta#",                   
					field         = "ActionStatus",				
					formatted     = "Rating",
					column        = "common",
					align         = "center",
					ratinglist    = "0=yellow,1=Green"}>		
		
<cfset itm = itm+1>		
<cf_tl id="Curr" var="vCurr">							
<cfset fields[itm] = {label      = "#vCurr#",                   
					field        = "Currency",
					column       = "common",
					search       = "text",
					filtermode   = "2"}>					

<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label      = "#vAmount#", 					
					field        = "Amount",
					align        = "right",
					aggregate    = "sum",
					formatted    = "numberformat(Amount,',.__')",
					search       = "number"}>	
									
<cfset itm = itm+1>		
<cf_tl id="Outstanding" var="vOutstanding">						
<cfset fields[itm] = {label     = "#vOutstanding#", 					
					field       = "AmountOutstanding",
					align       = "right",
					aggregate   = "sum", 
					formatted   = "numberformat(AmountOutstanding,',.__')",
					search      = "number"}>	
					
<table height="100%" width="100%">

<cfparam name="url.header" default="1">

<cfif url.value neq "" and url.header eq "1">
	<cfoutput>		
		<tr class="labelmedium line">
			<td style="font-size:24px;font-weight:300;height:40px"><cfif url.filter neq "Customer"><cf_tl id="Age">:</cfif> #url.value#</td>
		</tr>			
	</cfoutput>
</cfif>

<tr><td valign="top">	
	
	<cfif url.filter eq "customer">	
		<cfset cl = "hide">		
	<cfelse>	
		<cfset cl = "yes">		
	</cfif>			
										
	<cf_listing
	    header           = "Payables"
	    box              = "setting"
		link             = "#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryListing.cfm?header=0&value=#url.value#&mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
		systemfunctionid = "#url.systemfunctionid#"
	    html             = "No"	
		datasource       = "AppsQuery"
		calendar         = "9"
		tablewidth       = "100%"	
		filtershow       = "#cl#"
		excelshow        = "Yes"	
		listgroup        = "Currency"
	 	listgroupdir     = "ASC"
		listquery        = "#myquery#"
		listkey          = "TransactionId"
		listorder        = "TransactionDate"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		listlayout       = "#fields#"
		annotation       = "GLTransaction"
		drillmode        = "tab"
		drillargument    = "920;1180;false;false"	
		drilltemplate    = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey         = "TransactionId">
		
</td></tr></table>		
	
<script>
	Prosis.busy('no')	
</script>

