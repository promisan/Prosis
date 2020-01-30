
<!--- configuration file --->

			
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   role              = "'AssetHolder','AssetUser'"	   
	   anyunit           = "No"	   
	   returnvariable    = "accessright">	
	   
	<cfif accessright eq "DENIED">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
				<tr><td align="center" height="100" class="labelmedium"><cf_tl id="You have not been granted rights to this function. Option not available"></td></tr>
		</table>
		<cfabort>
	
	</cfif>   

<cfoutput>

<cfsavecontent variable="myquery">

	 SELECT    A.*, R.Description
	 FROM      AssetDisposal A INNER JOIN
	           Ref_Disposal R ON A.DisposalMethod = R.Code
	 WHERE     A.Mission = '#URL.Mission#'
	 AND       A.ActionStatus = '1' <!--- submitted --->
	 ORDER BY  A.Created DESC
</cfsavecontent>

<cfset fields=ArrayNew(1)>
					
<cfset fields[1] = {label   = "Reference",                     
					field   = "DisposalReference",
					search  = "text"}>
					
<cfset fields[2] = {label   = "Description",                    
					field   = "Description",
					search  = "text"}>					
					
<cfset fields[3] = {label   = "Value", 					
					field   = "disposalvalue",
					formatted  = "numberformat(disposalvalue,',.__')"}>	
					
<cfset fields[4] = {label   = "Memo",                    
					field   = "DisposalRemarks"}>		
					
<cfset fields[5] = {label   = "Requester",                     
					alias   = "A",
					field   = "OfficerLastName",
					search  = "text"}>			
					
<cfset fields[6] = {label   = "Date",                    
					alias   = "A",
					field   = "created",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search  = "date"}>		
							
<cf_listing
    box           = "setting"
	link          = "#SESSION.root#/Warehouse/Application/Asset/Disposal/DisposalListing.cfm?mission=#url.mission#"
    html          = "No"	
	datasource    = "AppsMaterials"
	tablewidth    = "99%"		
	listquery     = "#myquery#"
	listkey       = "DisposalId"		
	listorder     = "Created"
	listorderalias = "A"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	filterShow     = "Yes"
	excelShow      = "Yes"
	listlayout    = "#fields#"
	drillmode     = "window"
	drillargument = "780;1160;false;false"	
	drilltemplate = "Warehouse/Application/Asset/Disposal/DisposalView.cfm?disposalid="
	drillkey      = "DisposalId">
	
	
</cfoutput>	

