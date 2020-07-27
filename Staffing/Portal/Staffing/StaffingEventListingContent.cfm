<!--- control list data content --->

<cf_screentop html="No" jquery="Yes">

<cf_dialogposition>
<cf_listingscript>

<cfparam name="url.unit" default="">
<cfparam name="url.selection" default="">

<cf_wfpending entityCode="PersonEvent"  
      table="#SESSION.acc#wfEvent" mailfields="No" IncludeCompleted="No">			  
	
<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfquery name="getMission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Mission
	FROM     Ref_Mission
	WHERE    MissionParent =
                          (SELECT    MissionParent
                            FROM     Ref_Mission
                            WHERE    Mission = '#url.mission#')  
</cfquery>

<cfif getMission.recordcount eq "0">
	<cfset mis = "'#url.mission#'">
<cfelse>
    <cfset mis = "#quotedvalueList(getMission.Mission)#">
</cfif>	

<cfif url.unit neq "">

<!--- we take only people that are currently in those units --->
	
	<cfoutput>
		<cfsavecontent variable="mypeople">
		SELECT    PA.PersonNo
		FROM      PersonAssignment AS PA INNER JOIN
		          Position AS P ON PA.PositionNo = P.PositionNo
		WHERE     P.Mission = '#url.mission#' 
		AND       P.OrgUnitOperational IN (#url.unit#)
		AND       PA.DateEffective  < '#url.selection#' 
		AND       PA.DateExpiration > '#url.selection#'
		AND       PA.AssignmentStatus IN ('0','1')
		</cfsavecontent>
	</cfoutput>

</cfif>	

<!---

<cfquery name="qItems" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">				   
	SELECT   DocumentId,
	         DocumentCode,
			 DocumentDescription,
			 FieldType,
			 PortalShow
	FROM     Organization.dbo.Ref_EntityDocument
	WHERE    EntityCode='PersonEvent'
	AND      DocumentType='field'	
	AND      Operational = 1			   
</cfquery>

--->

<cfsavecontent variable="myquery">

	<cfoutput>	  	
	
	    SELECT *
		FROM (
	
		SELECT I.*, 
		       V.ActionDescriptionDue,
			   V.ActionMemo,
			   (CASE WHEN ReasonDescription is NOT NULL THEN EventDescription+' : '+ReasonDescription ELSE EventDescription END) as EventName
		FROM (
	
		    SELECT    Pe.Mission as Organization,
					  Pe.PositionNo,
									   
			          Pe.EventId, 
					  Pe.OfficerFirstName,
					  Pe.OfficerLastName,
					  Pe.OfficerUserId,
					  
			          P.IndexNo, 
					  P.PersonNo,
					  P.LastName, 
					  P.FirstName, 
					  P.LastName+','+P.FirstName as Name,
					  P.Gender, 	
					  				  			  
					  (SELECT   TOP 1 CP.Description
					   FROM     PersonContract G, Ref_PostGrade CG, Ref_PostGradeParent CP
					   WHERE    G.PersonNo = P.PersonNo
					   AND      G.ContractLevel = CG.PostGrade
					   AND      CG.PostGradeParent = CP.Code
					   AND      ActionStatus = '1'
					   ORDER BY G.Created DESC
					   
					   ) as ContractLevel,		
					   				   
					   <!--- disabled as this was based on the current assignment at the time
					   of the event	and now used based on the OrgUnit or Position --->
					   
					   CASE WHEN OrgUnit = 0 THEN (
					   
					   		  (  SELECT   SourcePostNumber
						       	 FROM     Position mPos
						         WHERE    mPos.PositionNo = Pe.PositionNo			       				      			   					   
							  )  
					   					   				   
				   			) ELSE (
					   
						   	   SELECT   O.OrgUnitNameShort
							   FROM     Organization.dbo.Organization AS O 		   
							   WHERE    O.OrgUnit = Pe.OrgUnit					  					
						   
						    )
					   
					   END as fPosition,		   
					  				   
					     (  
						   SELECT   TOP 1 OP.Mission + '/' + OP.OrgUnitNameShort
						   FROM     Organization.dbo.Organization AS O 
						   		    INNER JOIN Organization.dbo.Organization AS OP ON O.Mission = OP.Mission 
									    AND O.MandateNo = OP.MandateNo 
									    AND O.HierarchyRootUnit = OP.OrgUnitCode 
									INNER JOIN PersonAssignment Pa ON O.OrgUnit = Pa.OrgUnit					   
						   WHERE    Pa.PersonNo = P.PersonNo					  
						   AND      Pa.AssignmentStatus IN ('0','1')
						   AND      Pa.DateEffective <= Pe.DateEvent					   
						   AND      OP.Mission = Pe.Mission
						   ORDER BY Pa.DateExpiration DESC
						   
					   ) as OrgUnitParent, 				   
					   
					   <!--- actors on the fly --->
					   
					   (   SELECT   TOP 1 U.LastName
						   FROM     Organization.dbo.OrganizationObjectActionAccess OOAA INNER JOIN
						            Organization.dbo.OrganizationObjectAction OOA ON OOAA.ObjectId = OOA.ObjectId INNER JOIN
						            System.dbo.UserNames U ON OOAA.UserAccount = U.Account INNER JOIN
						            Organization.dbo.OrganizationObject OO ON OOAA.ObjectId = OO.ObjectId
						   WHERE    OO.ObjectKeyValue4 = Pe.EventId 
						   AND      OOAA.AccessLevel   = 1
						   ORDER BY OOAA.Created DESC) as Actor,						  
					  
					  Pe.EventTrigger,
					  T.Description as TriggerDescription,
					  
					  Pe.EventCode,
					  R.Description as EventDescription, 			   
					  
					  Pe.ReasonCode, 
					  Pe.ReasonListCode,
					  
					  (
						   SELECT GroupListCode+' '+Description 
						   FROM   Ref_PersonGroupList
						   WHERE  GroupCode = Pe.ReasonCode
						   AND    GroupListCode = Pe.ReasonListCode
					   ) as ReasonDescription,
					   
					   
					  (CASE WHEN DocumentNo != '0' THEN Pe.DocumentNo ELSE '' END) as DocumentNo,
					  (CASE WHEN T.EntityCode = 'PersonContract' THEN Pe.ContractNo ELSE '' END) as ContractNo,
					  
					  Pe.DateEvent, 
					  Pe.DateEventDue, 
					  Pe.ActionDateEffective, 
					  Pe.ActionDateExpiration, 
					  Pe.Remarks,
					 			  
					  Pe.ActionStatus,
					  P.Nationality,
					  
					  CASE    WHEN Pe.ActionStatus = 0 THEN 'Pending' 
							  WHEN Pe.ActionStatus = 1 THEN 'In Process' 
						      WHEN Pe.ActionStatus = 3 THEN 'Completed'
							  WHEN Pe.ActionStatus = 9 THEN 'Cancelled'
					  END  as ActionStatusDescription				  
					  
			FROM      PersonEvent Pe INNER JOIN
	                  Person P ON Pe.PersonNo = P.PersonNo INNER JOIN
	                  Ref_PersonEvent R ON Pe.EventCode = R.Code INNER JOIN
	                  Ref_EventTrigger T ON Pe.EventTrigger = T.Code
					  <!--- INNER JOIN System.dbo.Ref_Nation N ON P.Nationality = N.Code --->
	        WHERE     Pe.Mission IN (#preservesingleQuotes(mis)#)
			AND       R.EnablePortal = 1
			AND       DateEvent >= getDate()-365
			
			<cfif url.unit neq "">
			AND       Pe.PersonNo IN (#preserveSingleQuotes(myPeople)#) 
			
			</cfif>
			
			AND       Pe.ActionStatus != '9'
				
		     ) as I 
					
		LEFT OUTER JOIN userquery.dbo.#SESSION.acc#wfEvent V ON ObjectkeyValue4 = I.EventId
		
		) as XX
					
		WHERE 1=1 
			
		--Condition
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
							
	<cfset itm = itm+1>
	<cf_tl id="IndexNo" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "IndexNo",					
						alias         = "",							
						width         = "20",																	
						search        = "text"}>		
				
	<cfset itm = itm+1>
	<cf_tl id="Name" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Name",																							
						functionscript = "EditPerson",
						functionfield = "PersonNo",		
						functioncondition = "PersonEvent",						
						width         = "40",																		
						search        = "text"}>													
	
	<cfset itm = itm+1>	
	<cf_tl id="Entity" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Organization",								
						display       = "0",																																					
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>			
	
	<cfif url.unit eq "">
	
	<cfset itm = itm+1>	
	<cf_tl id="Assigned to" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "OrgUnitParent",	
						width         = "30",		
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "3"}>	
	</cfif>								
													
				
						
	<cfset itm = itm+1>
	<cf_tl id="Created" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "DateEvent",																																												
						search      = "date",
						display       = "0",	
						displayfilter = "No",		
						formatted   = "dateformat(DateEvent,client.dateformatshow)"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Due" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "DateEventDue",																																												
						search      = "date",
						display       = "0",	
						displayfilter = "No",		
						formatted   = "dateformat(DateEventDue,client.dateformatshow)"}>			
												
							
	<cfset itm = itm+1>	
	<cf_tl id="Category" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "TriggerDescription",																	
						display       = "1",																																					
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Event" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "EventDescription",								
						display       = "0",	
						rowlevel      = "1",
						Colspan       = "1",																																				
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "3"}>	
						
					
	<cfset itm = itm+1>	
	<cf_tl id="JO" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DocumentNo",								
						display       = "1",	
						width         = "13",																																									
						displayfilter = "yes",																																									
						search        = "text"}>							
						
	<cfset itm = itm+1>	
	<cf_tl id="Level" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ContractLevel",																																												
						search        = "text",
						display       = "0",
						displayfilter = "Yes",
						filtermode    = "3"}>							
								
	<cfset itm = itm+1>
	<cf_tl id="Reason" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "ReasonDescription",		
						display       = "0",	
						width         = "30",	
						rowlevel      = "1",
						Colspan       = "1",			
						displayfilter = "yes",																																															
						search        = "text",
						filtermode    = "2"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Event" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "EventName",								
						display       = "1",	
						rowlevel      = "1",
						Colspan       = "1",																																				
						displayfilter = "no",																																									
						search        = "text"}>												
						
	<cfset itm = itm+1>
	<cf_tl id="Effective" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "ActionDateEffective",																																												
						search      = "date",
						display       = "1",	
						width         = "20",
						displayfilter = "Yes",		
						formatted   = "dateformat(ActionDateEffective,client.dateformatshow)"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Expiry" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "ActionDateExpiration",																																												
						search      = "date",
						display       = "1",	
						width         = "20",
						displayfilter = "Yes",		
						formatted   = "dateformat(ActionDateExpiration,client.dateformatshow)"}>	
													
			
	<cfset itm = itm+1>	
	<cf_tl id="Submitter" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "OfficerLastName",	
						width         = "35",		
						display       = "0",																																						
						search        = "text",
						filtermode    = "2"}>	
						
	<cfset itm = itm+1>		
	<cf_tl id="Status" var = "1">		
	<cfset fields[itm] = {label       = "Status",      
						LabelFilter   = "#lt_text#", 
						field         = "ActionStatusDescription",  	
						search        = "text",		
						display       = "0",	
						displayfilter = "Yes",					   												
						filtermode    = "3"}>											

	<cfset itm = itm+1>		
	<cf_tl id="Status" var = "1">		
	<cfset fields[itm] = {label       = "S",      
						LabelFilter   = "#lt_text#", 
						field         = "ActionStatus",  
						width         = "4",    											
						formatted     = "Rating",
						ratinglist    = "9=Red,0=white,1=Yellow,3=Green"}>															
	
	
	<!--- ----- --->					
	<!--- row 2 --->
	<!--- ----- 
	
	<cfset itm = itm+1>	
	<cf_tl id="Remarks" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "Remarks",	
						display       = "1",								
						rowlevel      = "2",
						Colspan       = "5",																																													
						search        = "text"}>				
						
	<cfset itm = itm+1>	
	<cf_tl id="PAS" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "ContractNo",	
						display       = "1",								
						rowlevel      = "2",
						Colspan       = "1",
						width         = "35",																																							
						search        = "text",
						filtermode    = "2"}>								
											
						
	<cfset itm = itm+1>	
	<cf_tl id="Actor" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "Actor",	
						display       = "1",								
						rowlevel      = "2",
						Colspan       = "1",
						width         = "35",																																							
						search        = "text",
						filtermode    = "2"}>	
						
	--->												
			
	<!---
						
	<cfloop query="qItems">
	
	    <cfif PortalShow eq "1">
		
		<cfset itm = itm+1>		
		
		<cfif qItems.FieldType eq "date">
		
		<!---
		
			<cfset fields[itm] = {label     = "#qItems.DocumentDescription#",      
								LabelFilter = "#qItems.DocumentDescription#", 
								field       = "#qItems.DocumentCode#",  						   											
								search      = "date",
								width       = "20",
								formatted   = "dateformat(#qItems.DocumentCode#,client.dateformatshow)"}>		
								
								--->
								
		<cfelse>
		
			<cfset fields[itm] = {label     = "#qItems.DocumentDescription#",      
								LabelFilter = "#qItems.DocumentDescription#", 
								field       = "#qItems.DocumentCode#",  						   											
								search      = "text",
								rowlevel      = "2",
								Colspan       = "1",		
								width       = "30",
								filtermode  = "2"}>				
		</cfif>
		
		</cfif>
		
	</cfloop>	
	
	--->							
	
	<!---
								
	<cfset itm = itm+1>		
	<cf_tl id="Stage" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",      
						LabelFilter = "#lt_text#", 
						field       = "ActionDescriptionDue",  						   											
						search      = "text",
						display       = "1",	
						rowlevel      = "2",
						colspan       = "3",
						displayfilter = "Yes",										
						search      = "text",
						filtermode  = "2"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Memo" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "ActionMemo",	
						display       = "1",
						displayfilter = "No",									
						rowlevel      = "3",
						Colspan       = "10",
						width         = "35",																																							
						search        = "text"}>	
						
	--->														
																
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "myeventbox"
	    box                 = "myeventlisting_#url.unit#"
		link                = "#SESSION.root#/Staffing/Portal/Staffing/StaffingEventListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&unit=#url.unit#&selection=#url.selection#"
	    html                = "No"		
		tableheight         = "260px"
		tablewidth          = "100%"
		calendar            = "9" 
		font                = "Calibri"
		datasource          = "AppsEmployee"
		listquery           = "#myquery#"		
		listorderfield      = "LastName"
		listorder           = "LastName"
		listorderdir        = "ASC"		
		headercolor         = "ffffff"		
		menu                = "#menu#"
		showrows            = "1"
		filtershow          = "No"
		excelshow           = "No" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "workflow"
		drillkey            = "eventid"
		drillbox            = "eventbox">
		
		
		