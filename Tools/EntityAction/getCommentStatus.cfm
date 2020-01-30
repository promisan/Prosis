
<cfoutput>

<cfparam name="url.objectid" default="">

<cftry>
   
	<cfquery name="VerifiedLastAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
	 SELECT     count(*) as Counted
	 FROM       OrganizationObjectActionMail
	 WHERE      ObjectId = '#url.objectid#'		
	 AND        MailType = 'Comment'
	 <cfif getAdministrator('*') eq "0">
	 AND        MailScope = 'All'
	 </cfif>
	 
	</cfquery>
						
	<cfif verifiedlastaction.counted gte "0">	
				
			<cfif url.last eq "">			
			     <!--- prior action, we trigger a reload --->				
				 <script>   	
				 	   try { clearInterval ( commentrefresh_#left(url.objectid,8)# ) } catch(e) {}		      			   
					   commentreload('#url.objectid#') 
				</script>			
				
			<cfelse>	
													
				<cfif verifiedlastaction.Counted neq url.last>				
				   <!--- different noted, we trigger a reload ---> 				
				  			  
				   <script>  				       
				       try { clearInterval ( commentrefresh_#left(url.objectid,8)# ) } catch(e) {}	 			           				   
					   commentreload('#url.objectid#')  
				   </script>		
				   		   
				<cfelse>				
					<cf_compression>   				   
				 </cfif>  			      
			</cfif>		
	<cfelse>	
		<!--- adjusted 14/8 if this is not found we trigger a workflow and terminate it --->
		<script>
			try { clearInterval ( commentrefresh_#left(url.objectid,8)# ) } catch(e) {}	 
			commentreload('#url.objectid#') 
			try { clearInterval ( commentrefresh_#left(url.objectid,8)# ) } catch(e) {}	
		</script>			
	    <cf_compression>				
	</cfif>
				
<cfcatch>
   <script>   
           
	    try { clearInterval ( commentrefresh_#left(url.objectid,8)# ) } catch(e) {}	
	</script>
</cfcatch>
</cftry>

</cfoutput>	