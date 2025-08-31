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
<cfloop index="itm" from="1" to="4">

     <cfparam name="Form.Crit#itm#_FieldName" default="">
	 
	 <cfif evaluate("Form.Crit#itm#_FieldName") neq "">
	 
	    <cftry>

		<cfquery name="Update" 
		 datasource="appsSystem">
			UPDATE UserReportOutput 
			SET    FieldName      = '#evaluate('Form.Crit#itm#_FieldName')#',
			       FilterOperator = '#evaluate('Form.Crit#itm#_Operator')#',
				   FilterType     = '#evaluate('Form.Crit#itm#_FieldType')#',
				   FilterValue    = '#evaluate('Form.Crit#itm#_Value')#'
			WHERE  UserAccount    = '#SESSION.acc#'
	        AND    OutputId       = '#URL.ID#'
			AND    OutputClass    = 'filter#itm#'
			AND    FieldNameOrder = '#itm#'		    		
		</cfquery>
		
		<cfcatch>
		
		</cfcatch>
		
		</cftry>
		
	</cfif>	

</cfloop>	
