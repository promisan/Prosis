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
<cfquery name="get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM   TransactionHeader
	WHERE  TransactionId = '#url.transactionid#'        
</cfquery>

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Journal, 
             JournalSerialNo, 
			 TransactionCheckId, 
			 CheckNo, 
			 CheckDate, 
			 CheckPayee, 
			 CheckAmount, 
			 CheckAmountText, 
			 CheckMemo, 
			 CheckOfficer, 
             OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName, 
			 Created			 
	FROM     TransactionIssuedCheck
	WHERE    TransactionCheckId = '#url.id#'        
</cfquery>

<cfset amt = replace("#form.checkamount#",",","","ALL")>

<cfif not LSIsNumeric(amt)>
	
	<script>
	    alert('Incorrect amount #amt#')					
	</script>	 
		
	<cfabort>
	
</cfif>

<cfif Form.checkDate neq ''>
    <CF_DateConvert Value="#Form.CheckDate#">
	<cfset dte = dateValue>
<cfelse>
    <cfset dte = 'NULL'>
</cfif>	

<cfif form.actionBankId neq "">

<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   TransactionHeader
		SET      ActionBankId     = '#Form.ActionBankId#'		
		WHERE    TransactionId    = '#get.TransactionId#'  	   
	</cfquery>
	
</cfif>	

<cfif check.recordcount eq "1">
	
	<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   TransactionIssuedCheck
		SET      CheckDate          = #dte#,
		         CheckNo            = '#form.checkNo#',
		         CheckPayee         = '#Form.CheckPayee#',
			     CheckAmount        = '#amt#',
			     CheckAmountText    = '#Form.CheckAmountText#',
			     CheckMemo          = '#Form.CheckMemo#',
			     OfficerUserId      = '#session.acc#',
			     OfficerLastName    = '#session.last#',
			     OfficerFirstName   = '#session.first#'
		WHERE    TransactionCheckId = '#url.id#'  	   
	</cfquery>

<cfelse>	
	
	<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO TransactionIssuedCheck
				(Journal,
				 JournalSerialNo,
				 TransactionCheckId, 
				 CheckNo, 
				 CheckDate, 
				 CheckPayee, 
				 CheckAmount, 
				 CheckAmountText, 
				 CheckMemo, 		
				 CheckOfficer,		 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName )			 
		VALUES ('#get.Journal#',
		        '#get.JournalSerialNo#',
				'#url.id#', <!--- organizationObject.ActionId --->
				'#Form.checkNo#', 
				#dte#,
				'#Form.CheckPayee#',
				'#amt#',
				'#Form.CheckAmountText#',
				'#Form.CheckMemo#',
				'#session.acc#',
				'#session.acc#',
				'#session.last#',
				'#session.first#')
	</cfquery>
		   
</cfif>		   
