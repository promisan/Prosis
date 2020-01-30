
<cfparam name="URL.Mission"    default="">

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput> 

<!--- body --->


	<cfsavecontent variable="sqlbody">
	
	    SELECT * 
		FROM (
	
		SELECT       M.Mission, 
		             P.IndexNo, P.LastName, P.FirstName, P.Gender, M.PersonNo, 
					 P.LastName+','+P.FirstName as Name,	
					 M.CostId, M.DateEffective, M.DateExpiration, 
					 M.DocumentDate, M.DocumentReference, 
					 M.PayrollItem, R.PayrollItemName, 
					 M.EntitlementClass, M.Quantity, 
					 M.Currency, M.Rate, M.Amount, 
					 M.Status, M.Remarks, 
					 M.Source, M.SourceId, 
					 M.OfficerUserId, M.OfficerLastName, M.OfficerFirstName, M.Created
						 
        FROM         PersonMiscellaneous AS M INNER JOIN
                     Ref_PayrollItem AS R ON M.PayrollItem = R.PayrollItem INNER JOIN
                     Employee.dbo.Person AS P ON M.PersonNo = P.PersonNo	
		
		) as B
		
		WHERE        Mission = '#url.mission#'	
	   
	</cfsavecontent>
	
</cfoutput>	

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<!--- pass the view --->

<cfoutput> 

	<cfsavecontent variable="myquery">  
		#preserveSingleQuotes(sqlbody)#					
	</cfsavecontent>	
		  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->


<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "IndexNo",                  
					field         = "IndexNo",					
					search        = "text"}>	
					

					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Name",                  
					field         = "Name",
					filtermode    = "0",
					search        = "text"}>			
			
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "S", 					
                    labelfilter   = "Gender",
					field         = "Gender",					
					filtermode    = "3",    
					align         = "center",
					search        = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Class",  					
					field         = "EntitlementClass",
					filtermode    = "2",					
					search        = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Item",  					
                    labelfilter   = "Item",
					field         = "PayrollItemName",	
					filtermode    = "2",								
					search        = "text"}>		
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Source",  					
                    labelfilter   = "Source",
					field         = "Source",	
					filtermode    = "2",								
					search        = "text"}>		
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "Status",					
					filtermode    = "2",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=White,1=Yellow,3=green,5=purple,9=red"}>								
																			
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Date",  					
					field         = "DateEffective",
					align         = "center",					
					search        = "date",
					formatted     = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>						
		
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Curr",  
                    labelfilter   = "Currency", 					
					field         = "Currency",
					filtermode    = "2",					
					search        = "text"}>
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Amount",                  
					field         = "Amount",
					formatted     = "numberformat(Amount,',.__')",
					align         = "right",
					search        = "amount"}>								
					

<!---
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label    = "Expiration",  					
					field      = "DateEffective",
					align      = "center",					
					search        = "date",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
	
--->
						

<table width="100%" height="100%"><tr><td style="padding:8px;width:100%;height:100%">	
	
	<cf_listing
		    header         = "PAS"
		    box            = "PAS"
			link           = "#SESSION.root#/Payroll/Application/Entitlements/MiscellaneousViewListing.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
		    html           = "No"
			show           = "40"
			datasource     = "appsPayroll"
			listquery      = "#myquery#"			
			listorder      = "Name"
			listorderdir   = "ASC"
			headercolor    = "ffffff"
			listlayout     = "#fields#"
			filterShow     = "Yes"
			excelShow      = "Yes"
			drillmode      = "tab"
			drillargument  = "940;1190;false;false"	
			drilltemplate  = "Staffing/Application/Employee/PersonView.cfm?id="
			drillkey       = "PersonNo">
	
</td></tr></table>		
