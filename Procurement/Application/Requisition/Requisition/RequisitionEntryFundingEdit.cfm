
<!--- check the object code --->

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
  
   
