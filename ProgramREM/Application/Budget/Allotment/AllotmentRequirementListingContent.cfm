<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- listing of requirements --->

<cfoutput>
<cfsavecontent variable="myquery">
	SELECT 	*
	FROM
		(
			SELECT    	E.Description AS EditionName, 
						R.RequestDescription, 
						I.Description AS ItemMaster, 
						R.RequestDue, 
						R.RequestRemarks, 
						R.ObjectCode, 
						R.Fund,
						CON.Donor,
						CON.ContributionLineReference,
						CON.ContributionReference,
			            O.Description AS ObjectDescription, 
						R.ActionStatus, 						
						R.RequirementId,
						R.RequestQuantity, 
						R.RequestPrice,
						R.RequestAmountBase,						
						R.BudgetCategory, 
						R.OfficerUserId, 
						R.OfficerLastName, 
						R.OfficerFirstName 
			           
			FROM        ProgramAllotmentRequest R 
						INNER JOIN Ref_AllotmentEdition E 
							ON R.EditionId = E.EditionId 
						INNER JOIN Purchase.dbo.ItemMaster I 
							ON R.ItemMaster = I.Code 
						INNER JOIN Ref_Object O 
							ON R.ObjectCode = O.Code	
							
						LEFT OUTER JOIN (
						 SELECT     PARC.RequirementId,
						            O.OrgUnitName AS Donor, 
						 			PARC.ContributionLineId,	
						            CL.Reference AS ContributionLineReference, 
									C.Reference AS ContributionReference
						 FROM       ProgramAllotmentRequestContribution PARC INNER JOIN
				                    ContributionLine CL ON PARC.ContributionLineId = CL.ContributionLineId INNER JOIN
                				    Contribution C ON CL.ContributionId = C.ContributionId INNER JOIN
				                    Organization.dbo.Organization O ON C.OrgUnitDonor = O.OrgUnit	
						) as CON ON Con.RequirementId = R.RequirementId 						  
														
									
			WHERE     R.ProgramCode = '#url.programcode#' 
			AND 	  R.Period = '#url.period#'
			AND       ActionStatus IN ('0','1')
		) AS Data
		WHERE 	1=1
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Edition" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "EditionName",
						  filtermode  = "3",
						  search    = "Text",						  
						  align     = "left"}>	
	
								  
	<cfset itm = itm+1>
	<cf_tl id="Object" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "ObjectDescription",
						  filtermode  = "3",
						  align     = "left",							
						  search  = "text"}>	
						  
	<cfset itm = itm+1>	
	<cf_tl id="Request Due" var = "1">
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "RequestDue",	
						  align     = "left",						
					      formatted  = "DateFormat(RequestDue,CLIENT.DateFormatShow)",
						  search  = "date"}>						  
						  
	<cfset itm = itm+1>
	<cf_tl id="Fund" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "Fund",
						  filtermode  = "3",
						  align     = "left",							
						  search  = "text"}>						  
						  
	<cfset itm = itm+1>
	<cf_tl id="Donor" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "Donor",
						  filtermode = "3",
						  align     = "left",							
						  search  = "text"}>						  
						  
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "ContributionReference",
						  align     = "left",							
						  search  = "text"}>									  
						 
	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                   		
						  field     = "RequestQuantity",	
						  align     = "right",				
						  formatted = "numberformat(RequestQuantity,'__,__')"}>	
						  
	
	<cfset itm = itm+1>
	<cf_tl id="Price" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "RequestPrice",	
						  align     = "right",	
						  formatted = "numberformat(RequestPrice,',.__')"}>	
						  
	
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                   		
						  field     = "RequestAmountBase",	
						  align     = "right",					
						  formatted = "numberformat(RequestAmountBase,'__,__')",
						  search    = "number"}>
						  
	<cfset itm = itm+1>
	<cf_tl id="Status" var = "1">				
	<cfset fields[itm] = {label       = "#lt_text#",      
					     LabelFilter = "Status", 
					     field       = "ActionStatus",     
					     filtermode  = "2",    
					     search      = "text",
					     align       = "center",
					     formatted   = "Rating",
					     ratinglist  = "9=Red,0=yellow,1=Green"}>
						 
	<cfset itm = itm+1>
	<cf_tl id="Request Description" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",  
	                      rowlevel      = "2",
						  Colspan       = "10",	               		
						  field   = "RequestDescription",		
						  align     = "left",					
						  search  = "text"}>					 
						
			  
<cf_listing
	    header         = "ProgramAllotmentList"
	    box            = "linedetail"
		link           = "#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentRequirementListingContent.cfm?programcode=#url.programcode#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"		
		tableheight    = "100%"
		tablewidth     = "100%"
		datasource     = "AppsProgram"
		listquery      = "#myquery#"		
		listorderfield = "RequestDescription"		
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		show           = "35"		
		filtershow     = "Hide"
		excelshow      = "Yes" 		
		listlayout     = "#fields#"
		allowgrouping  = "No">	
	