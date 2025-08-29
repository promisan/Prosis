<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="GetMail" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Journal 
	WHERE  Journal IN (SELECT Journal FROM TransactionHeaderAction WHERE ActionId = '#url.actionid#')					 						 				 
</cfquery>	

<cfquery name="Customer" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		UPDATE   TransactionHeaderAction
		SET      EMailAddress = '#email#'
		WHERE    ActionId = '#url.actionid#'       
</cfquery>

<cfif GetMail.eMailTemplate neq "">
	<cfinclude template="../../../../#GetMail.emailTemplate#">
<cfelse>
	<cf_receiptLedger actionid="#url.actionid#">	
</cfif>

<script>
	alert('eMail sent')
</script>

	