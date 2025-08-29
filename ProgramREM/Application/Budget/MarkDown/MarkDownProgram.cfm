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
<cfparam name="client.markdownlist" default="'1'">

<cfif client.markdownlist eq "">

 	<table cellspacing="0" cellpadding="0" align="center" class="formpadding">
	 <tr><td align="center" height="40" class="labelmedium">
	 <font color="808080">There are no items to show in this view.</font>
	 </td></tr>
	 </table>
 
	 <cfabort>
	 
</cfif>

<cfinvoke component="Service.Presentation.Presentation" 
     	  method="highlight" 
	      returnvariable="stylescroll"/>
		  
<cfquery name="GetEdition" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  SELECT * 
		  FROM   Ref_AllotmentEdition R, Ref_AllotmentVersion V
		  WHERE  R.Version = V.Code
		  AND    R.EditionId = '#url.editionid#'
</cfquery>		  

 <cfquery name="GetProgram" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		   SELECT     P.Mission, 
		              Pe.OrgUnit, 
					  O.OrgUnitCode, 
					  O.OrgUnitName, 
					  O.HierarchyCode, 
					  P.ProgramCode, 
					  P.ProgramClass, 
					  P.ProgramName, 
					  Pe.PeriodDescription as ProgramDescription, 
		              Pe.PeriodHierarchy,
					  Pe.ProgramId,
					  <cfloop index="itm" from="1" to="6">
					  	Pe.ReferenceBudget#itm#,
					  </cfloop>
					  Pe.Reference,
					  
					  (SELECT ISNULL(SUM(RequestAmountBase),0) 
					   FROM   ProgramAllotmentRequest S
					   WHERE  ProgramCode   = P.ProgramCode
					   AND    Period        = '#url.period#' 
					   AND    ObjectCode IN (SELECT Code 
					                         FROM Ref_Object 
											 WHERE ObjectUsage = '#GetEdition.ObjectUsage#')
					   <!--- valid and blocked --->						
					   AND    ActionStatus  IN ('0','1')
					   
					   <!--- not partially or fully allotted not records with allotment status = 1 --->
							   
					   AND   (
					         RequirementId NOT IN   
				                          (
										    SELECT   RequirementId
		        		                    FROM     ProgramAllotmentDetailRequest DR,
													 ProgramAllotmentDetail D
		                		            WHERE    DR.RequirementId = S.RequirementId
											AND      DR.TransactionId = D.TransactionId
											AND      D.Status = '1'     
										   )	
							 OR		
							 
							 RequirementId NOT IN   
				                          (
										    SELECT   RequirementId
		        		                    FROM     ProgramAllotmentDetailRequest DR															
		                		            WHERE    DR.RequirementId = S.RequirementId																										
										   )		   
							 )
							 			   
					   AND   EditionId     = '#url.editionid#') as PendingRequirement,	
					   
							   
					 (   SELECT SUM(AmountBase) 
						 FROM  ProgramAllotmentDetail
						 WHERE ProgramCode     = P.ProgramCode
						 AND   Period          = '#url.period#' 
						 AND   ObjectCode IN (SELECT Code 
						                      FROM   Ref_Object 
						   					  WHERE  ObjectUsage = '#GetEdition.ObjectUsage#')
					     AND   Status          = '1'
						 AND   TransactionType = 'Standard'
						 AND   EditionId       = '#url.editionid#' ) as Allocated		   				
					  
			FROM      Program AS P INNER JOIN
		              ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
		              Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit
					  
			WHERE     P.ProgramCode IN
			
                          (SELECT    ProgramCode
                            FROM     ProgramAllotmentRequest
							WHERE    ProgramCode = P.ProgramCode
                            AND      EditionId = '#url.editionid#') 
							
		    AND       Pe.Period = '#url.period#'	
			
			<!--- not locked for data entry --->
			
			AND       P.ProgramCode IN
			
                          (SELECT    ProgramCode
                            FROM     ProgramAllotment
							WHERE    ProgramCode = P.ProgramCode
							AND      Period = '#URL.Period#'
                            AND      LockEntry = 0) 
						
			AND       P.ProgramCode IN (SELECT  ProgramCode 
			                            FROM    ProgramAllotmentRequest 
										WHERE   ProgramCode   = P.ProgramCode
										   AND  Period        = '#url.period#' 
										   AND  ObjectCode IN (SELECT Code 
										                       FROM   Ref_Object 
															   WHERE  ObjectUsage = '#GetEdition.ObjectUsage#')
										   AND  ActionStatus != '9'
										   AND  EditionId     = '#url.editionid#'										
										)			
			AND       P.ProgramCode IN (#preserveSingleQuotes(client.markdownlist)#)	
												   
			ORDER BY  O.HierarchyCode,Pe.PeriodHierarchy		
					 		 
		</cfquery>
		
		<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
		   
			<tr>
				<td style="padding-left:4px" class="labelit"></td>
				<td></td>
				<td class="labelit">Code</td>
				<td class="labelit">Budget Code</td>
				<td class="labelit">Name</td>
				<td class="labelit" align="right" style="padding-right:4px">Pending<br>Requirements</td>		
				
				<td class="labelit" align="right" style="padding-right:4px">(Partially)<br>cleared</td>	
			</tr>
			<tr><td colspan="7" height="1" class="line"></td></tr>
			<tr><td height="5"></td></tr>
			
			<cfoutput query="Getprogram" group="OrgUnit">
			
			  <tr>
				<td style="padding-left:4px" colspan="7" height="25" class="labelmedium"><b>#OrgUnitName#</b></td>
				<td></td>
				<td></td>
			  </tr>
			  			  
			  <tr><td colspan="7" class="line"></td></tr>
			
			  <cfoutput>
			  			  						
					<cfif PendingRequirement gt 0 or Allocated gt 0>
					
						<tr class="labelit navigation_row line">
						    <td height="20" width="20" bgcolor="white"></td>
							<td align="center">
							<cfif abs(PendingRequirement) gte 1>
							<input type="checkbox" 
							       onclick="hl(this,this.checked);ajaxsel('program',this.value,this.checked)" 
								   name="programselect" 
								   id="programselect" 
								   value="#ProgramId#">
							</cfif>	   </td>					
							<td>#Reference#</td>
							<td>
							 <cfloop index="itm" from="1" to="6">
							  #evaluate("ReferenceBudget#itm#")#<cfif itm neq "6">-</cfif>
							  </cfloop>
							</td>
							<td>#ProgramName#</td>
							<td align="right" style="padding-right:4px">#numberformat(pendingrequirement,"__,__.__")#</td>
							<td align="right" style="padding-right:4px">#numberformat(allocated,"__,__.__")#</td>
						</tr>
					
					</cfif>
				
			  </cfoutput>
							
			  <tr><td height="5"></td></tr>
			
			</cfoutput>
				
		</table>			