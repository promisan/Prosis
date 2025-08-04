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

<cfquery name="ProgramPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT  *
    FROM    ProgramPeriod
	WHERE   ProgramCode = '#url.programcode#'
	AND     Period      = '#url.planperiod#'					  
</cfquery>

<cfquery name="getUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT  *
    FROM    Organization
	WHERE   OrgUnit = '#ProgramPeriod.orgunit#'					  
</cfquery>

<cfquery name="Units" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT  OrgUnit
    FROM    Organization
	WHERE   Mission       = '#getUnit.Mission#'					  
	AND     MandateNo     = '#getUnit.MandateNo#'
	AND     HierarchyCode LIKE '#getUnit.HierarchyCode#.%'	
</cfquery>

<cfset showorgunits = "#quotedvalueList(Units.OrgUnit)#">

<cfif showorgunits eq "">
	<cfset showorgunits = "0">
</cfif>

<cfquery name="getLowerPrograms" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     O.OrgUnit, O.HierarchyCode
	FROM       ProgramPeriod Pe INNER JOIN Organization.dbo.Organization O ON Pe.OrgUnit = O.Orgunit
	WHERE      ProgramCode IN (SELECT ProgramCode 
	                           FROM   Program 
							   WHERE  Mission = '#getUnit.Mission#'
							   AND    ProgramAllotment = '1')
	AND        Period     = '#url.planperiod#'	
	AND        (
	          ( Pe.PeriodHierarchy LIKE '#ProgramPeriod.PeriodHierarchy#.%' AND Pe.OrgUnit != '#ProgramPeriod.orgunit#')
	             OR   Pe.OrgUnit IN (#preserveSingleQuotes(showOrgunits)#) 
		       )	   
</cfquery>	

<cfset HideUnit = "'0'">

<cfloop query="getLowerPrograms">
		
		<cfquery name="LowerUnits" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT  OrgUnit
		    FROM    Organization
			WHERE   Mission       = '#getUnit.Mission#'					  
			AND     MandateNo     = '#getUnit.MandateNo#'
			AND     HierarchyCode LIKE '#HierarchyCode#%'	
		</cfquery>
		
		<cfset HideUnit = "#HideUnit#,#quotedvalueList(LowerUnits.OrgUnit)#">

</cfloop>


<!--- URL.period is the period of the EXECUTION period of the edition !! --->

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT  *
    FROM    Ref_Period
	WHERE   Period = '#url.period#'					  
</cfquery>

<cfquery name="List" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    P.PostGradeBudget, 
	          P.FunctionNo, 
			  P.FunctionDescription, 
			  P.PositionNo, 
			  P.SourcePostNumber,
			  P.PositionParentId,
			  P.OrgUnitOperational, 
			  L.*,
			 
			  ( SELECT TOP 1 PersonNo 
			    FROM   Employee.dbo.PersonAssignment
			    WHERE  PositionNo      = P.PositionNo
			    AND    AssignmentStatus IN ('0','1')
			    AND    Incumbency      > 0
			    AND    AssignmentType  = 'Actual'
			    AND    DateEffective  <= '#period.dateEffective#'
				AND    DateExpiration >= getDate() <!--- person currently on this position --->
			    -- AND    DateExpiration >= '#period.dateEffective#'
				ORDER BY DateEffective DESC ) as PersonNo
			  
    FROM     Ref_AllotmentEditionPosition P INNER JOIN Purchase.dbo.ItemMasterList L ON P.PostGradeBudget = L.TopicValueCode			
		 			 
	WHERE    EditionId = '#url.editionid#'
	AND		 ( P.OrgUnitOperational = '#ProgramPeriod.orgunit#'  OR
	            ( P.OrgUnitOperational IN (#preserveSingleQuotes(showOrgunits)#) 
				  AND P.OrgUnitOperational NOT IN (#preserveSingleQuotes(HideUnit)#)
				)
			 ) 	
		
	<!--- hierarchy check if no programs under it --->
	
	<cfif mode.BudgetEntryPositionFilter neq "">
	AND      P.PostClass = '#mode.BudgetEntryPositionFilter#' 
	</cfif>
		
	<!--- positions valid on the start of the budget preparation year --->	
	AND      L.ItemMaster      =  '#url.itemmaster#'
	AND      L.Operational     =  1 	
	AND      P.Operational     =  1
	AND      (P.Fund = '#url.fund#' or P.Fund is NULL)
	ORDER BY PostOrderBudget, PositionNo	
							  
</cfquery>

<cfif list.recordcount eq "0">
	
	<cfoutput>
	<tr><td colspan="#dates.recordcount+4#" align="center" style="height:40px" class="labelmedium2"><font color="green">There are no more positions for this organization element  that are pending your submission.<br><font color="FF0000">Contact your administrator if this is not correct.</font></td></tr>
	</cfoutput>
	
<cfelse>	

		<cfoutput query="list">
			
			<cfquery name="Dates" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    A.*, '' as requestQuantity
					FROM      Ref_Audit A
					WHERE     A.Period = '#url.period#'	
					          #preserveSingleQuotes(filterdates)#		  
					ORDER BY  DateYear, AuditDate 
			</cfquery>	
										
		    <cfif Request.recordcount eq "1">
		
				<cfquery name="Requirement" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      ProgramAllotmentRequest
					WHERE     ProgramCode         = '#Request.ProgramCode#'		  
					AND       Period              = '#Request.period#'
					AND       EditionId           = '#Request.EditionId#'
					
					AND       RequirementIdParent = '#Request.RequirementIdParent#'		
					AND       TopicValueCode      = '#TopicValueCode#'		
					AND       PositionNo          = '#PositionNo#'
					AND       RequestType         = 'Standard' <!--- do not show reippled transaction --->
				</cfquery>							
	
				<cfif Requirement.recordcount eq "1">	
										
					<cfquery name="Dates" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT    A.*, P.RequestQuantity
						FROM      Ref_Audit A 
						          LEFT OUTER JOIN ProgramAllotmentRequestQuantity P 
								  ON A.AuditId = P.AuditId AND P.RequirementId = '#Requirement.requirementid#'
						WHERE     A.Period = '#url.period#'		
						#preserveSingleQuotes(filterdates)#	  
						ORDER BY  DateYear, 
						          AuditDate 
								  
					</cfquery>	
															
				</cfif>
					 
			 </cfif>	
			 
			  <cfquery name="AlreadyCoveredMonth" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT      R.AuditId
					FROM        ProgramAllotmentRequestQuantity AS R INNER JOIN
                    			ProgramAllotmentRequest AS P ON R.RequirementId = P.RequirementId
					<cfif Request.RequirementIdParent neq "">			
					WHERE       P.RequirementIdParent != '#Request.RequirementIdParent#'		
					<cfelse>
					WHERE       1=1
					</cfif>
					AND         P.Period              = '#url.period#'
					AND         P.EditionId           = '#url.EditionId#'
					AND         P.TopicValueCode      = '#TopicValueCode#'		
					AND         P.PositionNo          = '#PositionNo#'
					AND         P.RequestType         = 'Standard'									
		    </cfquery>
					
			<cfset covered = valueList(AlreadyCoveredMonth.AuditId)>			 
			 
			<cfset row = currentrow>
							 
			 <tr class="navigation_row" style="height:10px">
			 <td style="height:12px;min-width:370px;border-top:1px solid silver;border-left:0px dotted silver;padding-left:10px">
			 
				 <table width="100%">
				 <tr class="labelmedium" style="height:23px">
				 <td style="width:36px">#PostGradeBudget#</td>
				 <td style="width:36px">
					 <a href="javascript:EditPosition('#getUnit.mission#','#getUnit.mandateno#','#PositionNo#')">
					 <cfif sourcePostNumber neq "">
					 #SourcePostNumber#
					 <cfelse>
					 #PositionParentId#
					 </cfif>
					 </a>
				 </td>
				 <td>#FunctionDescription#</td>
				 
				 <cfif PersonNo neq "">
				 
					 <cfquery name="getPerson" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   Person 
							WHERE  PersonNo = '#PersonNo#'
					  </cfquery>		
					 <td style="padding-left:4px;padding-right:5px" align="right">					 
					 <a href="javascript:EditPerson('#personno#')" class="navigation_action">#getPerson.LastName#</a>
					 </td>
					 
				 </cfif>
				 
				 </td></tr>
				 </table>
			 </td>
			 	  
			  <cfset total = 0>
			  <cfset col   = 0>
			  <cfset rate = list.listamount>
			  <cfset cov   = 1>
			  			  
			  <cfloop query="dates">
			  
			   <cfset col = col+1>
			   
			   <cfif find(auditid, covered)> 	
			   	
			     <td style="background-color:##e1e1e180;border-top:1px solid silver;border-left:1px solid silver">				
				  <input type="hidden" value="0" name="c#row#_#col#" id= "c#row#_#col#">				  
				  </td>
				   <cfif currentrow eq "1">
				    <td align="center" style="background-color:##f1f1f180;cursor:pointer;padding-right:1px;border-top:1px solid silver;border-left:1px solid silver"></td>
				   </cfif>
				   
			   <cfelse>
			   
			   	  <cfset cov = "0">  
			   			   
			      <td style="background-color:##ffffff80;border-top:1px solid silver;border-left:1px solid silver">
				  
				   <input type = "text"
				      onchange = "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=#col#&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')" 
					  style    = "font-size:13px;padding-top:2px;width:100%;text-align:center" 
					  onclick  = "if (this.value != '1') { this.value = '1' } else { this.value = '0'};ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=#col#&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')"
					  name     = "c#row#_#col#"
					  id       = "c#row#_#col#"
					  readonly					 				  
					  class    = "button3 enterastab"
					  value    = "<cfif Request.RequirementIdParent eq "">1<cfelseif requestQuantity neq "">#RequestQuantity#</cfif>">
			  
					  <cfif requestQuantity eq "" and Request.RequirementIdParent eq "">
						  <cfset total = total+1>
					  <cfelseif requestQuantity neq "">
						  <cfset total = total+requestquantity>					  
					  </cfif>
					  				  					  
			     </td>
				 
				  <cfif currentrow eq "1">
			
					 <td align="center" bgcolor="f4f4f4" style="cursor:pointer;padding-right:1px;border-top:1px solid silver;border-left:1px solid silver"
				   		onclick="ptoken.navigate('RequestDialogFormMatrixCopy.cfm?row=#row#&col=1&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal');domatrix()">
						 <img src="#SESSION.root#/images/copy.png" height="12" width="12" alt="" border="0">
					 </td>
				 
				   </cfif>
			     
			  </cfif>		   				 				  
			 			   
			  </cfloop>
			  
			  <!--- --------- --->
			  <!--- row total --->
			  <!--- --------- --->
			  
			  <cfif cov eq "1">
			  
			  <td colspan="3" style="border-top:1px solid silver" bgcolor="e4e4e4">
			  
			   <input type= "hidden" 
				    class   = "button3" 
				 	readonly 
					style   = "font-size:13px;padding-top:2px;text-align:right;padding-right:2px;;width:100%"
					name    = "requestQuantity_#row#" 
					id      = "requestQuantity_#row#" 
					value   = "0"> 	 
			  </td>
			  
			  <cfelse>
			  			  
			  <td align="right" style="padding-right:2px;border-top:1px solid silver;border-left:1px solid silver">
			 			 
			     <input type= "input" 
				    class   = "button3" 
				 	readonly 
					style   = "font-size:13px;padding-top:2px;text-align:right;padding-right:2px;;width:100%"
					name    = "requestQuantity_#row#" 
					id      = "requestQuantity_#row#" 
					value   = "#numberformat(total,',__')#"> 	 
			  
			  </td>
			  <td  align="center" style="padding-top:5px;padding-left:4px;border-top:1px solid silver;border-left:1px solid silver">
			  
			  <!--- only visible for budgetmanager --->
			  
			  <cfparam name="Requirement.requirementid" default="#URL.RequirementId#">
			  
			  <cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">
			 			  		   
			   	   <cf_img icon="expand" toggle="yes" id="rate_#row#"
					   onclick="parent.getrate('#row#','#url.programcode#','#url.itemmaster#','#topicvaluecode#','','#Requirement.requirementid#','#url.objectCode#','#url.location#','#url.period#')">			 			 						
					   
			  </cfif>		   
				   
			  </td>
			  
			  <td style="padding-left:3px;padding-top:1px;padding-right:1px;border-top:1px solid silver;border-left:1px solid silver;border-right:2px solid silver">			 
			  			   			  			   
			    <cfif Request.recordcount eq "1" and Requirement.recordcount eq "1">	
																	  
				     <input type   = "input" 
						  onchange = "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=0&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')"		
						  class    = "regularh" 
						  style    = "border:0px;padding-top:2px;text-align:right;padding-right:2px;height:100%;width:99%" 
						  id       = "requestPrice_#row#" 
						  name     = "requestPrice_#row#" 
						  value    = "#numberformat(requirement.requestprice,'__,__')#">  
					  				  
			    <cfelse>
				
								
					<cfquery name="GetPeriod" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_Period
							WHERE  Period = '#URL.Period#'
					</cfquery>
													
					<cfquery name="StandardCost" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT IC.* 
						FROM   ItemMasterStandardCost IC INNER JOIN 
						       ItemMasterList L ON IC.TopicValueCode = L.TopicValueCode AND IC.ItemMaster = L.ItemMaster
							   
						WHERE  IC.ItemMaster		= '#URL.ItemMaster#' 
						AND    IC.TopicValueCode	= '#TopicValueCode#' 						
						AND    IC.Mission			= '#URL.Mission#' 						
						AND    IC.DateEffective 	=
						
									( SELECT   TOP 1 DateEffective
										FROM   ItemMasterStandardCost
										WHERE  ItemMaster		= '#URL.ItemMaster#' 
										AND    TopicValueCode	= '#TopicValueCode#' 
										AND    Mission			= '#URL.Mission#' 
										<cfif url.location neq "">
										AND    Location         = '#URL.Location#'
										</cfif>
										AND    CostElement      = IC.CostElement 
										AND    DateEffective   <= '#getPeriod.DateEffective#'
									  ORDER BY DateEffective DESC	
									)
						
						<cfif url.location neq "">
						AND Location	= '#url.Location#'	
						<cfelse>
						AND Location = ''
						</cfif>
						
						ORDER BY L.ListOrder, IC.CostOrder
						
					</cfquery>		
															
					<cfif StandardCost.recordcount eq 0>
															
					     <input type="input"  
						  onchange= "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=0&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')"
						  class="regularh" style="font-size:13px;border:0px;padding-top:2px;text-align:right;width:96%" id="requestPrice_#row#" name="requestPrice_#row#" value="#numberformat(rate,',__')#">  	  
					
					<cfelse>
					
														
				     <cfif mode.BudgetForceStandardCost eq "1">										
						<input type="input"  
						  readonly
						  class="regularh" style="font-size:13px;border:0px;padding-top:2px;text-align:right;width:96%" id="requestPrice_#row#" name="requestPrice_#row#" value="0">  	  							  
					 <cfelse>
					    <input type="input"
						  class="regularh" style="font-size:13px;border:0px;padding-top:2px;text-align:right;width:96%" id="requestPrice_#row#" name="requestPrice_#row#" value="0">  	
					 </cfif>	  
						  
					</cfif>			   	  
				  
			    </cfif>
							   
			   </td>	
			   
			   </cfif>
			   		   			  
			 </tr>
			 
			 <cfif cov eq "0">
							 
			 <tr style="height:0px"><td colspan="#5+col#">					 		 		
			 		<cfdiv bind="url:RequestDialogGetRate.cfm?overwrite=#Request.recordcount#&row=#row#&programcode=#url.programcode#&period=#url.period#&&itemmaster=#url.itemmaster#&objectCode=#url.objectCode#&topicvaluecode=#topicvaluecode#&requirementid=#Requirement.requirementid#&location=#url.location#" 
					id="dPrice_#row#" style="display:none" / >
				</td>
			 </tr>			
			 
			 </cfif>
													
		</cfoutput>		
		
		<cfoutput>
			<input type="hidden" name="PositionList" id="PositionList" value="#quotedvalueList(List.PositionNo)#">		
			<input type="hidden" id="listcount" value="#list.recordcount#">
			<input type="hidden" id="colncount" value="#dates.recordcount#">
		</cfoutput>	
									
		<cfset ajaxonload("domatrix")> 
				
</cfif>	
