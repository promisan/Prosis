
<cfoutput>

<cfparam name="url.objectid" default="">

<cftry>

	
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObject
	WHERE      ObjectId = '#URL.Objectid#'
</cfquery>
		
	<cfquery name="Related" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     ObjectId
		FROM       OrganizationObject
		WHERE      EntityCode = '#Object.EntityCode#'
		<cfif Object.ObjectKeyValue1 neq "">
		AND        ObjectKeyValue1 = '#Object.ObjectKeyValue1#' 
		</cfif>
		<cfif Object.ObjectKeyValue2 neq "">
		AND        ObjectKeyValue2 = '#Object.ObjectKeyValue2#' 
		</cfif>
		<cfif Object.ObjectKeyValue3 neq "">
		AND        ObjectKeyValue3 = '#Object.ObjectKeyValue3#' 
		</cfif>
		<cfif Object.ObjectKeyValue4 neq "">
		AND        ObjectKeyValue4 = '#Object.ObjectKeyValue4#' 
		</cfif>	
	</cfquery>
   
	<cfquery name="VerifiedLastAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
		 SELECT     count(*) as Counted
		 FROM       OrganizationObjectActionMail
		 WHERE      ObjectId IN (#quotedvalueList(Related.ObjectId)#)
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