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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Transaction utilities Queries">	

	<cffunction name="LogTransaction"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
		
		<cfargument name="Datasource"          type="string"  required="true"   default="AppsLedger">							
		<cfargument name="Journal"             type="string"  required="true"   default="">								
		<cfargument name="JournalSerialNo"     type="string"  required="true"   default="">		
		<cfargument name="TransactionSerialNo" type="string"  required="true"   default="">					
		<cfargument name="Action"              type="string"  required="true"   default="Delete">		
								
		<cfquery name="tablecontent" 
		    datasource="#datasource#"  
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT   C.name, C.userType 
		    FROM     Accounting.dbo.SysObjects S, Accounting.dbo.SysColumns C 
			WHERE    S.id = C.id
			AND      S.name = 'TransactionLine'	
			AND      C.Name NOT IN ('OfficerUserId','OfficerLastName','OfficerFirstname','Created')
			ORDER BY C.ColId			
		</cfquery>
		
		<cfquery name="LogDeleteAction"
		    datasource="#datasource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			INSERT INTO Accounting.dbo.TransactionLineLog
			(LogAction,OfficerUserId,OfficerLastName,OfficerFirstName,<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
				SELECT '#Action#', 
				       '#SESSION.acc#',
				       '#SESSION.last#',
					   '#SESSION.first#',<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop> 
				FROM   Accounting.dbo.TransactionLine
				WHERE  Journal             = '#Journal#'
				AND    JournalSerialNo     = '#JournalSerialNo#'
				<cfif transactionSerialNo neq "">
				AND    TransactionSerialNo = '#TransactionSerialNo#'
			    </cfif>
		</cfquery>						
								
	</cffunction>					
	
</cfcomponent>	