<!---
	DocumentEntrySubmit.cfm
	
	Page to process saving of new Personnel Request document.
	
	Called by: DocumentEntry.cfm
	
	Modification History:
	21Apr04 - added Remarks and UsualOrigin fields
	10May04 - added Travel Arrangement and SatDate fields
--->


<!--- Register EnterRequest action 
	<CF_RegisterAction 
	SystemFunctionId="1201" 
	ActionClass="Request" 
	ActionType="Enter" 
	ActionReference="#GetDocNo.DocumentNo#" 
	ActionScript="">    
--->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfset CLIENT.Datasource = "AppsTravel">
<!---
<cfparam name="URL.DocumentNo" default="0">
<cfparam name="URL.Category" default="">
<cfparam name="URL.Class" default="">
--->

<cfoutput>
<cfquery name="TravellerType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT TravellerType FROM Ref_Category
	WHERE  Category = '#URL.ID1#'
</cfquery>
</cfoutput>

<!--- Count # of rotating personnel that have not been matched to nominees --->    
<cfquery name="NonMatchedRotatingPersonnel" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   	SELECT * 
	FROM DocumentRotatingPerson
	WHERE DocumentNo = '#URL.ID#'
	AND  (ReplacementPersonNo IS NULL OR ReplacementPersonNo = '')
</cfquery>

<!--- Create a copy of current Document record --->
<cfquery name="AggregateDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE Parameter SET DocumentNo = DocumentNo+1
</cfquery>

<cfquery name="GetDocNo" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DocumentNo FROM Parameter
</cfquery>

<!--- Insert record into table DOCUMENT --->
<cfquery name="InsertRequest" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	INSERT INTO Document
 		(DocumentNo,
		DocumentNoTrigger,		
		PermanentMissionId,
		Mission,
		RequestDate,
		PersonCategory,
		PersonCount,
		LevelRequired,
		Qualification,
		DutyLength,
		PlannedDeployment,
		SatDate,
		Status,
		ActionClass,
		TravelArrangement,
		RequestType,
		Remarks,
		UsualOrigin,
		OfficerUserId,
		OfficerUserLastName,
		OfficerUserFirstName,	
		Created)
  	SELECT 
	    #GetDocNo.DocumentNo#,
		#URL.ID#,
		PermanentMissionId,
		Mission,
		RequestDate,
		PersonCategory,
		#NonMatchedRotatingPersonnel.RecordCount#,
		LevelRequired,
		Qualification,
		DutyLength,
		PlannedDeployment,
		SatDate,
		Status,
		ActionClass,
		TravelArrangement,
		RequestType,
		Remarks,
		UsualOrigin,
		'#SESSION.acc#',
    	'#SESSION.last#',
	  	'#SESSION.first#',
		'#DateFormat(Now(),"mm/dd/yyyy")#'
	FROM Document
	WHERE DocumentNo = '#URL.ID#'
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
	WHERE Operational  = '1' AND ActionClass = '#URL.ID2#'	
</cfquery>

<!--- Read FlowAction table --->
<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * 
	FROM FlowAction
	WHERE Operational = '1' AND ActionClass = '#URL.ID2#'
</cfquery>
  
<!--- Loop through each record retrieved from FlowAction --->  
<cfoutput query="Action">

	<!--- Initialize variables dte, and status which are to be used in the query InsertDocumentAction --->
	<cfset dte = now()>
  
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
 		'#URL.ID2#',
		#dte#)
	</cfquery>

</cfoutput> 

<!--- Copy rotating personnel that have not been matched to nominees into the new document --->    
<cfquery name="InsertDocumentRotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   	INSERT INTO DocumentRotatingPerson (DocumentNo, PersonNo, 
			SourceId, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
	SELECT #GetDocNo.DocumentNo#, PersonNo, 
	        DocumentNo, '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', '#DateFormat(Now(),"mm/dd/yyyy")#'
	FROM   DocumentRotatingPerson
	WHERE  DocumentNo = '#URL.ID#'
	AND   (ReplacementPersonNo IS NULL OR ReplacementPersonNo = '')
</cfquery>

<cfoutput>
<script language="JavaScript">	
	//alert("New request number #GetDocNo.DocumentNo# has been created.");
	//opener.location.reload();
	opener.location.href="DocumentEdit.cfm?ID=#GetDocNo.DocumentNo#"
	window.close();	
</script>
</cfoutput>

<!---
<cflocation url="DocumentListing.cfm?IDP_Mission=#URL.ID3#"> 
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
--->