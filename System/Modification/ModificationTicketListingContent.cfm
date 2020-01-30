
<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity 
  WHERE   EntityCode  = 'SysTicket' 
</cfquery>
  
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset vTempTableName = "#session.acc#_ticketListingContent">

<cf_dropTable 
	tblname="#vTempTableName#" 
	dbname="AppsQuery">
	
<cfoutput>
	
	<cfswitch expression="#URL.context#">
	
		<cfcase value="status">
		
				<cfquery name="getData" 
				  datasource="AppsQuery" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				
					  SELECT   O.*, 
					         left(RequestName,200) as RequestShort,
					         A.Description AS EntityGroup,						
							 R.StatusDescription,
							 M.Description,
							 left(V.ActionDescriptionDue,35) AS ActionDescriptionDue,
							 <cfif CGI.HTTP_HOST neq "DEV01" and CGI.HTTP_HOST neq "www.promisan.com">						  
							 STUFF(
							        (
							         SELECT DISTINCT ', ' + UserAccount
							         FROM 	Organization.dbo.OrganizationObjectActionAccess
							         WHERE	ObjectId = O.ObservationId
							         FOR XML PATH(''), TYPE
							        ).value('.', 'NVARCHAR(MAX)') 
							 ,1,2,'') AS Actors
							 <cfelse>
							 (
							         SELECT TOP 1 UserAccount
							         FROM 	Organization.dbo.OrganizationObjectActionAccess
							         WHERE	ObjectId = O.ObservationId
							 ) AS Actors
							 </cfif>
							 
					
					INTO	UserQuery.dbo.#vTempTableName#
					 
					FROM     [#Parameter.controlServer#].Control.dbo.Observation O 
					         INNER JOIN Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4 AND B.EntityCode = 'SysTicket'
							 INNER JOIN Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysTicket' AND R.EntityStatus = O.ActionStatus 
						     INNER JOIN System.dbo.Ref_SystemModule M ON O.SystemModule = M.SystemModule 			
							 INNER JOIN System.dbo.Ref_Application  A ON A.Code = B.EntityGroup
							 LEFT OUTER JOIN userquery.dbo.#SESSION.acc#wfSysTicket V ON V.ObjectkeyValue4 = O.Observationid												
							 
					WHERE    ObservationClass = '#url.observationclass#'		 
					<cfif url.contextid neq "">		 
					AND      O.ActionStatus = '#URL.contextid#'											
					</cfif>
										
					<cfif session.isAdministrator eq "Yes">
					
						<!--- no limitation --->
					
					<cfelse>
											
					AND     (
					
							 <!--- involved in the workflow --->
					
					          B.EntityGroup IN (
					
								SELECT   DISTINCT GroupParameter
								FROM     Organization.dbo.OrganizationAuthorization AS A 
								WHERE    A.UserAccount   = '#SESSION.acc#' 
								AND      A.Role          = '#Entity.role#' 								
									
								)	
								
							<!--- requester itself --->						
															
							OR O.Requester   = '#SESSION.acc#' 		
							
							<!--- tree role mananger --->
							
							OR O.Mission IN (SELECT Mission 
						                     FROM   Organization.dbo.OrganizationAuthorization  
											 WHERE  UserAccount = '#session.acc#'
											 AND    Role        = 'OrgUnitManager'
											 AND    Mission     = O.Mission)
							
														
							)							 	
								
					</cfif>
					
					AND O.ActionStatus != '8'  <!--- hardcoded way to hide all records with status = 8 --->
				
				</cfquery>
					
				<cfsavecontent variable="myquery">		
				    
					SELECT	*
					FROM	UserQuery.dbo.#vTempTableName#
					
				</cfsavecontent>	
				
				
						
		</cfcase>
				
		<cfcase value="OrgUnit">
		
			<!--- website access --->
		
			<cfset url.id1 = "">
			
			<cfquery name="getData" 
				  datasource="AppsQuery" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  
				  SELECT  O.*, 
						    B.EntityGroup,
							R.StatusDescription
							
				  INTO		UserQuery.dbo.#vTempTableName#
				  
					FROM    [#Parameter.controlServer#].Control.dbo.Observation O LEFT OUTER JOIN Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4			
							INNER JOIN Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysChange' AND R.EntityStatus = O.ActionStatus 
					WHERE   ApplicationServer IN (SELECT ApplicationServer 
					                              FROM   ParameterSite 
								   				  WHERE  OrgUnit = '#client.orgunit#')		
					AND     ObservationClass = '#url.observationclass#'	
				  
			</cfquery>
			
			<cfsavecontent variable="myquery">	
				
				SELECT	*
				FROM	UserQuery.dbo.#vTempTableName#
						
			</cfsavecontent>	
				
		</cfcase>
			
	</cfswitch>

</cfoutput>
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Application",                  
					  field         = "EntityGroup",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>		
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "No",    
					  Width       = "20",               
					  field       = "ObservationNo",					
					  search      = "text"}>						  				  
				
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Module",                  
					  field         = "Description",
					  filtermode    = "2",
					  searchfield   = "Description",
					  displayfilter = "Yes",
					  search        = "text"}>							  					
									
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Briefs",      
                      width       = "60",            
					  field       = "RequestShort",
					  formatted   = "left(RequestShort,50)",	
					  searchfield = "RequestName",
					  filtermode  = "0",
					  search      = "text"}>								
						
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Status",	
                      field       = "StatusDescription",		
					  filtermode  = "3",
					  search      = "text"}>						  
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "Stage", 					
					  field       = "ActionDescriptionDue",					
					  search      = "text",			
					  filtermode  = "2"}>		
					  
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "Actors", 					
					field         = "Actors",					
					search        = "text",			
					filtermode    = "4"}>					  
					  				
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "Pr", 		
                      LabelFilter = "Priority",				
					  field       = "RequestPriority",					
					  filtermode  = "3",    
					  search      = "text",
					  align       = "center",
					  formatted   = "Rating",
					  ratinglist  = "High=Red,Medium=FF8000,Low=Yellow"}>	
					  
					  
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Fr", 	
                      LabelFilter = "Frequency",				
					  field       = "ObservationFrequency",					
					  filtermode  = "3",    
					  search      = "text",
					  align       = "center",
					  formatted   = "Rating",
					  ratinglist  = "High=Red,Medium=FF8000,Low=Yellow"}>	
					
<cfset itm = itm+1>												
<cfset fields[itm] = {label         = "Im", 					
                      LabelFilter   = "Impact",	
					  field         = "ObservationImpact",					
					  filtermode    = "3",    
					  search        = "text",
					  align         = "center",
					  formatted     = "Rating",
					  ratinglist    = "High=Red,,Medium=FF8000,Low=Yellow"}>						  						
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Officer",	
					  field         = "OfficerLastName",
					  search        = "text",	
					  filtermode    = "2"}>	

<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Observed",  					
					  field         = "ObservationDate",
					  search        = "date",
					  formatted     = "dateformat(ObservationDate,'#CLIENT.DateFormatShow#')"}>	

<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Entered",  					
					  field         = "Created",
					  display       = "no",
					  search        = "date",
					  formatted     = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "ActionStatus",  					
					  field         = "ActionStatus",
					  display       = "no",
					  search        = "text"}>							
							
	   
<cfset menu=ArrayNew(1)>	   				
<cfset newLabel = "New #url.observationclass# Ticket">		
<cf_tl id="#newLabel#" var="1">							
<cfset menu[1]   = {label = "#lt_text#", script = "addRequest('#url.context#','#url.observationclass#')"}>		
	
<!--- <cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "ActionStatus", value= "0"}> --->						 
		
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Ticket"
		menu           = "#menu#"
	    box            = "observation"
		link           = "#SESSION.root#/System/Modification/ModificationTicketListingContent.cfm?systemfunctionid=#url.systemfunctionid#&observationclass=#url.observationclass#&context=#url.context#&contextid=#url.contextid#"
	    html           = "No"		
		datasource     = "AppsQuery"
		listquery      = "#myquery#"			
		listgroup      = "Entitygroup"		
		listgroupdir   = "ASC"			
		listorder      = "ObservationDate"
		listorderfield = "ObservationDate"
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		<!--- listfilter     = "#filters#"  --->
		excelShow      = "Yes"
		drillmode      = "tab"	
		drillargument  = "900;1200;true;true"	
		drilltemplate  = "System/Modification/DocumentView.cfm?drillid="
		drillkey       = "ObservationId"
		annotation     = "SysTicket">		
	
	</td></tr>
</table>			