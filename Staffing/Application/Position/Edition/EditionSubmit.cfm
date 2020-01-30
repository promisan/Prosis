
<cfparam name="Form.Operational" default="0">

<cftransaction action="BEGIN">
	
		<cfif URL.ID1 eq "">
		
			<cfquery name="Insert" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PositionParentEdition
			         (PositionParentId,
					 SubmissionEdition,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#URL.ID#',
			      	  '#Form.SubmissionEdition#',
					  '#Form.Operational#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
						
		<cfelse>
			
			   <cfquery name="Update" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE PositionParentEdition
				  SET   Operational = '#Form.Operational#' 
				 WHERE  PositionParentId = '#URL.ID#'
				   AND  SubmissionEdition = '#URL.ID1#'
		    	</cfquery>			
							
		</cfif>
		
</cftransaction>
  	
<script>
	 <cfoutput>
	 #ajaxLink('../Edition/Edition.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	
   
