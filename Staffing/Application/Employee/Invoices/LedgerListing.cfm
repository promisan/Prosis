
<cfsilent>
<cfoutput>
	
	<cfsavecontent variable="myquery">	
	
	SELECT 	*
		FROM
			(
	
			 SELECT H.TransactionId,
			        H.Mission,		
					H.Reference as DocumentReference,			
			        P.*, 
					(CAST(
								FLOOR(
									CAST(
										h.created
										AS FLOAT
										)
									)
									AS DATETIME
									)
									) AS Posted,
					P.AmountDebit-P.AmountCredit         as PostingAmount,
					P.AmountBaseDebit-P.AmountBaseCredit as PostingAmountBase,
					G.Description                        as GLAccountName, 
					G.AccountGroup, 
					S.Description as AccountGroupName, 
					J.Description as JournalName,
					(SELECT Description FROM Program.dbo.Ref_Object WHERE Code = P.ObjectCode) as ObjectDescription
			 	
				FROM TransactionHeader H, 
				     TransactionLine P, 
					 Ref_Account G, 
					 Ref_AccountGroup S, 
					 Journal J
				WHERE J.Journal = P.Journal
				AND  H.Journal = P.Journal
				AND  H.JournalSerialNo = P.JournalSerialNo
				AND  P.GLAccount          = G.GLAccount
				AND  S.AccountGroup       = G.AccountGroup
				AND  H.ReferencePersonNo  = '#url.id#'  
				AND  G.AccountClass       = 'Result' 
				
			) AS Data	
			
			WHERE 1=1
				
	</cfsavecontent>

</cfoutput>

</cfsilent>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Journal",    					             
					  field       = "JournalName",						  
					  filtermode    = "2",
					  displayfilter = "Yes",				
					  search      = "text"}>	  

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "Entity",                  
					  field         = "Mission",
					  Width         = "10",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>				
						  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Document",    					             
					  field       = "ObjectDescription",						  
					  filtermode    = "2",
					  displayfilter = "Yes",				
					  search      = "text"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Document",    					             
					  field       = "DocumentReference",						  							
					  search      = "text"}>	 					  
					    					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Reference",    					             
					  field       = "ReferenceName",						  							
					  search      = "text"}>	 					  

<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Date",  					
					  field         = "TransactionDate",					  
					  search        = "date",					  
					  formatted     = "dateformat(TransactionDate,'#CLIENT.DateFormatShow#')"}>									  
				  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Curr",    					  				                
					  field       = "Currency",	
					  width       = "10",		
					    filtermode    = "2",
					  displayfilter = "Yes",			
					  search      = "text"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Amount",    					  				                
					  field       = "PostingAmount",					
					  search      = "number",
					  align       = "right",
					  formatted   = "numberformat(PostingAmount,',.__')"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Base",    					  				                
					  field       = "PostingAmountBase",					
					  search      = "number",
					  align       = "right",
					  aggregate   = "sum",
					  formatted   = "numberformat(PostingAmountBase,',.__')"}>		
					  

	   
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Posting"
	    box            = "PostingList"
		link           = "#SESSION.root#/Staffing/Application/Employee/Invoices/LedgerListing.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"		
		datasource     = "AppsLedger"
		listquery      = "#myquery#"			
		screentop      = "yes"
		listgroup      = "JournalName"		
		listgroupdir   = "ASC"			
		listorder      = "TransactionDate"
		listorderfield = "TransactionDate"		
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		excelShow      = "Yes"
		drillmode      = "window"	
		drillargument  = "900;1200"
		drilltemplate  = "../Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id="
		drillkey       = "TransactionId">		
	
	</td></tr>
</table>			