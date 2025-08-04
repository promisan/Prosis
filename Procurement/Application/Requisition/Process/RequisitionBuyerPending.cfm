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
<!--- create selection lines --->

<cfparam name="url.message" default="">
<cfparam name="url.search" default="">
<cfparam name="url.annotationid" default="">	
<cfparam name="url.unit" default="">
<cfparam name="url.fund" default="">
<cfparam name="st" default="'2i'">


<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfset fun = "0">

<cfquery name="Role" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AuthorizationRole
		WHERE  Role = 'ProcManager' 
</cfquery>
		
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
				  
				  (  SELECT CustomDialog
			         FROM Ref_EntryClass
			         WHERE Code = I.EntryClass
		          )  as CustomDialog,	
				  
				  			  
				  
				  I.CustomForm,		  <!--- define if this is enabled for the master --->
			  
			  Org.Mission, 
			  Org.MandateNo, 
			  Org.HierarchyCode, 
			  Org.OrgUnitName
	FROM      RequisitionLine L, 
	          ItemMaster I, 
			  Organization.dbo.Organization Org
	WHERE     L.OrgUnit = Org.OrgUnit
	
	AND       Org.Mission = '#URL.Mission#' 
	AND       L.Period    = '#URL.Period#' 
		
	<cfif getAdministrator(url.mission) eq "0">
	
 	AND       (I.EntryClass IN 
	            (SELECT DISTINCT ClassParameter 
				 FROM Organization.dbo.OrganizationAuthorization 
				 WHERE Role           = 'ProcManager'
				 AND   UserAccount    = '#SESSION.acc#'
				 AND   OrgUnit        = L.OrgUnit
				 AND   ClassParameter = I.EntryClass				
				 AND   AccessLevel IN ('1','2'))
				 
				 OR
				 
				<!--- mission level access --->
				 				 				 
				I.EntryClass IN (
				  SELECT DISTINCT ClassParameter
				  FROM  Organization.dbo.OrganizationAuthorization 
				  WHERE Role = 'ProcManager'
				  AND   UserAccount = '#SESSION.acc#'				
				  AND   Mission = '#url.mission#'
				  AND   OrgUnit is NULL
				  AND   AccessLevel IN ('1','2')
				  )				 
			 )
		   	 
	</cfif>		
		
	<cfif url.fund neq "">	
	AND   L.RequisitionNo IN (SELECT RequisitionNo 
	                          FROM   RequisitionLineFunding 
							  WHERE  RequisitionNo = L.RequisitionNo
							  AND    Fund = '#url.fund#')
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
		
	AND    (   L.ActionStatus IN (#preservesingleQuotes(st)#)
	     
		       OR 
			   
			   <!--- no valid user selected --->
		 
		       L.ActionStatus = '2k' and L.RequisitionNo NOT IN (SELECT RequisitionNo 
		                                                         FROM   RequisitionLineActor
						      								     WHERE  Role = 'ProcBuyer'
														         AND    ActorUserId IN (SELECT Account FROM System.dbo.UserNames)
														  ) 

		   )
		   
	<cfif url.unit neq "">
	AND   	L.OrgUnit = '#url.Unit#'
	</cfif>
	
	<cfif getAdministrator(url.mission) eq "0">
						
				AND  
				(
				
				<cfif Role.OrgUnitLevel eq "All">
				
				 L.OrgUnit IN 
			            (SELECT OrgUnit 
						 FROM   Organization.dbo.OrganizationAuthorization 
						 WHERE  Role        = 'ProcManager' 
						 AND    AccessLevel IN ('1','2')
						 AND    UserAccount = '#SESSION.acc#') 
						 
				<cfelse>
				
				 L.OrgUnit IN 
			            (SELECT   Org.OrgUnit
						 FROM     Organization.dbo.Organization O INNER JOIN
			                      Organization.dbo.Organization Par ON 
								  	Par.OrgUnitCode = O.HierarchyRootUnit
									AND O.Mission = Par.Mission 
									AND O.MandateNo = Par.MandateNo INNER JOIN
			                      Organization.dbo.OrganizationAuthorization OA ON Par.OrgUnit = OA.OrgUnit
						 WHERE  OA.Role        = 'ProcManager' 
						 AND    OA.AccessLevel IN ('1','2')
						 AND    OA.UserAccount = '#SESSION.acc#')		
				
				</cfif>		
				 
				 OR
					L.Mission IN 
					 (SELECT Mission
						 FROM Organization.dbo.OrganizationAuthorization 
						 WHERE Role        = 'ProcManager'
						 AND   UserAccount = '#SESSION.acc#'
						 AND   AccessLevel IN ('1','2')
						 AND   OrgUnit is NULL)
					 
				)
			
			</cfif>		
				
		
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
	
	AND   I.Code = L.ItemMaster 		
			
	ORDER BY Org.Mission, Org.MandateNo, Org.HierarchyCode, L.Created DESC							
	</cfquery>
						
	<cfset fun = "0">	
	
	<cfset Mode = "Pending">
	
	<cfform method="post" name="buyer" id="buyer" style="height:100%">
				
	<table width="100%" height="100%" class="formpadding">
	
	    <tr><td height="6"></td></tr>
	    <cfif url.message neq "">
		<tr><td colspan="2">#url.message#</td></tr>
		</cfif>
						
		<cfoutput>
		<tr>
		   <td>
		   <table cellspacing="0" cellpadding="0" class="formspacing">
			   <tr>
			   <td style="padding-left:10px;padding-right:20px" class="labellarge">
			   #Parameter.BuyerDescription#:</td>
			   <td>
			   
			  <cfparam name="url.buyer" default="0">
			  
			  <cfquery name="Buyer" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	 
				 SELECT * 
				 FROM   UserNames 
				 WHERE  Account = '#url.buyer#'
			  </cfquery>				   

				<cfset link="RequisitionBuyerUser.cfm?">

				<cf_selectlookup
				    box          = "sBuyerSelection"
				    link         = "#link#"
					button       = "yes"
					icon         = "contract.gif"
					iconwidth    = "13"
					iconheight   = "14"
					close        = "Yes"
					class        = "user"
					des1         = "account">	
								  
				</td>
				<td>	   
			    	<table width="100%">
							    		
			    		<tr>
			    			<td style="padding-left:5px">
								<cfdiv id="sBuyerSelection" bind="url:RequisitionBuyerUser.cfm">
							</td>
						</tr>
					</table>			
			    </td>   
			  			   
			   </tr>
		   </table>
		   
		   </td>
		   
		   <td align="right">
			   
			   <cfparam name="url.page" default="1">
		
					<cfquery name="Count"
			         dbtype="query">
					 	SELECT DISTINCT Reference
						FROM   Requisition		 
					 </cfquery>		
					 		 		 		
					<cf_PageCountN count="#count.recordcount#" show="10">		
							   
					<cfif pages lte "1">
					   
					   		<input type="hidden" name="page" id="page" value="1">
							
					<cfelse>					   
					  
							<cfset currrow = 0>
							<cfset navigation = 1>
							
							<cf_tl id="Page" var="1">
							<cfset vPage = lt_text>
				
							<cf_tl id="Of" var="1">
							<cfset vOf = lt_text>
					   			   				
						    <select name="page" id="page"
						       size="1" 
							   class="regularxl"
					           onChange="javascript:ColdFusion.navigate('RequisitionBuyerPending.cfm?message=#url.message#&mission=#url.mission#&period=#url.period#&page='+this.value,'contentbox1')">
							   
							   <cfloop index="Item" from="1" to="#pages#" step="1">
					              <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
					           </cfloop>	 
							   
					        </SELECT>	
										   
					</cfif> 		   
			   
			   </td>
		</tr>				
			
		</cfoutput>	
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>
			<td colspan="2" height="100%" style="padding-left:15px">						
				<cfinclude template="RequisitionListing.cfm">
			</td>
		</tr>		
		
		<cf_tl id="Submit" var="1">		
		
		<cfoutput>
		
		<cf_tl id="REQ005" var="1">
		<cfset vReq005=lt_text>
		
		<cfif Requisition.recordcount neq "0">
		
		<tr><td colspan="2" class="line"></td></tr>

		<tr><td colspan="2" height="30" align="center">
			
			   <input type="button" 
			          name="Submit" 
                      id="Submit"
					  class="button10g"
					  style="width:260; height:28px;font-size:13px" 
					  value="#vReq005#" 
					  onclick="processdata('assign','#url.period#')">
			   
			</td></tr>
		
		</cfif>
		</cfoutput>					
		
	</table>	
	
	</cfform>


<script>	
	Prosis.busy('no')
</script>	