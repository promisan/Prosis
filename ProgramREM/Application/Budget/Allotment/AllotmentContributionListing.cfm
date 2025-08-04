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

<cfoutput>
<cfsavecontent variable="myquery"> 

	SELECT *
	FROM (
		
		SELECT     R.Code + ' '+ R.Description AS Resource, 
		           PAD.Fund, 
				   PAD.ObjectCode, 
				   O.Description as ObjectName, 
				   M.Description as Earmark,
				   CL.DateReceived, 
				   SUM(PADC.Amount) AS Amount, 
				   <!--- also get to the total executed --->
				   CL.ContributionLineId,
				   CL.ContributionId,
				   C.Reference as Reference,
				   
				   (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = C.OrgUnitDonor) as Donor			   
			
		FROM       Ref_Resource AS R INNER JOIN
		           Ref_Object AS O ON R.Code = O.Resource INNER JOIN
		           ProgramAllotmentDetail AS PAD INNER JOIN
		           ProgramAllotmentDetailContribution AS PADC ON PAD.TransactionId = PADC.TransactionId INNER JOIN
		           ContributionLine AS CL ON PADC.ContributionLineId = CL.ContributionLineId INNER JOIN
		           Contribution AS C ON CL.ContributionId = C.ContributionId ON O.Code = PAD.ObjectCode INNER JOIN
				   Ref_Earmark AS M ON C.Earmark = M.Earmark
		
		WHERE      PAD.ProgramCode = '#url.programcode#' 
		AND        PAD.Period = '#url.period#' 	
		AND        PAD.Status IN ('0','1')			
		AND        O.Status = '1'
		
		GROUP BY   PAD.Fund, 
		           PAD.ObjectCode, 
				   O.Description, 		
				   M.Description,	   
				   CL.DateReceived, 
				   R.Code,
				   R.Description, 
				   CL.ContributionLineId,
				   CL.ContributionId,
				   C.OrgUnitDonor,
				   C.Reference
			   
			   ) as tab	
		
</cfsavecontent> 
</cfoutput>


<cfset fields=ArrayNew(1)>

<cfset itm = "0">


<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Resource",                     				
					field       = "Resource",							
					filtermode  = "2",  										
					search      = "text"}>		

<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Fund",                     				
					field       = "Fund",							
					filtermode  = "2",  										
					search      = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Object",                   
					field       = "ObjectCode",	
					filtermode  = "2",  										
					search      = "text"}>					

<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Name",                   
					field       = "ObjectName",															
					search      = "text"}>		
					
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Donor",                   
					field       = "Donor",	
					filtermode  = "2",  										
					search      = "text"}>		
					
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Earmark",                   
					field       = "Earmark",	
					filtermode  = "2",  										
					search      = "text"}>							
					
				
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Reference",                   
					field       = "Reference",	
					filtermode  = "0",  										
					search      = "text"}>															
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Received",                  			
					field      = "DateReceived",		
					formatted  = "dateformat(DateReceived,CLIENT.DateFormatShow)",			 
					search     = "date"}>										
			
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Amount",    					
					field      = "Amount",
					align      = "right",
					aggregate  = "sum",					
					formatted  = "numberformat(Amount,',__')"}>			
				
	
<table width="99%" height="100%" align="center"><tr><td style="padding-bottom:7px">

<!--- systemfunctionid=#url.systemfunctionid# --->									
<cf_listing
    header        = "lsLedger"
    box           = "lsLedger"
	link          = "AllotmentContributionListing.cfm?programcode=#url.programcode#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"	
    html          = "No"
	show          = "30"
	datasource    = "AppsProgram"
	listquery     = "#myquery#"		
	listorder     = "ObjectCode"	
	listorderdir  = "DESC"
	listgroup     = "Resource"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"	
	drillmode     = "window"	
	drillargument = "930;1000;false;false"
	drilltemplate = "ProgramREM/Application/Program/Donor/Contribution/ContributionView.cfm?drillid="
	drillkey      = "ContributionId">

</td></tr></table>


