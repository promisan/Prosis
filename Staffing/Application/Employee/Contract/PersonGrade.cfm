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
<!--- summary --->

<cfparam name="url.entry" default="view">
	
<cfif url.entry is "delete">

	<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PersonGrade
		WHERE   PersonNo      = '#URL.ID#'
		AND     DateEffective = '#url.eff#'
		AND     Source        = 'Manual'
	</cfquery>
	
	<cfset url.entry = "view">

</cfif>

<!---
<cf_screentop height="100%" user="No" label="Grade History" banner="yellow" option="Summary of Grade/Step increase" layout="webapp">
--->

<table width="97%" align="center" cellspacing="0" cellpadding="0" height="100%" bgcolor="white">

    <tr class="hide"><td id="dialoggradesave"></td></tr>
	
	<tr><td valign="top">
	
	<cfquery name="Grade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    PersonGrade
		WHERE   PersonNo = '#URL.ID#'
		ORDER BY DateEffective
	</cfquery>	
	
	<cfform name="gradeform" id="gradeform">
	
	<table width="95%" align="center" class="navigation_table">	
	
	<cfif url.entry eq "view">
	
		<cfoutput>		
		<tr  class="labelmedium2">
		  <td colspan="5" style="font-size:16px;padding-top:5px;padding-left:0px">
		  <a href="javascript:_cf_loadingtexthtml='';ptoken.navigate('PersonGrade.cfm?&ts='+new Date().getTime()+'&entry=add&id=#url.id#','dialoggrade')"><cf_tl id="Manual entry"></a>
		  </td>
		</tr>
		</cfoutput>
		
	<cfelse>
	
		<tr><td height="8"></td></tr>	
		
	</cfif>	
	
	<tr class="labelmedium2 line">
	  <td><cf_tl id="Effective"></td>
	  <td height="30"><cf_tl id="Grade"></td>
	  <td><cf_tl id="Step"></td>	 
	  <td><cf_tl id="Source"></td>
	  <td><cf_tl id="Officer"></td>
	  <td></td>
	</tr>
			
	<cfif url.entry eq "add">	
					
		<tr>
		  <td height="40">
		  
		    <cf_intelliCalendarDate9
				FieldName="DateEffective" 			
				AllowBlank="False"
				Default=""
				class="regularxl">				  
		  </td>
		  
		  <cfquery name="PostGrade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Ref_PostGrade
				WHERE PostGradeContract = 1
				<!--- I made this more flexible 1/6/2010
				AND   PostGradeParent = (SELECT PostGradeParent 
				                         FROM   Ref_PostGrade 
										 WHERE  PostGrade = '#contract.ContractLevel#')
										 --->								
				ORDER BY PostOrder
			</cfquery>
			
			<cfif PostGrade.recordcount eq "0">
			
				<cfquery name="PostGrade" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_PostGrade
					WHERE PostGradeContract = 1										
					ORDER BY PostOrder
				</cfquery>
							
			</cfif>
		  
		  
		  <td>
		  
	         <select name="contractlevel" 
				   size="1" class="regularxl">
					<cfoutput query="PostGrade">
						<option value="#PostGrade#" <cfif grade.contractlevel eq PostGrade>selected</cfif>>#PostGrade#</option>
					</cfoutput>
			  </select>		
		  
		  </td>
		  <td>
		       <cfinput type="Text"
			       name="contractstep"
			       validate="integer"
			       required="Yes"
				   range="1,15"
				   message="please record a valid step 1-15"
			       visible="Yes"
			       enabled="Yes"			     
			       size="1"
				   style="width:20px;text-align:center"
			       maxlength="2"
				   value="1"
			       class="regularxl">
		  
		  </td>
		  <td class="labelmedium">Manual</td>
		  <td colspan="1" align="center">
		  
		  <cfoutput>
			  <input type="button" 
			    value="Save" 
				onclick="_cf_loadingtexthtml='';ptoken.navigate('PersonGradeSave.cfm?id=#url.id#','dialoggradesave','','','POST','gradeform')" name="SaveGrade" class="button10s" style="height:25;width:90">
			  </cfoutput>
		  
		  </td>
	
		</tr>	
		
	
	</cfif>
	
	<cfoutput query="grade">
		
	<tr class="line labelmedium navigation_row">
	   <td>#dateformat(dateeffective,CLIENT.DateFormatShow)#</td>
	   <td height="20">#ContractLevel# <font size="1">#dateformat(leveleffective,CLIENT.DateFormatShow)#</font></td>
	   <td>#ContractStep#</td>	   
	   <td>#Source#</td>
	   <td>#OfficerFirstName# #OfficerLastName#</td>
	   <td style="padding-top:2px">
	   <cfif source eq "Manual">
	   <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('PersonGrade.cfm?entry=delete&id=#url.id#&eff=#dateformat(dateeffective,client.datesql)#','dialoggrade')">
	   </cfif>
	   </td>
	</tr>		
	
	</cfoutput>
	
	</table>
	
	</cfform>
	
	</td></tr>

</table>

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doCalendar")>
