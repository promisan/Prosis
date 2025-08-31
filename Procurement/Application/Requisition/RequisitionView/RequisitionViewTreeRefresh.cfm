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
<cfoutput>

<!--- update the top --->

<cfif url.Role eq "ProcReqReview" 
   or url.Role eq "ProcReqApprove" 
   or url.Role eq "ProcReqBudget" 
   or url.Role eq "ProcReqObject"
   or url.Role eq "ProcReqCertify"> 

<cfinvoke component = "Service.PendingAction.Check"  
   method           = "#url.role#" 
   Mission          = "#URL.Mission#" 
   Period           = "#URL.Period#"
   returnvariable   = "Check">		
   
   <cfif check.total eq "">
   	<cfset tot = 0>
   <cfelse>
    <cfset tot = check.total>	
   </cfif>
   
   <script>
   	  
	   	if (window.parent.document.getElementById('total'))			
    	    window.parent.document.getElementById('total').innerHTML = "#tot#"		
			   
   </script>   
   
</cfif>   

<cfinvoke component = "Service.Process.Procurement.Requisition"  
	method           = "getQueryScope" 
	role             = "#url.role#" 
	Mode             = "Both"
	returnvariable   = "UserRequestScope">	

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   	   SELECT *
	   FROM   Ref_MissionPeriod
	   WHERE  Mission = '#URL.Mission#' 
	   AND    Period  = '#URL.Period#'
</cfquery>

<cfoutput>

<cfsavecontent variable="sQuery">
		  FROM       RequisitionLine L INNER JOIN Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit 				  
		  WHERE      L.Period        = '#URL.Period#'
		  AND        L.RequestType IN ('Regular','Warehouse') 
		  AND        L.ActionStatus != '0'	
		  AND        Org.Mission     = '#URL.Mission#'   
	      AND        Org.MandateNo   = '#Mandate.MandateNo#'	
		  <cfif getAdministrator(url.mission) eq "1">
			   <!--- no filtering --->
		  <cfelse>		
	 	  AND        #preserveSingleQuotes(UserRequestScope)# 		
		  </cfif>	
		  <cfif url.role eq "ProcReqCertify" or url.role eq "ProcManager">
		  AND        L.ActionStatus >= '1p'
		  </cfif>		
</cfsavecontent>	   
	
</cfoutput>
	   	   
<cfquery name="qStatusgetNodeInformation" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	  SELECT    L.ActionStatus, count(*) as Total
	            #preserveSingleQuotes(sQuery)#	
	  GROUP BY  L.ActionStatus 			  
	      	  
</cfquery>	

<cfquery name="qStatus"  
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	  SELECT    Status as ActionStatus
	  FROM      Status
	  WHERE     StatusClass = 'Requisition'  
</cfquery>	   

<!--- update the tree --->

<script language="JavaScript">  

	<cfloop query = "qStatus">
								   
		<cfquery name="get" dbtype="query">
			SELECT   *
		    FROM     qStatusgetNodeInformation
			WHERE    ActionStatus = '#ActionStatus#'			
		</cfquery>
						
		if (parent.document.getElementById('status_#actionstatus#')) {	
		    <cfif get.recordcount eq 1>	  
			 
	         window.parent.document.getElementById('status_#ActionStatus#').innerHTML = '#get.total#'
			<cfelse>
			 window.parent.document.getElementById('status_#ActionStatus#').innerHTML = '0'
			</cfif>
		} else {
		  
		}			
					
	</cfloop>
		
</script>

</cfoutput>