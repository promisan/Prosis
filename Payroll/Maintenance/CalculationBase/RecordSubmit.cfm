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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.BaseAmount" default="0">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_CalculationBase
	WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>   
   
	   	<cftransaction>
		
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_CalculationBase
		         (Code, 
				  Description, 
				  BaseAmount,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#Form.Code#',
        		  '#Form.Description#', 
				  '#Form.BaseAmount#',
				  '#session.acc#',
				  '#session.last#',
				  '#session.first#')
  	   </cfquery>
	   	   	   
		<cfquery name="Schedule"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM SalarySchedule
		</cfquery>
		
	   <cfloop query="schedule">
	   
	   	   <cfparam name="Form.PayrollItem_#SalarySchedule#" default="">		   
	   	   <cfset lsch   = Evaluate("Form.PayrollItem_#SalarySchedule#")>
		   <cfset sch = SalarySchedule>
		   	   
		   <cfloop index="itm" list="#lsch#" delimiters=",">
		   
			   <cfquery name="Insert" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_CalculationBaseItem
				         (Code, 
						  SalarySchedule, 
						  PayrollItem)
				  VALUES ('#Form.Code#',
				          '#sch#',
		        		  '#itm#')
		  	   </cfquery>
		   
		   </cfloop>
	   
	   </cfloop>	  
	   
	   </cftransaction> 
		     		  
    </cfif>		
	
	  
           
</cfif>

<cfif ParameterExists(Form.Update)>

		<cftransaction>

		<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_CalculationBase
			SET    Description      = '#Form.Description#', 
				   BaseAmount       = '#Form.BaseAmount#' 
			WHERE Code   = '#Form.CodeOld#'
		</cfquery>
		
		<cfquery name="Delete" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_CalculationBaseItem
			WHERE Code   = '#Form.CodeOld#'
		</cfquery>
		
		<cfquery name="Schedule"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM SalarySchedule
		</cfquery>
				
		<cfloop query="schedule">
			   
		   	   <cfparam name="Form.PayrollItem_#SalarySchedule#" default="">		   
		   	   <cfset lsch = Evaluate("Form.PayrollItem_#SalarySchedule#")>
			   <cfset sch  = SalarySchedule>
				   	   
			   <cfloop index="itm" list="#lsch#" delimiters=",">
			   
			           <cftry>
				   
						   <cfquery name="Insert" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO Ref_CalculationBaseItem
								         (Code,SalarySchedule,PayrollItem)
								VALUES   ('#Form.Code#','#sch#','#itm#')
					  	   </cfquery>
					   
					   <cfcatch></cfcatch>
					   
					   </cftry>
				   
			   </cfloop>
			   
		</cfloop>
		
		</cftransaction>

	
</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
		FROM SalaryScalePercentage
		WHERE CalculationBase = '#Form.CodeOld#'
	</cfquery>
	    
    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">	    
		   alert("Code is in use. Operation aborted.")		        
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_CalculationBase
			WHERE Code = '#Form.CodeOld#'
		</cfquery>
			
	</cfif>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.history.go()        
</script>  
