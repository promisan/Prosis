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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfif ParameterExists(Form.Save)>

	<cfoutput>
		
		<cfif Form.Deadline eq "">
			
		    <cfset dte = "NULL">
			
		<cfelse>
				
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.Deadline#">
		<cfset dte = #dateValue#>
	
	</cfif>
	
	</cfoutput>

	<cfquery name="Insert" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE Job 
	   SET <!--- OrderClass = '#Form.OrderClass#', --->
	  	   Description      = '#Form.Description#',
	       CaseNo           = '#Form.CaseNo#',
		   CaseReference    = '#Form.CaseReference#',
		   Period           = '#Form.Period#',
		   QuotationRemarks = '#Form.QuotationRemarks#',
		   QuotationContact = '#Form.QuotationContact#',
		   <cfif dte neq "NULL">
			   DeadLineHour  = '#form.deadlinehour#',
			   DeadLine      = #dte# 
		   <cfelse>
		   	   DeadLineHour  = '#form.deadlinehour#',
			   DeadLine      = #dte# 
		   </cfif>	   
	   WHERE JobNo = '#URL.ID1#'
	</cfquery>

</cfif>

<cfif ParameterExists(Form.Delete)>
	
	<cftransaction>	
		
		<!--- make a logging --->
		
		<cfquery name="RequestLine" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   RequisitionLine 		  
		   WHERE  JobNo = '#URL.ID1#'
		</cfquery>
		
		<cfloop query="RequestLine">
		
			<cf_assignId>
		
			<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineAction 
							 (RequisitionNo, 
							  ActionId,
							  ActionStatus, 
							  ActionDate, 
							  ActionMemo,
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
							  
				     VALUES ('#RequisitionNo#', 
					         '#rowguid#',
					         '2k', 
							 getdate(), 
							 'Job Cancellation',
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#')
			</cfquery>	
		
		</cfloop>		
				
		<cfquery name="reset" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE RequisitionLine 
		   SET    ActionStatus = '2k', 
		          JobNo = NULL
		   WHERE  JobNo = '#URL.ID1#'
		</cfquery>
		
		<cfquery name="delete" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   DELETE FROM Job
		   WHERE  JobNo = '#URL.ID1#'
		</cfquery>
	
	</cftransaction>

</cfif>
	
<cfoutput>

<script language="JavaScript"> 
	   window.location="JobViewGeneral.cfm?header=No&Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Role=#URL.Role#"					 
</script>

</cfoutput>

