<cfinvoke component = "Service.Access"  
   method           = "CaseFileManager" 	 
   Mission          = "#url.mission#"  
   returnvariable   = "accessLevel">	
   
<!--- casefile record --->

<!--- show the matching lines --->

<cfsavecontent variable="selectfields">
	        C.ClaimId, 
	        P.FirstName,
			P.LastName,
			P.IndexNo,
			P.Nationality,
			C.DependentId,
			C.DocumentNo, 
			C.DocumentDate, 
			C.DocumentSource, 
			C.DocumentDescription, 
			C.ClaimType, 
	        C.OfficerLastName, 
			C.OfficerFirstName,	
			C.PersonNo, 
			C.ClaimantEMail, 
			C.ActionStatus,	
		    S.Description,				
			O.OrgUnitName,
			O.OrgUnitCode,
			CT.Description as PersonType,			
			CI.Mission,
			CI.Location,
			CI.Circumstance,
			CI.Casualty,
			RI_Casualty.Description AS CasualtyDescription,
			CI.Cause,
			RI_Cause.Description AS CauseDescription,
			CI.IncidentDate,
			RN.Name as CountryName, 								
			C.CaseNo
</cfsavecontent>

<cfoutput>

<cfsavecontent variable="OrgAccess">

<cfif getAdministrator(url.mission) eq "0">

	AND 
	(
		C.ClaimType IN (SELECT ClassParameter 
                    FROM   Organization.dbo.OrganizationAuthorization
		  		    WHERE  UserAccount = '#SESSION.acc#'
				     AND    ((OrgUnit = C.OrgUnit) or (OrgUnit is NULL and Mission = C.Mission))
				     AND    Role IN ('CaseFileManager')				 
				   ) 
		OR
		
		EXISTS
		
		(
			SELECT 'X'
			FROM     Organization.dbo.OrganizationAuthorization
			WHERE    Role IN ('CaseFileManager')				 
			AND      UserAccount = '#SESSION.acc#'						
			AND      (Mission     = C.Mission or Mission is NULL)
			AND      EXISTS
			(
				SELECT 'X'
				FROM ClaimIncident 
				WHERE ClaimId = C.ClaimId
			)
		)
	) 
</cfif>	
</cfsavecontent>
</cfoutput>

<cfset condition = "WHERE 1=1 ">

<cfsavecontent variable="preQuery">

	<cfoutput>
   
	<cfswitch expression="#URL.ID#">
		  	
		<cfcase value="org">
		
		        <cfif url.id1 neq "">
				
					<cfquery name="OrgSelect" 
				    datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#URL.ID1#'
					</cfquery>	
			
					<cfset condition = "#condition# AND LEFT(O.HierarchyCode,2) = '#LEFT(OrgSelect.HierarchyCode,2)#' AND C.Mission = '#URL.mission#'">
				
				<cfelse>
				
					<cfset condition = "">
				
				</cfif>
										
				SELECT  #preservesinglequotes(selectfields)#
				
				FROM    Claim C LEFT OUTER JOIN Ref_Status S	ON C.ActionStatus = S.Status AND S.StatusClass = 'clm'
						LEFT OUTER JOIN Employee.dbo.Person P ON P.personNo = C.PersonNo 
						LEFT OUTER JOIN ClaimPerson CP ON CP.ClaimId = C.ClaimId 
						LEFT OUTER JOIN ClaimIncident CI on CI.ClaimId = C.ClaimId  
						LEFT OUTER JOIN Ref_Incident  RI_Casualty ON RI_Casualty.Class = 'Casualty' AND RI_Casualty.Code = CI.Casualty
						LEFT OUTER JOIN Ref_Incident  RI_Cause    ON RI_Casualty.Class = 'Cause' AND RI_Casualty.Code = CI.Cause
						LEFT OUTER JOIN System.dbo.Ref_Nation RN ON CI.Location = RN.Code 
						LEFT OUTER JOIN Ref_ClaimantType CT ON CP.Type = CT.Code 
						LEFT OUTER JOIN Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit

				        #preserveSingleQuotes(Condition)#		

						<cfif accessLevel eq "NONE">
							<!--- check if person has been granted access on-the-fly to the workflow on the claim level --->
							AND    C.ClaimId IN (
							                      SELECT DISTINCT O.ObjectKeyValue4
												  FROM   Organization.dbo.OrganizationObject AS O INNER JOIN
									                     Organization.dbo.OrganizationObjectActionAccess AS A ON O.ObjectId = A.ObjectId
												  WHERE  O.EntityCode = 'Clm'+C.ClaimType 
												  AND    A.UserAccount = '#SESSION.acc#'
											     )				
						</cfif>
						
						<!--- only to orgunit to which the person has been granted access --->
							
						#preserveSingleQuotes(OrgAccess)#
									
		</cfcase>	
		
		<cfcase value="status">
						
		        <cfif url.id1 eq "">
				
				<cfset condition = "#condition# AND C.Mission = '#URL.ID2#'">
				
				<cfelse>
				
						
				<cfset condition = "#condition# AND C.ActionStatus IN ('#URL.ID1#') AND C.Mission = '#URL.ID2#'">
				
				</cfif>
		
					SELECT  #preservesinglequotes(selectfields)#
				    FROM    Claim C INNER JOIN Ref_Status S
							ON C.ActionStatus = S.Status AND S.StatusClass = 'clm'					
							LEFT JOIN
							Employee.dbo.Person P ON P.personNo = C.PersonNo left JOIN
							ClaimPerson CP ON CP.ClaimId=C.ClaimId LEFT JOIN
							ClaimIncident CI on CI.ClaimId=C.ClaimId  
							LEFT OUTER JOIN Ref_Incident  RI_Casualty ON RI_Casualty.Class = 'Casualty' AND RI_Casualty.Code = CI.Casualty
							LEFT OUTER JOIN Ref_Incident  RI_Cause    ON RI_Casualty.Class = 'Cause' AND RI_Casualty.Code = CI.Cause
							LEFT JOIN System.dbo.Ref_Nation RN ON CI.Location=RN.Code LEFT JOIN
							Ref_ClaimantType CT ON CP.Type=CT.Code LEFT JOIN
							Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit
					        #preserveSingleQuotes(Condition)#		
							
							
							<cfif accessLevel eq "NONE">
							<!--- check if person has been granted access on-the-fly to the workflow on the claim level --->
							AND    C.ClaimId IN (
							                      SELECT DISTINCT O.ObjectKeyValue4
												  FROM   Organization.dbo.OrganizationObject AS O INNER JOIN
									                     Organization.dbo.OrganizationObjectActionAccess AS A ON O.ObjectId = A.ObjectId
												  WHERE  O.EntityCode = 'Clm'+C.ClaimType 
												  AND    A.UserAccount = '#SESSION.acc#'
											     )				
							</cfif>
							
							#preserveSingleQuotes(OrgAccess)#
																
									
		</cfcase>	
		
		<cfcase value="nation">
		
					<CFIF url.id2 neq "undefined">
		
						<cfset condition = "#condition# AND CI.Casualty = '#URL.ID2#' AND CI.Location = '#URL.ID1#'">
					
					<cfelse>
					
						<cfset condition = "#condition# AND CI.Location = '#URL.ID1#'">
						
					</cfif>

						SELECT   #preservesinglequotes(selectfields)#
					    FROM     Claim C INNER JOIN Ref_Status S
								ON C.ActionStatus = S.Status AND S.StatusClass = 'clm' 
								LEFT JOIN Employee.dbo.Person P ON P.personNo = C.PersonNo left JOIN
								 ClaimPerson CP ON CP.ClaimId=C.ClaimId LEFT JOIN
								 ClaimIncident CI on CI.ClaimId=C.ClaimId  LEFT JOIN
								 System.dbo.Ref_Nation RN ON CI.Location=RN.Code 
								 LEFT OUTER JOIN Ref_Incident  RI_Casualty ON RI_Casualty.Class = 'Casualty' AND RI_Casualty.Code = CI.Casualty
		 						 LEFT OUTER JOIN Ref_Incident  RI_Cause    ON RI_Casualty.Class = 'Cause'    AND RI_Casualty.Code = CI.Cause
								 LEFT JOIN
								 Ref_ClaimantType CT ON CP.Type=CT.Code  LEFT JOIN
								Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit
				         #preserveSingleQuotes(Condition)#		
						 <cfif accessLevel eq "NONE">
						<!--- check if person has been granted access on-the-fly to the workflow on the claim level --->
						AND    C.ClaimId IN (
						                   SELECT DISTINCT O.ObjectKeyValue4
										   FROM   Organization.dbo.OrganizationObject AS O INNER JOIN
							                      Organization.dbo.OrganizationObjectActionAccess AS A ON O.ObjectId = A.ObjectId
										   WHERE  O.EntityCode = 'Clm'+C.ClaimType 
										   AND    A.UserAccount = '#SESSION.acc#'
										   )				
						</cfif>				 
						#preserveSingleQuotes(OrgAccess)#
						
						
						
		</cfcase>		
		
	</cfswitch>
	
	</cfoutput>
	
</cfsavecontent>	

<cfsavecontent variable="qQuery">

<cfoutput>
	SELECT *
	FROM (#preserveSingleQuotes(preQuery)#) as Sub
	WHERE 1=1
</cfoutput>
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<!----			
This was removed from the listing on 7/1/2011 by Armin
			#Dependent.firstName# #dependent.LastName#
--->		

<cfset itm = itm+1>					
<cfset fields[itm] = {label          = "Unit",                    
					 field           = "OrgUnitName", 														
					 search          = "text",
					 filtermode      = "2"}>							 

<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "Type", 					
					 field           = "ClaimType",		
					 align           = "left",																			
					 search          = "text",
					 filtermode      = "2"}>	 					 
				
<cfset itm = itm+1>					
<cfset fields[itm] = {label          = "No",                    
					 field           = "CaseNo", 		
					 formatted       = "CaseNo",								
					 search          = "text"}>		

<cfset itm = itm+1>					
<cfset fields[itm] = {label          = "Case Date",                    
					 field           = "DocumentDate", 					 
					 formatted       = "dateformat(documentdate,CLIENT.DateFormatShow)",			
					 search          = "date"}>	
					 					 
<cfset itm = itm+1>
<cfset fields[itm] = {label          = "Status",                   		
					 field           = "Description",		
					 displayfilter   = "yes",																						 	
					 search          = "text",
					 filtermode      = "3"}>						 	

<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "First Name", 					
					 field           = "FirstName",	
					 align           = "left",		
					 filtermode      = "4",															
					 search          = "text"}>							 

<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "Last Name", 					
					 field           = "LastName",						
					 filtermode      = "4",		
					 align           = "left",																	
					 search          = "text"}>	
					 
<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "IndexNo", 					
					 field           = "IndexNo",	
					 align           = "left",	
					 functionscript  = "showemployee",	
					 filtermode      = "4",																	
					 functionfield   = "PersonNo",
					 search          = "text"}>	

<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "Nat.", 	
                     labelfilter     = "Nationality",				
					 field           = "Nationality",						
					 align           = "left",		
					 filtermode      = "2",															
					 search          = "text"}>			

<cfset itm = itm+1>
<cfset fields[itm] = {label          = "Casualty",                   		
					 field           = "Casualty",					
					 display         = "No",
					 displayfilter   = "Yes",					
					 searchfield     = "Casualty",					
					 filtermode      = "2",		
					 search          = "text"}>	

<cfset itm = itm + 1>															
<cfset fields[itm] = {label          = "Type", 	
                    labelfilter      = "Modality",				
					field            = "PersonType",	
					searchfield      = "PersonType",					
					filtermode       = "2",	
					align            = "left",																		
					search           = "text"}>	

<cfset itm = itm+1>
<cfset fields[itm] = {label          = "Cause",                   		
					 field           = "Cause",					
					 display         = "No",
					 displayfilter   = "Yes",					
					 filtermode      = "2",		
					 search          = "text"}>	

<cfset itm = itm+1>
<cfset fields[itm] = {label          = "Mission",                   		
					 field           = "Mission",					
					 display         = "No",
					 displayfilter   = "Yes",									 
					 filtermode      = "4",		
					 search          = "text"}>	

<cfset itm = itm+1>
<cfset fields[itm] = {label          = "Incident date",                   		
					 field           = "IncidentDate",					
					 display         = "No",
					 displayfilter   = "Yes",										
					 search          = "date"}>	

<!--- define access --->

<cfset menu = "">

<!--- get entity --->

<cfquery name="Entity" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Ref_Entity	
	WHERE    EntityTableName = 'CaseFile.dbo.Claim' 
</cfquery>	

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
						

			
<cf_listing
    header         = "caselist"
    box            = "casebox"
	link           = "#SESSION.root#/casefile/application/Case/ControlEmployee/ClaimListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&id=#url.id#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#"
    html           = "No"		
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsCaseFile"
	listquery      = "#qQuery#"
	listorderfield = "DocumentDescription"
	listorderalias = ""
	listorder      = "DocumentDescription"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	show           = "40"			
	menu           = "#menu#"			
	filtershow     = "Show"
	excelshow      = "Yes" 		
	listlayout     = "#fields#"
	drillmode      = "tab" 
	drillargument  = "#client.height-80#;#client.widthfull-30#;true;true"			
	drilltemplate  = "CaseFile/Application/Case/CaseView/CaseView.cfm?claimId="
	drillkey       = "ClaimId"
	drillbox       = "addcasefile"
	annotation     = "#Entity.EntityCode#"
	allowgrouping  = "No">	 
	
</td></tr></table>	 