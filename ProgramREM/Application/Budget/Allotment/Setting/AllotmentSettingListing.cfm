<!--
    Copyright © 2025 Promisan B.V.

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
<cfsavecontent variable="myquery">

	<cfoutput>	  
	 
		SELECT    PAA.ProgramCode, 
		          P.ProgramName, 
				  PAA.Period, 
				  PAA.EditionId,
				   CASE
				  WHEN PAA.ActionClass = 'Transfer' THEN				  
					(SELECT  SUM(Amount)
					FROM    ProgramAllotmentDetail
					WHERE   ActionId = PAA.ActionId AND Amount > 0) 
				  ELSE
				  	(SELECT  SUM(Amount)
					FROM    ProgramAllotmentDetail
					WHERE   ActionId = PAA.ActionId AND Amount <> 0) 
				  END AS Amount, 
				  
				  PAA.ActionClass, 
				  PAA.Reference,
				  PAA.OfficerUserId, 
				  PAA.OfficerLastName, 
				  PAA.OfficerFirstName, 
				  PAA.Created, 
                  PAA.ActionId, 
				  Pe.Reference as ProgramReference
		FROM      ProgramAllotmentAction PAA INNER JOIN
                  Program P ON PAA.ProgramCode = P.ProgramCode INNER JOIN
                  ProgramPeriod Pe ON PAA.ProgramCode = Pe.ProgramCode AND PAA.Period = Pe.Period
		WHERE     PAA.ActionClass IN ('Transaction', 'Transfer', 'Amendment') 
		
		<!--- has transactions --->
		AND       PAA.ActionId IN
                          (SELECT     ActionId
                            FROM      ProgramAllotmentDetail
                            WHERE     ActionId = PAA.ActionId)
				
		AND       P.ProgramCode = '#URL.ProgramCode#'			
		AND       Pe.Period     = '#URL.Period#'
		AND       PAA.EditionId = '#URL.EditionId#'	
				
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>					
							
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",					
						alias       = "PAA",																			
						search      = "text",
						filtermode  = "2"}>																				
	
	<cfset itm = itm+1>
	<cf_tl id="Action" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ActionClass",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>		
											
	<cfset itm = itm+1>
	<cf_tl id="Officer" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OfficerLastName",					
						alias       = "PAA",																			
						search      = "text",
						filtermode  = "2"}>							
														
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Created",					
						alias       = "PAA",		
						align       = "center",		
						formatted   = "dateformat(Created,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
						

	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Amount",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(Amount,'__,__')"}>																		
	
	<cfset itm = itm+1>			
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ActionId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- ------- embed|window|dialogajax|dialog|standard------ --->
<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header              = "budgetactionlist"
	    box                 = "mylisting"
		link                = "#SESSION.root#/ProgramREM/Application/Budget/Allotment/Setting/AllotmentSettingListing.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsProgram"
		listquery           = "#myquery#"		
		listorderfield      = "Created"
		listorder           = "Created"
		listorderalias      = "PAA"
		listorderdir        = "DESC"
		headercolor         = "ffffff"
		show                = "20"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?id="
		drillkey            = "ActionId"
		drillbox            = "addaction">	
		

			
