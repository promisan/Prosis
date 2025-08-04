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
<cfparam name="url.mode" default="dialog">

<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="FunctionAdmin" 
		  returnvariable="Access">

<cfform name="gjp" id="gjp" style="height:100%" onsubmit="return false">

<table height="100%" width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td height="4" colspan="3" align="center">


<tr>
   <td colspan="3" height="100%" align="center">
   
    <cf_divscroll> 
		  		  		  
	<cfif Access eq "EDIT" or Access eq "ALL">       
	 
	   <cf_ApplicantTextArea
		Table           = "FunctionTitleGradeProfile" 
		Domain          = "JobProfile"
		FieldOutput     = "ProfileNotes"
		Ajax            = "Yes"
		Mode            = "Edit"
		Height          = "75"
		Format          = "RichText"
		Key01           = "FunctionNo"
		Key01Value      = "#URL.ID#"
		Key02           = "GradeDeployment"
		Key02Value      = "#URL.ID1#">
				
	<cfelse>
	
	  <cf_ApplicantTextArea
		Table           = "FunctionTitleGradeProfile" 
		Domain          = "JobProfile"
		FieldOutput     = "ProfileNotes"
		Mode            = "View"
		Key01           = "FunctionNo"
		Key01Value      = "#URL.ID#"
		Key02           = "GradeDeployment"
		Key02Value      = "#URL.ID1#">
	
	</cfif>	
	
	</cf_divscroll>
   
   </td>
</tr>


<cfif url.mode eq "dialog">
			  
	<tr>
		<td style="padding:10px" colspan="3" align="center">
		   <table width="100%"><tr>
		   <td align="left" width="200"></td>
		   <td width="70%" align="center">
			<cfif Access eq "EDIT" or Access eq "ALL">
				<cfoutput>
				<input type="Submit" style="height:30px;width:200px" name="Save" class="button10g" value="Save" onclick="javascript: do_submit('#url.mode#','#URL.ID#','#URL.ID1#','#url.idmenu#');">
				</cfoutput>
			</cfif>
			</td>
			<td align="right" width="200" id="processVariable"></td>
			</tr></table>
		</td>
	</tr>
	

</cfif>


</table>

</cfform>

<cfset ajaxonload("initTextArea")>