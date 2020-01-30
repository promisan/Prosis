
<cfset name = evaluate("Form.MessageName_#box#")>
<cfset subj = evaluate("Form.MessageSubject_#box#")>
<cfset text = evaluate("Form.MessageText_#box#")>

<cfquery name="update" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     UPDATE FunctionOrganizationMessage
	 SET    MessageName      = '#name#',
	        MessageSubject   = '#subj#', 
		    MessageText      = '#text#',
		    OfficerUserid    = '#session.acc#',
		    OfficerLastName  = '#session.last#',
		    OfficerFirstName = '#session.first#',
		    Created          = #now()# 
	 WHERE  MessageId = '#MessageId#'			 	
</cfquery>

saved!