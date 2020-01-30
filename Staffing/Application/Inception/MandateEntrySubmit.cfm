<!---
MandateEntrySubmit.cfm

Create new financial period records (Mandate, Organization, PositionParent, Position, PersonAssignment)

Called by: MandateEntry.cfm

ModificationHistory:
050525 - when creating new personassignment recs, include those recs where DateDeparture
         greater than OR EQUAL TO end of current financial period
050616 - modified InsertPositionParent query to read records from PositionParent (except PositionNo)
		 by joining Position and PositionParent. Previously, only table Position was being read.
050622 - added code to delete temp tables
050629 - following condition added to limit assignment copied to only the last non-revoked assignment for a given individual 
050701 - modify PositionParent copy code to copy only latest PositionParent record for a given IMIS number
050707 - modify InsertAssignment such that DateExpiration and DateDeparture follow these rules:
	     a) If DateDeparture falls within the beginning and 1 day before end of next period, carry over original departure date
		 b) If DateDeparture falls within the beginning and 1 day before end of next period, assign original departure date as new DateExpiration value
		 c) Otherwise, extend both DateDeparture and DateExpiration (in the new period) by 1 year.		    
--->
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_wait>

<cfparam name="Form.MandateDefault" default="0">
<cfparam name="Form.SettingTrack"   default="0">
<cfparam name="Form.SettingUser"    default="0">

<cf_dialogStaffing>

<cfquery name="Verify" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Mission
  WHERE  Mission  = '#URL.Mission#'
</cfquery>

<cfif Verify.MissionStatus eq "1">

    <cf_message message = "Sorry, but I am not able to add a period to a static tree. Request can not be processed!"
      return = "back">
     <cfabort>

</cfif>

<!---
1.	Define current mandate
2.	Entry new mandate into mandate table
3.  Select positions current mandate and insert into position with the 
	a. correct mandateNo and new Effective/Expiration
	b. PositionNosource
4.  Select current assignments (enddate last mandate or blank) and add to PersonAssignment by referring to old position
5.  Show the view (tree view)
6.  Start making modification in position (modify) and refresh view by also updating temp table.
7.  Inherit access rights
--->

<cfparam name="Form.MissionTemplate" default="">

<cfswitch expression="#Len(Form.MandateNo)#">

	<cfcase value="1">
	    <cfset Man = "P00#Form.MandateNo#">
	</cfcase>
	<cfcase value="2">
	    <cfset Man = "P0#Form.MandateNo#">
	</cfcase>
	<cfcase value="3">
        <cfset Man = "P#Form.MandateNo#">
	</cfcase>
	<cfdefaultcase>
    	<cfset Man = "P#Form.MandateNo#">
	</cfdefaultcase>

</cfswitch>

<cfif Len(Man) gt "4">

	<script>
	   alert("You entered an invalid Period No.:<cfoutput>#man#</cfoutput>. Please enter a serialNo up to 999.")
	   history.back()
	</script>

	<cfabort>

</cfif>

<cfquery name="Verify" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT MandateNo
	FROM   Ref_Mandate
	WHERE  Mission  = '#URL.Mission#'
	  AND  MandateNo = '#Man#'
</cfquery>/

<cfif Verify.recordCount gte "1">

	<script>
	   alert("You entered an existing Period No.")
	   history.back()
	</script>

	<cfabort>

</cfif>

<!--- insert mandate --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset STR1 = DateAdd("d","-1",STR)>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset END = dateValue>

<cfif Form.MandateDefault eq "1">

	<cfquery name="Mandate"
	      datasource="AppsOrganization"
	      username="#SESSION.login#"
	      password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_Mandate
			 WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfloop query="Mandate"> 
	
	  <cfquery name="EditMandate"
	      datasource="AppsOrganization"
	      username="#SESSION.login#"
	      password="#SESSION.dbpw#">
	         UPDATE Ref_Mandate
	         SET    MandateDefault = '0'
	         WHERE  Mission = '#URL.Mission#' 
			 AND    MandateNo = '#Mandate.MandateNo#'
	  </cfquery>
	  
	</cfloop>	

</cfif>	

<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg21">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg22">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg11">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg12">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#PersonExtension"> 

<cftransaction>

<cfquery name="InsertMandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_Mandate
	         (Mission,
			  MandateNo,
			  Description,
			  DateEffective,
			  MandateDefault,
			  MandateParent,
			  DateExpiration,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
	  VALUES ('#URL.Mission#',
	          '#man#',
	          '#Form.Description#',
			  #STR#,
			  '#Form.MandateDefault#',
			  '#Form.MissionTemplate#',
			  #END#,
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
</cfquery>

<cfif Form.MissionTemplate neq "None" and Form.MissionTemplate neq "">
		
	<!--- insert/create organization codes --->
	
	<cfquery name="InsertOrganization" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		INSERT INTO Organization
				  (OrgUnitCode, 
				   OrgUnitName, 
				   OrgUnitNameShort,
				   OrgUnitClass, 
				   Mission, 
				   MandateNo, 
				   MissionOrgUnitId, <!--- important field to keep a constant link --->
				   TreeOrder, 
				   TreeUnit,
				   Autonomous,
				   ParentSupport,
				   DateEffective, 
				   DateExpiration, 
				   ParentOrgUnit, 
				   HierarchyRootUnit, 
				   HierarchyCode,
				   Source, 
				   SourceCode,
				   SourceGroup,
				   MissionAssociation,
				   OrganizationCode,
				   Remarks,
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName)
			SELECT  OrgUnitCode, 
			        OrgUnitName, 
					OrgUnitNameShort,
					OrgUnitClass, 
					'#URL.Mission#', 
					'#man#',
					MissionOrgUnitId,  <!--- important field to keep a constant link --->
					TreeOrder, 
					TreeUnit,
					Autonomous,
				    ParentSupport,
					#STR#, 
					#END#,
					ParentOrgUnit, 
					HierarchyRootUnit,
					HierarchyCode,
					Source,
					SourceCode,
					SourceGroup,
					MissionAssociation,
					OrganizationCode,
					Remarks,
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
		FROM    Organization 
		WHERE   Mission   = '#URL.Mission#'
		AND     MandateNo = '#Form.MissionTemplate#'
	</cfquery>
	
	<!--- insert orgunit workforce classification --->
	<cfquery name="InsertClassification" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">  
		INSERT INTO OrganizationCategory
				(OrgUnit, OrganizationCategory, OfficerUserId, OfficerLastName, OfficerFirstName)
		SELECT DISTINCT O.OrgUnit, 
		                Prior.OrganizationCategory, 						
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#'
		FROM   Organization O, 
		       OrganizationCategory Prior, 
			   Organization P 
		WHERE  O.Mission    = '#URL.Mission#' 
		AND    O.MandateNo  = '#man#'
		AND    O.MissionOrgUnitId = P.MissionOrgUnitId
		AND    Prior.Status = '1'
		AND    P.OrgUnit = Prior.OrgUnit
	</cfquery>

	<cf_verifyOperational module="Staffing" Warning="No" Datasource="appsOrganization">

	<cfif Operational eq "1">
	
		<cfquery name="MissionCurrent" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT *
		   FROM   Ref_Mission
		   WHERE  Mission = '#URL.Mission#'
	    </cfquery>
			  					
		<!--- insert parent positions --->
		<cfinclude template="MandateEntryParentPosition.cfm">
			
		<!--- insert postions --->
	    <cfinclude template="MandateEntryPosition.cfm">
			
		<!--- insert orgunit workflow classifications to the new mandate  --->
		<cfquery name="InsertClassification" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">  
				INSERT INTO Employee.dbo.PositionCategory
						(PositionNo, 
						 OrganizationCategory, 
						 Status, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
				SELECT P.PositionNo, 
				       Prior.OrganizationCategory, 
					   Prior.Status,
					   Prior.OfficerUserId, 
					   Prior.OfficerLastName, 
					   Prior.OfficerFirstName
				FROM   Employee.dbo.Position P, 
				       Organization O, 
					   Employee.dbo.PositionCategory Prior
				WHERE  O.Mission    = '#URL.Mission#' 
				AND    O.MandateNo  = '#man#'
				AND    O.OrgUnit    = P.OrgUnitOperational
				AND    P.SourcePositionNo = Prior.PositionNo
		</cfquery>
				
		<!--- insert positiongrouping --->
		<cfquery name="InsertGrouping" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">  
			
			INSERT INTO Employee.dbo.PositionGroup
			
					(PositionNo, 
					 PositionGroup, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			 
				SELECT P.PositionNo, 
				       Prior.PositionGroup, 
					   Prior.OfficerUserId, 
					   Prior.OfficerLastName, 
					   Prior.OfficerFirstName
				FROM   Employee.dbo.Position P, 
				       Organization O, 
					   Employee.dbo.PositionGroup Prior
				WHERE  O.Mission    = '#URL.Mission#' 
				AND    O.MandateNo  = '#man#'
				AND    O.OrgUnit    = P.OrgUnitOperational
				AND    P.SourcePositionNo = Prior.PositionNo
			
			</cfquery>
		
			<!--- insert assignments and contract --->
		    <cfinclude template="MandateEntryAssignment.cfm">
								
	</cfif>	

	<cfif Form.SettingUser eq "1">
	
	    <!--- 22/11/2013 we disabled this as the interface now allows for easy assignment on the mandate level --->		
		<cfinclude template="AccessInherit.cfm">		
		
	</cfif>
	
	

	<cfif Form.SettingTrack eq "1">
	
	    <!--- 22/11/2013 we disabled this as the interface now allows for easy assignment on the mandate level --->		
		
		<cfquery name="InsertGrouping" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">  
		
			UPDATE Vacancy.dbo.DocumentPost
			SET    PositionNo = P.PositionNo
			FROM   Employee.dbo.Position AS P INNER JOIN
                   Vacancy.dbo.DocumentPost AS DP ON P.SourcePositionNo = DP.PositionNo INNER JOIN
                   Vacancy.dbo.Document AS D ON DP.DocumentNo = D.DocumentNo
			WHERE  P.Mission = '#url.mission#' 
			AND    P.MandateNo = '#man#' 
			AND    D.Status = '0' <!--- only active tracks --->
		</cfquery>	
				
	</cfif>	

	</cfif>	

</cftransaction>	
	
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg21">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg22">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg11">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#tmpOrg12">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#access1">
<CF_DropTable dbName="appsQuery"  tblName="#SESSION.acc#access2">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#PersonExtension"> 	

<cfoutput>

	<script language="JavaScript1.2">
	
	 	parent.ColdFusion.navigate('MandateViewTree.cfm?Mission=#URL.Mission#&Mandate=#man#','tree')
		window.location = "MandateListing.cfm?Mission=#URL.Mission#"
		
	</script>

</cfoutput>