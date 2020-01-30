<!---
	..Travel/PersonMedicalClearanceEditSubmit.cfm
	
	Write user edits to the DocumentCandidateAction record for this person, document, and Medically-Clear Nominee record.
	
	Called by: PersonMedicalClearanceEdit.cfm
	
	Modification History:

--->
<!--- Clearance Effective Date field may be empty --->
<cfset dateValue = "">
<cfif #Form.ActionDateActual# NEQ ''>	
<CF_DateConvert Value="#Form.ActionDateActual#">
	<cfset effdt = #dateValue#>
<cfelse>
	<CF_DateConvert Value="#DateFormat(Now(),Client.DateFormatShow)#">
	<cfset effdt = "">
</cfif>

<!--- verify that a pending DocumentCandidateAction record exists for this 
      1. DocumentNo
	  2. PersonNo
	  3. MedicallyClearNominee step
--->
<cfquery name="Check" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DC.*
	FROM DocumentCandidateAction DC, Document D, FlowActionView FA, EMPLOYEE.DBO.Person P
	WHERE DC.DocumentNo = D.DocumentNo
	AND   DC.ActionId = FA.ActionId
	AND   DC.PersonNo = P.PersonNo
    AND   DC.DocumentNo = #Form.docno#
	AND   DC.PersonNo = '#Form.persno#'
	AND   DC.ActionStatus = '7'
	AND   D.Status IN ('0','1')
	AND   FA.ConditionForView LIKE 'MedicallyClear'
</cfquery>	

<cfif #Check.RecordCount# GT 0>
    <cfquery name="UpdateCand" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
       	 UPDATE DocumentCandidate
      	 SET 	Status        	 = #Form.actionstat#,
	  			StatusDate       = #now()#,
	  			OfficerUserId    = '#SESSION.acc#',
	  			OfficerLastName  = '#SESSION.last#',
	  			OfficerFirstName = '#SESSION.first#'	
      	 WHERE 	DocumentNo  	 = '#Form.docno#'
      	 AND 	PersonNo      	 = '#Form.persno#'
     </cfquery>
	 
	<cfquery name="UpdateCandAction" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
		 UPDATE DocumentCandidateAction
		 SET 	ActionDateActual = #effdt#,
	 		 	ActionStatus     = #Form.actionstat#,
	 	     	ActionUserId     = '#SESSION.acc#',
	  		 	ActionLastName   = '#SESSION.last#',
	  		 	ActionFirstName  = '#SESSION.first#',
				ActionReference  = '#Form.actionref#',
				ActionMemo		 = '#Form.actionmem#',
	  		 	ActionDate       = #now()#
		 WHERE 	DocumentNo 		 = '#Form.docno#'
		 AND   	PersonNo 		 = '#Form.persno#'
		 AND   	ActionId		 = '#Form.actid#'
	</cfquery>	
</cfif>
  
<script language="JavaScript">
   opener.history.go()
   window.close()
</script>	