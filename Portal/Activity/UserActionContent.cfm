
<!--- control list data content --->

<cfparam name="url.filter"  default="">
<cfparam name="url.mode"    default="current">
<cfparam name="url.scope"   default="usr">
<cfparam name="url.systemfunctionid"   default="">

<cfif getAdministrator("*") eq "1">

	<cfset Drill.recordcount = "1">
	
<cfelse>

	<cfquery name="Drill" 
	datasource="AppsOrganization">
		SELECT   *
		FROM     OrganizationAuthorization
		WHERE    UserAccount = '#SESSION.acc#'
		AND      Role = 'AdminUser'
	</cfquery>

</cfif>

<cfif drill.recordcount gte "1">
  <cfset access = "Full">
<cfelse>
  <cfset access = "Limited">  
</cfif>

<cfset daterecent = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfoutput>

	<cfsavecontent variable="myquery">
	
	    SELECT *
		FROM (
			SELECT   U.UserStatusId, 
			         U.Account, 
			         U.HostName, 
					 U.HostSessionId, 
					 U.ApplicationServer, 
					 U.NodeIP, 
					 U.ActionTimestamp, 
					 U.TemplateGroup, 
					 U.ActionTemplate, 
					 U.SystemFunctionId, 
					 U.Mission, 
                     U.ActionExpiration, 
					 U.Created,
					 N.AccountMission,
					 N.AccountGroup,					 
					 CASE WHEN DATEDIFF(n, ActionTimestamp, GETDATE()) < 4 
					        THEN '<b>Now</b>' 
							ELSE CAST(DATEDIFF(n, ActionTimestamp, 
                         GETDATE()) AS VARCHAR(10)) END AS myTime,
						 
					 DATEDIFF(n, ActionTimestamp, GETDATE()) as myTimeSort,	 
					 
			         FirstName+' '+LastName               as Name, 
					 NodeBrowser+' '+NodeBrowserVersion   as Browser,				 
					 (SELECT PersonNo 
					  FROM   Employee.dbo.Person
					  WHERE  PersonNo = N.PersonNo)       as PersonNo
					  
			FROM     UserStatus U INNER JOIN UserNames N ON U.Account = N.Account
			WHERE    1=1 <!--- not terminate yet --->
			
				<cfif URL.Filter neq "">
					<cfif url.filter eq "Framework">
			    	AND TemplateGroup IN ('System','Portal','Tools','Component')
					<cfelse>		
					AND SystemFunctionId IN (SELECT     SystemFunctionId
											 FROM       Ref_ModuleControl C INNER JOIN
								                        Ref_ApplicationModule AM ON C.SystemModule = AM.SystemModule INNER JOIN
									                    Ref_Application R ON AM.Code = R.Code
											WHERE       C.Operational = '1' 
											AND         R.Usage       = 'System' 
											AND         R.Description = '#URL.Filter#')					
			    	</cfif>
				</cfif>  
				
				<cfif url.scope eq "usr">
				
				AND   HostSessionId IN (
				
						SELECT    U.HostSessionId
						FROM      (SELECT   Account, MAX(ActionTimestamp) AS TimeStamp
		                		   FROM     UserStatus
		                           GROUP BY Account) AS D INNER JOIN UserStatus AS U ON D.Account = U.Account AND D.TimeStamp = U.ActionTimestamp
					 )			   
				
				
				</cfif>
				
		        <cfif URL.Mode eq "Current">
			
				    AND  ActionTimeStamp > #daterecent#
					
			    </cfif>		
		) as D
		WHERE 1=1
		--condition	 
		
	</cfsavecontent>	

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
	
	<cfset itm = itm+1>					
	<cf_tl id="Control" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "AccountMission",																	
						alias           = "",																			
						search          = "text",
						filtermode      = "2"}>				
	
	<cfif access eq "Full">
	
	<cfset itm = itm+1>	
	<cf_tl id="Account" var = "1">		
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "Account",																	
						alias             = "",	
						functionscript    = "ShowUser",
						functionfield     = "Account",																		
						functioncondition = "audit",
						search            = "text"}>	
						
	<cfelse>
	
	<cfset itm = itm+1>	
	<cf_tl id="Account" var = "1">		
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "Account",																	
						alias             = "",		
						filtermode		  = "3",					
						search            = "text"}>		
	
	</cfif>						
									
	
	<cfif access eq "Full">
						
		<cfset itm = itm+1>	
		<cf_tl id="Name" var = "1">		
		<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field           = "Name",																	
							alias           = "",
							functionscript  = "EditPerson",
							functionfield   = "PersonNo",
							filtermode		= "1",
							display         = "yes",																			
							search          = "text"}>	
						
	<cfelse>
	
		<cfset itm = itm+1>	
		<cf_tl id="Name" var = "1">		
		<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field           = "Name",																	
							alias           = "",
							filtermode		= "1",
							display         = "yes",																			
							search          = "text"}>	
		
	
	</cfif>		
	
	<cfset itm = itm+1>	
	<cf_tl id="Group" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "AccountGroup",																	
						alias           = "",
						column          = "common",						
						filtermode		= "2",																	
						search          = "text"}>					


	<cfset itm = itm+1>	
	<cf_tl id="Entity" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "Mission",																	
						alias           = "",
						column          = "common",						
						filtermode		= "2",																	
						search          = "text"}>			
	
	<cfset itm = itm+1>	
	<cf_tl id="Host" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "HostName",																	
						alias           = "",
						column          = "common",						
						filtermode		= "2",																	
						search          = "text"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Browser" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "Browser",																	
						alias           = "",
						column          = "common",						
						filtermode		= "2",																	
						search          = "text"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="IP" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "NodeIP",																	
						alias           = "",																														
						search          = "text"}>		
					
							
	<cfset itm = itm+1>	
	<cf_tl id="Last (min)" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "myTime",		
						fieldsort       = "mytimeSort",																					
						alias           = "",		
						align           = "right"}>		
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "S", 	
                    LabelFilter         = "Expiration",				
					field               = "ActionExpiration",					
					filtermode          = "3",    					
					align               = "center",
					formatted           = "Rating",
					ratinglist          = "0=Green,1=Red"}>																											
	
	<cfset itm = itm+1>	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UserStatusId",					
						display     = "No",
						alias       = ""}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->

<cfif url.mode eq "Current">
	<cfset label = "Active users">
<cfelse>
	<cfset label = "Today's users"> 
</cfif>
	
<cf_listing
    header              = "useraction"
    box                 = "useraction"
	boxlabel            = "#label#"
	link                = "#SESSION.root#/Portal/Activity/UserActionContent.cfm?mode=#url.mode#&filter=#url.filter#&systemfunctionid=#url.systemfunctionid#"	   		
	tableheight         = "100%"
	tablewidth          = "100%"		
	datasource          = "AppsSystem"
	listquery           = "#myquery#"		
	listorderfield      = "Name"
	listorder           = "Name"		
	show                = "500"		<!--- better to let is be set in the preferences --->
	menu                = "#menu#"
	filtershow          = "hide"
	excelshow           = "Yes" 	
	refresh             = "1"						
	listlayout          = "#fields#"
	drillmode           = "embed" 
	drillargument       = "#client.height-90#;#client.width-90#;false;false"	
	drillstring         = "systemfunctionid=#url.systemfunctionid#"
	drilltemplate       = "Portal/Activity/UserActionDetail.cfm"
	drillkey            = "UserStatusId"
	deletescript        = "expiresession">	
		