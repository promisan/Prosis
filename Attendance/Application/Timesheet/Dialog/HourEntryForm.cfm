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
<cfparam name="url.hour"           default="">
<cfparam name="url.slot"           default="1">
<cfparam name="url.actionclass"    default="1">
<cfparam name="url.actioncode"     default="">

<cfif url.slot eq "" or url.slot eq "undefined">
  <cfset slot = "1">
<cfelse>
  <cfset slot = url.slot>  
</cfif>

<cfif url.actionclass eq "" or url.actionclass eq "undefined">
  <cfset actionclass = "">
<cfelse>
  <cfset actionclass = url.actionclass>  
</cfif>

<cfif url.actioncode eq "" or url.actioncode eq "undefined">
  <cfset actioncode = "">
<cfelse>
  <cfset actioncode = url.actioncode>  
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfquery name="WorkAction" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_WorkAction R INNER JOIN Ref_TimeClass T ON R.ActionParent = T.TimeClass
		  WHERE  R.Operational = 1
		  ORDER BY R.ListingOrder
</cfquery>

<cfif url.hour eq "">

	<cfquery name="Last" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   TOP 1 * 
		  FROM     PersonWorkDetail
		  WHERE    PersonNo         = '#URL.ID#'
		   AND     CalendarDate     = #dte#
		  ORDER BY CalendarDate DESC,Created DESC
	</cfquery>
	
<cfelse>	

	 <!--- we determine the relevant selection for this so we can
	 show relevant information selected --->
	 
	 <cfquery name="Last" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT TOP 1 * 
		  FROM   PersonWorkDetail
		  WHERE  PersonNo         = '#URL.ID#'
		   AND   CalendarDate     = #dte#		  
		   AND   (
		          
				  (CalendarDateHour = '#URL.Hour#' and HourSlot = '#slot#')
				  
				  OR 
				  
		          (ActionClass = '#actionclass#'  <cfif actioncode neq "">  AND ActionCode = '#actioncode#' </cfif>)
				  
				 )
	</cfquery>	
		  
		  
</cfif>		

<cfoutput>
	<input type="hidden" name="action"     id="action"     value="#last.ActionClass#">
	<input type="hidden" name="actioncode" id="actioncode" value="#last.ActionCode#">	
</cfoutput>
					
<cfquery name="Mission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT O.Mission, P.LocationCode
	 FROM 	PersonAssignment P, Organization.dbo.Organization O
	 WHERE	P.DateEffective   <= #dte# 
	  AND   P.DateExpiration  >= #dte#
	  AND   P.Incumbency      > 0
	  AND   P.AssignmentStatus IN ('0','1')
	  AND   P.AssignmentClass = 'Regular'
	  AND   P.AssignmentType  = 'Actual'
	  AND   P.OrgUnit         = O.OrgUnit
	  AND   P.PersonNo        = '#URL.ID#' 
</cfquery>

<cfset url.cde = WorkAction.ActionClass>
		
<table width="97%" align="center">	
		
	<tr class="hide"><td id="process"></td></tr>
	
	<cfquery name="Location" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Location
		WHERE    Mission = '#Mission.Mission#'
		ORDER BY LocationName
	</cfquery>
	
	<cfif Location.recordcount eq "0">
		
		<cfquery name="LocationList" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   N.Code,
			         N.Name,
					 L.LocationCode,
					 L.Description as LocationName,
					 N.Continent,
					 LocationDefault
			FROM     Ref_PayrollLocation L, 
			         System.dbo.Ref_Nation N,
					 Ref_PayrollLocationMission M
			WHERE    L.LocationCountry = N.Code
			AND      M.LocationCode = L.LocationCode
			AND      M.Mission = '#Mission.Mission#'	
			AND      N.Code != 'UUU'			
			ORDER BY L.Description,N.Name,L.LocationCode
		</cfquery>
				
		<cfif Location.recordcount eq "0">
		
			<cfquery name="Location" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   Code,
				         Name,
						 LocationCode,
						 L.Description as LocationName,
						 Continent,'' as LocationDefault
				FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
				WHERE    L.LocationCountry = N.Code		
				AND      N.Code != 'UUU'			
				ORDER BY Description,Name, LocationCode
			</cfquery>			
		
		</cfif>
	
	</cfif>
	
	<!--- ------------ --->
	<!--- --Location-- --->
	<!--- ------------ --->

	<cfif Location.recordcount eq "0">
	 
		 <input type="hidden" name="locationcode" id="locationcode" value="">
		 
	<cfelse> 
	
		 <tr><td colspan="2" style="padding-top:3px">
		
			<table width="100%" cellspacing="0" cellpadding="0">
			 	
			<tr class="line">
					
			
				<td width="50%"> 
				
					<cfif last.LocationCode eq "">
						<cfset loc = mission.locationcode>
					<cfelse>
					    <cfset loc = last.LocationCode>
					</cfif>		
				   	<select name="locationcode" id="locationcode" style="border:0px;background-color:f1f1f1" size="1" class="regularxxl">
				    <cfoutput query="Location">
						<option value="#LocationCode#" <cfif Loc eq LocationCode>selected</cfif>>
				    		#LocationName# #LocationCode#
						</option>
					</cfoutput>
				    </select>
				</td>
				
				<td align="right" class="labelmedium">
				
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
					<td style="padding-right:4px">
						  <cfset dd = dateAdd("d",-1,dte)>	
						  <cfoutput>  
						  <img src="#Client.VirtualDir#/Images/Back.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="entryhour('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1','#slot#','#url.context#')">
						  </cfoutput>							  	
					</td>
					<td class="labelmedium" style="padding-bottom:3px">					
					 <font color="808080">					
						 <cfoutput>#dateformat(dte,"dddd")# #dateformat(dte,client.dateformatshow)#</cfoutput>
					 </font>					
					</td>
					<td style="padding-left:4px">					
						  <cfset dd = dateAdd("d",1,dte)>	
						  <cfoutput>  
						  <img src="#Client.VirtualDir#/Images/Next.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="entryhour('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1','#slot#','#url.context#')">
						  </cfoutput>						
					</td>
					</table>
				
				</td>				   
				
			</tr>
			
			</table>
		
		</td> 
		
	  </tr>		
	  				
	</cfif>
		
	<tr>
	
		<td style="border:0px solid silver;width:100%" 
		   align="center" valign="top">
		   <cfinclude template="HourEntryFormActivity.cfm">
		</td>  
		
	    <td valign="top">	
		
			<table width="100%">
			
				<tr><td id="myslots">		 
				   <cfinclude template="HourEntryFormSlots.cfm">		
			    </td></tr>							
				
		     </table>	
		 	
		</td>
		
	</tr>
			
</table>

