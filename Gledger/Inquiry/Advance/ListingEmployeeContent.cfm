
<cfoutput>

	<cfsavecontent variable="myquery">	
		SELECT     PersonNo, 
		           IndexNo, 
				   LastName, 
				   FirstName, 
				   GLAccount, 
				   Gender, 
				   Nationality, 
				   Currency, 
				   Debit, 
	               Credit, 
				   Balance
		FROM       #SESSION.acc#_Advance		
	</cfsavecontent>	
	
</cfoutput>				  
				
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "IndexNo", 
                    width   = "8%", 
					field   = "IndexNo",
					functionscript   = "EditPerson",
					functionfield = "personno",
					search  = "text"}>
					
<cfset fields[2] = {label   = "Last name", 
                    width   = "29%", 
					field   = "LastName",
					filtermode = "1",
					search  = "text"}>					
					
<cfset fields[3] = {label   = "First name", 
                    width   = "10%", 
					field   = "FirstName",
					filtermode = "1",
					search  = "text"}>
						
<cfset fields[4] = {label   = "S", 
					width   = "4%", 
					field   = "Gender",					
					filtermode = "2",    
					search  = "text"}>		
					
<cfset fields[5] = {label      = "Nat.",    
					width      = "6%", 
					field      = "Nationality",
					filtermode = "2",					
					search     = "text"}>		
					
<cfset fields[6] = {label      = "Account",    
					width      = "8%", 
					field      = "GLAccount",									
					search     = "text",
					filtermode = "2"}>						
						
<cfset fields[7] = {label      = "Debit",    
					width      = "13%", 
					field      = "Debit",
					align      = "right",
					formatted  = "numberformat(Debit,'__,__.__')"}>
					
<cfset fields[8] = {label      = "Credit",    
					width      = "13%", 
					field      = "Credit",		
					align      = "right",			
					formatted  = "numberformat(Credit,'__,__.__')"}>					
					
<cfset fields[9] = {label      = "Balance",    
					width      = "14%", 
					field      = "Balance",
					align      = "right",
					search     = "number",
					formatted  = "numberformat(Balance,'__,__.__')"}>											
			
<cfset fields[10] = {label      = "PersonNo",    
					width      = "1%", 
					Display    = "No",
					field      = "PersonNo"}>				
										
							
<cf_listing
    header        = "Finance"
    box           = "transaction"
	link          = "#SESSION.root#/GLedger/Inquiry/Advance/ListingEmployeeContent.cfm?mission=#url.mission#&currency=#url.currency#&area=#url.area#"
    html          = "No"
	show          = "40"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listorder     = "LastName"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "940;1000;false;false"	
	drilltemplate = "Gledger/Application/lookup/AccountResult.cfm?mission=#url.mission#&currency=#url.currency#&account="
	drillkey      = "GLAccount">
	