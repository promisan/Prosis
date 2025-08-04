<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.line" default="'0'">
<cfparam name="Form.RequisitionNo" default="'#url.line#'">

<cftransaction>
	
	<!--- Select --->
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   RequisitionLineQuote
		WHERE  RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
	</cfquery>
	
	<!--- Remove lines --->
	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM RequisitionLineQuote
		WHERE RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
	</cfquery>
	
	<!--- Remove purchase buyer created lines --->
	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM RequisitionLine
		WHERE  RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
		AND    RequestType = 'Purchase'
	</cfquery>
	
	<!--- Reset link remaining requisitions --->
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE RequisitionLine
		SET    JobNo = NULL, 
		       ActionStatus = '2k'
		WHERE RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
	</cfquery>
	
	<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,				
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 SELECT   RequisitionNo, 
			          '2k',
					  getdate(),
					  'Removed from Job', 
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
					  '#SESSION.first#'
			 FROM     RequisitionLine
			 WHERE    RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)		  	     
	</cfquery>
	
</cftransaction>	

<!--- check if job is valid for any lines  --->

<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     RequisitionLine
	WHERE    JobNo = '#url.id1#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<!--- Remove lines --->
	<cfquery name="Remove" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Job
	WHERE JobNo = '#URL.ID1#'
	</cfquery>

	<cf_tl id="Job" var="1">
	<cfset vJob=#lt_text#>
			
	<cf_tl id="REQ066" var="1">
	<cfset vReq066=#lt_text#>

	<cf_message message = "#vJob# [#URL.ID1#] #vReq066#" return="no">
	
<cfelse>	

	<cfoutput>
	
	<cfset url.sort = "Line">		
	<cfinclude template="JobViewVendor.cfm">

	</cfoutput>

</cfif>


