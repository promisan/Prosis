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

<cfparam name="url.role"         default="ProcReqReview">	
<cfparam name="url.message"      default="">		
<cfparam name="url.annotationid" default="">		
<cfparam name="url.search"       default="">
<cfparam name="url.unit"         default="">
<cfparam name="url.fund"         default="">
		
<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#'
</cfquery>		

<cfquery name="RoleData" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRole
	WHERE  Role = '#URL.Role#' 
</cfquery>

<cfinvoke component = "Service.Process.Procurement.Requisition"  
	method           = "getQueryScope" 
	role             = "#url.role#" 
	accesslevel      = "'1','2'"
	mode             = "OrgUnitImplement"
	returnvariable   = "UserRequestScope">	
	
<cfquery name="Requisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    L.*, 
          I.Description, 
		  
		   (  SELECT count(*) 
					 FROM RequisitionLineTravel
					 WHERE RequisitionNo = L.RequisitionNo						 
				  )  as IndTravel,			  
				  
				  (  SELECT count(*)
					 FROM Employee.dbo.PositionParentFunding
			         WHERE RequisitionNo = L.RequisitionNo
				  )  as IndPosition,
				  	
				  (  SELECT count(*)
			         FROM RequisitionLineService
			         WHERE RequisitionNo = L.RequisitionNo
		          )  as IndService,		
				  
				   (  SELECT count(*)
				 FROM   RequisitionLineTopic R, Ref_Topic S
				 WHERE  R.Topic = S.Code
			     AND    S.Operational   = 1
			     AND    R.RequisitionNo = L.RequisitionNo
			   ) as CountedTopics,	  	  
		  
		  Org.Mission, 
		  Org.MandateNo, 
		  Org.HierarchyCode, 
		  Org.OrgUnitName
FROM      RequisitionLine L, 
          ItemMaster I, 
		  Organization.dbo.Organization Org
WHERE     L.OrgUnit = Org.OrgUnit

		
<cfif url.role eq "ProcReqReview">
AND       (L.ActionStatus = '1p' and Reference is not NULL <!--- OR (L.ActionStatus = '1' AND Reference is not NULL) --->) 
<cfelseif url.role eq "ProcReqApprove">
AND       (L.ActionStatus = '2' and Reference is not NULL <!--- OR (L.ActionStatus = '1' AND Reference is not NULL) --->) 		
<cfelse>
AND       (L.ActionStatus = '2a' and Reference is not NULL <!--- OR (L.ActionStatus = '1' AND Reference is not NULL) --->) 	
</cfif>	

<cfif getAdministrator(url.mission) eq "0">
AND  #preserveSingleQuotes(UserRequestScope)# 					
</cfif>		

<cfif url.annotationid neq "">
		
	<cfif url.annotationid eq "None">
		
		AND  L.RequisitionNo NOT IN (SELECT ObjectKeyValue1
		                         FROM   System.dbo.UserAnnotationRecord
								 WHERE  Account = '#SESSION.acc#' 
								 AND    EntityCode = 'ProcReq')	
		
	<cfelse>

		AND  L.RequisitionNo IN (SELECT ObjectKeyValue1
		                         FROM   System.dbo.UserAnnotationRecord
								 WHERE  Account = '#SESSION.acc#' 
								 AND    EntityCode = 'ProcReq' 
								 AND    AnnotationId = '#url.annotationid#')	
								 
	</cfif>						 
		
</cfif>
						 							
AND      L.Period    = '#URL.Period#'
AND      Org.Mission = '#URL.Mission#'	

<cfif url.unit neq "">
AND   L.OrgUnit = '#url.Unit#'
</cfif>

<cfif url.fund neq "">	

AND   L.RequisitionNo IN (SELECT RequisitionNo 
                          FROM   RequisitionLineFunding 
						  WHERE  Fund = '#url.fund#'
						  AND    RequisitionNo = L.RequisitionNo)
</cfif>

AND   I.Code = L.ItemMaster 

<cfif url.search neq "">
		AND   (L.Reference LIKE '%#URL.Search#%' OR 
	       L.RequisitionNo LIKE '%#URL.Search#%' OR 
		   L.RequestDescription LIKE '%#URL.Search#%' OR 
		   I.Description LIKE '%#URL.Search#%' OR 
		   L.OfficerLastName LIKE '%#URL.Search#%' OR
		   L.OfficerFirstName LIKE '%#URL.Search#%') OR
		   L.RequisitionNo IN (SELECT RequisitionNo 
		                       FROM RequisitionLineTopic
							   WHERE RequisitionNo = L.RequisitionNo
							   AND   (CAST(TopicValue AS varchar(100)) LIKE '%#URL.Search#%'))
							   
							   
							   
	</cfif>	   

ORDER BY L.Reference, Org.Mission, Org.MandateNo, Org.HierarchyCode, L.Created DESC		
				
</cfquery>
			
<cfset Mode = "Pending">

<cfoutput>

<table width="100%" height="100%" border="0" class="formpadding">
  
    <cfif url.message neq "">
	<tr><td>#url.message#</td></tr>
	</cfif>
	
	<cfparam name="url.page" default="1">

	<cfquery name="Count"
        dbtype="query">
	 	SELECT DISTINCT Reference
		FROM   Requisition		 
	 </cfquery>		
	 		 		 		
	<cf_PageCountN count="#count.recordcount#" show="#Parameter.LinesInView#">
		   
	<cfif pages lte "1">
	   
	   		<input type="hidden" name="page" id="page" value="1">
			
	<cfelse>
	   
	   	<tr>
		<td align="right" valign="bottom">
	   		   		
			<cfset currrow = 0>
			<cfset navigation = 1>
			
			<cf_tl id="Page" var="1">
			<cfset vPage = lt_text>

			<cf_tl id="Of" var="1">
			<cfset vOf = lt_text>
	   			   				
		    <select name="page" id="page" 
			   size="1" 
	           onChange="reqsearch()">
			   
			   <cfloop index="Item" from="1" to="#pages#" step="1">		             
				  <option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option>					 
	           </cfloop>	 
			   
	        </SELECT>	
		   
		 </td>
		 </tr>  	
			   
	</cfif>   	
					
	<tr>
					
		<cfif Parameter.EnableFundingCheck eq "1">				
			<cfset fundcheck = "Funds">
		<cfelse>
		    <cfset fundcheck = "No">
		</cfif>		
		
		<cfif Parameter.RequisitionProcessMode eq "0">
			<cfset processlevel = "Line">
		<cfelse>
			<cfset processlevel = "Header">
		</cfif>
		
		<!--- check if workflow exists for the requisition --->
		<cfset wfcheck = "ProcReview">
		
		<cfset url.process = "radio">
		<td height="100%" valign="top" align="center" style="padding-right:5px">		
		<cfinclude template="RequisitionListing.cfm">
		</td>
		
	</tr>
	
	<cf_tl id="Deny" var="1">
	<cfset vDeny=lt_text>											
	<cf_tl id="Clear" var="1">
	<cfset vClear=lt_text>					
	
	<cf_tl id="Submit" var="1">		

	<CFIF requisition.recordcount gt "0">			
		
		<tr><td colspan="2" style="height:40px" id="block" valign="top" align="center">
		
		   <input type    = "button" 
		          onclick = "processdata('process','#url.period#','#url.role#')" 
				  name    = "Submit" 
                  id      = "Submit"
				  style   = "width:150px;height:30px"
				  value   = "#lt_text#" 
				  class   = "button10g">
				  
		</td></tr>
		
	</cfif>
			
</table>	

</cfoutput>