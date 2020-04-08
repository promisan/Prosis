
<!--- listing --->

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">

<cfoutput> 

	<cfsavecontent variable="myquery">  
		SELECT   *
		FROM  	tmp#SESSION.acc#Program
		WHERE   ShowUnit is not NULL	 			
	</cfsavecontent>	
		  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Code",                     				
					field      = "ProgramCode",												
					search     = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Reference",                   
					field      = "Reference",					
					search     = "text"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Class",                  			
					field      = "ProgramClass",
					filtermode = "2",  
					search     = "text"}>								

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Name", 
                    width      = "50", 					
					field      = "ProgramName",
					search     = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Scope",                  			
					field      = "ProgramScope",
					filtermode = "2",  
					search     = "text"}>							

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Unit", 
                    width      = "40", 					
					field      = "OrgUnitName",
					filtermode = "2",  
					search     = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Officer",                    			
					field      = "OfficerLastName",
					filtermode = "2",  
					search     = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Recorded",                    			
					field      = "Created",					 
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>																	
					
	
<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td style="padding-bottom:10px">
									
<cf_listing
    header        = "lsPurchase"
    box           = "lsPurchase"
	link          = "#SESSION.root#/ProgramREM/Application/Program/ProgramView/ProgramViewListing.cfm?period=#url.period#"	
    html          = "No"
	show          = "40"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "ProgramCode"	
	listorder     = "Reference"	
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "tab"	
	drillargument = "950;1200;false;false"
	drilltemplate = "ProgramREM/Application/Program/ProgramView.cfm?period=#url.period#&programcode="
	drillkey      = "ProgramCode">

</td></tr>
</table>
