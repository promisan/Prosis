
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_dialogStaffing>

<cfquery name="Verify" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Mission
WHERE  Mission  = '#Form.Mission#' 
</cfquery>

<cfif find(" ", form.mission)>
  <cf_message message="Problem, a tree acronym may not contain any spaces in its name. Use _ instead" return="back">
  <cfabort>
</cfif>

<cfoutput>
<input type="hidden" name="Mission" id="Mission" value="#Form.Mission#">
</cfoutput>

<cfif Verify.recordCount is 1> 

<cflocation url="../Menu.cfm" addtoken="No"> 

<CFELSE>

<!--- insert mission --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset Dte = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset Exp = dateValue>

<cftransaction action="BEGIN">

<cfquery name="InsertMission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_Mission
	         (Mission,
			 MissionType,
			 MissionName,
			 MissionPrefix,
			 MissionStatus,
			 DateEffective,
			 MissionOwner,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
   VALUES ('#Form.Mission#',
          '#Form.MissionType#',
          '#Form.MissionName#',
		  '#Form.MissionPrefix#',
		  '#Form.Status#',
		  #Dte#,
		  '#Form.Owner#',		  
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.DateSQL)#')
</cfquery>

<cfquery name="InsertMandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Mandate
         (Mission,
		 Description,
		 MandateNo,
		 DateEffective,
		 DateExpiration,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Mission#',
          'Initial Mandate',
          'P001',
      	  #Dte#,
		  #Exp#,
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.DateSQL)#')
</cfquery>

<cfquery name="Topic" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Ref_GroupMission
    WHERE   Code IN (SELECT GroupCode FROM Ref_GroupMissionList)
	 AND    Code IN (SELECT GroupCode FROM Ref_GroupMissionType WHERE MissionType = '#Form.missionType#')
</cfquery>
  
 <cfloop query="topic">
			        
     <cfset ListCode  = Evaluate("ListCode_#Code#")>
	 
	 <cfif listcode neq "">
				  
	   <cfquery name="Insert" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO Ref_MissionGroup
			 (Mission,
			  GroupCode,
			  GroupListCode, 
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		 VALUES
		 ('#Form.Mission#', '#Code#', '#ListCode#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
		</cfquery>
		
	</cfif>	
	   
  </cfloop>
  
  <!--- mission modules --->
  
  <cfquery name="ResetModule" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_MissionModule
	WHERE       Mission = '#Form.Mission#'
	</cfquery>  
	
	<cfparam name="Form.SystemModule" type="any" default="">
	
	<cfloop index="Item" 
	        list="#Form.SystemModule#" 
	        delimiters="' ,">
	
		<cfquery name="InsertFunction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_MissionModule 
		         (Mission,
				 SystemModule,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Mission#', 
		      	  '#Item#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
		</cfquery>
					  			  
	</cfloop>	
	
	<!--- create initial entry --->
	
	<cfquery name="MissionList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Mission 
	FROM   Ref_MissionModule
	WHERE  SystemModule IN (SELECT SystemModule 
	                        FROM   System.dbo.Ref_SystemModuleDatabase) 
	</cfquery>  
	
	<cfloop query="MissionList">
		 
		<cfquery name="CheckModule" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   System.dbo.Ref_SystemModuleDatabase
		WHERE  SystemModule IN (SELECT SystemModule 
		                        FROM Ref_MissionModule
							    WHERE Mission = '#Mission#')
		AND    SystemModule IN (SELECT SystemModule 
		                        FROM   System.dbo.Ref_SystemModule
								WHERE  Operational = 1)						   
		</cfquery>  
		
		<cfset mis = "#Form.Mission#">
		
		<cfloop query="CheckModule">
		  
		    <cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM #DatabaseName#.dbo.#MissionTable#
			WHERE Mission =	'#Mis#'
			</cfquery>  
			
			<cfif check.recordcount eq "0">
		   
			<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO #DatabaseName#.dbo.#MissionTable#
				(Mission)
				VALUES ('#Mis#')
			</cfquery>  
			
			</cfif>
		
		</cfloop>
	
</cfloop>	

<!--- insert tree role manager --->

<cftry>
<cfquery name="Add" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO OrganizationAuthorization
		(Mission, 
		 UserAccount, 
		 Role, 
		 ClassParameter, 
		 AccessLevel, 
		 Source, 
		 OfficerUserId, 
		 OfficerLastName, 
		 OfficerFirstName)
		VALUES
		('#Form.Mission#',
		 '#SESSION.acc#',
		 'OrgUnitManager',
		 '#Form.Owner#',
		 '2',
		 'Manual',
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')
</cfquery> 
<cfcatch></cfcatch>
</cftry>
  
  
</cftransaction>  

<!--- </cfif> --->

<!--- show result --->

<cfoutput>
<script language="JavaScript1.2">
	
	w = 0
	h = 0
	if (screen) 
	{
	w = #CLIENT.width# - 60
	h = #CLIENT.height# - 140
	}
	
	{
	 	window.open("#SESSION.root#/System/Organization/Application/OrganizationView.cfm?systemfunctionid=#url.idmenu#&Mission=#Form.Mission#",  "mandate", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
			
	}
	
	</script>
</cfoutput>	

<cflocation addtoken="No" url="../Menu.cfm">
		
</cfif> 
