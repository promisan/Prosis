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
<cfquery name="Financial" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *		       
		FROM     Ref_ProgramFinancial F
		ORDER BY ListingOrder				
</cfquery>

<cfloop query="financial">

  <cfparam name="FORM.Metric_#Code#" default="">
  <cfparam name="FORM.MetricsPlanned_#Code#" default="">
  <cfparam name="FORM.MetricsReference_#Code#" default="">
  
  <cfset code     = Evaluate("FORM.Metric_#Code#")>
  <cfset plan     = Evaluate("FORM.MetricsPlanned_#Code#")>
  <cfset ref      = Evaluate("FORM.MetricsReference_#Code#")>
  
  <cfset plan = replace(plan,',','',"ALL")>
  
  <cfif LSIsNumeric(plan)>
	  	
	  <cfquery name="Last" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 * 
			FROM     ProgramFinancial
			WHERE    ProgramCode  = '#ProgramCode#'
			AND      Code         = '#Code#'
			ORDER BY DateEffective DESC
	  </cfquery>	
		
	  <cfset lastamt = Last.AmountPlanned>
						
		<cfif lastamt neq plan>
		
			<cfquery name="Insert" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO ProgramFinancial  
				         (ProgramCode, 
						  Code, 
						  DateEffective,
						  AmountPlanned, 
						  Reference, 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
			     VALUES ('#url.ProgramCode#', 
				      	'#Code#', 
						getDate(),
						'#plan#',
				        '#ref#',
			    	 	'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		     </cfquery>		
			 
		 <cfelse>	 
			
		     <cfquery name="Update" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      UPDATE  ProgramFinancial
				  SET     Reference    = '#ref#'			   
				  WHERE   ProgramCode  = '#ProgramCode#' 
				  AND     Code         = '#Code#'
				  AND     DateEffective = '#last.dateeffective#'
		     </cfquery>	 
		
	     </cfif>
		 
	 </cfif>	 
	
</cfloop>

