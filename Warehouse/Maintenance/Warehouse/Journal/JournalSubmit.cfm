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
<cfset areaList = "STOCK,COGS,SALE,SETTLE,INTEROFFICE">

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cftransaction>

	<cfquery name="clear" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    DELETE FROM WarehouseJournal
		WHERE    	Warehouse = '#url.id1#'
	</cfquery>
	
	<cfloop list="#areaList#" index="area">
	
		<cfloop query="Currency">
			
			<cfif isDefined("Form.Journal_#area#_#Currency.currency#")>
				
				<cfset vJournal = evaluate("Form.Journal_#area#_#Currency.currency#")>
				
				<cfif vJournal neq "">
				
					<cfset vMode = "1">
					<cfif isDefined("Form.Mode_#area#_#Currency.currency#")>
						<cfset vMode = evaluate("Form.Mode_#area#_#Currency.currency#")>
					</cfif>
					
					<cfset vMail = "0">
					<cfif isDefined("Form.Mail_#area#_#Currency.currency#")>
						<cfset vMail = evaluate("Form.Mail_#area#_#Currency.currency#")>
					</cfif>
				
					<cfset vMemo = "">
					<cfif isDefined("Form.Memo_#area#_#Currency.currency#")>
						<cfset vMemo = evaluate("Form.Memo_#area#_#Currency.currency#")>
					</cfif>
					
					<cfset vTemplate1 = "">
					<cfif isDefined("Form.TemplateMode1_#area#_#Currency.currency#")>
						<cfset vTemplate1 = evaluate("Form.TemplateMode1_#area#_#Currency.currency#")>
					</cfif>
					
					<cfset vTemplate2 = "">
					<cfif isDefined("Form.TemplateMode2_#area#_#Currency.currency#")>
						<cfset vTemplate2 = evaluate("Form.TemplateMode2_#area#_#Currency.currency#")>
					</cfif>
				
					<cfquery name="Insert" 
					     datasource="AppsMaterials" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO WarehouseJournal
					         	(Warehouse,
								Area,
								Currency,
								Journal,
								TransactionMode,
								TransactionMail,
								TransactionTemplateMode1,
								TransactionTemplateMode2,
								TransactionMemo,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName)
					      VALUES ('#url.id1#',
						  		'#area#',
								'#currency.currency#',
								'#vJournal#',
								'#vMode#',
								'#vMail#',
								'#vTemplate1#',
								'#vTemplate2#',
								'#vMemo#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')
					</cfquery>
					
				</cfif>
				
			</cfif>
		
		</cfloop>
		
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ptoken.navigate('Journal/Journal.cfm?id1=#url.id1#','contentbox2');
	</script>
</cfoutput>