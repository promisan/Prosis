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
<cfquery name="Check" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
		 FROM  Ref_Object 
		 WHERE Code = '#url.ObjectCode#' 
</cfquery>				 
	
<cfif Check.recordcount eq "0">
	
	<cfoutput>
	<script>
	   alert("Problem object code #url.ObjectCode# does no longer exist")
	</script>
	</cfoutput>

<cfelse>

	<cfif LSisNumeric(URL.percentage)>
		 
		<cftransaction action="BEGIN">
		
			<cfif url.FundingId eq "">
		
		       <cfquery name="Check" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT *
					 FROM RequisitionLineFunding 
					 WHERE RequisitionNo = '#URL.ID#'
					 AND   Fund       = '#url.Fund#'
					 AND   ObjectCode = '#url.ObjectCode#'
					 <cfif url.ProgramCode neq "">
					 AND   ProgramCode = '#url.ProgramCode#'
				 </cfif>
				 
				</cfquery>
				
				<cfif Check.recordcount neq "1">
			
					<cfquery name="InsertFunding" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO RequisitionLineFunding 
					         (RequisitionNo,							 
							 Fund,
							 ObjectCode,
							 ProgramPeriod,
							 <cfif url.ProgramCode neq "">
							 ProgramCode,
							 </cfif>
							 Percentage,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					      VALUES ('#URL.ID#',
					      	  '#url.Fund#',
							  '#url.ObjectCode#',
							  '#url.period#',
							  <cfif url.ProgramCode neq "">
							  '#url.ProgramCode#',
							  </cfif>
							  '#url.Percentage/100#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
					</cfquery>
			
			 	<cfelse>
			
				   <cfquery name="UpdateFunding" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     	UPDATE RequisitionLineFunding SET
							   Percentage       = Percentage + '#url.Percentage/100#',
							   OfficerUserId    = '#SESSION.acc#',
							   OfficerLastName  = '#SESSION.last#',
							   OfficerFirstName = '#SESSION.first#',	
							    Created   = getDate()
						 WHERE FundingId = '#Check.FundingId#'
			    	</cfquery>
			
				</cfif>
			
		<cfelse>	
		
		       <cfquery name="UpdateFunding" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE RequisitionLineFunding SET
				 	 Fund             = '#url.Fund#',
					 ObjectCode       = '#url.ObjectCode#',
					 ProgramPeriod    = '#url.period#',
					 <cfif url.ProgramCode neq "">
					 ProgramCode      = '#url.ProgramCode#',
					 </cfif>
					 Percentage       = '#url.Percentage/100#',
					 OfficerUserId    = '#SESSION.acc#',
					 OfficerLastName  = '#SESSION.last#',
					 OfficerFirstName = '#SESSION.first#',	
					 Created   = getDate()
					 WHERE FundingId = '#url.FundingId#'
		    	</cfquery>
		
		</cfif>
		
		</cftransaction>
	
	</cfif>
	
</cfif>	
  
   
