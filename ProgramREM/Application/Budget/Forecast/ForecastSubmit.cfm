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
<cfquery name="ResetForecast" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ProgramPeriodForecast 
	SET   ForecastCorrection = 0
	WHERE ProgramCode = '#url.ProgramCode#'
	AND   Period = '#url.period#'
</cfquery>

<cfquery name="Audit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Audit
	WHERE   Period = '#url.period#' 	
</cfquery>	



<cfoutput query="Audit">
	
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramPeriodForecast
		WHERE  ProgramCode = '#url.ProgramCode#'
		AND    Period      = '#url.period#'
		AND    AuditId     = '#auditid#' 
	</cfquery>
	
	<cfset corr = evaluate("Form.Correction_#left(auditid,8)#")>
	
	<cfif isvalid("float",corr)> 
		
		<cfif verify.recordcount eq "0">
			
			<cfquery name="Insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramPeriodForecast 
				    	     (ProgramCode,
							 Period,
							 AuditId,
							 ForecastCorrection,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					VALUES ('#url.ProgramCode#', 
					        '#url.period#',
							'#Auditid#',
							'#corr#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
				</cfquery>
		
		<cfelse>
		
				<cfquery name="Verify" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ProgramPeriodForecast
					SET   ForecastCorrection = '#corr#'
					WHERE ProgramCode = '#url.ProgramCode#'
					AND   Period      = '#url.period#'
					AND   AuditId     = '#auditid#' 
				</cfquery>
		
		</cfif>		
		
	</cfif>	

</cfoutput>
