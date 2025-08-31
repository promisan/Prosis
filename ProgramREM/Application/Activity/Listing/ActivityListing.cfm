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
<cfparam name = "url.periodmode"     default="fit">
<cfparam name = "url.mode"           default="0">
<cfparam name = "url.option"           default="9">
<cfparam name = "url.output"         default="0">
<cfparam name = "url.periodfilter"   default="#url.period#">
<cfparam name = "URL.fileNo"         default="">

<!--- --------------- --->
<!--- added 18/8/2015 --->
<!--- --------------- --->
	
  <cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"					
		Role           = "'BudgetManager','BudgetOfficer'"
		ReturnVariable = "BudgetAccess">		

<cfquery name="Param" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Parameter
</cfquery>

<cfquery name="Parameter" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'
</cfquery>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramActivityCluster
	WHERE     ProgramCode = '#URL.ProgramCode#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="sub" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT P.*
	    FROM   #CLIENT.LanPrefix#Program P, ProgramPeriod Pe
		WHERE  P.ProgramCode  =  Pe.ProgramCode
		AND    P.ProgramCode  =  '#url.ProgramCode#'
		AND    Pe.Period      =  '#url.Period#' 
	</cfquery>
	
	<cfset val = "'#URL.ProgramCode#'">
	
	<cfloop query="sub">
		  	   
	     <cfset val = "#val#,'#ProgramCode#'">	
			 
	</cfloop>

	<cfset ProgramFilter = "ProgramCode IN (#val#)">		

<cfelse>
	
	<cfset ProgramFilter = "ProgramCode = '#URL.ProgramCode#'">		

</cfif>				

<cfset FileNo = round(Rand()*100)>

<!--- prepare data remhere --->
<cfinclude template="ActivityProgressInit.cfm">

<!--- check if the project has internal clusters --->
	
	<cfquery name="Cluster" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    Pr.*				 
				  
		FROM      ProgramActivity Pr 
		          INNER JOIN Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit 
				  INNER JOIN ProgramActivityCluster C ON Pr.ActivityClusterId = C.ActivityClusterId
		
		WHERE     Pr.ProgramCode    = '#URL.ProgramCode#' 
		AND       Pr.RecordStatus <> '9'
		<cfif url.periodfilter neq "">	
		AND       Pr.ActivityPeriod = '#url.periodfilter#'
		</cfif>
	
		AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
		                                 FROM ProgramPeriod 
										 WHERE Period = '#URL.Period#' and RecordStatus = '9')								 
										 
		
	</cfquery>
	

<!--- check if the activities are to be listed by outcome --->

<cfif url.option eq "2">

		<cfquery name="Activity" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
			SELECT    PT.TargetDescription as SubProject,
			          Pr.ActivityId,Pr.ActivityPeriod,Pr.ActivityDateStart,Pr.ActivityDateEnd,Pr.ActivityDate,Pr.ActivityDescription, Pr.ActivityDescriptionShort,
					  <!---
					  (SELECT Description FROM Payroll.dbo.Ref_PayrollLocation WHERE LocationCode = Pr.LocationCode) as LocationName,
					  --->
			          PT.ListingOrder AS ListingOrder,
					  Pen.Status,
					  Org.OrgUnitNameShort,
					  (SELECT count(*) FROM ProgramActivityParent P WHERE Pr.ActivityId = P.ActivityId) as Dependent
					  
			FROM      ProgramActivityOutput PAO INNER JOIN
                      ProgramActivity PR ON PAO.ProgramCode = PR.ProgramCode AND PAO.ActivityPeriod = PR.ActivityPeriod AND PAO.ActivityId = PR.ActivityId AND 
                      PR.RecordStatus <> '9' RIGHT OUTER JOIN
                      ProgramTarget PT ON PAO.TargetId = PT.TargetId INNER JOIN
	                  Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
		              UserQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId
								
			WHERE     PT.ProgramCode = '#URL.ProgramCode#' 				
			AND       PT.ProgramCode NOT IN (SELECT ProgramCode 
			                                 FROM   ProgramPeriod 
											 WHERE  Period = '#URL.Period#' 
											 AND    RecordStatus = '9')
											 
			<cfif url.periodfilter neq "">	
			AND       PT.Period = '#url.periodfilter#'
			</cfif>		
			
			AND       PT.ActionStatus  <> '9' 
			AND       PAO.RecordStatus <> '9'
			ORDER BY  PT.TargetReference	
		
		</cfquery>								 

<cfelse>
	
		<!---	
		<cfoutput>#cfquery.executiontime#</cfoutput>		
		--->
	
		<cfif Cluster.recordcount eq "0">   
		
			<cfquery name="Activity" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
			 SELECT   P.ProgramName as SubProject,
			          Pr.ActivityId,Pr.ActivityPeriod,Pr.ActivityDateStart,Pr.ActivityDateEnd,Pr.ActivityDate,Pr.ActivityDescription, Pr.ActivityDescriptionShort,
					  <!---
					  (SELECT Description FROM Payroll.dbo.Ref_PayrollLocation WHERE LocationCode = Pr.LocationCode) as LocationName,
					  --->
			          '0' AS ListingOrder,
					  Pen.Status,
					  Org.OrgUnitNameShort,
					  (SELECT count(*) FROM ProgramActivityParent P WHERE Pr.ActivityId = P.ActivityId) as Dependent
					  
			FROM      Program P INNER JOIN
		                   ProgramActivity Pr ON P.ProgramCode = Pr.ProgramCode INNER JOIN
		                   Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
		                   userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId
								
			WHERE     Pr.ProgramCode = '#URL.ProgramCode#' 	
			AND       Pr.RecordStatus != '9'
			AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
			                                 FROM   ProgramPeriod 
											 WHERE  Period = '#URL.Period#' 
											 AND    RecordStatus = '9')
											 
			<cfif url.periodfilter neq "">	
			AND       Pr.ActivityPeriod = '#url.periodfilter#'
			</cfif>								 
				
			UNION 
			 
			SELECT    P.ProgramName as SubProject,
			          PR.ActivityId,Pr.ActivityPeriod,Pr.ActivityDateStart,Pr.ActivityDateEnd,Pr.ActivityDate,Pr.ActivityDescription, Pr.ActivityDescriptionShort,
					  <!---
					  (SELECT Description FROM Payroll.dbo.Ref_PayrollLocation WHERE LocationCode = Pr.LocationCode) as LocationName,
					  --->
			          P.ListingOrder AS ListingOrder,
					  Pen.Status,
					  Org.OrgUnitNameShort,
					  
					   (SELECT count(*) 
					    FROM   ProgramActivityParent P 
						WHERE  Pr.ActivityId = P.ActivityId) as Dependent
			
			FROM      Program P INNER JOIN
			          ProgramPeriod Pe  ON P.ProgramCode = Pe.ProgramCode AND Pe.Period = '#url.period#' INNER JOIN <!--- condition to exisit for that period --->
		              ProgramActivity Pr ON P.ProgramCode = Pr.ProgramCode INNER JOIN
		              Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
		              userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId
						  
			WHERE     Pe.PeriodParentCode = '#URL.ProgramCode#' 
			AND       Pr.RecordStatus != '9'
			AND       Pe.RecordStatus != '9'
			
			<cfif url.periodfilter neq "">	
			AND       Pr.ActivityPeriod = '#url.periodfilter#'
			</cfif>
			
			<!---
			AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
			                                 FROM   ProgramPeriod 
											 WHERE  Period = '#URL.Period#' 
											 AND    RecordStatus = '9')
											 --->
			
			ORDER BY  ListingOrder, Pr.ActivityDateStart   
			</cfquery>		
				
		<cfelse>
		
			<!--- clustering --->
			
			<cfquery name="Activity" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    Pr.*, 
				          C.ClusterDescription AS SubProject, 
						  C.ListingOrder AS ListingOrder,
						  <!---
						  (SELECT Description FROM Payroll.dbo.Ref_PayrollLocation WHERE LocationCode = Pr.LocationCode) as LocationName,
						  --->
						  Pen.Status,
						  Org.OrgUnitNameShort,
						  (SELECT count(*) FROM ProgramActivityParent P WHERE Pr.ActivityId = P.ActivityId) as Dependent
						   
				FROM      ProgramActivity Pr 
			              INNER JOIN Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit 
					      LEFT OUTER JOIN ProgramActivityCluster C ON Pr.ActivityClusterId = C.ActivityClusterId
					      LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId				  		   
				
				WHERE     Pr.ProgramCode = '#URL.ProgramCode#' 
				AND       Pr.RecordStatus != '9'
				
				AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
				                                 FROM   ProgramPeriod 
												 WHERE  Period = '#URL.Period#' 
												 AND    RecordStatus = '9')
												 
				<cfif url.periodfilter neq "">	
				AND       Pr.ActivityPeriod = '#url.periodfilter#'
				</cfif>								 
				
				ORDER BY  C.ListingOrder, Pr.ActivityDateStart, Pr.ActivityDateEnd
			</cfquery>
			
		</cfif>	
		
</cfif>	

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>	
--->

<cfset actid = quotedValueList(Activity.ActivityId)>

<cfif url.option eq "1">
	
	<cfquery name="Costing" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    PAR.RequirementId, 
		          PAR.ProgramCode, 
				  PAR.Period, 
				  PAR.EditionId, 
				  PAR.ObjectCode, 
				  R.Description, 
				  R.HierarchyCode,
				  PAR.Fund, 
				  PAR.BudgetCategory, 
				  PAR.ActivityId, 
	              PAR.ItemMaster, 
				  PAR.RequestType, 
				  PAR.RequestDescription, 
				  PAR.RequestDue, 
				  PAR.RequestLocationCode, 
				  PAR.ResourceUnit, 
				  PAR.ResourceQuantity, 
	              PAR.ResourceDays, 
				  PAR.RequestQuantity, 
				  PAR.RequestPrice, 
				  PAR.RequestLumpsum, 
				  PAR.RequestAmountBase, 
				  PAR.AmountBaseAllotment, 
				  			   
				 (  SELECT SUM(R.Amount) 
			  	    FROM   ProgramAllotmentDetailRequest R, 
					       ProgramAllotmentDetail S
					WHERE  R.TransactionId =  S.TransactionId
					AND    R.RequirementId  = PAR.RequirementId 
					AND    S.Status = '1') as Allotment,		
				  
	              PAR.AmountBasePercentageDue, 
				  PAR.RequestRemarks, 
				  PAR.ActionStatus, 
				  PAR.ActionStatusDate, 
				  PAR.ActionStatusOfficer, 
				  PAR.RequirementIdParent, 
	              PAR.Created
		FROM      ProgramAllotmentRequest AS PAR INNER JOIN
	              Ref_Object AS R ON PAR.ObjectCode = R.Code
		WHERE     PAR.Period       = '#url.period#' 
		<cfif actid eq "">
		AND       1=0
		<cfelse>
		AND       PAR.ActivityId   IN (#preservesingleQuotes(actid)#) 
		</cfif>
		AND       PAR.ActionStatus = '1'
		ORDER BY R.HierarchyCode
	</cfquery>	

</cfif>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>	  		  
--->

<cfif url.periodmode eq "fit">
	
		<cfquery name="Period" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT  MIN(ActivityDateStart) AS DateEffective, MAX(ActivityDate) AS DateExpiration
			FROM    ProgramActivity
			WHERE   (ProgramCode = '#URL.ProgramCode#')
			AND     RecordStatus != '9'
		</cfquery>
				
		<cfset perS = Period.DateEffective>
		<cfset perE = Period.DateExpiration>
		
		<cfif pers eq "">
		    <cfset diff = "99999">
		<cfelse>		
			<cfset diff = DateDiff("m", pers, pere)> 
		</cfif>	
		
		<cfif pers eq "" or pere eq "" or diff gte "48">
		
			<cfquery name="Period" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Ref_Period
				 WHERE  Period = '#URL.Period#'
			</cfquery>
			
			<cfset perS = Period.DateEffective>
			<cfset perE = Period.DateExpiration>
				
		</cfif>
				
<cfelse>		
		
	<cfquery name="Period" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_Period
			 WHERE  Period = '#URL.Period#'
	</cfquery>
	
	<cfset perS = Period.DateEffective>
	<cfset perE = Period.DateExpiration>
	
</cfif>	
	
<cfquery name="PeriodListing" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT *
		     FROM Ref_Period
			 WHERE IncludeListing = '1'
			 AND Period <= (SELECT MAX(Period) FROM ProgramPeriod WHERE ProgramCode = '#URL.ProgramCode#')
			 AND Period IN (SELECT Period FROM Organization.dbo.Ref_MissionPeriod WHERE Mission = '#url.Mission#') 			
			 
</cfquery>
	
<cfset cols = 5>

<cf_divscroll overflowx="auto">
		
<table width="100%" align="center" cellspacing="0" cellpadding="0" border="0">

<tr><td align="right">

	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		
	<td class="noprint" height="26">
	
	<cfinvoke component="Service.Access"
			Method="Program"
			ProgramCode="#URL.ProgramCode#"
			Period="#URL.Period#"	
			Role="'ProgramOfficer'"	
	    	ReturnVariable="EditAccess">
		
			<table>
			
			<tr>
			
				<cfoutput>	 	
								
				 <cfif EditAccess eq "Edit" or EditAccess eq "ALL">
				 					 
					 <td>
				
				 	 <img src="#SESSION.root#/Images/activity.png" name="act1" 
							  onMouseOver="document.act1.src='#SESSION.root#/Images/activity_faded.png'" 
							  onMouseOut="document.act1.src='#SESSION.root#/Images/activity.png'" height="20"
							  style="cursor: pointer;" alt="Add an activity and output" border="0" align="absmiddle" 
							  onClick="edit('')"> 
							  
					  </td>
				  
				 </cfif>			
				
				 <td style="padding-left:4px;padding-bottom:6px" align="right">	
						  
					<span style="display:none;" id="printTitle"><cf_tl id="Activity Progress"></span>
					
					<cf_tl id="Print" var="1">
					
					<cf_button2
						title = "#lt_text#"
						type = "Print"
						mode = "icon"
						height = "22px"
						printContent = ".clsPrintContent"
						printTitle = "##printTitle">
						  
				 </td>		 
						
				</cfoutput> 	
												
				<cfif url.mode neq "Print">
					
					<td style="height:40px;padding-left:10px">
					    <table cellspacing="0" cellpadding="0" class="formpadding">
					    <tr class="labelmedium">
						
						<td>	
							<input type="radio" class="radiol" name="Out" id="Out" value="none" <cfif url.option eq "9">checked</cfif> onclick="menuoption('list','9');"></td>
							<cfif Cluster.recordcount eq "0">
							<td style="padding-left:3px"><cf_tl id="Activities"></td>	
							<cfelse>
							<td style="padding-left:3px"><cf_tl id="Activities by Cluster"></td>	
							</cfif>
						</td>	
						
						<td class="labelmedium" style="padding-left:10px">							    
							<input type="radio" class="radiol" name="Out" id="Out" value="hide" <cfif url.option eq "0">checked</cfif> onclick="menuoption('list','0');"></td>
							<cfif Cluster.recordcount eq "0">
							<td style="padding-left:3px"><cf_tl id="Activities and Outputs"></td>	
							<cfelse>
							<td style="padding-left:3px"><cf_tl id="Clustered Activities and Outputs"></td>	
							</cfif>
						</td>		
						
						<td class="labelmedium" style="padding-left:10px">	
							<input type="radio" class="radiol" name="Out" id="Out" value="outcome" <cfif url.option eq "2">checked</cfif> onclick="menuoption('list','2');"></td>
							<td style="padding-left:3px"><cf_tl id="Activities by outcome"></td>	
						</td>		
												
						<td class="labelmedium"  style="padding-left:10px">	
							<input type="radio" class="radiol" name="Out" id="Out" value="show" <cfif url.option eq "1">checked</cfif> onclick="menuoption('list','1');"></td>
							<td style="padding-left:3px"><cf_tl id="Activities and costs"></td>	
						</td>		
						</tr>
						</table>
					</td>
				
				</cfif>
								
				<td id="progressrefresh" onclick="menuoption('list','0')"></td>
								
			</tr>
					
			</table>
			
	</td>
	
	<cfif url.option eq "0">	
		<cfset url.outputshow = "1">
	<cfelse>
	
		<cfset url.outputshow = "0">
	</cfif>
					
	</tr></table>	

</td></tr>

<tr><td id="detail" class="clsPrintContent">

	<table width="99%" align="center" cellspacing="0" cellpadding="0">
	<tr><td>
		
		<table width="100%"
		   height="30" class="navigation_table">
																				
			<cfinclude template="ActivityListingHeader.cfm">
														
			<cfset act = 0>	
			<cfset clrow = 0>
			<cfset dep = 0>
				
			<cfoutput query = "Activity" group="SubProject">			
			    
				<cfquery name="Project" dbtype="query">
					SELECT    MIN(ActivityDateStart) AS ProjectStart, 
					          MAX(ActivityDate)      AS ProjectEnd							  
					FROM      Activity
					<cfif subproject neq "">
					WHERE     SubProject = '#Subproject#'  														
					<cfelse>
					WHERE     Subproject is NULL
					</cfif>
				</cfquery>			
							
			    <cfinclude template="ActivityListingCluster.cfm">								
				<cfoutput>											
					<cfinclude template="ActivityListingLine.cfm">												
				</cfoutput>
			
			</cfoutput>
			
		</table>
	</td></tr>
	
	</table>

</td></tr>

</table>

</cf_divscroll>

<script>
	Prosis.busy('no')
</script>

<cfset ajaxonload("doHighlight")>

