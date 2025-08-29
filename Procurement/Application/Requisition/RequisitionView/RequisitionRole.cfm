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
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cfquery name="ParameterFlow" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMissionEntryClass
		WHERE  Mission = '#URL.Mission#' 
		AND    Period = '#url.period#'
		AND    Operational = 1
</cfquery>

<cfoutput>

<script language="JavaScript">

function reloadForm() {
 
    rle  = document.getElementById("role").value	
	per  = treeview.PeriodSelect.value			

	_cf_loadingtexthtml="";		

	ColdFusion.navigate('RequisitionViewTree.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&period='+per+'&role='+rle,'treeboxcontent')	
	window.right.location = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"		
}

</script>

</cfoutput>

<cfset Criteria = ''>
	   	   
   	<cfsavecontent variable="rl">
   
   		 'ProcReqInquiry',
   		 'ProcReqEntry',
		 <cfif ParameterFlow.EntityClass eq "">
		 'ProcReqReview',
		 'ProcReqApprove',
		 'ProcReqBudget',
		 'ProcReqObject',
		 </cfif>
		 'ProcReqCertify',
		 'ProcManager'
				
	</cfsavecontent>	   
	   
<cfif getAdministrator(url.mission) eq "1">
	   
	    <cfquery name="Roles" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT DISTINCT R.Role, R.Description, R.ListingOrder
	     FROM   Ref_AuthorizationRole R 
	     WHERE  R.Role IN (#preserveSingleQuotes(rl)#)
		
		 <!---
		 <cfif Parameter.PeriodPreparation neq period>
		 --->
		 
			 UNION
			 
			 SELECT DISTINCT R.Role, R.Description, R.ListingOrder    
			 FROM   Purchase.dbo.RequisitionLineActor A INNER JOIN
		            Purchase.dbo.RequisitionLine L ON A.RequisitionNo = L.RequisitionNo INNER JOIN
		            Organization O ON L.OrgUnit = O.OrgUnit INNER JOIN
		            Ref_AuthorizationRole R ON A.Role = R.Role 			 		
			 ORDER BY ListingOrder
		 
		 <!---
		 </cfif>
		 --->
		 
		 </cfquery>
	   
<cfelse>
	  
		 <cfquery name="Roles" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT DISTINCT R.Role, R.Description, R.ListingOrder
	     FROM   OrganizationAuthorization A INNER JOIN
	            Ref_AuthorizationRole R ON A.Role = R.Role
	     WHERE  A.Mission = '#URL.Mission#' 
		 AND    A.UserAccount = '#SESSION.acc#' 
		 AND    A.Role IN (#preserveSingleQuotes(rl)#)
			
		 <!---		 
		 <cfif Parameter.PeriodPreparation neq period>
		 --->
				 
		 UNION
		 
		 SELECT DISTINCT R.Role, R.Description, R.ListingOrder    
		 FROM   Purchase.dbo.RequisitionLineActor A INNER JOIN
	            Purchase.dbo.RequisitionLine L ON A.RequisitionNo = L.RequisitionNo INNER JOIN
	            Organization O ON L.OrgUnit = O.OrgUnit INNER JOIN
	            Ref_AuthorizationRole R ON A.Role = R.Role 
		 WHERE  L.Mission     = '#URL.Mission#' 
		 AND    A.ActorUserId = '#SESSION.acc#' 	
		 ORDER BY ListingOrder
		 
		 <!---
		 </cfif>
		 --->
		 
		 </cfquery>
	 	
	  </cfif>
	  
	  <cfparam name="URL.Role" default=""> 
	  <cfset buyer = "0">	 
	 	 						
	 	  <select id="role" name="role" class="regularxl" style="width:100%;height:27px;font-size:17px;border:0px solid gray" onChange="reloadForm()">
		  		  		   		   
	      <cfoutput query = "Roles"> 
		  
			  <cfset st = "1">			  
			 			 			  
			  <cfif Role eq "ProcReqApprove">			  
			  
					<cfquery name="check" dbtype="query">
							SELECT *
						    FROM   ParameterFlow
							WHERE  EnableClearance = 1
					</cfquery>
				  			  
				   <cfif check.recordcount eq "0">
				      <cfset st = "0">
				   </cfif>
			 
			  </cfif>	
			  
			  <cfif Role eq "ProcReqBudget">			  
			  
					<cfquery name="check" dbtype="query">
							SELECT *
						    FROM   ParameterFlow
							WHERE  EnableBudgetReview = 1
					</cfquery>
				  			  
				   <cfif check.recordcount eq "0">
				      <cfset st = "0">
				   </cfif>
			 
			  </cfif>	
			  
			  <cfif Role eq "ProcReqObject">
			   
				   <cfquery name="check" dbtype="query">
							SELECT *
						    FROM   ParameterFlow
							WHERE  EnableFundingClear = 1
					</cfquery>
				  			  
				   <cfif check.recordcount eq "0">
				      <cfset st = "0">
				   </cfif>
			 
			  </cfif>	
			  
			  <cfif Role eq "ProcReqCertify">
			  
			   <cfquery name="check" dbtype="query">
							SELECT *
						    FROM   ParameterFlow
							WHERE  EnableCertification = 1
					</cfquery>
				  			  
				   <cfif check.recordcount eq "0">
				      <cfset st = "0">
				   </cfif>
				   
			  </cfif>	
			 
			  
			  <!---
			  
			  <cfif Role eq "ProcAccManager" or Role eq "ProcAcc">			   
			   <cfif Parameter.EnforceProgramBudget eq "1" or Parameter.FundingClearPurchase eq "0">
			      <cfset st = "0">
			   </cfif>
			  </cfif>	
			  
			  --->
			  
			  <cfif st eq "1">
			  
			      <cfif role neq "ProcBuyer" or (role eq "ProcBuyer" and buyer eq "0")>
					  <option value="#Role#" <cfif URL.Role eq Role>selected</cfif>><cf_tl id="#Description#"></option>
					   <cfif url.role eq "">
						  <cfset url.role = role>
					  </cfif>
				  </cfif>
			  </cfif>
			  
			  <cfif role eq "ProcManager">
			  			  
				  <cfquery name="Role" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT * FROM Ref_AuthorizationRole WHERE Role = 'ProcBuyer'
				  </cfquery>
				  
				  <cfset buyer = "1">
				  
				  <option value="ProcBuyer" <cfif URL.Role eq "ProcBuyer">selected</cfif>><cf_tl id="#Role.Description#"></option>
				  <cfif url.role eq "">
					  <cfset url.role = role>
				  </cfif>
			  			  
			  </cfif>
		  	  
          </cfoutput> 
		  		 
     	  </select>	
			
		 
				
	 