<!--
    Copyright © 2025 Promisan

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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_dialogStaffing>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	  

<cftransaction action="BEGIN">

<!--- insert mission --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset Dte = dateValue>

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.ProcurementMode" default="0">
<cfparam name="Form.FunctionClass" default="">

<cfquery name="UpdateMission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Mission
	SET MissionType          = '#Form.MissionType#',
	    MissionName          = '#Form.MissionName#',
		<!--- MissionPrefix = '#Form.MissionPrefix#', --->
		DateEffective         = #STR#,
		DateExpiration        = #END#,
		MissionURL            = '#Form.MissionURL#',
		MissionPathLogo       = '#Form.MissionPathLogo#',
		MissionParentOrgUnit  = '#Form.MissionParentOrgUnit#',
		Operational           = '#Form.Operational#',
		ProcurementMode       = '#Form.ProcurementMode#',		
		MissionOwner          = '#Form.MissionOwner#',
		StaffingMode          = '#Form.StaffingMode#',
		DocumentServerMode    = '#Form.DocumentServerMode#',
		<!---
		<cfif form.FunctionClass neq "">
		FunctionClass         = '#Form.FunctionClass#',
		</cfif>
		--->
		<cfif Form.TreeAdministrative neq "">
			 TreeAdministrative = '#Form.TreeAdministrative#',
		 <cfelse>
			 TreeAdministrative = NULL,
		 </cfif>
		 <cfif Form.TreeFunctional neq "">
			 TreeFunctional     = '#Form.TreeFunctional#',
		 <cfelse>
			 TreeFunctional     = NULL,
		 </cfif>
		 <cfif Form.Country neq "">
			 CountryCode     = '#Form.Country#'
		 <cfelse>
	 	  CountryCode = NULL
		 </cfif>	 
	WHERE Mission = '#Form.Mission#'	
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.TimeZoneDateEffective,CLIENT.DateFormatShow)#">
<cfset ZSTR = dateValue>
	
<cfquery name="check" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_MissionTimeZone	
		WHERE  Mission     = '#Form.Mission#'
		AND    DateEffective = #ZSTR#
</cfquery>
	
<cfif check.recordcount eq "1">
	
		<cfquery name="check" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_MissionTimeZone	
			SET    TimeZone      = '#Form.TimeZone#'
			WHERE  Mission       = '#Form.Mission#'
			AND    DateEffective = #ZSTR#
		</cfquery>
		
<cfelse>
	
		<cfquery name="insert" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_MissionTimeZone	
			
				(Mission,
				 DateEffective,
				 TimeZone,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				 
			VALUES
			
				('#Form.Mission#',
				 #ZSTR#,
				 '#Form.TimeZone#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')				 
			
		</cfquery>	
	
</cfif>


<cfquery name="Topic" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Ref_GroupMission
    WHERE   Code IN (SELECT GroupCode FROM Ref_GroupMissionList)
	 AND    Code IN (SELECT GroupCode FROM Ref_GroupMissionType WHERE MissionType = '#Form.missionType#')
</cfquery>

<cfif topic.recordcount gte "1">
	
	<cfquery name="ResetModule" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_MissionGroup
		WHERE  Mission = '#Form.Mission#'
		AND    GroupCode IN (#quotedValueList(Topic.Code)#)
	</cfquery>
	  
	 <cfloop query="topic">
				        
	     <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
		 
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
  
</cfif>  
  
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
	
	<cfset mis = "#Mission#">
	
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

</cftransaction>

<cfinclude template="MissionEdit.cfm">

