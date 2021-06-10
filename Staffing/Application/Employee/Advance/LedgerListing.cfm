
<cfsilent>
<cfoutput>
	
	<cfsavecontent variable="myquery">	
	
	SELECT 	*, TransactionDate
		FROM
			(
	
			 SELECT   H.TransactionId,
			          H.Mission,		
					  H.Reference as DocumentReference,		
					  H.Description,	
			          L.*,
					  <!--- (CAST( FLOOR(CAST( h.created AS FLOAT )) AS DATETIME )) AS Posted, --->
					  L.AmountDebit-L.AmountCredit         as PostingAmount,
					  L.AmountBaseDebit-L.AmountBaseCredit as PostingAmountBase,
					  G.Description                        as GLAccountName, 
					  G.AccountGroup, 
					  S.Description as AccountGroupName, 
					  J.Description as JournalName,
					  (SELECT Description FROM Program.dbo.Ref_Object WHERE Code = L.ObjectCode) as ObjectDescription
					
				FROM  TransactionHeader AS H 
			           INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
			 	       INNER JOIN Ref_Account G ON G.GLAccount = L.GLAccount 
					   INNER JOIN Ref_AccountGroup S ON S.AccountGroup       = G.AccountGroup
					   INNER JOIN Journal J ON J.Journal = H.Journal
											 
					 
				WHERE  H.Journal IN   (SELECT  Journal
                                   	   FROM    Journal
                                       WHERE   SystemJournal IN ('Advance','Offset')) 
			
				AND    H.RecordStatus <> '9' 
				AND    H.ActionStatus <> '9'
								
			    AND    L.GLAccount IN (SELECT  GLAccount 
			                           FROM    Ref_Account 
							    	   WHERE   AccountClass = 'Balance')
									   
				AND    L.TransactionSerialNo = '0'
												
				AND    H.ReferencePersonNo  = '#url.id#'  
								
			) AS Data	
			
			WHERE 1=1
				
	</cfsavecontent>

</cfoutput>

</cfsilent>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "Entity",                  
					  field         = "Mission",
					  Width         = "10",
					  column        = "common",		
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Journal",    					             
					  field         = "JournalName",						  
					  filtermode    = "2",
					  column        = "common",	
					  displayfilter = "Yes",				
					  search        = "text"}>	 
						  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Object",    					             
					  field         = "ObjectDescription",						  
					  filtermode    = "2",
					  displayfilter = "Yes",				
					  search        = "text"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Document",    					             
					  field         = "DocumentReference",						  							
					  search        = "text"}>	 					  
					    					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Reference",    					             
					  field         = "Description",						  							
					  search        = "text"}>	 					  

<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Date",  					
					  field         = "TransactionDate",	
					  column        = "month",				  
					  search        = "date",					  
					  formatted     = "dateformat(TransactionDate,'#CLIENT.DateFormatShow#')"}>									  
				  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Curr",    					  				                
					  field         = "Currency",	
					  width         = "10",		
					  filtermode    = "2",
					  displayfilter = "Yes",			
					  search        = "text"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Amount",    					  				                
					  field         = "PostingAmount",					
					  search        = "number",
					  align         = "right",
					  formatted     = "numberformat(PostingAmount,',.__')"}>	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Base",    					  				                
					  field         = "PostingAmountBase",					
					  search        = "number",
					  align         = "right",
					  aggregate     = "sum",
					  formatted     = "numberformat(PostingAmountBase,',.__')"}>		
					  
	
	<cf_listing
	    header          = "Advance"
	    box             = "AdvanceList_#url.id#"
		link            = "#SESSION.root#/Staffing/Application/Employee/Advance/LedgerListing.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#"	   
		datasource      = "AppsLedger"
		listquery       = "#myquery#"					
		listgroup       = "Currency"		
		listgroupdir    = "ASC"			
		listorder       = "TransactionDate"
		listorderfield  = "TransactionDate"		
		listorderdir    = "DESC"		
		headercolor     = "ffffff"
		listlayout      = "#fields#"
		filterShow      = "Hide"
		excelShow       = "Yes"
		drillmode       = "tab"	
		drillargument   = "900;1200"
		drilltemplate   = "../Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey        = "TransactionId">		
