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
<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK">

<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

 <cfif url.orgunit eq "0">
	<cfset org ="">
<cfelse>
    <cfset org = url.orgunit>
</cfif>

<cfquery name="Base" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		SELECT     DISTINCT Sub.Actor
					  
		FROM         (SELECT     Pe.Mission, 
		
								(CASE WHEN OrgUnit = '0' THEN
		                                (SELECT    OrgUnitOperational
		                                 FROM      Position
		                                 WHERE     PositionNo = Pe.PositionNo) ELSE OrgUnit END) AS OrgUnit, 
								 Pe.ActionStatus, 
								 YEAR(Pe.DateEvent) AS Year, 
								 MONTH(Pe.DateEvent) AS Month, 
		                         Pe.EventTrigger, 
								 R.Description AS EventTriggerName, 
								 Pe.EventCode, 
								 E.Description AS EventName,
		                         
		                         (SELECT     TOP 1 U.Account
		                          FROM       Organization.dbo.OrganizationObjectActionAccess AS OOAA INNER JOIN
		                                     Organization.dbo.OrganizationObjectAction AS OOA ON OOAA.ObjectId = OOA.ObjectId INNER JOIN
		                                     System.dbo.UserNames AS U ON OOAA.UserAccount = U.Account INNER JOIN
		                                     Organization.dbo.OrganizationObject AS OO ON OOAA.ObjectId = OO.ObjectId
		                          WHERE      OO.ObjectKeyValue4 = Pe.EventId AND OOAA.AccessLevel = 1
		                          ORDER BY   OOAA.Created DESC) 
								  
								  AS Actor
															
		            FROM       dbo.PersonEvent AS Pe INNER JOIN
		                       dbo.Ref_EventTrigger AS R ON Pe.EventTrigger = R.Code INNER JOIN
		                       dbo.Ref_PersonEvent AS E ON Pe.EventCode = E.Code
							   
		            WHERE      Pe.ActionStatus <> '9') AS Sub 
							   
				 <cfif url.OrgUnit neq "">				   
			   INNER JOIN
		                      Organization.dbo.Organization AS O ON Sub.OrgUnit = O.OrgUnit INNER JOIN
		                      Organization.dbo.Organization AS P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.HierarchyRootUnit = P.OrgUnitCode
					</cfif>		  
					  
		WHERE  Sub.Mission IN (#preserveSingleQuotes(mission)#) 
		<cfif url.period eq "All">
			AND    Sub.Year >= '2015'
		<cfelse>
			AND    Sub.Year    = '#url.period#' 
		</cfif>
		
		<cfif org neq "">	
		AND    P.OrgUnit = '#url.orgunit#'				  					  
		</cfif>

</cfquery>

<cfquery name="Actor" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   System.dbo.UserNames
	<cfif quotedValueList(Base.Actor) eq ""> 
		WHERE  1=0
	<cfelse>
		WHERE  Account IN (#quotedValueList(Base.Actor)#)
	</cfif>
	ORDER BY LastName
</cfquery>

<cfset link = "#session.root#/Portal/Topics/PersonEvent/EventContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#url.orgunit#&divname=#thisDivName#">

<cfoutput>
	<table width="100%">	
	    
	    <tr><td style="padding-left:10px">
			    <table>
			    <tr>
				
				<td class="label" style="color:gray;padding-left:3px;padding-right:10px"></td>
					<td style="padding-left:7px;padding-right:4px" class="labelit">
						<input type="radio" class="radiol" name="layout_#thisDivName#" id="layout_#thisDivName#" value="Trigger" 
							onclick="if ($('##divPersonEventDetail_#thisDivName#').length > 0) { ptoken.navigate('#link#&status='+$('##fldstatus_#thisDivName#').val()+'&actor='+$('##fldactor_#thisDivName#').val()+'&sort='+$('##fldsort_#thisDivName#').val()+'&stage='+$('##fldstage_#thisDivName#').val()+'&layout=Trigger','divPersonEventDetail_#thisDivName#');}"
							checked></td>
					<td class="labelmedium" style="padding-right:4px"><cf_tl id="Category"></td>
					<td style="padding-left:7px;padding-right:4px" class="labelit">
						<input type="radio" class="radiol" name="layout_#thisDivName#" id="layout_#thisDivName#" value="Event" 
							onclick="if ($('##divPersonEventDetail_#thisDivName#').length > 0) { ptoken.navigate('#link#&status='+$('##fldstatus_#thisDivName#').val()+'&actor='+$('##fldactor_#thisDivName#').val()+'&sort='+$('##fldsort_#thisDivName#').val()+'&stage='+$('##fldstage_#thisDivName#').val()+'&layout=Event','divPersonEventDetail_#thisDivName#');}"
							></td>
					<td class="labelmedium" style="padding-right:4px"><cf_tl id="Event"></td>				
				
				<td></td>
				
				<td style="padding-left:10px" class="labelit"><cf_tl id="Actor"></td>
											
					<td class="label" style="color:gray;padding-left:12px">	
					  <select class="regularxl" id="fldactor_#thisDivName#" style="width:130px" onchange="doChangeActor('#link#','#URL.mission#',this,document.getElementById('fldsort_#thisDivName#'),document.getElementById('fldstage_#thisDivName#'),'#thisDivName#')">					 		
					       <option value="">ANY</option>
						  <cfloop query="Actor">				  
						  	<option value="#Account#" <cfif session.acc eq account and lastName neq "Pana">selected</cfif>>#LastName#</option>					  
						  </cfloop>
					  </select>	
					</td>		
					
					<input type="hidden" id="fldstatus_#thisDivName#" value="0">	
					
				<td style="padding-left:10px" class="labelit"><cf_tl id="Distribution"></td>
								
				<td class="labelit" style="color:gray;padding-left:12px">	
				  <select class="regularxl" id="fldsort_#thisDivName#" onchange="doChangeActor('#link#','#URL.mission#',document.getElementById('fldactor_#thisDivName#'),this,document.getElementById('fldstage_#thisDivName#'),'#thisDivName#')">					 		
				      <option value="EventMonth"><cf_tl id="Due date"></option>
					  <option value="ActionEffective" selected><cf_tl id="Action effective"></option>						 
				  </select>	
				</td>		
				
				<td style="padding-left:10px" class="labelit"><cf_tl id="Status"></td>
								
				<td class="labelit" style="color:gray;padding-left:12px">	
				  <select class="regularxl" id="fldstage_#thisDivName#" onchange="doChangeActor('#link#','#URL.mission#',document.getElementById('fldactor_#thisDivName#'),document.getElementById('fldsort_#thisDivName#'),this,'#thisDivName#');">					 		
				      <option value="Pending" selected><cf_tl id="Pending"></option>
					  <option value="Completed"><cf_tl id="Completed"></option>		
					  <option value=""><cf_tl id="Both"></option>						 
				  </select>	
				</td>											
					
				</tr>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>