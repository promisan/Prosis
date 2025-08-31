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
 <cfparam name="Attributes.Owner" 		default="">
 <cfparam name="Attributes.ApplicantNo" default="">
 <cfparam name="Attributes.Mode" 		default="Edit">
  <cfparam name="Attributes.Title" 		default="Please respond the following questions on the candidate">

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 	  SELECT   *
		  FROM     #CLIENT.LanPrefix#Ref_Topic
		  WHERE    Operational = 1
		  AND Topic IN (SELECT Topic 
		  	            FROM Ref_TopicOwner 
					  	WHERE Owner = '#Attributes.Owner#'
						AND Operational = 1)
		  ORDER BY ListingOrder 
</cfquery>

<table width="100%">
  <cfif Master.recordcount neq 0>
	
    <cf_tl id="#Attributes.Title#" var="1">
    <cfset msg1 = lt_text>
    <cfoutput>
    <tr>
    	<td colspan="2" class="labelmedium" style="height:30;padding-left:10px"><i><cfoutput>#msg1#</cfoutput></b> </font>
    		<input type="hidden" id="fApplicantNo" name="fApplicantNo" value="#Attributes.ApplicantNo#">
    	</td>
    </tr>
    </cfoutput>
  
    <tr>
  	<td colspan="2">

		  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
		  
		  	<cfset row = 0>

			<cfoutput query="Master">
		  
			  <cfset row = row+1>		 
			  
			  <TR> 		  		
	          <td height="25" width="5%" align="center">
			  <td width="5%"  class="labelit" style="padding-left:3px">#CurrentRow#.</td>
			  <td width="50%" class="labelit">	 
			  #Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif></td>
			  <td>
			  	<!---
				<cfif  Attributes.Mode eq "Read">
					<div style="position:relative">
					<div id="first" style="position:absolute;top:0px;left:0px;width:400px;height:200px;">
				</cfif>
				--->

			  <cf_TopicEntry 
			       Mode="regularxl"
			       ApplicantNo ="#Attributes.ApplicantNo#" 
		           Topic="#Topic#">

				<!---
				<cfif  Attributes.Mode eq "Read">
					</div>
					<div id="second" style="position:absolute;top:0px;left:0px;width:400px;height:200px;"></div>
					</div>			 
				</cfif>
				--->
			  </td>
			  </tr>
			  
			  <cfif QuestionCondition neq "">
				  <tr>
					  <td></td>
					  <td></td>
					  <td class="labelit"><b>Note:&nbsp;</b><i>#QuestionCondition#</i></td>
					  <td width="20%" align="right" class="regular"></td>
				  </tr>
			  </cfif>
			  		  
		    </cfoutput>		
		 								
		  </table>
	
	</td>
  
  </tr>
  </cfif>    

  </table>