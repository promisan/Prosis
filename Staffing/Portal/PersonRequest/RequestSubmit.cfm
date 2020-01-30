
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfquery name="qCheck" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonRequest
	WHERE  PersonNo   = '#Form.PersonNo#'
	AND    Reference    = '#Form.Reference#'
	AND    EventCode    = '#Form.EventCode#'
	AND    Mission      = '#Form.Mission#'
	AND    RequestDate  = #STR#
</cfquery>

<cfif qCheck.recordCount gte 1> 

   <cf_tl id="You entered an existing record. Operation not allowed." var="1">
   <cf_alert message = "#lt_text#">
	
<cfelse>	

	<cf_AssignId>
	<cfset RequestId = rowguid>

	<cfquery name="InsertRequest" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     INSERT INTO PersonRequest (
		         RequestId,
		         PersonNo,
				 Reference,
				 Mission,
				 EventCode,
				 RequestDate,
				 RequestMemo,
				 ActionStatus,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      VALUES ('#RequestId#',
	      		  '#Form.PersonNo#',
	      		  '#Form.Reference#',
			  	  '#Form.Mission#',
			  	  '#Form.EventCode#',
		          #STR#,
				  '#Form.RequestMemo#',				
				  '0',				 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>	
	
	<cfquery name="qPerson" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT * 
	 	FROM Person
	 	WHERE PersonNo = '#FORM.PersonNo#'
	</cfquery> 

	<cfset link = "Staffing/Application/Portal/PersonRequest/RequestEntry.cfm?id=#Form.PersonNo#&id1=#RequestId#">

     <cf_ActionListing 
         EntityCode       = "PersonRequest"
           EntityClass      = "Standard"
           EntityGroup      = ""
           EntityStatus     = ""     
           PersonNo         = "#FORM.Personno#"
           ObjectReference2 = "#qPerson.FirstName# #qPerson.LastName#" 
           ObjectKey4       = "#RequestId#"
           AjaxId           = "#Requestid#" 
           ObjectURL        = "#link#"
           Show             = "No">


	 <cfoutput>
		<script language = "JavaScript">			
		    ptoken.navigate('#SESSION.root#/Staffing/Portal/PersonRequest/PersonRequestDetails.cfm?mode=edit&webapp=#url.webapp#&ID=#Form.PersonNo#','requestdetail')
	 	</script>	
	 </cfoutput>
 
</cfif>