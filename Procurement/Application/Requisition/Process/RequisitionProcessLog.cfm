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

<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>	

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_AuthorizationRole
		WHERE Role = '#url.role#' 
</cfquery>

<cfoutput>
			  
  	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
					
	<!--- additional query script --->
	
	<cfsavecontent variable="SubInfo">
	
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
		
					  
	</cfsavecontent>
				
	<tr><td width="100%" height="100%">
	
		<cfif url.role is "ProcReqReview">
		<cf_tl id="Reviewed" var="1">
		<cfelse>
		<cf_tl id="Forwarded" var="1">
		</cfif>
					
		<CF_DropTable dbName="AppsQuery"  tblName="lsRequest_#SESSION.acc#">
		 
		<cfquery name="Dataset" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				SELECT    '#lt_text#' as Mode,
				          A.ActionDate,
				          L.RequestDate, 
						  L.Reference,
						  L.RequisitionNo,
						  L.Period,
						  L.RequestAmountBase,
				          I.Description, 				  
						  #preservesinglequotes(subinfo)#				  
						  Org.Mission, 
						  Org.MandateNo, 
						  Org.HierarchyCode, 
						  Org.OrgUnitName
				INTO 	  userQuery.dbo.lsRequest_#SESSION.acc#			  
				FROM      RequisitionLine L, 
				          ItemMaster I, 
						  Organization.dbo.Organization Org,
						  RequisitionLineAction A
				WHERE     L.OrgUnit = Org.OrgUnit	
				AND       L.RequisitionNo = A.RequisitionNo
				
				AND       A. OfficerUserId = '#SESSION.acc#'	
				
				<cfif url.role eq "ProcReqReview">										  
				  AND    A.ActionStatus IN ('2')
				<cfelseif url.role eq "ProcReqApprove">
				  AND    A.ActionStatus IN ('2a')
				<cfelseif url.role eq "ProcReqBudget">									  
				  AND    A.ActionStatus IN ('2b')
				<cfelseif url.role eq "ProcReqObject">									  
				  AND    A.ActionStatus IN ('2f')
				<cfelseif url.role eq "ProcReqCertify">									  
				  AND    A.ActionStatus IN ('2i')
				</cfif>
				<!--- last 100 days 
				AND    ActionDate > getdate()-300
				--->
								
				AND      I.Code = L.ItemMaster   
				<!---							
				AND      L.Period    = '#URL.Period#'
				--->
				AND      Org.Mission = '#URL.Mission#'	
				
				
				UNION
				
				SELECT    'Denied' as Mode,
				          A.ActionDate,
				          L.RequestDate, 
						  L.Reference,
						  L.RequisitionNo,
						  L.Period,
						  L.RequestAmountBase,
				          I.Description, 				  
						  #preservesinglequotes(subinfo)#				  
						  Org.Mission, 
						  Org.MandateNo, 
						  Org.HierarchyCode, 
						  Org.OrgUnitName
				  
				FROM      RequisitionLine L, 
				          ItemMaster I, 
						  Organization.dbo.Organization Org,
						  RequisitionLineAction A
				WHERE     L.OrgUnit = Org.OrgUnit	
				AND       L.RequisitionNo = A.RequisitionNo
				
				AND       A. OfficerUserId = '#SESSION.acc#' <!--- 'fodnysa4' --->			
				
				AND       A.ActionStatus IN ('9')
				
				AND       A.ActionDate IN (SELECT MAX(ActionDate) 
					                       FROM   RequisitionLineAction 
									   	   WHERE  RequisitionNo = L.RequisitionNo)		
				
				<!---						   
				AND       A.RequisitionNo IN (SELECT RequisitionNo 
					                          FROM   RequisitionLineAction 
											  WHERE  ActionStatus = '9'
											  AND    RequisitionNo = L.RequisitionNo)	
											  --->
				
				<cfif url.role eq "ProcReqReview">										  
				  AND    A.ActionStatus IN ('2')
				<cfelseif url.role eq "ProcReqApprove">
				  AND    A.ActionStatus IN ('2a')
				<cfelseif url.role eq "ProcReqBudget">									  
				  AND    A.ActionStatus IN ('2b')
				<cfelseif url.role eq "ProcReqObject">									  
				  AND    A.ActionStatus IN ('2f')
				<cfelseif url.role eq "ProcReqCertify">									  
				  AND    A.ActionStatus IN ('2i')
				</cfif>
				<!--- last 100 days 
				AND    ActionDate > getdate()-300
				--->
								
				AND      I.Code = L.ItemMaster   
				<!---							
				AND      L.Period    = '#URL.Period#'
				--->
				AND      Org.Mission = '#URL.Mission#'	
						
				
		 
		</cfquery>	
	
		<cfinclude template="RequisitionProcessLogContent.cfm">
	
	</td></tr>
	
	<!---
	
	<tr><td style="width:96%" class="linedotted"></td></tr>
	
	<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    L.*, 
		          I.Description, 
				  #preservesinglequotes(subinfo)#				  
				  Org.Mission, 
				  Org.MandateNo, 
				  Org.HierarchyCode, 
				  Org.OrgUnitName
		FROM      RequisitionLine L, 
		          ItemMaster I, 
				  Organization.dbo.Organization Org
		WHERE     L.OrgUnit = Org.OrgUnit			
		AND       L.RequisitionNo IN (
		
					SELECT   S.RequisitionNo
		            FROM     RequisitionLineAction S
					WHERE    S.RequisitionNo = L.RequisitionNo
					AND      S.ActionStatus IN ('9','1')
					AND      S.RequisitionNo IN (SELECT RequisitionNo 
					                             FROM   RequisitionLineAction 
												 WHERE  ActionStatus = '9'
												 AND    RequisitionNo = S.RequisitionNo)
					AND      S.ActionDate > getdate()-1
					AND      S.ActionDate IN (SELECT MAX(ActionDate) 
					                          FROM   RequisitionLineAction 
									   		  WHERE  RequisitionNo = S.RequisitionNo)			
		)
				
		AND      I.Code      = L.ItemMaster   							
		AND      L.Period    = '#URL.Period#'
		AND      Org.Mission = '#URL.Mission#'	
		ORDER BY L.Reference, Org.Mission, Org.MandateNo, Org.HierarchyCode, L.Created DESC						
	</cfquery>	  	  
	
	<cfif Requisition.recordcount gte "0">
			
		<tr><td style="width:96%" class="linedotted"></td></tr>
		<tr><td align="center" height="30"><font size="3" color="FF8080"><b><cf_tl id="Denied"></font></td></tr>
				
		<tr><td valign="top">
		
			<cfset mode = "Denied">
			<cfset md = "Reference">
						
			<cfinclude template="RequisitionListing.cfm">
			
		</td></tr>
		<tr><td style="width:96%" class="linedotted"></td></tr>
	
	</cfif>
	
	--->

	</table>
		
</cfoutput>	
