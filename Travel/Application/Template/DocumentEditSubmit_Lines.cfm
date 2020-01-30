
<!--- continue from Master --->

<cfoutput>

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfset actionid      = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset actionstatus  = Evaluate("FORM.actionstatus_" & #Rec#)>
  <cfif actionstatus eq "">
       <cfset #actionstatus# = "0">
  </cfif>
  <cfset dteactual     = Evaluate("FORM.actiondateactual_" & #Rec#)>
  <cfset dtestart      = Evaluate("FORM.actiondatestart_" & #Rec#)>
  <cfset actionmemo    = Evaluate("FORM.actionmemo_" & #Rec#)>
  <cfset actionreference  = Evaluate("FORM.actionreference_" & #Rec#)>
  
  <!--- STATUS : capture values in an array --->
     
   <cfset dateValue = "">
   <cfif dteactual neq "">
       <CF_DateConvert Value="#dteactual#">
       <cfset ActionDateActual = #dateValue#>
   <cfelseif #actionstatus# gt "0">
       <cfset ActionDateActual = "#DateFormat(now(), Client.DateFormatShow)#">
      <cfelse>
       <cfset ActionDateActual = "NULL">
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
          
   <cfif #Rule.recordCount# eq 1 AND
       (#actionstatus# eq "1" or #actionstatus# eq "7" or #actionstatus# eq "8")>
   
       <cfmodule template="#Rule.RuleTemplate#"
	   Action   = #Form.DocumentNo#
	   Person   = "0"
	   ActionId = #actionid#
	   ActionStat = #actionstatus#>
	  
       <cfif #go# eq "0">
	       <cfoutput>
		   <script language="JavaScript">
		     alert("#message#");
			 window.location = "DocumentEdit.cfm?ID=#Form.DocumentNo#" ;
	       </script>
		   </cfoutput>
	       <cfexit method="EXITTEMPLATE">
	   </cfif>
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
      UPDATE DocumentAction
      SET ActionStatus     = '0',
	  ActionDateActual     = NULL,
	  ActionUserId         = '#SESSION.acc#',
	  ActionLastName       = '#SESSION.last#',
	  ActionFirstName      = '#SESSION.first#',	
	  ActionDate           = #now()#
	  WHERE DocumentNo     = '#FORM.DocumentNo#'
	  AND ActionOrder     >= '#Check.ActionResetToOrder#'
	  AND ActionStatus   <> '4'
     </cfquery>
	      
   <cfelse>
   
   <cfquery name="Update" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE DocumentAction
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
	AND ActionId         = '#actionid#'
    </cfquery>
	
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
      ActionId, 
      UserActionNo, 
      ActionDateActual,
	  ActionStatus,
	  ActionMemo)
    VALUES 
      ('#Form.DocumentNo#',
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
	 
	 <!--- define to which step it has to be reset --->
		   
     <cfquery name="Update" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      UPDATE DocumentAction
      SET ActionStatus    = '0'
      WHERE DocumentNo    = '#FORM.DocumentNo#'
	  AND ActionId        = '#id#'
	  AND ActionStatus <> '4'
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
         ActionId, 
         UserActionNo, 
         ActionDateActual,
         ActionStatus)
      VALUES 
        ('#Form.DocumentNo#',
        '#Id#',
        #ActionNo#,
        NULL,
        '9')
      </cfquery> 
	  
      <cfset i = i + 1>

    </cfloop>
   
</cfif> 
 
</cfoutput>
   
<!--- now check the overall status --->
   
   <cfquery name="GetStatus" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT DocumentNo
    FROM DocumentAction V
    WHERE V.ActionStatus = '0'
	AND DocumentNo = '#Form.DocumentNo#'	
  </cfquery>
  
  <cfif GetStatus.recordCount eq "0">
  
  <cfquery name="UpdateDocument" 
   datasource="#CLIENT.Datasource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE Document
   SET Status            = '1'
   WHERE DocumentNo = '#Form.DocumentNo#'	
  </cfquery>
    
  </cfif>

<cfoutput>
<script>
  window.location="DocumentEdit.cfm?ID=#Form.DocumentNo#"
</script>  
</cfoutput>
 
<!---<cflocation url="DocumentEdit.cfm?ID=#Form.DocumentNo#" addtoken="No"> --->
  
