
<cfparam name="URL.Mission"    default="">

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_ParameterMission 
	   WHERE  Mission = '#url.mission#'
</cfquery>

<cfinvoke component = "Service.Process.Payroll.PayrollItem"  
   method           = "PayrollItem"   
   mission          = "#url.mission#"
   returnvariable   = "accessItem">	   

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
							 
				WHERE      1=1 
				<cfif accessItem neq "">
				AND   R.PayrollItem IN (#preservesingleQuotes(accessItem)#)			 
				</cfif>
				<cfif url.id1 neq "">
				AND M.EntitlementClass = '#url.id1#'
				</cfif>
				
				) as B
		
		WHERE        Mission = '#url.mission#'	
		
		--condition
	   
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

<cfif url.id1 eq "">					
	 
	<cfset itm = itm+1>							
	<cfset fields[itm] = {label       = "Class",  					
						field         = "EntitlementClass",
						filtermode    = "2",					
						search        = "text"}>	
					
</cfif>					
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Item",  					
                    labelfilter   = "Item",
					field         = "PayrollItemName",	
					filtermode    = "3",								
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
					
				
<cfset itm = itm+1>							
<cfset fields[itm] = {label    = "Remarks",  					
					field      = "Remarks",
					rowLevel   = "2",
					colspan    = "10",
					align      = "center"}>		

<cf_listing
	    header         = "PAS"
	    box            = "PAS"
		link           = "#SESSION.root#/Payroll/Application/Entitlements/MiscellaneousViewListing.cfm?id1=#url.id1#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"
		show           = "300"
		datasource     = "appsPayroll"
		listquery      = "#myquery#"			
		listorder      = "Name"
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Yes"
		excelShow      = "Yes"
		drillmode      = "tab"
		rowshow        = "2"
		drillargument  = "940;1190;false;false"	
		drilltemplate  = "Staffing/Application/Employee/PersonView.cfm?Template=miscellaneous&id="
		drillkey       = "PersonNo">
	
