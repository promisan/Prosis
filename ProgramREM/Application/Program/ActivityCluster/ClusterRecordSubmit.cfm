 
<cfparam name="url.action" default="">
 
<cfif URL.Action eq "delete">
		 		 	 
		<cfquery name="Delete" 
		     datasource="AppsProgram" 
    		 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
    		 DELETE FROM ProgramActivityCluster
			  WHERE  ActivityClusterId   = '#URL.ID2#' 
		</cfquery>		
			
		<cfset URL.id2 = "new">	 
	 
<cfelseif URL.desc eq "">

	<cf_tl id="Please enter a description" var="1" class="message">
	<cfset msg1="#lt_text#">	
	<cfoutput>
		<tr><td colspan="4">#msg1#</td></tr>
	</cfoutput>
		
<cfelse>	
			 	
	 <cfif URL.ID2 eq "new">
		  	  	  		      		
			<cfquery name="Insert" 
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO  ProgramActivityCluster
						      (ProgramCode, 
							   ClusterDescription,
							   ListingOrder,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName)
				  VALUES ('#URL.ProgramCode#',
				          '#URL.desc#',
						  '#URL.Orde#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			 </cfquery>	
					 
															 
	 <cfelse>
		 		 
	 	<cfquery name="Update" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ProgramActivityCluster
			SET    ClusterDescription  = '#URL.Desc#',
				   ListingOrder        = '#URL.Orde#'
			WHERE  ActivityClusterId   = '#URL.ID2#' 
		 </cfquery>	
		 
		 <cfset URL.id2 = "new">
		 
		 </cfif>
		 	 	
</cfif>

<cfinclude template="ClusterRecord.cfm">  


