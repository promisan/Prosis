
<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity 
  WHERE   EntityCode  = 'SysChange' 
</cfquery>
  
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset vTempTableName = "#session.acc#_amendmentListingContent">

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
						SELECT   O.Owner,
							     O.ObservationNo,
							     O.ObservationClass,
							     O.Reference,
							     O.ApplicationServer,
							     O.SystemModule,
							     O.RequestName,
							     O.RequestPriority,
							     O.ObservationFrequency,
							     O.ObservationImpact,
							     O.ActionStatus,
							     O.ObservationId,
							     O.OfficerUserId,
							     O.OfficerLastName,
							     O.OfficerFirstName,
							     O.Created,
								 O.ObservationDate,
						         left(RequestName,200) as RequestShort,							
						         B.EntityGroup,						
								 R.StatusDescription,
								 left(V.ActionDescriptionDue,35) AS ActionDescriptionDue,
								 RO.Description AS OwnerDescription,	
								 <cfif CGI.HTTP_HOST neq "DEV01" and CGI.HTTP_HOST neq "www.promisan.com">						  
								 STUFF(
								        (
								         SELECT ', ' + UserAccount
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
						         INNER JOIN Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4 AND B.EntityCode = 'SysChange'
								 INNER JOIN Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysChange' AND R.EntityStatus = O.ActionStatus 
								 INNER JOIN Organization.dbo.Ref_AuthorizationRoleOwner RO ON RO.Code = O.Owner
								 LEFT OUTER JOIN userquery.dbo.#SESSION.acc#wfSysChange V ON V.ObjectkeyValue4 = O.ObservationId	
								 
						WHERE    ObservationClass = '#url.observationclass#'		 
						<cfif url.contextid neq "">		 
						AND      O.ActionStatus = '#URL.contextid#'											
						</cfif>
						
						<cfif SESSION.isAdministrator eq "Yes">
						
							<!--- no limitation --->
						
						<cfelse>
												
						AND     					
						          O.Owner IN (
						
									SELECT   DISTINCT R.Owner
									FROM     Organization.dbo.OrganizationAuthorization AS A INNER JOIN
						    	             Organization.dbo.Ref_EntityGroup AS R ON A.GroupParameter = R.EntityGroup
									WHERE    A.UserAccount   = '#SESSION.acc#' 
									AND      A.Role          = '#Entity.role#' 
									AND 	 R.EntityCode    = 'SysChange' 		
																
								)							 	
									
						</cfif>
						
						AND ActionStatus != '5'
				</cfquery>
					
				<cfsavecontent variable="myquery">		
				    
					SELECT	*, ObservationDate
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
					INTO	UserQuery.dbo.#vTempTableName#
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
<cfset fields[itm] = {label       = "Module",                  
					field         = "SystemModule",
					filtermode    = "2",
					displayfilter = "Yes",
					search        = "text"}>							

<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "No",                  
					field         = "ObservationNo",	
					width         = "20",				
					search        = "text"}>		
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Owner",                  
					field         = "OwnerDescription",
					searchfield   = "Description",
					column        = "Common",
					filtermode    = "2",
					displayfilter = "Yes",
					search        = "text"}>						
				
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Briefs",                  
					field         = "RequestShort",
					searchfield   = "RequestName",
					filtermode    = "0",
					search        = "text"}>		
								
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "Stage", 					
					field         = "ActionDescriptionDue",					
					search        = "text",			
					filtermode    = "2"}>	
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "Actors", 					
					field         = "Actors",					
					search        = "text",			
					filtermode    = "4"}>							  
					  				
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "P", 		
                    LabelFilter   = "Priority",				
					field         = "RequestPriority",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "High=Red,,Medium=FF8000,Low=Yellow"}>	
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "F", 	
                    LabelFilter   = "Frequency",				
					field         = "ObservationFrequency",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "High=Red,,Medium=FF8000,Low=Yellow"}>	
					
<cfset itm = itm+1>												
<cfset fields[itm] = {label       = "I", 					
                    LabelFilter   = "Impact",	
					field         = "ObservationImpact",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "High=Red,,Medium=FF8000,Low=Yellow"}>						  						
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Officer",	
					  field       = "OfficerLastName",
					  search      = "text",		
					  filtermode  = "2"}>
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Observed",  					
					  field       = "ObservationDate",
					  search      = "date",
					  column      = "month",
					  formatted   = "dateformat(ObservationDate,'#CLIENT.DateFormatShow#')"}>		
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "ActionStatus",  					
					  field         = "ActionStatus",
					  display       = "no",
					  search        = "text"}>									  

<!---					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Entered",  					
					  field       = "Created",
					  alias       = "O",
					  search      = "date",
					  searchalias = "O",
					  formatted   = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
--->					  
					
<cfset itm = itm+1>							
	   
<cfset menu=ArrayNew(1)>	
     	
	<cfinvoke component = "Service.Access"  
	   method           = "createwfobject" 
	   entitycode       = "SysChange"
	   returnvariable   = "accesscreate">   
				   
	<cfif accesscreate eq "EDIT" or SESSION.isAdministrator eq "Yes">						
		<cfset menu[1] = {label = "New #url.observationclass# Request", script = "addRequest('#url.context#','#url.observationclass#')"}>				 
	</cfif>
	

<!--- <cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "ActionStatus", value= "1"}>	 --->			
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"><tr><td style="padding:6px">	
	
<cf_listing
    header         = "Observation"
	menu           = "#menu#"
    box            = "observation"
	link           = "#SESSION.root#/System/Modification/ModificationAmendmentListingContent.cfm?systemfunctionid=#url.systemfunctionid#&observationclass=#url.observationclass#&context=#url.context#&contextid=#url.contextid#"
    html           = "No"	
	datasource     = "AppsQuery"
	listquery      = "#myquery#"	

	listgroup      = "SystemModule"
	listgroupdir   = "ASC"
	
	listorder      = "ObservationDate"
	listorderfield = "ObservationDate"
	listorderdir   = "DESC"
		
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Hide"
	<!--- listfilter     = "#filters#" --->
	excelShow      = "Yes"
	drillmode      = "tab"	
	drillargument  = "900;1400;true;true"	
	drilltemplate  = "System/Modification/DocumentView.cfm?drillid="
	drillkey       = "ObservationId"
	annotation     = "SysChange">
	
	
	</td></tr>
	</table>	