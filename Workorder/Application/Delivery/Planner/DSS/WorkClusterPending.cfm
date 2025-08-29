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
<cfparam name="url.date" 	 default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.loadmode" default="full">
<cfparam name="url.step" 	 default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

   <cfquery name="Branch"
      datasource="AppsTransaction" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#"> 
        SELECT O.OrgUnit,
               O.OrgUnitName,
               OC.OrganizationCategory,
                   (SELECT MarkerColor 
                     FROM   Organization.dbo.vwOrganizationAddress 
                     WHERE  OrgUnit = O.OrgUnit 
                     AND    AddressType = 'Office') as MarkerColor,
                   (SELECT COUNT(Node)
                         FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# 
                          WHERE Date = N.Date
                         AND OrgUnitOwner = O.OrgUnit
                         AND Branch = '0'
                   ) as Requested,
                   (SELECT COUNT(Node)
                         FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# 
                          WHERE Date = N.Date
                         AND OrgUnitOwner = O.OrgUnit
                         AND Branch = '0'
                         AND ActionStatus in ('1','1a') 
                    ) as Planned
               
        FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N
             INNER JOIN Organization.dbo.Organization O
                   ON   N.OrgUnitOwner = O.OrgUnit
             LEFT OUTER JOIN Organization.dbo.OrganizationCategory OC ON O.OrgUnit = OC.Orgunit
             LEFT OUTER JOIN Organization.dbo.Ref_OrganizationCategory ROC ON ROC.Code = OC.OrganizationCategory 
             AND ROC.Area='Location'                  
        WHERE
        N.Branch = 1
        AND N.Date         = #dts#
        AND   
        <cfif URL.step eq "Final">
                N.ActionStatus in ('1','1a')
             ORDER BY N.Node ASC 
        <cfelse>
              EXISTS
              (
                SELECT 'X'
                FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N2
                WHERE N2.Date = #dts#
                AND   N2.ActionStatus in ('0')
                AND   N2.OrgUnitOwner = N.OrgUnitOwner
                AND   N2.Branch = '0'
              ) 
          ORDER BY N.Node ASC
        </cfif>     
            
   </cfquery>

 	  	
<table cellspacing="0" height="100%" width="100%" align="center">
			
	<tr>
		<td align="right">
			<button type="button" class="button3" style="border:0px" onclick="javascript:hidePending();">
				<cfoutput>
				 <img style="cursor:pointer" onclick="" src="#client.root#/images/close3.gif" alt="" border="0">
				</cfoutput> 	
			</button>				
		</td>		
	</tr>
	<cfif url.step neq "final">
		
		<cfif url.step neq "final">
			<tr style="padding:5px;height:55px;" id="trAddPending" name="trAddPending" >
				<td style="border-bottom:1px solid silver" align="center" valign="center">
					<cfoutput>
							<input type="button" id="btnAdd" name="btnAdd" value="Add to Plan" class="button10g" style="height:34px;width:200px;font-size:15px" onclick="processcluster_add('#url.date#','#url.id#','#url.step#')">		
					</cfoutput>	
				</td>
			</tr>		
		</cfif>	

	<cfelse>
	
		<tr class="line">
			<td class="labellarge"  style="padding-left:10px;padding-top:16px">
				<cfoutput>
				All branches have been scheduled nothing pending
				</cfoutput>							
			</td>
		</tr>
		
	</cfif>
	
		
	<tr>	
	<td height="100%" valign="top" style="padding:10px;height:100%">			

		<table width="99%" cellspacing="0" cellpadding="0" navigationhover="transparent">
			<cfoutput query="Branch">
			
					<tr class="labelit line">
						
						<td class="navigation_pointer"></td>	
						<td width="100%" style="padding-left:4px;height:19px;cursor:pointer">
						
						   <cfif currentrow eq "1"><cf_space spaces="45"></cfif>
						   
						    <cf_UIToolTip tooltip="#orgunitname#">
								<cfif len(orgunitname) gt "26">
								#left(orgunitname,26)#..
								<cfelse>
								#orgunitname#
								</cfif>									
							</cf_UIToolTip>
							
						</td>		
						
						<cfif requested eq planned>
							<cfset cl = "white">
						<cfelse>
							<cfset cl = "ffffaf">	
						</cfif>
						
						<td colspan="3">
						    
							<table>
								<tr class="labelit">	
								<td align="right"  bgcolor="#cl#" style="padding-left:3px">#Requested#</td>	
								<td align="center" bgcolor="#cl#" style="width:3px;padding-left:3px;padding-right:3px">|</td>			
								<td align="left"   bgcolor="#cl#" style="padding-right:3px">#Planned#</td>	
								</tr>
							</table>
						
						</td>
						<td width="20" align="right" style="padding-right:3px">
							<cfif url.step neq "final">						
								<input type="checkbox" style="height:14px;width:14px" name="pselect_#OrgUnit#" id="pselect_#OrgUnit#" value="1" onclick="reloadcontent('dss');" class="selector">
							</cfif>					
						</td>
					</tr>					
										
			</cfoutput>				
																		
							
			</table>	
					
	</td>											
	</tr>			
											
</table>

<script>	
	Prosis.busy('no')
</script>




