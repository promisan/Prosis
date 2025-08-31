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
 <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
  
 <cfquery name="SelArea" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
 		SELECT   DISTINCT Area
		FROM     Ref_ExperienceParent
 </cfquery>		
 
 <cfset row = 0>
 
 <cfloop query="Selarea">
 
 <tr>  
   <td colspan="4">
   
	   <cfoutput>
	   
	   <table cellspacing="0" cellpadding="0">
	   
		   <tr>
		   
			   <td style="padding-top:2px">	   	   
			   
			       <cf_img icon="open" onClick="keyword('<cfoutput>#Area#</cfoutput>')">
				   
				   <!---
			  
				   <button type="button"
				        class="button3"
				        >
						
							   <img src="#SESSION.root#/Images/select4.gif" 
								    onMouseOver="document.img0_#Area#.src='#SESSION.root#/Images/button.jpg'"
						 			onMouseOut="document.img0_#Area#.src='#SESSION.root#/Images/select4.gif'"
									id="img0_#Area#"
									name="img0_#Area#"
								    alt="Select criteria for #Area#" 
								    border="0" 
								    height="13"
								    width="13"
								    align="absmiddle" 
								    style="cursor: pointer;">
					</button>
					
					--->
				
				</td>
				
				<td style="padding-left:4px;height:20px" class="labelmedium"> 	
				   <a href="javascript:keyword('<cfoutput>#Area#</cfoutput>')"><font color="0080C0">#Area#</font></a>	   
			    </td>
			
			</tr>
			
	   </table>
	   
	   </cfoutput>
   
   </td>
</tr> 
 
<tr>

    <td colspan="1"></td>	
    <td height="1" colspan="3">
					
		<cfquery name="Keywords" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT   RC.Parent,
			         RC.ListingOrder, 
					 R.ExperienceFieldId, 
					 R.Description, 
					 Ros.SelectParameter, 
					 SearchEnable, 
					 RP.PeriodEnable
			FROM     Ref_ExperienceClass RC INNER JOIN
	                 Ref_Experience R ON RC.ExperienceClass = R.ExperienceClass INNER JOIN
	                 RosterSearchLine Ros ON R.ExperienceFieldId = Ros.SelectId INNER JOIN
	                 Ref_ExperienceParent RP ON RC.Parent = RP.Parent
			WHERE    Ros.SearchId    = '#URL.ID#' 
			AND      RP.Area         = '#Area#'
			AND      RP.SearchEnable = '1' <!--- enabled for searching --->
			ORDER BY RC.Parent, RC.ListingOrder
		</cfquery>	
			
		<table width="95%" align="right">
		
			<cfset ar = "#SelArea.Area#">
			
			<cfoutput query="Keywords" group="Parent">
			
				<cfquery name="Operator" 
			        datasource="AppsSelection" 
			        username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			        SELECT *
					FROM   RosterSearchLine
					WHERE  SearchClass = '#Parent#Operator' 
					AND    SearchId = '#URL.ID#'				  
				</cfquery>	
				
				<tr>
				    <td width="70%" class="labelmedium" colspan="1"><b><cfif Parent neq ar>#Parent#<cfelse>#ar#</cfif></td>
					<td width="30%" style="color:0080ff" class="labelmedium" align="left" colspan="2">#Operator.SelectId# of the below</td>		
				</tr>
				
				<cfoutput>
								
				<tr  class="linedotted labelmedium">
				
				     <td width="80%" class="labelit" style="padding-left:10px">- #Description#</td>
					 
					 <cfif PeriodEnable eq "1">	
					    <td align="right" style="padding:2px">					
   					    <!--- enabled to record the period --->					 				 
					    <cfset row = row + 1>
					    <input type="hidden" name="SelectClass_#row#"    ide="SelectClass_#row#"     value="#Parent#">
					    <input type="hidden" name="SelectID_#row#"       ide="SelectID_#row#"        value="#ExperienceFieldId#">
						<input type="text"   name="SelectParameter_#row#" id="SelectParameter_#row#" value="#SelectParameter#" size="2" maxlength="3" style="text-align:right;font-size:11px" class="regularh enterastab" onchange="profileupdate('#url.id#','#Parent#','#ExperienceFieldId#',this.value)" style="text-align: center;"></td>									 
						<td style="padding-left:2px">Yrs</td>		
					 <cfelse>
						 <input type="hidden" name="SelectParameter_#row#" id="SelectParameter_#row#" value="#SelectParameter#" size="2" maxlength="3" style="text-align:right;font-size:11px" class="regularh enterastab" onchange="profileupdate('#url.id#','#Parent#','#ExperienceFieldId#',this.value)" style="text-align: center;"></td>			
					 </cfif>								 				 
					 
					 <td width="5%" align="right" style="padding-left:4px">
					     <cf_img icon="delete" tooltip="Remove selection" onClick="Prosis.busy('yes');_cf_loadingtexthtml='';profiledel('#url.id#','#Parent#','#ExperienceFieldId#')">
					 </td>
					 
				</tr>
					
				</cfoutput>
			
			</cfoutput>
			
		</table>

	</td>
</tr>

</cfloop>

<cfoutput>
	   <input type="hidden" name="Row" value="#row#">	   
</cfoutput>					

</table>
