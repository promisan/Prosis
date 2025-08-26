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

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RequisitionSet">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PurchaseSet">

<!--- check for job --->
			
<cfquery name="SET" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
   			  
  SELECT DISTINCT J.JobNo, 
                  J.OrderClass as JobType, 
				  R.EntityClassName as JobName, 
				  J.Description, 
				  J.CaseNo, 
				  J.Created, 
				  'Active' AS JobStatus, 
				  MIN(L.Period) as Period
				  
  INTO       UserQuery.dbo.#SESSION.acc#RequisitionSet
  FROM       Job J INNER JOIN
                   JobActor A ON J.JobNo = A.JobNo INNER JOIN
                   RequisitionLine L ON J.JobNo = L.JobNo INNER JOIN
                   ItemMaster S ON L.ItemMaster = S.Code
			 INNER JOIN Organization.dbo.Ref_EntityClass R ON R.EntityClass = J.OrderClass and R.EntityCode='ProcJob'
  WHERE      J.Mission = '#URL.Mission#'	
  
  <!--- added the filtering 15/10/2012 --->
  
  AND        J.Period  = '#URL.Period#'

  AND        L.ActionStatus NOT IN ('0z','9') and J.ActionStatus NOT IN ('8','9')
  
  <cfif getAdministrator(url.mission) eq "1">

	<!--- no filtering --->
	  
  <cfelse>
  
  AND        (A.ActorUserId         = '#SESSION.acc#'		
  			
				OR
	
			  L.Mission IN
			   (
			     SELECT Mission 
                 FROM   Organization.dbo.OrganizationAuthorization					
				 WHERE  Role IN ('ProcManager')
				  AND   ClassParameter = S.EntryClass
			      AND   UserAccount = '#SESSION.acc#')
			    )
														  
  </cfif>    
   		 
  GROUP BY   J.JobNo, 
             J.OrderClass, 
			 R.EntityClassName, 
			 J.Description, 
			 J.CaseNo, 
			 J.Created	         
 
  HAVING       
  		   
		   (
			   	MIN(L.ActionStatus) < '3' 
				
				OR  
				
				 J.JobNo IN (SELECT ObjectKeyValue1 
                              FROM  Organization.dbo.OrganizationObject O, 
						            Organization.dbo.OrganizationObjectAction OA
							  WHERE O.ObjectId = OA.ObjectId
							  AND   OA.ActionStatus = '0'
							  AND   O.EntityCode = 'ProcJob')	
				
				
  			)
			
   
   UNION	
   
   
     SELECT   DISTINCT J.JobNo, 
              J.OrderClass as JobType, 
			  R.EntityClassName as JobName, 
			  J.Description, 
			  J.CaseNo, 
			  J.Created, 
			  CASE WHEN J.ActionStatus = '8' THEN ('Stalled') ELSE ('Cancelled') END,							 
			  MIN(L.Period) as Period
				  			
  FROM       Job J INNER JOIN
                   JobActor A ON J.JobNo = A.JobNo INNER JOIN
                   RequisitionLine L ON J.JobNo = L.JobNo INNER JOIN
                   ItemMaster S ON L.ItemMaster = S.Code
			 INNER JOIN Organization.dbo.Ref_EntityClass R
			 	ON R.EntityClass = J.OrderClass and R.EntityCode = 'ProcJob'
  WHERE      J.Mission = '#URL.Mission#'	
  AND        J.Period  = '#URL.Period#'
  AND        J.ActionStatus IN ('8','9')
  <cfif getAdministrator(url.mission) eq "1">
	
	  <!--- no filtering --->
	  
  <cfelse>
  
  AND        (A.ActorUserId         = '#SESSION.acc#'		
  			
				OR
	
			 L.Mission IN
			    (
			     SELECT Mission 
                 FROM   Organization.dbo.OrganizationAuthorization					
				 WHERE  Role IN ('ProcManager')
				  AND   ClassParameter = S.EntryClass
			      AND   UserAccount = '#SESSION.acc#')
			    )
														  
  </cfif>   
    		 
  GROUP BY   J.JobNo, 
             J.OrderClass, 
			 R.EntityClassName, 
			 J.Description, 
			 J.ActionStatus,
			 J.CaseNo, 
			 J.Created       
 
  HAVING    		   
		   (
			   	MIN(L.ActionStatus) < '3' <!--- no workflow, in that case we hide if it is a PO --->
				
				OR  <!--- workflow is still pending --->
				
				 J.JobNo IN (SELECT  ObjectKeyValue1 
                             FROM    Organization.dbo.OrganizationObject O, 
						             Organization.dbo.OrganizationObjectAction OA
							 WHERE   O.ObjectId = OA.ObjectId
							 AND     OA.ActionStatus = '0'
							 AND     O.EntityCode = 'ProcJob')					
  			)		  
		  
 
  </cfquery>
  
  <cfquery name="SETPO" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT    P.PurchaseNo, P.ActionStatus, S.StatusDescription, S.Description
	  INTO      UserQuery.dbo.#SESSION.acc#PurchaseSet
	  FROM      Purchase P INNER JOIN
                PurchaseActor PA ON P.PurchaseNo = PA.PurchaseNo INNER JOIN
                Status S ON S.Status = P.ActionStatus
	  WHERE     P.Mission = '#URL.Mission#'	
	  
	  <!--- added the filtering 15/10/2012 --->
	  AND       P.Period  = '#URL.Period#'
	  
	  <cfif getAdministrator(url.mission) eq "1">

			<!--- no filtering --->
	   
	  <cfelse>
	  
	  AND       (
	             PA.ActorUserId = '#SESSION.acc#'	
	   		     OR P.Mission IN (SELECT Mission 
	               	        	  FROM   Organization.dbo.OrganizationAuthorization					
							      WHERE  Role = 'ProcApprover'
				                  AND    UserAccount = '#SESSION.acc#')
			    )
	  </cfif>     	
	  AND      S.StatusClass = 'Purchase'  
      AND      PA.Role       = 'ProcBuyer' 
  </cfquery>

   
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0"
	   class="formpadding">
	  			
	 <cfquery name="Period" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
		   AND    R.Period IN (SELECT Period
		                        FROM   Purchase.dbo.RequisitionLine 
								WHERE  Period = R.Period
								AND    Mission = '#URL.Mission#')
	      AND     M.Mission = '#URL.Mission#'
	      AND     R.Period = M.Period
      </cfquery>
	  	  	  	  	    	  
      <tr>
      <td>	  
	 
	  <table width="100%" class="formpadding">
			 		   
      <cfset PNo = 0>
	  <cfset setperiod = 0>
	  <cfset cnt = 0>
  
      <cfoutput query = "Period"> 
	  
	  	  <cfset cnt = cnt+1>
		  <cfset PNo = PNo+1>
		  <cfif cnt eq "1">
	      <tr>
		  </cfif>
	      <td id="Period#PNo#" class="labelmedium" style="padding-top:4px;<cfif URL.Period eq Period>font='bold'</cfif>"> 
		  <input type="radio" class="radiol" name="Period" id="Period" value="#Period#" 
			onClick="updatePeriod(this.value,'#MandateNo#',parent.role.value);Period#PNo#.style.fontWeight='bold';"
			<cfif URL.Period eq Period>Checked</cfif>>&nbsp;#Description#&nbsp;
			
	        	<cfif URL.Period eq Period>				
					<input type="hidden" name="PeriodSelect" id="PeriodSelect" value="#Period#">
					<cfset setperiod = "1">
				<cfset CLIENT.period         = "#Period#">
					<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
				<cfset CLIENT.mandateNo      = "#MandateNo#">			
			</cfif>
		  </td>
		  <cfif cnt eq "2">
	      </tr>
		  <cfset cnt=0>
		  </cfif>
	  
      </cfoutput> 
	  
  	  </table> 	  
	  
	  </td>
      </tr>
	  
	    <cfif setperiod eq "0">
	  
		  <input type="hidden" name="PeriodSelect" id="PeriodSelect">
		  
	  </cfif>	  
	 
	 	  
	  <tr>
			  <td>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
								
				<cfinclude template="../../Quote/Create/JobCreateCondition.cfm">
											
				<cfinclude template="../../PurchaseOrder/Create/PurchaseCreateCondition.cfm">			
						
				</table>
			  </td>
	  </tr>
	  
	  <tr><td height="1" class="linedotted"></td></tr>
	  <tr><td height="4"></td></tr>
	  <cfoutput>
	  <tr><td>
	  	<table width="100%"><tr>
		<td>
		  <table width="100%" align="center" style="border:1px solid silver">
		<tr>
		
		<td title="Search for quote order">
		
		<input type="text" 
		   name="searchme" 
           id="searchme"
		   style="border:0px;width:100%" 
		   class="regularxl">
		   
		</td>
		<td width="23" align="center">
		<img src="#SESSION.root#/Images/search.png" style="cursor:pointer;" height="23" width="23" align="absmiddle" id="searchicon"  
		  alt="Quick locate" border="0" onclick="find(document.getElementById('searchme').value)">
		</td>
		</tr>
		</table>
		</td></tr>
	  </table>
	  </td></tr>
	  <tr><td height="4"></td></tr>
	 
	  </cfoutput>
	  
	  <tr><td id="findme"></td></tr>
	  	  
	  <cfquery name="Check" 
	  datasource="AppsQuery" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	  SELECT TOP 1 *
		  FROM #SESSION.acc#RequisitionSet 
	  </cfquery>
	  
	  <cfquery name="Check1" 
	  datasource="AppsQuery" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT TOP 1 *
		  FROM #SESSION.acc#PurchaseSet 
	  </cfquery>
	  
	  <cfif Check.recordcount neq "0" or Check1.recordcount neq "0">
	 	
	  <tr><td>	<table width="95%" align="center"><tr><td>
	  	 
	  		  <cf_ProcurementJobTreeData			
					mission = "#URL.Mission#"
				    destination1= "RequisitionViewBuyerOpen.cfm"	
					destination2= "RequisitionViewPOOpen.cfm"> 			
					
				</td></tr></table>					
				
	  </td></tr>	
	  					
	  <cfelse>
   		<tr><td height="40" align="center" class="labelmedium"><cf_tl id="Alert"></b>:<cf_tl id="REQ036">!</td></tr>
		 <tr><td height="1" class="linedotted"></td></tr>
	  </cfif>
			 
     </td></tr>
 
	</table>	
		
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PurchaseSet">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RequisitionSet"> 
