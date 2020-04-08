<!--- control list data content 

<cf_wfpending entityCode="PersonEvent"  
      table="#SESSION.acc#wfEvent" mailfields="No" IncludeCompleted="No">	
	  
--->

<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfsavecontent variable="myquery">

<cfoutput>

SELECT       M.CostId, P.PersonNo, P.IndexNo, P.LastName, P.FullName, M.Mission, M.DateEffective, 
             M.DocumentDate, M.DocumentReference, M.PayrollItem, Ref_PayrollItem.PayrollItemName, 
             M.EntitlementClass, M.Currency, M.Amount, 
			 M.Status as ActionStatus, 
			 M.Source, 
			 M.OfficerLastName, M.OfficerFirstName, M.Created
FROM         PersonMiscellaneous AS M INNER JOIN
             Employee.dbo.Person AS P ON M.PersonNo = P.PersonNo INNER JOIN
             Ref_PayrollItem ON M.PayrollItem = Ref_PayrollItem.PayrollItem
WHERE        M.Mission = '#url.mission#'

--condition

</cfoutput>
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
							
	<cfset itm = itm+1>
	<cf_tl id="IndexNo" var = "1">			
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "IndexNo",					
						alias             = "",		
						filtermode        = "3",						
						width             = "20",																	
						search            = "text"}>		
				
	<cfset itm = itm+1>
	<cf_tl id="Name" var = "1">		
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "FullName",																							
						functionscript    = "EditPerson",
						functionfield     = "PersonNo",		
						functioncondition = "Miscellaneous",	
						filtermode        = "3",					
						width             = "40",																		
						search            = "text"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Document" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DocumentReference",								
						display       = "1",	
						width         = "13",																																									
						displayfilter = "yes",																																									
						search        = "text"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Date" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DocumentDate",								
						display       = "1",	
						width         = "13",																																									
						displayfilter = "yes",																																									
						search        = "date",		
						formatted     = "dateformat(DocumentDate,client.dateformatshow)"}>												
						
	<cfset itm = itm+1>
	<cf_tl id="Effective" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "DateEffective",																																												
						search      = "date",
						display       = "1",	
						width         = "20",
						displayfilter = "Yes",		
						formatted   = "dateformat(DateEffective,client.dateformatshow)"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Item" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "PayrollItemName",								
						display       = "1",																																										
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>																						
						
	<cfset itm = itm+1>	
	<cf_tl id="Source" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Source",								
						display       = "1",																																									
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Cur" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Currency",								
						display       = "1",																																										
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Amount" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Amount",								
						display       = "1",																																										
						displayfilter = "yes",	
						align         = "right",																																								
						search        = "amount",
						filtermode    = "3",
						formatted     = "numberformat(amount,',.__')"}>																							
	
		

	<cfset itm = itm+1>		
	<cf_tl id="Status" var = "1">		
	<cfset fields[itm] = {label       = "S",      
						LabelFilter = "#lt_text#", 
						field       = "ActionStatus",  
						width       = "4",    											
						formatted   = "Rating",
						ratinglist  = "9=Red,0=white,1=Yellow,3=Green,5=black"}>																								
																
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "cost"
	    box                 = "costlisting"
		link                = "#SESSION.root#/Staffing/Reporting/ActionLog/EmployeeCostListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		calendar            = "9" 
		font                = "Calibri"
		datasource          = "AppsPayroll"
		listquery           = "#myquery#"		
		listorderfield      = "LastName"
		listorder           = "LastName"
		listorderdir        = "ASC"		
		headercolor         = "ffffff"		
		menu                = "#menu#"
		showrows            = "1"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "workflow"
		drillkey            = "costid"
		drillbox            = "costbox">
		
		
		