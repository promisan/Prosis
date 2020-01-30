<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#url.init#">
<cfset vInit = dateValue>
<cfset vInit = dateAdd('s',1,vInit)>
<cfset vInit = dateAdd('s',-1,vInit)>

<cfset dateValue = "">
<CF_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfset vEnd = dateAdd('d',1,vEnd)>
<cfset vEnd = dateAdd('s',-1,vEnd)>

<cfset vFilter1 = url.series>
<cfset vFilter2 = url.item>
<cfif vFilter1 eq "TOPICVALUE">
	<cfset vFilter1 = "">
</cfif>
<cfif vFilter2 eq "TOPICVALUE">
	<cfset vFilter2 = "">
</cfif>

<cf_dropTable 
	tblname="#session.acc#_supportDrill" 
	dbname="AppsQuery">  

	
<cfquery name="getTickets" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	D.*
		INTO	UserQuery.dbo.#session.acc#_supportDrill
		FROM
			(
				SELECT   O.*, 
						 R.StatusDescription,
						 ISNULL((
							SELECT TOP 1 OI.DocumentItemValue
							FROM    Organization.dbo.OrganizationObjectInformation AS OI 
									INNER JOIN Organization.dbo.Ref_EntityDocument AS ED
										ON OI.DocumentId = ED.DocumentId
									INNER JOIN Organization.dbo.OrganizationObject AS OO 
										ON OI.ObjectId = OO.ObjectId
							WHERE	OO.Operational = 1 
							AND		OO.ObjectKeyValue4 = O.ObservationId
							AND		ED.EntityCode = R.EntityCode
							AND		ED.DocumentCode = 'c001'
							ORDER BY OI.CREATED DESC
						),'[Not classified]') as Classification,
						CONVERT(VARCHAR(7),O.Created,120) as DateValue,
						CASE
							WHEN LTRIM(RTRIM(U.AccountOwner)) = '' THEN '[No owner]'
							ELSE ISNULL(LTRIM(RTRIM(U.AccountOwner)), '[No owner]') 
						END as AccountOwner,
						A.Code as Application,
						A.Description as ApplicationDescription
				 
				FROM     Observation O 
				         INNER JOIN [#Parameter.databaseServer#].Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4 AND B.EntityCode = 'SysTicket'
						 INNER JOIN [#Parameter.databaseServer#].Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysTicket' AND R.EntityStatus = O.ActionStatus 
					     INNER JOIN [#Parameter.databaseServer#].System.dbo.Ref_SystemModule M ON O.SystemModule = M.SystemModule 			
						 INNER JOIN [#Parameter.databaseServer#].System.dbo.Ref_Application  A ON A.Code = B.EntityGroup
						 INNER JOIN [#Parameter.databaseServer#].System.dbo.UserNames U ON O.Requester = U.Account
						 
				WHERE    O.ObservationClass = 'Inquiry'
				AND		 O.Created BETWEEN #vInit# AND #vEnd#
			) AS D
		
		WHERE	1=1
		AND 	D.ActionStatus NOT IN ('8','9')
		
		<cfif vFilter2 neq "">
		AND		D.DateValue = '#vFilter2#'
		</cfif>
		
		<cfif url.by eq "actor" and vFilter1 neq "">
		AND		EXISTS
				(
					SELECT	'X'
					FROM   	Organization.dbo.OrganizationObjectActionAccess OAS 
							INNER JOIN System.dbo.UserNames U 
								ON OAS.UserAccount = U.Account
					WHERE	OAS.Objectid = D.ObservationId
					AND		U.Account = '#vFilter1#'
				)
		</cfif>
		
		<cfif url.by eq "assigner" and vFilter1 neq "">
		AND		D.OfficerUserId = '#vFilter1#'
		</cfif>
		
		<cfif url.by eq "status" and vFilter1 neq "">
		AND		D.StatusDescription = '#vFilter1#'
		</cfif>
		
		<cfif url.by eq "owner" and vFilter1 neq "">
		AND		D.AccountOwner = '#vFilter1#'
		</cfif>
		
		<cfif url.by eq "application" and vFilter1 neq "">
		AND		LTRIM(RTRIM(D.ApplicationDescription)) = '#TRIM(vFilter1)#'
		</cfif>
		
		<cfif url.by eq "classification" and vFilter1 neq "">
		AND		D.Classification = '#vFilter1#'
		</cfif> 
				
</cfquery>

					
<cfsavecontent variable="myquery">		
	<cfoutput>
		SELECT	*
		FROM	UserQuery.dbo.#session.acc#_supportDrill
	</cfoutput>
</cfsavecontent>		

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Date",  					
					  field         = "ObservationDate",
					  search        = "date",
					  formatted     = "dateformat(ObservationDate,'#CLIENT.DateFormatShow#')"}>

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "Ticket No",                  
					  field         = "ObservationNo",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "Description",                  
					  field         = "RequestName",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "Status",                  
					  field         = "StatusDescription",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	
		
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "SupportDrill"
	    box            = "SupportDrill"
		link           = "#session.root#/system/portal/support/summary/statistics/drillListingContent.cfm?val=#url.val#&series=#url.series#&item=#url.item#&init=#url.init#&end=#url.end#&by=#url.by#"
	    html           = "No"		
		datasource     = "AppsQuery"
		listquery      = "#preserveSingleQuotes(myquery)#"		
		listorder      = "ObservationDate"
		listorderfield = "ObservationDate"
		listorderdir   = "DESC"	 
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		excelShow      = "Yes"
		drillmode      = "window"
		drillargument  = "900;1200;true;true"	
		drilltemplate  = "System/Modification/DocumentView.cfm?drillid="
		drillkey       = "ObservationId">
	
	</td></tr>
</table>		