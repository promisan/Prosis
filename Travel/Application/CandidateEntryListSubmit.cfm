<!---
	CandidateEntryListSubmit.cfm
	
	- check if the person picked from the matching list (CandidateEntryList.cfm) is already in Person table.
	- if yes, insert new record into DocumentCandidate and DocumentCandidateAction
	
	Called by: CandidateEntryList.cfm
	Calls: none
	
	Params:
	URL.ID	- Current document no
	URL.ID1 - Current person no
	URL.ID2	- Last name
	URL.ID3 - First name
	URL.ID4 - Category
	URL.ID5 - Deployment Date
	URL.ID6 - Remarks
	URL.ID7 - Rank
	URL.ID8 - PassportNo
	URL.ID9 - PassportIssue
	URL.ID10 - PassportExpiry
	URL.ID11 - PoliceJoinDate
	
	Modification History:
	27Apr04 - added URL.ID8 - URL10 including code to insert passport info into table PersonDocument
	15Jun04 - modified code to check if person has been already been nominated to current request.
		    - instead check if the person already been nominated to any active request.
	24Aug04 - added condition to look only for active candidates when checking for persons currently nominated on a request.
	27Sep04 - removed DateFormat() wrapper on Now() value in the INSERT RECORD statements
--->
<cfif ParameterExists(URL.ID1)>
	<!--- Do nothing --->
<cfelse>
	<cfquery name="AssignNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		UPDATE Parameter SET PersonNo = PersonNo+1
	</cfquery>

	<cfquery name="LastNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM Parameter
	</cfquery>

	<cfparam name="URL.ID1" default="#LastNo.PersonNo#">
	<cfparam name="URL.ID2" default="#Form.LastName#">
	<cfparam name="URL.ID3" default="#Form.FirstName#">
	<cfparam name="URL.ID4" default="#Form.Category#">
	<cfparam name="URL.ID5" default="#Form.PlannedDeployment#">
	<cfparam name="URL.ID6" default="#Form.Remarks#">
	<cfparam name="URL.ID7" default="#Form.Rank#">
	<cfparam name="URL.ID8" default="#Form.PassportNo#">
	<cfparam name="URL.ID9" default="#Form.PassportIssue#">
	<cfparam name="URL.ID10" default="#Form.PassportExpiry#">
	<cfparam name="URL.ID11" default="#Form.ServiceJoinDate#">
	<cfparam name="URL.ID12" default="#Form.SatDate#">	
</cfif>

<!-- Check if person has already been nominated for this request -->
<!--- 15 June 04 - modified code to check if person has already been nominated to any pending request --->
<!--- 24 Aug 04 - added condition to look only for active candidates --->
<cfquery name="Check" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT TOP 1 DocumentNo FROM DocumentCandidate DC
	WHERE DC.PersonNo   = '#URL.ID1#'
	AND   DC.Status <> 6 
	AND   DC.Status <> 9
	<!---AND   DocumentNo = '#URL.ID#'--->
	AND  EXISTS (SELECT * FROM Document D WHERE D.Status = '0' AND D.DocumentNo = DC.DocumentNo)
</cfquery>

<!-- 15 June 04 - If this person has been nominated for a pending request, show alert message and exit -->
<cfif Check.RecordCount GT 0>
   
	<cfoutput>
	<script language="JavaScript">
		alert("Person nominated in request number #Check.DocumentNo#. Person may not be nominated multiple times.");
		//window.location = "CandidateEntry.cfm?ID=#URL.ID#" ;
		window.close() ;
	</script>
	</cfoutput>
	
	<!---******* EXIT TEMPLATE ******--->
	<cfexit method="EXITTEMPLATE">

</cfif>

<!--- Otherwise, save nominee record --->
<cfset join_date = "">
<cfif #URL.ID11# neq ''>	 
		<cfset dateValue = "">
		<cfif Len(#Trim(URL.ID11)#) EQ 4>
			<cfoutput>
			<cfset tmpDt = "31/12" & #Trim(URL.ID11)#>
			<CF_DateConvert Value="#tmpDt#">				
			</cfoutput>
		<cfelse>
			<CF_DateConvert Value="#URL.ID11#">
		</cfif>

		<cfset join_date = #dateValue#>
</cfif>
 
 		
<!-- Get info about the nominee from Person table -->
<cfquery name="Get" datasource="AppsEmployee"  username="#SESSION.login#" password="#SESSION.dbpw#">
  		SELECT * FROM Person
  		WHERE  PersonNo = '#URL.ID1#'
</cfquery>
	
<!--- If a matching Person record is found, assign Category from Add Nominee to that record. --->
<cfif Get.Recordcount NEQ 0>
		<cfquery name="UpdatePersonCategory" datasource="AppsEmployee"  username="#SESSION.login#" password="#SESSION.dbpw#">
  			UPDATE Person
			SET    Category = '#URL.ID4#', 
				   ServiceJoinDate = <cfif #join_date# NEQ "">#join_date#,<cfelse>NULL,</cfif>
			       Rank     = #URL.ID7#
	  		WHERE  PersonNo = '#URL.ID1#'
 		</cfquery>		
</cfif>

<!--- Insert passport info into PersonDocument --->
<!--- Convert date fields to proper format local vars --->
<cfset pass_iss = "">
<cfif #URL.ID9# neq ''>
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#URL.ID9#">
		 <cfset pass_iss = #dateValue#>
</cfif>
	 
<cfset pass_exp = "">
<cfif #URL.ID10# neq ''>	 
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#URL.ID10#">
		 <cfset pass_exp = #dateValue#>
</cfif>
	
 <!--- added 10 May 04 --->
<cfset sat_date = "">
<cfif #URL.ID12# neq ''>	 
    	<cfset dateValue = "">
		<CF_DateConvert Value="#URL.ID12#">	
		<cfset sat_date = #dateValue#>
</cfif>
 
<cfif #URL.ID8# NEQ "">
	
	<cfset sPassportNo = UCase(#URL.ID8#)>

	<!--- register action --->	
	<CF_RegisterAction 
	SystemFunctionId="1265" 
   	ActionClass="Person Document" 
    ActionType="Enter" 
    ActionReference="#URL.ID1# #URL.ID8#" 
    ActionScript="">    

	<cfquery name="InsertPassport" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    	INSERT INTO PersonDocument
		 (PersonNo,
		  DocumentType,
		  DocumentReference,
		  <cfif #pass_iss# neq "">DateEffective,</cfif>
	      <cfif #pass_exp# neq "">DateExpiration,</cfif>
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
	    VALUES 
	     ('#URL.ID1#',
		  'Passport',
		  '#sPassportNo#',
		  <cfif #pass_iss# neq "">#pass_iss#,</cfif>
	      <cfif #pass_exp# neq "">#pass_exp#,</cfif>
		  '#SESSION.acc#',
    	  '#SESSION.last#',
	  	  '#SESSION.first#',
		  #Now()#)
	</cfquery>

</cfif>
 
<!--- submit nominee --->
<cfif #URL.ID5# neq ''>	 
		<cfset dateValue = "">
		<CF_DateConvert Value="#URL.ID5#">
		<cfset deploy_date = #dateValue#>
 <cfelse>
		<cfset deploy_date = "">
</cfif>

<cfset sLastName = UCase(#URL.ID2#)>
 
	<!----CF_RegisterAction 
	SystemFunctionId="1250" 
	ActionClass="Document Candidate" 
	ActionType="Enter" 
 	ActionReference="#URL.ID# #URL.ID1#" 
	ActionScript=""--->

<cfquery name="InsertCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO DocumentCandidate
  		(DocumentNo,
		 PersonNo,
		 LastName,
		 FirstName,
		 <cfif #deploy_date# neq "">PlannedDeployment,</cfif>
	     <cfif #sat_date# neq "">SatDate,</cfif>		 
		 Remarks,		 		 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  	VALUES 
	    ('#URL.ID#',
         '#URL.ID1#',
		 '#sLastName#',
		 '#URL.ID3#',
	     <cfif #deploy_date# neq "">#deploy_date#,</cfif>
	     <cfif #sat_date# neq "">#sat_date#,</cfif>		 
		 '#URL.ID6#',
		 '#SESSION.acc#',
    	 '#SESSION.last#',		  
	  	 '#SESSION.first#',
		 #Now()#)
</cfquery>	
  
<!--- insert steps for this candidate in DocumentCandidateAction --->
      
<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM DocumentFlow
		WHERE Operational  = '1'
		AND ActionLevel    = '1'
		AND DocumentNo  = '#URL.ID#'
</cfquery>
   
<cfset dte = now()>
	
<cfoutput query="action">
  
    <cfif #ActionLeadTime# neq "">
       <cfset dte = DateAdd("d",  #ActionLeadTime#,  #dte#)>
    <cfelse>
       <cfset dte = DateAdd("d",  0,  #dte#)>
    </cfif>
    
    <cfquery name="InsertDocumentAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    INSERT INTO DocumentCandidateAction
            (DocumentNo,
		     PersonNo,
		     ActionId,
			 ActionClass,
		     ActionOrder,
			 ActionOrderSub,
		     ActionDatePlanning)
    VALUES  ('#URL.ID#',
             '#URL.ID1#',
             '#ActionId#',
			 '#ActionClass#',
		     '#ActionOrder#',
			 '#ActionOrderSub#',
		     #dte#)
    </cfquery>
    
</cfoutput> 
  
<script language="JavaScript">
   window.close()
   opener.location.reload()
</script>