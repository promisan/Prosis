
<cfoutput>

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfset actionid      = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset actionstatus  = Evaluate("FORM.actionstatus_" & #Rec#)>
  <cfif actionstatus eq "">
       <cfset #actionstatus# = "0">
  </cfif>
  <cfset dteactual        = Evaluate("FORM.actiondateactual_" & #Rec#)>
  <cfset dtestart         = Evaluate("FORM.actiondatestart_" & #Rec#)>
  <cfset actionmemo       = Evaluate("FORM.actionmemo_" & #Rec#)>
  <cfset actionreference  = Evaluate("FORM.actionreference_" & #Rec#)>
  
  <!--- STATUS : capture values in an array --->
     
   <cfset dateValue = "">
   <cfif dteactual neq "">
       <CF_DateConvert Value="#dteactual#">
       <cfset ActionDateActual = #dateValue#>
   <cfelse>
       <CF_DateConvert Value="#DateFormat(now(), CLIENT.DateFormatShow)#">
       <cfset ActionDateActual = #dateValue#>
   </cfif>	   
   
   <cfset dateValue = "">
   <cfif dtestart neq "">
       <CF_DateConvert Value="#dtestart#">
       <cfset ActionDateStart = #dateValue#>
   <cfelse>
       <cfset ActionDateStart = "NULL">
   </cfif>	   
   <!--- verify if a business rule action is required --->
         
   <cfquery name="Rule" 
   datasource="#CLIENT.Datasource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM FlowActionRule
   WHERE ActionId  = '#actionid#'
   AND  RuleTriggerClass = 'Submit'
   </cfquery>
      
   <cfif #Rule.recordCount# eq 1 AND #actionstatus# eq "1">
   
       <cfmodule template="#Rule.RuleTemplate#"
	   Action   = #Form.DocumentNo#
	   Person   = #Form.PersonNo#
	   ActionId = #actionid#>
	  
       <cfif #go# eq "0">
	       <cfoutput>
		   <script language="JavaScript">
		     alert("#message#");
			 window.location = "DocumentCandidateEdit.cfm?ID=#Form.DocumentNo#&ID1=#Form.PersonNo#" ;
	       </script>
		   </cfoutput>
	       <cfexit method="EXITTEMPLATE">
	   </cfif>
   </cfif>
   
   <cfif #actionstatus# eq "9" or #actionstatus# eq "6">
  
    <cfquery name="UpdateDocument" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      UPDATE DocumentCandidate
      SET Status              = #actionstatus#,
	  StatusDate              = #now()#,
	  StatusOfficerUserId     = '#SESSION.acc#',
	  StatusOfficerLastName   = '#SESSION.last#',
	  StatusOfficerFirstName  = '#SESSION.first#'	
      WHERE DocumentNo        = '#Form.DocumentNo#'	
      AND PersonNo            = '#Form.PersonNo#'
     </cfquery>
    
   </cfif>  
      
   <cfif #actionstatus# eq "2">  <!--- reset --->
   
    <cfquery name="Check" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ActionResetToOrder
      FROM DocumentFlow
	  WHERE ActionId = '#actionid#'
	  AND DocumentNo  = '#FORM.DocumentNo#'
     </cfquery>
	   
     <cfquery name="Update" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      UPDATE DocumentCandidateAction
      SET ActionStatus     = '0',
	  ActionDateActual     =  NULL,
	  ActionUserId         = '#SESSION.acc#',
	  ActionLastName       = '#SESSION.last#',
	  ActionFirstName      = '#SESSION.first#',	
	  ActionDate           = #now()#
	  WHERE DocumentNo     = '#FORM.DocumentNo#'
	  AND PersonNo         = '#Form.PersonNo#'
	  AND ActionOrder     >= '#Check.ActionResetToOrder#'
     </cfquery>
	      
   <cfelse>
   
   <cfquery name="Update" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE DocumentCandidateAction
    SET ActionStatus     = '#ActionStatus#',
	ActionDateActual     = #ActionDateActual#,
	ActionDateStart      = #ActionDateStart#,
	ActionUserId         = '#SESSION.acc#',
	ActionLastName       = '#SESSION.last#',
	ActionFirstName      = '#SESSION.first#',	
	ActionDate           = #now()#,	
	ActionMemo           = '#actionmemo#',	
	ActionReference      = '#actionreference#'
    WHERE DocumentNo     = '#FORM.DocumentNo#'
	AND  ActionId        = '#actionid#'
	AND  PersonNo        = '#Form.PersonNo#'
    </cfquery>
	
	<cfif #actionstatus# eq "1"> 
	
	 <cfquery name="XOR" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT ActionXOR 
	FROM DocumentFlow
	WHERE DocumentNo     = '#FORM.DocumentNo#'
	AND  ActionId        = '#actionid#'
	</cfquery>
	
	<cfif XOR.ActionXOR neq "">
	
	<cfquery name="XOR" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	UPDATE DocumentCandidateAction 
    SET ActionStatus     = '8',
		ActionReference      = 'XOR'
    FROM DocumentCandidateAction D, DocumentFlow F
	WHERE D.DocumentNo     = '#FORM.DocumentNo#'
	AND  D.ActionId        <> '#actionid#'
	AND  D.PersonNo        = '#Form.PersonNo#'
	AND  F.DocumentNo = D.DocumentNo
	AND  F.ActionId   = D.ActionId
	AND  F.ActionXOR = '#XOR.ActionXOR#'
	 </cfquery>
	 
	</cfif> 
		
	</cfif>
	
   </cfif>	
	
    <!--- User action logging --->

    <cf_DocumentActionNo 
       ActionRemarks="" 
   	   ActionCode="ACT">  
	   
	   <cfset ActionNo = #UserActionNo#>

    <!--- roster action line --->

    <cfquery name="DocumentActionAction" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    INSERT INTO  DocumentActionAction
      (DocumentNo,
	  PersonNo,
      ActionId, 
      UserActionNo, 
      ActionDateActual,
	  ActionStatus,
	  ActionMemo)
    VALUES 
      ('#Form.DocumentNo#',
	  '#Form.PersonNo#',
      '#actionId#',
      #ActionNo#,
      #ActionDateStart#,
      '#actionstatus#',
	  '#actionMemo#')
   </cfquery> 

 </cfloop>

  <!--- UNDO action --->
  
  <cfif #Form.undoActionId# neq ''>

     <cfset count=arraynew(1)>
     <cfset i = 1>
   
     <cfloop index="id" list="#FORM.undoactionid#" delimiters=",">
	 	 	   
     <cfquery name="Update" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      UPDATE DocumentCandidateAction
      SET ActionStatus    = '0',
	      ActionDateActual = NULL
      WHERE DocumentNo    = '#FORM.DocumentNo#'
	  AND PersonNo        = '#Form.PersonNo#'
	  AND ActionId        = '#id#'
     </cfquery>
	
     <!--- User action logging --->

     <cf_DocumentActionNo 
       ActionRemarks="" 
   	   ActionCode="REV">  
	   
	   <cfset ActionNo = #UserActionNo#>

     <!--- roster action line --->

     <cfquery name="DocumentActionAction" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      INSERT INTO  DocumentActionAction
        (DocumentNo,
		 PersonNo,
         ActionId, 
         UserActionNo, 
         ActionDateActual,
         ActionStatus)
      VALUES 
        ('#Form.DocumentNo#',
		'#Form.PersonNo#',
        '#Id#',
        #ActionNo#,
        NULL,
        '9')
      </cfquery> 
	  
      <cfset i = i + 1>

    </cfloop>
   
   </cfif> 
  
     
   </cfoutput>
   
   <!--- now check the overall candidate status --->
  
   <cfquery name="GetStatus" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT DocumentNo
    FROM DocumentCandidateAction V
    WHERE (V.ActionStatus  = '0' or V.ActionStatus = '7' or V.ActionStatus = '9')
	AND PersonNo          = '#Form.PersonNo#'
	AND DocumentNo        = '#Form.DocumentNo#'
  </cfquery>
  
  <cfif GetStatus.recordCount eq "0">
  
  <cfquery name="UpdateDocument" 
   datasource="#CLIENT.Datasource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE DocumentCandidate
   SET Status            = '3'
   WHERE DocumentNo      = '#Form.DocumentNo#'	
   AND PersonNo          = '#Form.PersonNo#'
  </cfquery>
    
  </cfif>
   
