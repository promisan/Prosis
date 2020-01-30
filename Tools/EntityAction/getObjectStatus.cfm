
<cfparam name="url.objectid" default="">
<cfparam name="session.authent" default="">

<cfif session.authent neq "1">

    <cfoutput>
	 <script>   		    	         
	    try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {}
	</script>
	</cfoutput>

<cfelse>
  
	<cftry>
	
		<cfquery name="VerifiedLastAction" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   TOP 1 OfficerDate
			 FROM     OrganizationObjectAction
			 WHERE    ObjectId = '#url.ObjectId#'
			 AND      ActionStatus IN ('2','2Y','2N')		 
			 ORDER BY OfficerDate DESC 
		</cfquery>		
			
		<cfoutput>
							
		<cfif verifiedlastaction.officerdate neq "">	
		
				<cfif url.lastaction eq "">			
				
				     <!--- prior action, we trigger a reload --->				
					 <script>   					
					 	   try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {}			      			   
						   workflowreload('#url.ajaxid#') 
					</script>			
					
				<cfelse>	
						
					<cfset timediff = DateDiff("s", url.lastaction, VerifiedLastAction.officerdate)>				
					<cfif timediff neq "0">				
					   <!--- different noted, we trigger a reload ---> 				
					   <script> 				   			       
					       try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {}  			           				   
						   workflowreload('#url.ajaxid#') 
					   </script>				   					
					 </cfif>  			      
				</cfif>		
				
		<cfelse>	
		
			<!--- workflow is completely open no actions --->
		
			<cfif url.lastaction eq "">
			
				<!--- no action, nothing changed --->
			
			<cfelse>
				
				<!--- adjusted 14/8 if this is not found we trigger a workflow and terminate it --->
				<script>			    
					try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {} 				
					workflowreload('#url.ajaxid#') 
					try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {}
				</script>			
			
			</cfif>
				
		    <cf_compression>				
			
		</cfif>
			
	    </cfoutput>	
					
	<cfcatch>
	
	   <script>   		         
		    try { clearInterval ( workflowrefresh_#left(url.objectid,8)# ) } catch(e) {}
		</script>
		
	</cfcatch>
	
	</cftry>
	
</cfif>	
