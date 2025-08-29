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

<cfparam name="Form.ObjectCode" default="">

<cfif Form.ObjectCode neq "">

<cfif url.id neq "">

<cftransaction action="BEGIN">

     <cfquery name="Clear" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM RequisitionLineBudget 
		 WHERE RequisitionNo = '#URL.ID#'
		 </cfquery>
		 <cfset cnt = 0> 
		 
	<cfloop index="itm" 
	        list="#Form.ObjectCode#" 
			delimiters=",">
			
			<cfset cnt = cnt+1>
								
			<cfset x = ListToArray(itm, "-")>
			<cfset ProgramCode = x[1]>
			<cfset ObjectCode  = x[2]>
			<cfset Fund        = x[3]>
		
	</cfloop>	
	
	<cfset per = int(100/cnt)>
	
	<cfloop index="itm" 
	        list="#Form.ObjectCode#" 
			delimiters=",">
						
			<cfset x = ListToArray(itm, "-")>
			<cfset ProgramCode = x[1]>
			<cfset ObjectCode  = x[2]>
			<cfset Fund        = x[3]>
			<cfset Edition     = x[4]>
				
		    <cfif objectcode neq "">
			
				<cfset cnt = cnt - 1>
				
				<cfif cnt eq "0">
				
					<cfquery name="Check" 
					  datasource="AppsPurchase" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT sum(Percentage) as Percentage
					  FROM RequisitionLineBudget
					  WHERE RequisitionNo = '#URL.ID#'
					 </cfquery>
					 
					 <cfif Check.Percentage eq "">
					     <cfset Check.Percentage = "0">
					 </cfif>
					 	 
					 <cfif Check.Percentage neq "1">
						  <cfset per = 100 - Check.Percentage*100>
					 </cfif>
				 
				</cfif> 
			    	
				<cfquery name="InsertFunding" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineBudget
				         (RequisitionNo,
						 EditionId,
						 Fund,
						 ObjectCode,
						 ProgramCode,
						 Percentage,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Created)
				      VALUES ('#URL.ID#',
					      '#edition#',
						  '#Fund#',
						  '#ObjectCode#',
						  '#ProgramCode#',
						  '#per/100#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#',
						  getDate())
				</cfquery>
				   
			</cfif>
			
	</cfloop>
		
</cftransaction>

</cfif>

</cfif>


<script>
    try {
    parent.opener.document.getElementById('budgetrefresh').click()
	} catch(e) {}
    parent.window.close()
</script>	


   
