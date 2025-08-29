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
<cfflush>

<cfquery name="Clean" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT * 
	FROM   Accounting.dbo.TransactionHeader
	WHERE  Reference = 'Invoice'
	AND    Mission = 'CMP'
	AND    ReferenceId IN (SELECT InvoiceId 
	                        FROM Invoice 
							WHERE Invoiceid IN (SELECT ReferenceId FROM Accounting.dbo.TransactionHeader WHERE Referenceid is not NULL))
	AND Journal = '20002'						
</cfquery>

<cfloop query="Clean">
	
	<cfquery name="CleanPosting" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		DELETE FROM Accounting.dbo.TransactionHeader
		WHERE  Journal = '#Clean.Journal#'
		AND    JournalSerialNo = '#Clean.JournalSerialNo#'	
	</cfquery>

</cfloop>

<cfquery name="Listing" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  *
	FROM    Invoice 
	WHERE   ActionStatus >= 1
</cfquery>

<cfset URL.ID = "">

<cfoutput query="Listing">

	#currentrow# : #TransactionNo#<br>
	<cfflush>
		
			
	<cfset URL.INVID = Listing.InvoiceId>
	<cfset url.clear = 0>
	
	<cfinclude template="PostInvoice.cfm">		
	
	<cfquery name="Update" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		UPDATE Purchase.dbo.Invoice
		SET ActionStatus='2'
		WHERE InvoiceId='#InvoiceId#'
	</cfquery>	
	
</cfoutput>	