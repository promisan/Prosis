
<cfparam name="Form.accessLevel" default="">
<cfparam name="Form.PreRosterStatus" default="0">
<cfparam name="Form.ShowRosterSearchDefault" default="0">

<CF_DateConvert Value="#Form.MailDateStart#">
<cfset STR = dateValue>

<cfif ParameterExists(Form.Save)> 

	<cfquery name="Action" 
	 datasource="AppsSelection"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Ref_StatusCode
	 SET <cfif Form.accessLevel neq "">
	     AccessLevel  = '#Form.accessLevel#',
		 </cfif>
		 ShowDeniedStatus = '#Form.ShowDeniedStatus#',		
		 <cfif Form.EntityClass neq "">
		 	 EntityClass      = '#Form.EntityClass#',
		 <cfelse>
			 EntityClass      = NULL,
		 </cfif>
		 EnableStatusDate = '#Form.EnableStatusDate#',
		 ShowRoster       = '#Form.ShowRoster#',
		 ShowRosterSearch = '#Form.ShowRosterSearch#',
		 ShowRosterSearchDefault = '#Form.ShowRosterSearchDefault#',	 
		 PreRosterStatus  = '#Form.PreRosterStatus#',
		 EnforceReason    = '#Form.EnforceReason#',
		 MailConfirmation = '#Form.MailConfirmation#',
		 MailBatchDelay   = '#Form.MailBatchDelay#',
		 MailDateStart    = #STR#,
		 MailSubject      = '#Form.MailSubject#',
		 MailText         = '#Form.eMailText#',
		 Meaning          = '#Form.Meaning#' 
	 WHERE Owner  = '#URL.Owner#' 
	   AND Id     = 'Fun'
	   AND Status = '#URL.Status#'
	</cfquery>
	
	<cfquery name="Clear" 
	 datasource="AppsSelection"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM Ref_StatusCodeCriteria
	 WHERE Owner  = '#URL.Owner#' 
	   AND Id     = 'Fun'
	   AND Status = '#URL.Status#'
	</cfquery>
	
	<cfparam name="Form.DecisionCode" default="">
	
	<cfloop index="itm" list="#Form.DecisionCode#" delimiters=",">
		
		<cfquery name="Insert" 
		 datasource="AppsSelection"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO Ref_StatusCodeCriteria
		         (Owner,Id,Status,DecisionCode)
		 VALUES  ('#URL.Owner#','Fun','#URL.Status#','#itm#')
		</cfquery>
		
	</cfloop>
	
	<cfquery name="Clear" 
	 datasource="AppsSelection"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM Ref_StatusCodeProcess
	 WHERE Owner  = '#URL.Owner#' 
	   AND Id     = 'Fun'
	   AND Status = '#URL.Status#'
	   AND Role   = 'RosterClear'
	</cfquery>
	
	<cfquery name="AccessLevels" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT 	*
			 FROM 		Ref_AuthorizationRole 		
			 WHERE 		Role = 'RosterClear' 
	</cfquery>
	
	<cfset processList = "Process,Search">
	
	<cfloop list="#processList#" index="vProcess">
	
		<cfloop index="level" from="0" to="#AccessLevels.accesslevels-1#">
								
			<cfif isDefined("form.accessLevel#vProcess#_#Level#")>
			
				<cfquery name="Insert" 
					 datasource="AppsSelection"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO Ref_StatusCodeProcess (
							 	Owner,
								Id,
								Status,
								Role,
								Process,
								AccessLevel,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
					 VALUES   ('#URL.Owner#',
							   'Fun',
							   '#URL.Status#',
							   'RosterClear',
							   '#vProcess#',
							   '#Level#',
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#'
							  )
				</cfquery>
			</cfif>
			
		</cfloop>
	
	</cfloop>
			
	<cfoutput>		
	<script language="JavaScript">
	     try {
	    parent.opener.processrefresh('#url.owner#') } catch(e) {}
	    parent.window.close()		
	</script>
	</cfoutput>
	
</cfif>