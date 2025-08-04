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

<cfif url.scope eq "Activity">

	 <!--- ------------- --->
     <!--- Activity code --->
	 <!--- ------------- --->

	 <cfquery name="Clean" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM FinancialObjectAmountActivity
			WHERE ObjectId = '#URL.ID#'
			AND   SerialNo = '#URL.ser#'
	 </cfquery>
	 
	 <cfif URL.act eq "true">
	
		<cftry>
	
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO FinancialObjectAmountActivity
						(ObjectId,
						 SerialNo,
						 ActivityId,
						 OfficerUserid, 
						 OfficerLastName,
						 OfficerFirstName)
				VALUES
					('#url.id#','#url.ser#','#url.code#','#SESSION.acc#','#SESSION.last#','#SESSION.first#') 
			</cfquery>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
	  </cfif>	

<cfelseif url.scope eq "Program">

     <!--- ------------ --->
     <!--- Program code --->
	 <!--- ------------ --->

	 <cfquery name="Clean" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM FinancialObjectAmountProgram
			WHERE ObjectId = '#URL.ID#'
			AND   SerialNo = '#URL.ser#'
	 </cfquery>
	 
	 <cfif URL.act eq "true">
	
		<cftry>
	
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO FinancialObjectAmountProgram
						(ObjectId,
						 SerialNo,
						 ProgramCode,
						 OfficerUserid, 
						 OfficerLastName,
						 OfficerFirstName)
				VALUES
					('#url.id#','#url.ser#','#url.code#','#SESSION.acc#','#SESSION.last#','#SESSION.first#') 
			</cfquery>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
	<cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		DELETE FROM FinancialObjectAmountProgram
		WHERE ObjectId = '#URL.ID#'
		AND   SerialNo = '#url.ser#'
		AND   ProgramCode = '#URL.Code#'
		</cfquery>
	
	</cfif>	
	 	 

<cfelse>
	
	<cfif url.mode is "Single"> 
		
		<cfquery name="Clean" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM FinancialObjectAmountCategory
			WHERE ObjectId = '#URL.ID#'
			AND   SerialNo = '#URL.ser#'
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Clean" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM FinancialObjectAmountCategory
			WHERE ObjectId = '#URL.ID#'
			AND   SerialNo = '#URL.ser#'
			AND   Category IN (SELECT Code 
			                   FROM Ref_Category 
							   WHERE CategoryClass IN (SELECT CategoryClass 
							                           FROM Ref_Category
													   WHERE Code = '#URL.Code#')) 
		</cfquery>
		
	
	</cfif>

	<cfif URL.act eq "true">
	
		<cftry>
	
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO FinancialObjectAmountCategory
						(ObjectId,
						 SerialNo,
						 Category,
						 OfficerUserid, 
						 OfficerLastName,
						 OfficerFirstName)
				VALUES
					('#url.id#','#url.ser#','#url.code#','#SESSION.acc#','#SESSION.last#','#SESSION.first#') 
			</cfquery>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
	<cfelse>
	
		<cfquery name="Insert" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		DELETE FROM FinancialObjectAmountCategory
		WHERE ObjectId = '#URL.ID#'
		AND   SerialNo = '#url.ser#'
		AND   Category = '#URL.Code#'
		</cfquery>
	
	</cfif>	
	
</cfif>	

<cf_compression>