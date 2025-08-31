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
<cfparam name="Object.ObjectKeyValue4" default="">		  
<cfparam name="URL.TransactionId" default="#Object.ObjectKeyValue4#">	

<cfquery name="Header" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   TransactionHeader
		WHERE  TransactionId  ='#URL.TransactionId#'		
</cfquery>	

<cfif Header.PrintDocumentId neq "">

    <cfset url.docid = Header.PrintDocumentId>
	<cfset url.id  = "Print">
	<cfset url.id1 = "Financial Transaction">
			
	<cfinclude template="../../../../Tools/Mail/MailPrepare.cfm">
			
<cfelse>
	
	<!--- not defined --->

</cfif>		


