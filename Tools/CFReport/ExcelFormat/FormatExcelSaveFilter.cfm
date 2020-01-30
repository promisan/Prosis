
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
