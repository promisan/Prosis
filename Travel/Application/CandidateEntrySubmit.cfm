<!---
	CandidateEntrySubmit.cfm
	
	Process user request to save new candidate record.

	Called by: CandidateEntry.cfm
	
	Modification history:
	24Sep03 - Placed code to save LastName and Passport Number in uppercase
	23Oct03 - added code to update DocumentRotatingPerson to record person rotaing out
				of the field mission with the incoming candidate
	07Nov03 - removed passportissueplace from save fields after securing ok from Masaki
	17Feb04 - added query InsertPassport to handle creation of new passport record in PersonDocument
	        - modified InsertPerson to remove code related to writing of passport data
			  as these fields no longer in Person table
	27Apr04 - added code to handle entry of IndexNo during CandidateEntry
	27Sep04 - removed DateFormat() wrapper on Now() value in the INSERT RECORD statements
--->	
<cfquery name="AssignNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
  UPDATE Parameter SET PersonNo = PersonNo+1
</cfquery>

<cfquery name="LastNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
  SELECT * FROM Parameter
</cfquery>

<cfif #Form.BirthDate# NEQ ""> 
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.BirthDate#">
	 <cfset BirthDay = #dateValue#>
<cfelse>
	 <cfset BirthDay = "">
</cfif>

<!--- added 6 May 04 --->
<cfset join_date = "">
<cfif IsDefined("Form.ServiceJoinDate")>
    <cfset dateValue = "">
 	<cfif #Form.ServiceJoinDate# NEQ ""> 
		<cfif Len(#Trim(Form.ServiceJoinDate)#) EQ 4>
			<cfoutput>
			<cfset tmpDt = "31/12" & #Trim(Form.ServiceJoinDate)#>
			<CF_DateConvert Value="#tmpDt#">				
			</cfoutput>
		<cfelse>
			 <CF_DateConvert Value="#Form.ServiceJoinDate#">	
		</cfif>
		<cfset join_date = #dateValue#>
	</cfif>
</cfif>

 <!--- added 10 May 04 --->
<cfset sat_date = "">
<cfif IsDefined("Form.SatDate")>
    <cfset dateValue = "">
 	<cfif #Form.SatDate# NEQ ""> 
		<CF_DateConvert Value="#Form.SatDate#">	
		<cfset sat_date = #dateValue#>
	</cfif>
</cfif>

<cfif #Form.PassportIssue# NEQ "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#FORM.PassportIssue#">
	 <cfset pass_iss = #dateValue#>
<cfelse>
	 <cfset pass_iss = "">
</cfif>
	 
<cfif #Form.PassportExpiry# NEQ "">	 
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#FORM.PassportExpiry#">
	 <cfset pass_exp = #dateValue#>
<cfelse>
	 <cfset pass_exp = "">
</cfif>
 
<cfif #Form.PlannedDeployment# NEQ "">	 
	<cfset dateValue = "">
	<CF_DateConvert Value="#FORM.PlannedDeployment#">
	<cfset deploy_date = #dateValue#>
<cfelse>
	<cfset deploy_date = "">
</cfif>

<cfset sLastName = UCase(#FORM.LastName#)>
<cfset sPassportNo = UCase(#FORM.PassportNo#)>
<cfset sRemarks = Left(#FORM.PassportNo#,200)>

  <!---CF_RegisterAction 
   SystemFunctionId="1260" 
   ActionClass="Person" 
   ActionType="Enter" 
   ActionReference="#LastNo.PersonNo#" 
   ActionScript=""---> 
    
<!--- Submit person --->
<cfquery name="InsertPerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO Person
         (PersonNo,
		 IndexNo,
		 LastName,
  		 MiddleName,
		 FirstName,
		 Category,
		 Rank,
		 Gender,
		 <cfif #Birthday# NEQ "">BirthDate,</cfif>
		 Nationality,
	     BirthNationality,		 
		 <cfif #join_date# NEQ "">ServiceJoinDate,</cfif>
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
    VALUES ('#LastNo.PersonNo#',
		 '#FORM.IndexNo#',		
	     '#sLastName#', 
		 '#FORM.MiddleName#',
		 '#FORM.FirstName#',
		 '#FORM.Category#',
		 '#FORM.Rank#',
		 '#FORM.Gender#',
		 <cfif #Birthday# NEQ "">#BirthDay#,</cfif>
		 '#FORM.Nationality#',
		 '#FORM.BirthNationality#',		 
		 <cfif #join_date# NEQ "">#join_date#,</cfif>
		 '#SESSION.acc#',
    	 '#SESSION.last#',		  
	  	 '#SESSION.first#',
		 #Now()#)
</cfquery>

<!--- added 27Sep04 MM - only process passport no handling if a passport number was in fact entered. --->  
<cfif #Form.PassportNo# NEQ ''>

	  <CF_RegisterAction 
	   SystemFunctionId="1265" 
	   ActionClass="Person Document" 
	   ActionType="Enter" 
	   ActionReference="#LastNo.PersonNo# #Form.PassportNo#" 
	   ActionScript="">    

	  <cfquery name="InsertPassportRec" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	    INSERT INTO PersonDocument
		 (PersonNo,
		  DocumentType,
		  DocumentReference,
		  <cfif #pass_iss# NEQ "">DateEffective,</cfif>
	      <cfif #pass_exp# NEQ "">DateExpiration,</cfif>
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
    	VALUES 
	     ('#LastNo.PersonNo#',
		  'Passport',
		  '#sPassportNo#',
		  <cfif #pass_iss# NEQ "">#pass_iss#,</cfif>
	      <cfif #pass_exp# NEQ "">#pass_exp#,</cfif>
		  '#SESSION.acc#',
    	  '#SESSION.last#',
	  	  '#SESSION.first#',
		  #Now()#)
	  </cfquery>
  
</cfif>
  
  <!--- submit candidate 
  <CF_RegisterAction 
   SystemFunctionId="1250" 
   ActionClass="Document Candidate" 
   ActionType="Enter" 
   ActionReference="#Form.DocumentNo# #LastNo.PersonNo#" 
   ActionScript="">    --->
   
<cfquery name="InsertCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO DocumentCandidate
         (DocumentNo,
		 PersonNo,
		 LastName,
		 FirstName,
		 <cfif #deploy_date# NEQ "">PlannedDeployment,</cfif>
		 <cfif #sat_date# NEQ "">SatDate,</cfif>		 
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  	VALUES ('#Form.DocumentNo#',
         '#LastNo.PersonNo#',
	     '#sLastName#', 
		 '#Form.FirstName#',
	     <cfif #deploy_date# NEQ "">#deploy_date#,</cfif>
	     <cfif #sat_date# NEQ "">#sat_date#,</cfif>		 
	     '#sRemarks#', 
		 '#SESSION.acc#',
    	 '#SESSION.last#',		  
	  	 '#SESSION.first#',
		 #Now()#)
</cfquery>	
  
<!--- insert steps --->    
<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT *
	FROM DocumentFlow
	WHERE Operational  = '1'
	AND ActionLevel    = '1'
	AND DocumentNo  = '#URL.ID#'
</cfquery>
   
<cfset dte = now()>
  
<cfoutput query="action">
  
	<cfif #ActionLeadTime# NEQ "">
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
             '#LastNo.PersonNo#',
             '#ActionId#',
			 '#ActionClass#',
		     '#ActionOrder#',
			 '#ActionOrderSub#',
		     #dte#)
	</cfquery>
    
</cfoutput> 
  
<!-- Establish link between this candidate and the person rotating out of the mission -->
<!-- Note that variable FORM.RotatingPersonNo is only defined in CandidateEntry.cfm when
	 PersonCategory is 'UNMO'. -->
<cfif IsDefined("FORM.RotatingPersonNo")>
	<cfquery name="UpdateDocumentRotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		UPDATE DocumentRotatingPerson
		SET ReplacementPersonNo = '#LastNo.PersonNo#'
		WHERE DocumentNo = '#URL.ID#'
	  	AND   PersonNo = '#FORM.RotatingPersonNo#'
	</cfquery>
</cfif>

<script language="JavaScript">
   window.close()
   opener.location.reload()
</script>