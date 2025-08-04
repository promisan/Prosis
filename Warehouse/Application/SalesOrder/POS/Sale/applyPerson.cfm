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

<!--- this template 
1. adds a line to the list which it receives from the extended listing which has a form which passes
2. refreshes the listing 
--->

<!--- defined price --->

<cfquery name="setPersonNo" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	UPDATE  CustomerRequestLine 
	SET     SalesPersonNo = '#url.PersonNo#'
	WHERE   TransactionId IN (SELECT   TOP 1 TransactionId
			  				  FROM     CustomerRequestLine 
							  WHERE    RequestNo = '#url.RequestNo#'
							  ORDER BY Created DESC)	
	
</cfquery>	

<cfinclude template="SaleViewLines.cfm">

