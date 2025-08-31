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
<cfif isValid("email","#url.email#")>		
	
	<cfquery name="Customer" 
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			UPDATE   TransactionHeaderAction
			SET      EMailAddress = '#email#'
			WHERE    ActionId = '#url.actionid#'       
	</cfquery>
			
	<cfoutput>
	
		<cf_tl id="eMail" var="1">
							
		<input type="button" 
		     class="button10g" 
		     onclick="ptoken.navigate('#session.root#/GLedger/Application/Transaction/Invoice/doInvoiceMail.cfm?actionid=#url.actionid#','mailbox')" 
		     style="height:28;width:150;font-size:13px;border:1px solid silver" class="regular" name="save" id="save" value="#lt_text#">
			
	</cfoutput>

</cfif>		 