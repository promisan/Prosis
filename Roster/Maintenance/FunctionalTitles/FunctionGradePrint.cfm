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

<HTML><HEAD>
    <TITLE>Job profile</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>



<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<cfquery name="Grade" 
 datasource="AppsSelection">
	 SELECT *,
	 		(SELECT Description FROM Ref_GradeDeployment WHERE GradeDeployment = G.GradeDeployment) as GradeDeploymentDescription
	 FROM   FunctionTitleGrade G, 
	        FunctionTitle F
	 WHERE  F.FunctionNo      = '#URL.ID#'	 
	 AND    G.GradeDeployment = '#URL.ID1#'
	 AND    F.FunctionNo      = G.FunctionNo
</cfquery>

<table width="96%" align="center">
	
	<tr><td style="height:50px;font-size:31px;font-weight:normal" class="labellarge">Generic Job Profile</td></tr>	
	
	<tr><td>
	
			<table width="100%" class="formpadding">
			
			<tr><td height="1" colspan="2" class="line"></td></tr>
			<cfoutput>
			<tr><td height="4"></td></tr>
			<tr class="labelmedium2">
			   <td width="120" style="padding-left:4px"><cf_tl id="Function">:</td>
			   <td width="90%">#Grade.FunctionDescription#</td>
			</tr>
			<tr><td height="4"></td></tr>
			<tr><td height="1" colspan="2" class="linedotted"></td></tr>
			<tr><td height="4"></td></tr>
			<tr class="labelmedium2">
			   <td style="padding-left:4px"><cf_tl id="Grade">:</td>
			   <td>#Grade.GradeDeployment# - #Grade.GradeDeploymentDescription#</td>
			</tr>
			</cfoutput>
			<tr><td height="4"></td></tr>
			<tr><td height="1" colspan="2" class="linedotted"></td></tr>
			<tr><td height="4"></td></tr>
			<tr>
			   <td colspan="2" align="center">         
				 
				   <cf_ApplicantTextArea
					Table           = "FunctionTitleGradeProfile" 
					Domain          = "JobProfile"
					FieldOutput     = "ProfileNotes"
					Mode            = "View"
					Key01           = "FunctionNo"
					Key01Value      = "#URL.ID#"
					Key02           = "GradeDeployment"
					Key02Value      = "#URL.ID1#">
			   
			   </td>
			</tr>
			<tr><td></td></tr>	
			<tr class="noprint"><td colspan="2" align="center">
				<input type="button" name="Print" value="Print profile" style="width:150;height:29px" class="button10g"        onclick="window.print();">
				<input type="button" name="Close" class="button10g"     style="width:150;height:29px" onclick="window.close();" value="Close profile">
			</td></tr>
			
			</table>
	
	</td></tr>

</table>