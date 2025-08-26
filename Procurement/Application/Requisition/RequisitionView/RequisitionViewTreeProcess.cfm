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
	
<!--- base table for the tree preparations --->    		

<cfoutput>
<div id="drefresh" class="hide"></div>
<input type="hidden" id="refreshbutton" onclick="refreshtree('#url.mission#','#url.period#','#url.role#')">			   	
</cfoutput>

<cfset CLIENT.template  = "RequisitionViewOpen.cfm">

<cfquery name="Period" 
	      datasource="AppsProgram" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
	      WHERE   R.IncludeListing = 1  <!--- pointer to hide/show periods in a controlled manner for any reason --->
		  AND     R.Period = M.Period		  
		 
		  AND   (
		  
		  		
		        (
					M.EditionId != ''  <!--- meant for budget execution --->				
					     AND     
					R.Procurement = 1 <!--- this period is defined as a procurement period ---> 
				)
				
				OR  M.isPlanPeriod = 1
		  
		        OR   
		  
		  	    R.Period IN (SELECT Period as Period
		                        <!--- period is indeed used --->
		                       FROM   Purchase.dbo.RequisitionLine
							   WHERE  Mission = '#URL.Mission#' 
							   AND    ActionStatus != '0'
							   UNION 
							    <!--- period is default --->
							   SELECT DefaultPeriod as Period
							   FROM   Purchase.dbo.Ref_ParameterMission 
							   WHERE  Mission = '#URL.Mission#' 
							   )
				)			   
							   
	      AND     M.Mission = '#URL.Mission#'
	     
      </cfquery>	
	  
 <cfif url.period eq "">
	<cfset url.period = period.period>
 </cfif>	   

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#url.Mission#' 
		AND    Period = '#url.period#'  <!--- <cfqueryparam value="#URL.Period#" cfsqltype="CF_SQL_CHAR">  --->
</cfquery>
	
<table width="100%" class="formpadding">
  	   
	  <tr><td class="line"></td></tr> 
	 	    	  
      <tr>
      <td>
	 
	  <table width="95%" align="center" cellpadding="0">
	
		  <cfset row = 0>			   
	      <cfset PNo = 0>
		  <cfset setperiod = 0>
		  
	  	 		 	 	  	  
	      <cfoutput query = "Period"> 
		  <cfset PNo = PNo+1>
		  <cfset row = row+1>	 
	     
		  <cfif row eq "1"><tr></cfif>
		  
		      <td id="Period#PNo#" class="labelmedium" style="font-size:15px;padding:2px;padding-left:3px;<cfif URL.Period eq Period>font='bold'</cfif>"> 
			  
			  <table><tr><td>
			  <input type="radio" name="Period" style="height:14px; width:14px"  id="Period" value="#Period#" 
				onClick="Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#')"
				<cfif URL.Period eq Period>Checked</cfif>>
				</td>
				<td class="labelmedium2" style="height:20px;padding-left:4px;padding-right:4px">#Description#
				
		        	<cfif URL.Period eq Period>
						<input type="hidden" name="PeriodSelect" id="PeriodSelect" value="#Period#">
						<cfset setperiod = "1">
						<cfset CLIENT.period         = "#Period#">
							<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
						<cfset CLIENT.mandateNo      = "#MandateNo#">			
			   	    </cfif>
					
				</td>
			  </tr>
			  </table>	
				
			  </td>
					  
	      <cfif row eq "2"></tr><cfset row="0"></cfif>  
		  
	      </cfoutput> 
		  
		  <cfif setperiod eq "0">
		  
			  <input type="hidden" name="PeriodSelect" id="PeriodSelect">
			  
		  </cfif>	  
		 
  	  </table> 	  
	  
	  </td>
      </tr>
	  
	  <cfset FileNo = round(Rand()*10)>
	  	  	  
	  <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RequisitionSet_#fileNo#">
			
	  <!--- base table for the tree preparations --->
		 
	  			
	  <cfquery name="getNodeInformation" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			  SELECT     L.ActionStatus, 
			             L.OrgUnit, 
						 count(*) as Total
			  INTO       UserQuery.dbo.#SESSION.acc#RequisitionSet_#fileNo# 
			  FROM       RequisitionLine L INNER JOIN Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit 				  
			  WHERE      L.Period        = '#URL.Period#'
			  AND        L.RequestType IN ('Regular','Warehouse') 
			  AND        L.ActionStatus != '0'	
			  <!--- only orgunits valid for this mandate --->
			  AND        Org.Mission     = '#URL.Mission#'   
		      AND        Org.MandateNo   = '#Mandate.MandateNo#'	 
			  <cfif getAdministrator(url.mission) eq "1">	
			  <!--- no filter --->
			  <cfelse>
			  AND        #preserveSingleQuotes(UserRequestScope)# 		
			  </cfif>	
			  <cfif url.role eq "ProcReqCertify" or url.role eq "ProcManager">
			  AND        L.ActionStatus >= '1p'
			  </cfif>		
			  		  		  
		      GROUP BY 	 L.ActionStatus, L.OrgUnit 		  
	  </cfquery>	
	  
	  <cfquery name="Check" 
		  datasource="AppsQuery" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT *
		    FROM   #SESSION.acc#RequisitionSet_#fileNo#
			WHERE  ActionStatus != '0'
	  </cfquery>

	  <cfquery name="Check2" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			  SELECT     PER.*, L.RequisitionNo
			  FROM       PurchaseExecutionRequest PER 
						 INNER JOIN PurchaseLine L ON L.PurchaseNo = PER.PurchaseNo		
			  			 INNER JOIN Organization.dbo.Organization Org ON PER.OrgUnit = Org.OrgUnit 		  
			  WHERE      PER.Period        = '#URL.Period#'
			  <!--- only orgunits valid for this mandate --->
			  AND        Org.Mission     = '#URL.Mission#'   
		      AND        Org.MandateNo   = '#Mandate.MandateNo#'	
			  <cfif getAdministrator(url.mission) eq "1">	
			  <!--- no filter --->
			  <cfelse>
			  	AND        #preserveSingleQuotes(UserRequestScope)# 		
			  </cfif>	
	  </cfquery>	


	  <cfif Check.recordcount neq "0" or Check2.recordcount gt 0>	  
		  
		  <tr><td class="line" colspan="2"></td></tr>		  		 	
		  <tr><td style="padding-top:10px">		  
			   <cf_requisitionTreeData template="TreeTemplate\RequisitionTreeData.cfm" mission = "#URL.Mission#" fileNo="#fileNo#">	  		   
		  </td>
		  </tr>	
					
	<cfelse>
	
   	    <tr><td height="5"></td></tr>
   		<tr><td height="60" bgcolor="ffffff" align="center" class="labelit"><font color="FF0000"><b><cf_tl id="Alert"></b> : <cf_tl id="REQ037">!</td></tr>
		
	</cfif>
		
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RequisitionSet_#fileNo#">	
		 
   </td></tr>
 
</table>	
