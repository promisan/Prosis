
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
		
		<!---	removed hanno, we show all until we pass the period correctly 
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
						alias       = "PAA",		
						searchfield = "Reference",
						searchalias = "PAA",																	
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Period" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Period",					
						alias       = "Pe",	
						searchalias = "Pe",
						filtermode  = "2",																		
						search      = "text"}>										
	
	<cfset itm = itm+1>		
	<cf_tl id="Code" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ProgramReference",																	
						alias       = "Pe",		
						labelfilter = "Project code",
						searchfield = "Reference",
						searchalias = "Pe",																	
						search      = "text"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="Name" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ProgramName",	
						width       = "72",	
						labelfilter = "Project name",			
						alias       = "P",																			
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
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>												
						
	<cfset itm = itm+1>
	<cf_tl id="Officer" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OfficerLastName",					
						alias       = "PAA",		
						searchalias	= "PAA",																
						search      = "text",
						filtermode  = "2"}>			
						
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Amount",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(Amount,'__,__')"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="St" var = "1">											
	<cfset fields[itm] = {label       = "#lt_text#", 					
                    LabelFilter   = "Status",	
					field         = "Description",					
					filtermode    = "3",    
					search        = "text",
					searchalias   = "R",
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
		font                = "Verdana"
		datasource          = "AppsProgram"
		listquery           = "#myquery#"		
		listorderfield      = "Created"
		listorder           = "Created"
		listorderalias      = "PAA"
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
		

			
