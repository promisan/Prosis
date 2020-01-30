<!---
	DocumentEntrySubmit.cfm
	
	Page to process saving of new Personnel Request document.
	
	Called by: DocumentEntry.cfm
	
	Modification History:
	21Apr04 - added Remarks and UsualOrigin fields
	10May04 - added Travel Arrangement and SatDate fields
	27Aug04 - added code to make PlannedDeployment field optional field
	14Nov04 - added code to auto-mark identify rotating personnel step as NA when
			  request is form mil personnel and when type is 'Initial deployment'
--->

<cfquery name="AccessTest" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
select * from usernamesgroup where accountgroup='FGSTempAccess'
and account='#SESSION.acc#'
</cfquery>

<!--- 
06/05/2013
Removed by Armin as there was nothing to do with it 
<cfif AccessTest.RecordCount GT 0>
<cfset test="1">
<cflocation url="documententry.cfm">
<cfelse>
<cflocation url="documententry.cfm">
</cfif>
---->


<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfset Client.Datasource = "AppsTravel">

<!--- init FlowClassVal field which is used by record insert query --->
<cfquery name="TravellerType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT TravellerType FROM Ref_Category
	WHERE  Category = '#Form.Category#'
</cfquery>

<cfset flowClassVal = "">
<cfif #TravellerType.TravellerType# eq 'CIVPOL'>
	<cfif #Form.TravelBy# eq 'T'>
		<cfset flowClassVal = "3">
	<cfelse>
		<cfset flowClassVal = "4">
	</cfif>
<cfelse>
	<cfif #Form.TravelBy# eq 'T'>
		<cfset flowClassVal = "1">
	<cfelse>
		<cfset flowClassVal = "2">
	</cfif>
</cfif>

<!--- Check to see if there is any other request that is open for the same FM, PM, Class, and PlannedDeploymentDate --->
<cfquery name="Verify" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM Document
	WHERE	PermanentMissionId	= #Form.p_mission#
	AND		Mission				= '#Form.mission#'
	AND		ActionClass 		= '#flowClassVal#'
	AND		PlannedDeployment	= #Form.planneddeployment#
</cfquery>

<cfoutput>
<input type="hidden" name="mission" value="#Form.mission#">
</cfoutput>


<!--- Test no of records returned by Verify query --->
<!--- May need to revisit the WHERE clause in the Verify query --->
<CFIF #Verify.recordCount# is 1>  <!---********* START OF IF BLOCK *************************** --->
	<p>
	<p>
	<p>
	<p>
	<p>
	<hr>
	<p align="center">
	<cfoutput query = "Verify">
	<font size="2" color="77C5EA">A request to this permanent mission for the field mission and deployment date already exists!</font></p>
	<hr>
	<input type="button" value="Go to Document" onClick="javascript:showdocument(#DocumentNo#); window.close()">
	</cfoutput>	

<CFELSE>	<!---********* ELSE *************************** --->

	<cfquery name="AggregateDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE Parameter SET DocumentNo = DocumentNo+1
	</cfquery>

	<cfquery name="GetDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DocumentNo FROM Parameter
	</cfquery>

<!--- Register EnterRequest action --->
	<CF_RegisterAction 
	SystemFunctionId="1201" 
	ActionClass="Request" 
	ActionType="Enter" 
	ActionReference="#GetDocNo.DocumentNo#" 
	ActionScript="">    

<!--- init ReqDate field which is used by record insert query --->
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.requestdate#">
	<cfset ReqDate = #dateValue#>

<!--- init PlanDeploy field which is used by record insert query --->
	<cfset PlanDeploy = "">
	<cfif #Form.PlannedDeployment# NEQ "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.planneddeployment#">
		<cfset PlanDeploy = #dateValue#>
	</cfif>
	
<!--- init SatDate field which is used by record insert query (10May04)--->
	<cfset SatDt = "">
	<cfif #Form.SatDate# NEQ "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.planneddeployment#">
		<cfset SatDt = #dateValue#>
	</cfif>

<!--- Insert record into table DOCUMENT --->
	<cfquery name="InsertRequest" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	INSERT INTO Document
 		(DocumentNo,
		PermanentMissionId,
		Mission,
		RequestDate,
		PersonCategory,
		PersonCount,
		<cfif #Form.levelrequired# NEQ "">LevelRequired,</cfif>
		<cfif #Form.qualification# NEQ "">Qualification,</cfif>
		DutyLength,
		<cfif #PlanDeploy# NEQ "">PlannedDeployment,</cfif>		<!--- added 27Aug04 --->				
		<cfif #SatDt# NEQ "">SatDate,</cfif>	<!--- added 10May04 --->		
		Status,
		ActionClass,
		TravelArrangement, 						<!--- added 10May04 --->		
		<cfif #Form.ReferenceNo# NEQ "">ReferenceNo,</cfif>
		RequestType,
		<cfif #Form.remarks# NEQ "">Remarks,</cfif>
		UsualOrigin,
		OfficerUserId,
		OfficerUserLastName,
		OfficerUserFirstName,	
		Created)
  	VALUES (#GetDocNo.DocumentNo#,
   		#Form.p_mission#,
		'#Form.mission#',
		#ReqDate#,
		'#Form.category#',
		#Form.personcount#,
		<cfif #Form.levelrequired# NEQ "">Left('#Form.levelrequired#',200),</cfif>
		<cfif #Form.qualification# NEQ "">Left('#Form.qualification#',200),</cfif>
		#Form.dutylength#,
		<cfif #PlanDeploy# NEQ "">#PlanDeploy#,</cfif>	<!--- added 27Aug04 --->
		<cfif #SatDt# NEQ "">#SatDt#,</cfif>	<!--- added 10May04 --->		
		'0',									<!--- '#Form.actionclass#',  MM. 16/9/03 --->
		'#flowClassVal#',
		'#Form.TvlArrBy#',						<!--- added 10May04 --->		
		<cfif #Form.referenceno# NEQ "">Left('#Form.referenceno#',40),</cfif>
		#Form.requesttype#,
		<cfif #Form.remarks# NEQ "">Left('#Form.remarks#',200),</cfif>
		#Form.usualorigin#,		
		'#SESSION.acc#',
    	'#SESSION.last#',
	  	'#SESSION.first#',
		'#DateFormat(Now(),"mm/dd/yyyy")#') 
	</cfquery>
 
 <!--- Insert record into table DOCUMENTFLOW --->
	<cfquery name="InsertFlow" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">  
	INSERT INTO DocumentFlow 
  		(DocumentNo, 
		ActionId, 
		ActionDirectory, 
		ActionClass, 
	 	ActionLevel, 
		ActionType, 
		ActionArea, 
		ActionForm, 
		ActionParent, 
		ActionDescription, 
		ActionCompleted, 
		ActionReferenceShow, 
		ActionReferenceFieldName, 
		ActionOrder, 
	 	ActionOrderSub, 
		ActionLeadTime, 
		ActionResetToOrder, 
		ActionRequired, 
	 	ActionRejectDisabled, 
		ActionByPassDisabled, 
		ActionLevelTrigger, 
		ActionShowAllCandidates,
	 	ActionCandidateRevoke, 
		ActionCandidateBatch, 
		Operational)
	SELECT 
	    #GetDocNo.DocumentNo#,
		A.ActionId, 
		A.ActionDirectory, 
		A.ActionClass, 
		A.ActionLevel, 
	 	A.ActionType, 
		A.ActionArea, 
		A.ActionForm, 
		A.ActionParent, 
		A.ActionDescription, 
		A.ActionCompleted, 
		A.ActionReferenceShow, 
		A.ActionReferenceFieldName, 
		A.ActionOrder, 
	 	A.ActionOrderSub, 
		A.ActionLeadTime, 
		A.ActionResetToOrder, 
	 	A.ActionRequired, 
		A.ActionRejectDisabled, 
		A.ActionByPassDisabled, 
	 	A.ActionLevelTrigger, 
		A.ActionShowAllCandidates, 
		A.ActionCandidateRevoke, 
		A.ActionCandidateBatch, 
		A.Operational 
	FROM FlowAction A
	WHERE Operational  = '1' AND ActionClass = '#flowClassVal#'	
	</cfquery>

<!--- Hanno 02/05/03 Please add later !!!!!!!!!  AND ActionClass = '#Form.ActionClass#' --->
<!--- MM 19/08/03 ActionClass referes to the "processing paths" or "workflows", e.g.,
 1 - MD to Tvl Unit
 2 - MD to MovCon
 3 - CD to Tvl Unit
 4 - CD to MovCon
 ** The values are maintained in table FLOWCLASS **
  Therefore the code block below means: read all workflow steps that are predefined in table
  FLOWACTION which are operational for the selected processing path for this Request record 
--->
	<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT *
	FROM FlowAction
	WHERE Operational = '1' AND ActionClass = '#flowClassVal#'
	</cfquery>
  
<!--- Initialize variables dte, and status which are to be used in the query InsertDocumentAction --->
	<cfset dte = now()>

  	<cfoutput query="action">
  
  	<cfif #ActionLeadTime# neq "">
    	 <cfset dte = DateAdd("d",  #ActionLeadTime#,  #dte#)>
	<cfelse>
    	 <cfset dte = DateAdd("d",  0,  #dte#)>
  	</cfif>
  
  	<cfif #ActionLevel# eq "0">
     	<cfset status = "0">
  	<cfelse>
     	<cfset status = "4">
  	</cfif>

<!--- Insert record into table DOCUMENTACTION --->    
  	<cfquery name="InsertDocumentAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   	INSERT INTO DocumentAction
        (DocumentNo,
		ActionId,
		ActionOrder,
		ActionOrderSub,
		ActionStatus,
		ActionClass,
		ActionDatePlanning)
   VALUES ('#GetDocNo.DocumentNo#',
        '#ActionId#',
	  	'#ActionOrder#',
		'#ActionOrderSub#',
		'#Status#',
 		'#flowClassVal#',
		#dte#)
  	</cfquery>

<!--- If this is "military" request (flowclass 1 or 2) AND RequestType is "InitialDeployment", mark step as N/A --->    
	<cfif #Form.requesttype# EQ 1 AND (#flowClassVal# EQ "1" OR #flowClassVal# EQ "2")>
	  	<cfquery name="MarkStepAsNA" datasource="#CLIENT.Datasource#"
		 username="#SESSION.login#" password="#SESSION.dbpw#">
	   	UPDATE DocumentAction
		SET ActionStatus  		= 8,
			ActionDateActual 	= '#DateFormat(Now(),"mm/dd/yyyy")#',
			ActionUserId 		= '#SESSION.acc#',
			ActionLastName 		= '#SESSION.last#',
			ActionFirstName		= '#SESSION.first#',
			ActionDate			= #Now()#
		WHERE 	DocumentNo = #GetDocNo.DocumentNo#
		AND 	ActionId = 1	
  		</cfquery>
	</cfif>
	    
	</cfoutput> 
  
	<script language="JavaScript">
		opener.location.reload();
	</script>

	<cflocation url="DocumentListing.cfm?IDP_Mission=#FORM.p_mission#"> 
	<cfoutput>
	<script language="JavaScript">
	w = 0
	h = 0
	if (screen) {
		w = screen.width - 60
		h = screen.height - 116
	}
    window.close()
    window.open("DocumentEdit.cfm?ID=#GetDocNo.DocumentNo#", "DocumentEdit", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=no");
	</script>
	</cfoutput>

</CFIF>