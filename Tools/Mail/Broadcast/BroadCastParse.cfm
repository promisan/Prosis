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
<cfif recipientcode neq "">
		
		<cfquery name="Data" 
	    datasource="#Listing.QueryDataSource#">
			SELECT * FROM dbo.vwListing#SESSION.acc# 
			WHERE #Key.DrillFieldKey# = '#recipientcode#'  	
		</cfquery> 	
		
<cfelse>
		
		<cfquery name="Data" 
	    datasource="#Listing.QueryDataSource#">
		SELECT * FROM dbo.vwListing#SESSION.acc# 
		WHERE #Mail.FieldName# = '#eMailAddress#'  	
		</cfquery> 	
		
</cfif>

<cfloop query="Fields">
																		 
		 <cfquery name="FieldName" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 	
			SELECT * 
			FROM   Ref_ModuleControlDetailField
			WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
			AND    FunctionSerialNo = '#Broadcast.functionserialNo#'
			AND    FieldName = '#name#'
		</cfquery>		
		
		<cfif FieldName.FieldHeaderLabel neq "">
		
			<cfset fld = FieldName.FieldHeaderLabel>
			
		<cfelse>
		
			<cfset fld = name>
			
		</cfif>
				
		<cfif usertype eq "12">
		    <!--- date field --->
		    <cfset val = dateformat(evaluate("Data.#name#"),CLIENT.DateFormatShow)>							
		<cfelseif usertype eq "8">
		     <!--- number field --->
		    <cfset val = numberformat(evaluate("Data.#name#"),"__,__.__")>	
		<cfelse>
			<cfset val = evaluate("Data.#name#")>						
		</cfif>		
																				
		<cfset body = ReplaceNoCase("#body#", "@#fld#", "#val#", "ALL")>		
	
	</cfloop>			