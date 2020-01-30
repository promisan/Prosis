
<!--- Main view of a contribution 

    Status and role will drives access
	
	Donor officer : may edit core information as long as status = 0,1 4 tabs
	1. Contribution General Details, earmarks and attachments and lifecycle
	2. Contribution targeted usage for the amounts in the first tab, ability to add/edit
	3. Contribution recorded costs ; drill down and ability to change
	4. Summary
	
--->

<cfquery name="qCheck" 
   datasource="AppsProgram" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT *
	FROM   ContributionLine
	WHERE  ContributionLineId = '#URL.DrillId#'
</cfquery>

<cfif qCheck.recordcount eq "1">
	<cfset url.drillid = qCheck.ContributionId>
</cfif>

<cfquery name="get" 
   datasource="AppsProgram" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT  *
	FROM    Contribution C, 
	        Organization.dbo.Organization O,
		    Ref_ContributionClass R		   
	WHERE   ContributionId = '#url.drillid#'
	AND     C.OrgUnitDonor = O.OrgUnit
	AND     C.ContributionClass = R.Code
</cfquery>

<cfajaximport tags="cfwindow,cfchart,cfform,cfinput-datefield">
<cf_textareascript>	

<cf_screentop scroll="no" html="no" label="Donor Pledge, Planning and Usage" jQuery="Yes" line="no" layout="webapp">
	
	<script type="text/javascript" src="Contribution.js"></script>			
	<link rel="stylesheet" type="text/css" href="Contribution.css">	
	<cf_menuscript>
	<cf_filelibraryscript>
	<cf_listingscript>
	<cf_DialogPosition>
	<cf_DialogREMProgram>
	<cf_DialogLedger>
	<cf_DialogStaffing>
	<cf_DialogOrganization>
	<cf_actionlistingscript>
	<cf_presentationscript>
	<cf_LayoutScript>
	
	<!--- template to be set somewhere in the db --->
	<script>
		function printPledge(id,template) {
			<cfoutput>
				ptoken.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?ts=#GetTickCount()#&template="+template+"&ID1="+id, "_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
			</cfoutput>
		}
	</script>
	
</head>

 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
		
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
			<cf_ViewTopMenu label="Pledge, Planning and Contribution Usage #get.OrgUnitName# #get.Reference#" menuaccess="context" background="red" systemModule="Program">
						 			  
	</cf_layoutarea>		
		
	<cf_layoutarea position="center" name="box">
	
			<cf_divscroll style="height:99%">
			
			<table width="100%" height="100%">
		
			<tr class="line"><td height="40" style="padding-left:15px;padding-right:15px">
						
				<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
								
					<cfset ht = "48">
					<cfset wd = "48">
							
					<tr>							
							
							<cf_tl id="Pledge Donor Information" var="1">
							<cfset itm = 1>
							
							<cf_menutab item       = "#itm#" 					            
							            iconsrc    = "Logos/Program/Donor_red.png" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										class      = "highlight1"
										name       = "#lt_text#"
										source     = "ContributionViewGeneral.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#&action=view">			
							
							<cfset itm = itm + 1>				
							<cf_tl id="Summary" var="1">
						    <cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Program/Summary_red.png" 
										iconwidth  = "#wd#" 
										targetitem = "1"
										iconheight = "#ht#" 								
										name       = "#lt_text#"
										source     = "../Summary/ContributionFinancials.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#">										
							
							<cfset itm = itm + 1>					
							<cf_tl id="Earmarked Requirements" var="1">
							<cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Program/Allocation_red.png" 
										iconwidth  = "#wd#" 
										targetitem = "1"
										iconheight = "#ht#" 								
										name       = "#lt_text#"
										source     = "../Requirement/RequirementListing.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#">				
							
							
							<cfif get.execution eq "0">
							
							<cfelse>
							
								<!--- INCOME GRANT NOT relevant --->
								<cfset itm = itm + 1>								
								<cf_tl id="Donor Allocation" var="1">
								<cf_menutab item       = "#itm#" 
								            iconsrc    = "Logos/Program/Allocation_red.png" 
											iconwidth  = "#wd#" 
											targetitem = "1"
											iconheight = "#ht#" 								
											name       = "#lt_text#"
											source     = "../Allocation/RequirementListing.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#">								
								
								<cfset itm = itm + 1>	
								<cf_tl id="Donor Execution" var="1">	
								<cf_menutab item       = "#itm#" 
								            iconsrc    = "Logos/Program/Costing_red.png" 
											targetitem = "1"
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 								
											name       = "#lt_text#"
											source     = "../Expenditures/ExpenditureListing.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#">
								
							</cfif>					
							
							<cfset itm = itm + 1>		
							<cf_tl id="Reporting Event" var="1">		
						    <cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Program/Reporting_red.png" 
										iconwidth  = "#wd#" 
										targetitem = "1"
										iconheight = "#ht#" 								
										name       = "#lt_text#"
										source     = "../Event/ContributionEvent.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.drillid#">
								
																							 		
						</tr>
				</table>
				
				</td>
			</tr>
											
			<tr><td>
			
			    	<cf_divscroll style="height:99%">
					
					<table width="100%" 
					      border="0"
						  height="100%"
						  cellspacing="0" 
						  cellpadding="0" 				
					      bordercolor="d4d4d4">	  	
														
							<cf_menucontainer item="1" class="regular">
								 <cfset url.contributionId = url.drillid>
								 <cfset url.action = "view">
							     <cfinclude template="ContributionViewGeneral.cfm">		
							<cf_menucontainer>		
							
					</table>
					
					</cf_divscroll>	
					  
					</td>
			</tr>			
				
		</table>
		
		</cf_divscroll>	
								
	</cf_layoutarea>		
	
	<cf_wfactive objectKeyValue4="#url.drillid#">
	
	<cfif wfexist eq "1">
	  
		<cf_layoutarea 
		    position    = "right" 
			name        = "commentbox" 
			maxsize     = "500" 		
			size        = "25%" 		
			minsize     = "360"
			initcollapsed = "true"
			collapsible = "true" 
			splitter    = "true"
			overflow    = "scroll">
						
			<cf_divscroll style="height:98%">
				<cf_commentlisting objectid="#url.id#"  ajax="No">		
			</cf_divscroll>
								
		</cf_layoutarea>	
	
	</cfif>
		
</cf_layout>	



