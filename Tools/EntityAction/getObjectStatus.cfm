<!--
    Copyright © 2025 Promisan

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
	
	<cfoutput>
		<img style="height:12px;padding-top:4px;cursor:pointer" src="#session.root#/images/logos/system/refresh.png" border="0" title="Last check #timeformat(now(),'hh:mm:ss')#">		
	</cfoutput>
	
</cfif>	


