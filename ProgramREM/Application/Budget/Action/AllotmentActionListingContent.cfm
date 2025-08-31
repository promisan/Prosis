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
<cfquery name="MissionPeriod" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_MissionPeriod P
	 WHERE   Mission   = '#URL.ID2#'		
	 AND     MandateNo = '#URL.ID3#'	 
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>	  
	 
	  SELECT *
	  FROM (
	 
		SELECT    PAA.Reference,
		          PAA.ProgramCode, 
		          LEFT(P.ProgramName,40)+'..' as ProgramName, 
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
				  PAA.ActionDate,
				  R.Description,	
				  PAA.Status,			  
				  PAA.ActionClass, 
				  PAA.OfficerUserId, 
				  PAA.OfficerLastName, 
				  PAA.OfficerFirstName, 
				  PAA.Created, 
                  PAA.ActionId, 
				  Pe.Reference as ProgramReference
		FROM      ProgramAllotmentAction PAA INNER JOIN
                  Program P ON PAA.ProgramCode = P.ProgramCode INNER JOIN
                  ProgramPeriod Pe ON PAA.ProgramCode = Pe.ProgramCode AND PAA.Period = Pe.Period INNER JOIN
				  Ref_Status R ON ClassStatus = 'Budget' AND R.Status = PAA.Status
		WHERE     PAA.ActionClass IN ('Transaction', 'Transfer', 'Amendment') 
		
		AND       PAA.EditionId = '#url.edition#'
		<!--- has transactions --->
		AND      ( PAA.ActionId IN
                          (SELECT     ActionId
                            FROM      ProgramAllotmentDetail
                            WHERE     ActionId = PAA.ActionId) OR							
							PAA.Status = '9'
				  )			
				
		AND       P.Mission  = '#URL.ID2#'		
		
		) as D
		
		WHERE 1=1
		
		<!---	removed Dev, we show all until we pass the period correctly
		AND       PAA.Period = '#MissionPeriod.Period#'
		--->
				
	</cfoutput>	
	
</cfsavecontent>


<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>		
	<cf_tl id="Document" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",								
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Period" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Period",											
						filtermode  = "2",																		
						search      = "text"}>										
	
	<cfset itm = itm+1>		
	<cf_tl id="Code" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ProgramReference",																							
						labelfilter = "Project code",
						searchfield = "Reference",																					
						search      = "text"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="Name" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ProgramName",	
						width       = "72",	
						labelfilter = "Project name",																										
						search      = "text"}>		
						
				
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ActionDate",					
						formatted   = "dateformat(ActionDate,CLIENT.DateFormatShow)",																									
						search      = "date"}>			
											
	<cfset itm = itm+1>
	<cf_tl id="Transaction" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ActionClass",																											
						search      = "text",
						filtermode  = "2"}>												
						
	<cfset itm = itm+1>
	<cf_tl id="Officer" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OfficerLastName",																									
						search      = "text",
						filtermode  = "2"}>			
						
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Amount",	
						align       = "right",	
						aggregate   = "sum",											
						formatted   = "numberformat(Amount,',__')"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="St" var = "1">											
	<cfset fields[itm] = {label       = "#lt_text#", 					
                    LabelFilter   = "Status",	
					field         = "Description",					
					filtermode    = "3",    
					colomn        = "common",
					search        = "text",					
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "Cancelled=Red,Completed=Green,Pending=white"}>																							
	
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
		link                = "#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionListingContent.cfm?edition=#url.edition#&id2=#url.id2#&id3=#url.id3#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsProgram"
		listquery           = "#myquery#"		
		listorderfield      = "Created"
		listorder           = "Created"		
		listorderdir        = "DESC"
		headercolor         = "ffffff"
		show                = "35"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Yese"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?id="
		drillkey            = "ActionId"
		drillbox            = "addaction">	
		

			
