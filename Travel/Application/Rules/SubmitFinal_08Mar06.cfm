<!--- 
	  Travel/Application/Rules/submitFinal.cfm
	  
	  Once candidate has arrived in the field mission...
      a. Create a positionparent record
      b. Create a position record	  
	  c. Create a personassignment record
	  
	  Called by: Travel/Application/Template/DocumentEditCandidateBatchSubmit.cfm
	  Params:
		  Action, Person, ActionId (see below for description)
		  
	 Modification history:
	 11Oct04 - modified GetMissionInfo query to not use DefaultOrganization table.
	 15Nov04 - modified GetMissionInfo query to use TRAVEL.DBO.Ref_TVL_Mandate instead of Ref_Mandate
	 		 - and use appropriate or unit
--->

<cfparam name="Attributes.Action" default="0">   	<!--- this the DocumentNo --->
<cfparam name="Attributes.Person" default="0">	 	<!--- this the PersonNo --->
<cfparam name="Attributes.ActionId" default="0">	<!--- this the ActionId (=36 for Milestone step --->

<cfset CLIENT.Datasource = "AppsTravel">

<!--- Select all candidates for this request that have been marked as "selected" in the Complete Travel Authorization step --->
<cfquery name="CheckCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
      SELECT PersonNo FROM DocumentCandidate
	  WHERE DocumentNo = #Attributes.Action#
	  AND Status = '3'
</cfquery>

<!--- Check if there is any action pending (other than "In-Process") for the "selected" candidates (those that have
	  completed the "Complete Travel Authorization" step) for steps prior to the Milestone: Traveller arrives in FM step. --->
<cfquery name="CheckActionPending" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
      SELECT CA.PersonNo  FROM DocumentCandidateAction CA, DocumentCandidate C
	  WHERE CA.DocumentNo 	= #Attributes.Action#
	  AND 	CA.DocumentNo 	= C.DocumentNo
	  AND 	CA.PersonNo 	= C.PersonNo
	  AND 	CA.ActionId 	< #Attributes.ActionId#
<!---	  AND (CA.ActionStatus  = '0' or CA.ActionStatus = '7' or CA.ActionStatus = '9')   DO NOT TRAP 'In Process' actions for now --->
	  AND 	(CA.ActionStatus = '0' or CA.ActionStatus = '9')	  
	  AND 	C.Status 		= '3'
</cfquery>

<!--- If there is no (non-stalled) candidate that has completed the "Complete TA step" OR
      if candidates who have completed the "Complete TA step" has pending prior actions,
	  DISCONTINUE processing --->
<CFIF CheckCandidate.recordCount eq 0 or CheckActionPending.recordCount gt 0>
   <cfset caller.go = "0">  
   <cfset caller.message = "No candidates have been completely processed. Operation not allowed">
<CFELSE>   
   <!--- Create position parent record --->
   <!--- 1. Get current mission, mandate, postgrade, posttype , and org unit.  The Org Unit is 
            based on Traveller Type. Retrieve the OrgUnit id of default unit which will accept the 
            newly deployed personnel.  This information is stored in DefaultOrganization table

         2. 11Oct04. Redesign GetMissionInfo query to use vwMaxOrgUnit view (instead of DefaultOrganization table)
		    to identify the org unit to use in entries to the tables Position and PositionParent.
			Table DefaultOrganization has been deleted from the Travel db.
		 
		    - assumption here is that the MaxOrgUnit value returned by vwMaxOrgUnit view is the
              correct default org unit that will be used when creating entries to tables Position and PositionParent
    --->
	
   <!---cfquery name="GetMissionInfo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">   
      SELECT RM.Mission, RM.MandateNo, RM.DateEffective, RM.DateExpiration, C.Category, C.TravellerType, O.OrgUnit
	  FROM Document D, ORGANIZATION.DBO.Ref_Mandate RM, Ref_Category C, DefaultOrganization O 
	  WHERE D.Mission = RM.Mission
	  AND   D.PersonCategory = C.Category
	  AND   D.Mission = O.Mission
	  AND   C.TravellerType = O.TravellerType
	  AND   D.DocumentNo = #Attributes.Action#
   </cfquery--->
	
   <cfquery name="GetMissionInfo" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">   
    SELECT RM.Mission, RM.MandateNo, RM.DateEffective, RM.DateExpiration, C.Category, C.TravellerType, O.OrgUnit
	  FROM Document D, Ref_TVL_Mandate RM, Ref_Category C, Organization.dbo.Organization O
	  WHERE D.Mission = RM.Mission
	  AND   D.PersonCategory = C.Category
	  AND   RM.Mission = O.Mission
	  AND   RM.MandateNo =  O.MandateNo
	  AND   C.TravellerType = O.Source
	  AND   D.DocumentNo = #Attributes.Action#
	  AND   RM.MandateDefault = 1				
	  AND   O.SourceCode = 'DEFAULT'
<!---	  15Nov04 -- used new code above in lieu of version below
      SELECT RM.Mission, RM.MandateNo, RM.DateEffective, RM.DateExpiration, C.Category, C.TravellerType, O.MaxOrgUnit AS OrgUnit
	  FROM Document D, Ref_Mandate RM, Ref_Category C, Organization.dbo.Organization O
	  WHERE D.Mission = RM.Mission
	  AND   D.PersonCategory = C.Category
	  AND   D.Mission = O.Mission
	  AND   C.TravellerType = O.Source
	  AND   D.DocumentNo = #Attributes.Action#
	  AND   RM.MandateDefault = 1					<!--- added 1Nov04 --->
	  AND   O.SourceCode = 'DEFAULT'
--->	  
   </cfquery>

   <!--- FORMAT DATES INTO LOCAL DATE VARIABLES --->
   <cfset dateValue = "">
   <cfif #GetMissionInfo.DateEffective# NEQ "">
	   	<CF_DateConvert Value="#GetMissionInfo.DateEffective#">
	   	<cfset eff_date = #dateValue#>
   <cfelse>
		<cfset eff_date = "">
   </cfif>
   
   <cfset dateValue = "">
   <cfif #GetMissionInfo.DateExpiration# NEQ "">
   		<CF_DateConvert Value="#GetMissionInfo.DateExpiration#">
	   	<cfset exp_date = #dateValue#>
   <cfelse>
	    <cfset exp_date = "">
   </cfif>

   <cfset dateValue = "">
   <cfif #FORM.ActionDateActual# NEQ "">
   		<CF_DateConvert Value="#FORM.ActionDateActual#">
	   	<cfset DateAction = #dateValue#>
   <cfelse>
        <cfset DateAction = "">
   </cfif>
   
    <!---  NEED VALIDATION ROUTINES HERE TO FORCE RTN TO FAIL IF INCOMPLETE DATA 
   <cfif GetMissionInfo.recordCount eq 0>
   	 	<cfset caller.go = "0">  
   		<cfset caller.message = "Error: Unable to retrieve data needed to create a position record.">
   </cfif> 
   --->
   
    <!--- 2. Retrieve default function no and function description from DefaultFunction table --->
   <cfquery name="GetFunctionInfo" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">   
      SELECT F.FunctionNo, F.FunctionDescription
	  FROM DefaultFunction F
	  WHERE F.Category = '#GetMissionInfo.Category#'
   </cfquery>  

   <!---
   <cfset select = "spCreatePersonAssignment">
   <cfstoredproc procedure="#select#" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID"      	value="#SESSION.acc#"        			null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERLNAME"   	value="#SESSION.last#"       			null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERFNAME"   	value="#SESSION.first#"      			null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@REQNO"       	value="#ATTRIBUTES.action#" 			null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@PERSNO"      	value="#ATTRIBUTES.person#" 			null="No"> 
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MISSION"     	value="#GetMissionInfo.Mission#"   		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MANDATE"     	value="#GetMissionInfo.Mandate"    		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@ORGUNIT"     	value="#GetMissionInfo.OrgUnit#"   		null="No"> 
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FUNCTIONNO"   	value="#GetFunctionInfo.FunctionNo#"   	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FUNCTIONDESC" 	value="#GetFunctionInfo.FunctionDescription#"  null="No">   
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRAVTYPE"     	value="#GetMissionInfo.TravellerType"   null="No">  
   <cfprocparam type="In" cfsqltype="CF_SQL_DATE"    dbvarname="@DATEEFF"      	value="#GetMissionInfo.DateEffective"   null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_DATE"    dbvarname="@DATEEXP"      	value="#GetMissionInfo.DateExpiration"  null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_DATE"    dbvarname="@DATEACTION"   	value="#DateAction#"     				null="No">
   </cfstoredproc>
   
   !---- FOLLOWING CODE MOVE TO spCreatePersonAssignment in TRAVEL --------------------------------------->
   
   <cftransaction action="BEGIN">
	  
   <cfquery name="AddPositionParent" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">   
   	  INSERT INTO PositionParent
	        (Mission,
			 MandateNo,
			 OrgUnitAdministrative,
			 OrgUnitOperational,
			 FunctionNo,
			 FunctionDescription,
			 PostGrade,
			 PostType,
		     <cfif #eff_date# neq "">DateEffective,</cfif>
		     <cfif #exp_date# neq "">DateExpiration,</cfif>
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Created)
		VALUES 
		    ('#GetMissionInfo.Mission#',
   			 '#GetMissionInfo.MandateNo#',
			 #GetMissionInfo.OrgUnit#,
			 #GetMissionInfo.OrgUnit#,
			 '#GetFunctionInfo.FunctionNo#',
			 '#GetFunctionInfo.FunctionDescription#',
   			 '#GetMissionInfo.TravellerType#',
   			 '#GetMissionInfo.TravellerType#',
		     <cfif #eff_date# neq "">'#DateFormat(GetMissionInfo.DateEffective,"mm/dd/yyyy")#',</cfif>
		     <cfif #exp_date# neq "">'#DateFormat(GetMissionInfo.DateExpiration,"mm/dd/yyyy")#',</cfif>
			 '#SESSION.acc#',
		     '#SESSION.last#',
			 '#SESSION.first#',
		 	 '#DateFormat(Now(),"mm/dd/yyyy")#')
   </cfquery>
   
   <!--- AT EACH DATABASE WRITE POINT. CHECK FOR SUCCESS!  THIS WHOLE SERIES OF RTNS SHOULD BE EMBEDDED IN A TRANSACT BLOCK --->
   
   <!--- Get id of newly created record from PositionParent table --->
   <cfquery name="GetPositionParentId" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">   
      SELECT MAX(PositionParentId) AS MaxId FROM PositionParent 
   </cfquery>
   	  
   <cfquery name="AddPosition" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">   
   	  INSERT INTO Position
	        (PositionParentId,
 			 Mission,
			 MandateNo,
			 MissionOperational,
			 OrgUnitAdministrative,
			 OrgUnitOperational,
			 FunctionNo,
			 FunctionDescription,
			 PostGrade,
			 PostType,
			 Source,
		     <cfif #eff_date# neq "">DateEffective,</cfif>
		     <cfif #exp_date# neq "">DateExpiration,</cfif>
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Created)
		VALUES 
		    (#GetPositionParentId.MaxId#,
			 '#GetMissionInfo.Mission#',
   			 '#GetMissionInfo.MandateNo#',
			 '#GetMissionInfo.Mission#',
			 #GetMissionInfo.OrgUnit#,
			 #GetMissionInfo.OrgUnit#,
			 '#GetFunctionInfo.FunctionNo#',
			 '#GetFunctionInfo.FunctionDescription#',
   			 '#GetMissionInfo.TravellerType#',
   			 '#GetMissionInfo.TravellerType#',
			 'PM Travel',
		     <cfif #eff_date# neq "">'#DateFormat(GetMissionInfo.DateEffective,"mm/dd/yyyy")#',</cfif>
		     <cfif #exp_date# neq "">'#DateFormat(GetMissionInfo.DateExpiration,"mm/dd/yyyy")#',</cfif>
			 '#SESSION.acc#',
		     '#SESSION.last#',
			 '#SESSION.first#',
		 	 '#DateFormat(Now(),"mm/dd/yyyy")#')
   </cfquery>			 

   <!--- AT EACH DATABASE WRITE POINT. CHECK FOR SUCCESS!  THIS WHOLE SERIES OF RTNS SHOULD BE EMBEDDED IN A TRANSACT BLOCK --->   
   <cfset dateValue = "">
   <cfif #FORM.ActionDateActual# NEQ "">
	   <CF_DateConvert Value="#FORM.ActionDateActual#">
	   <cfset DateAction = #dateValue#>
   <cfelse>
       <cfset DateAction = "">
   </cfif>

   <!--- Get id of newly created record from Position table --->
   <cfquery name="GetPositionNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">   
      SELECT MAX(PositionNo) AS MaxId FROM Position
   </cfquery>

   <!--- Get Tour of Duty Length from Document table --->
   <cfquery name="GetTOD" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">   
      SELECT DutyLength FROM TRAVEL.DBO.Document WHERE DocumentNo = #Attributes.Action#
   </cfquery>
         
   <!---  create PersonAssignment record --->
   <cfquery name="AddPersonAssigment" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	  INSERT INTO PersonAssignment 
	        (PersonNo,
			 PositionNo,
		     <cfif #DateAction# neq "">DateArrival,</cfif>
		     <cfif #DateAction# neq "">DateEffective,</cfif>
		     <cfif #exp_date# neq "">DateExpiration,</cfif>
		     <cfif #DateAction# neq "">DateDeparture,</cfif>
			 OrgUnit,
			 FunctionNo,
			 FunctionDescription,
			 Parent,
			 ParentId,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Created)
	  SELECT 
	         P.PersonNo, 
	  		 #GetPositionNo.MaxId#, 
		     <cfif #DateAction# neq "">#DateAction#, </cfif>
		     <cfif #DateAction# neq "">#DateAction#, </cfif>
		     <cfif #exp_date# neq "">'#DateFormat(GetMissionInfo.DateExpiration,"mm/dd/yyyy")#',</cfif>
		     <cfif #DateAction# neq "">#DateAdd("m",GetTOD.DutyLength,DateAction)#,</cfif>
			 #GetMissionInfo.OrgUnit#,
			 '#GetFunctionInfo.FunctionNo#',
			 '#GetFunctionInfo.FunctionDescription#',
			 'PM Travel',
			 #Attributes.Action#,
    		 '#SESSION.acc#',
    	     '#SESSION.last#',		  
	  	     '#SESSION.first#',
		     '#DateFormat(Now(),"mm/dd/yyyy")#'
	  FROM  TRAVEL.DBO.DocumentCandidate DC, TRAVEL.DBO.Document D, Person P
      WHERE DC.DocumentNo = D.DocumentNo
	  AND   DC.PersonNo = P.PersonNo
	  AND   DC.DocumentNo = #Attributes.Action#
	  AND   DC.PersonNo = '#Attributes.Person#'
   </cfquery>

   <!---  get latest assignment number.  this must be done right after the AddPersonAssignment step --->
   <cfquery name="GetAssignNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT Max(AssignmentNo) As MaxAssNo FROM PersonAssignment
   </cfquery>
   
   </cftransaction>
   
   <cfset caller.go = "1"> 
   <cfset caller.message = "Candidates assignment record successfully created.">   
</CFIF>