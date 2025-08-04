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

<cfparam name="url.scope"    default="profile">  
<cfparam name="url.source"   default="">  
<cfparam name="url.occgroup" default="">

<cfparam name="URL.ID" default="0000">

<!--- check for full listing in default roster to select --->

<!--- add to defualt roster in case 
a. function is roster function 
b. function is not enabled for manual entry in another edition
c. function is part of an edition that is enabled
d. does not exist in the default roster yet --->


<table width="100%" align="left">

<tr class="line">
   	<td class="labellarge" style="font-size:20px;height:35px">
	<cf_tl id="Roster this candidate">
	<!--- we take the default submission source to capture the bucket candidacy --->
	<cfoutput>
	<input type="hidden" id="source" name="Source" value="#Parameter.DefaultPHPEntry#">
	</cfoutput>
	<!--- <cf_ProfileSource PersonNo= "#url.id#" ShowAll="Yes" label=""> --->	 
	</td>
</tr>	

<tr><td>

<table width="100%" class="navigation_table">

<!--- -----------------------------------------------------------  --->
<!--- check the default source through the user or the background  --->
<!--- -----------------------------------------------------------  

<cfquery name="CheckOcc" dbtype="query">
	SELECT DISTINCT OccupationGroupDescription
	FROM FunctionAll 
</cfquery>

<cfset showOcc = 0>
<cfif CheckOcc.RecordCount gte 8>
	<cfset showOcc = 1>
</cfif>

--->

 	
<script language="JavaScript">
	
	function hl(fld,row,grp){
	
		 itm = document.getElementById("row"+row)
		 occ = document.getElementById(grp+"Min")
	 		 	 		 	
		 if (fld != false){		
		 itm.className = "labelmedium line highLight2";				 
		 }else{		 
		 itm.className = "labelmedium line";			    	 
		 }
	  }	  
	  
	function expand(cls) {	
		if ($('.'+cls).is(':visible'))	{	   
			$('.'+cls).hide()		
		} else {
			$('.'+cls).show()			
		}		
	}
	

</script>

<TR class="labelmedium fixrow line">
    <td height="20" style="padding-left:3px"><cf_tl id="Area"></td>
	<TD><cf_tl id="No"></TD>
    <TD><cf_tl id="Function"></TD>
    <TD><cf_tl id="Level"></TD>
	<TD><cf_tl id="Reference"></TD>
	<td><cf_tl id="Current"></td>
	<td width="20" style="padding-right:4px"><cf_tl id="S"></td>
</TR>

<cfoutput query="FunctionAll" group="OccupationGroupDescription">
	
	<cfset clGroup = "regular">
	<cfset clDetail = "regular">
		
	<tr class="#clGroup# fixrow2"><td colspan="7">
		
		<table width="100%" class="formpadding">
		<tr>
		<!---
		<td width="20" style="padding-top:2px">
			<cf_img icon="expand" toggle="yes" onclick="javascript:expand('#OccupationalGroup#')">
		</td>
		--->
		<td class="labelmedium" style="font-size:17px;height:32px">#OccupationGroupDescription#</td>
		</tr>
		</table>
		
	</td></tr>			

	<cfoutput group="OrganizationDescription">
				
		<TR class="#OccupationalGroup# #clDetail#">
			<td></td>
		    <td colspan="6" class="labelmedium">#OrganizationDescription#</td>
		</tr>
				
		<CFOUTPUT>
						
			<TR class="navigation_row labelmedium #OccupationalGroup# #clDetail# line" id="row#currentrow#" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
			    <TD style="height:17;width:1px"></TD>
				<TD>#FunctionNo#</TD>
			    <TD>
					<cfif AnnouncementTitle neq "">
						#AnnouncementTitle#
					<cfelse>
						#FunctionDescription#
					</cfif>
				</TD>
			    <TD>#GradeDeployment#</TD>
				<TD>#ReferenceNo#</TD>
				<td>
				
					<cfquery name="getStatus" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_StatusCode
							WHERE  Owner = '#edition.Owner#'
							AND    Id     = 'FUN'
							AND    Status = '#ApplicantFunctionStatus#'
					</cfquery>					
					#getStatus.Meaning#
					
				</TD>
				<td align="center" style="padding-right:4px">	
				
				  	<cfif ApplicantFunctionStatus neq "3">
					<input type="checkbox" class="radiol" name="FunctionId" value="#FunctionId#" onClick="hl(this.checked,'#currentrow#','#OccupationalGroup#')" <cfif ApplicantFunctionStatus eq "3">checked</cfif>>				
					</cfif>
				</TD>
			</TR>
						
		</CFOUTPUT>
	
	</CFOUTPUT>

	<tr><td colspan="6" class="line"></td></tr>

</CFOUTPUT>

</table>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>




