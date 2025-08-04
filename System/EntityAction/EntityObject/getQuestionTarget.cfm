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

<cfswitch expression="#url.field#">

<cfcase value="target">
	
	<cfif url.inputmode eq "YesNo">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>
	</select>
	
	<cfelseif url.inputmode eq "YesNoNA">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>	
	</select>
	
	<cfelseif url.inputmode eq "YesNoPA">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>	
		<option value="5" <cfif url.selected eq "5">selected</cfif>>Partly</option>
	</select>
	
	<cfelse>
		
		<cfoutput>
		<select name="InputValuePass" class="regularxl">
		   <cfloop index="itm" from="1" to="#url.inputmode#">
			<option value="#itm#" <cfif url.selected eq itm>selected</cfif>>#itm#</option>
		   </cfloop>			
		</select>
		</cfoutput>
	
	</cfif>
	
</cfcase>	

<cfcase value="inputmodelabel">
	
	<cfif url.inputmode eq "2" or url.inputmode eq "3" or url.inputmode eq "4" or url.inputmode eq "5" or url.inputmode eq "6">
	
		<cfquery name="get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM 	Ref_EntityDocumentQuestion		
			WHERE 	DocumentId  			= '#url.documentId#'
			<cfif url.questionid eq "">
			AND     1=0
			<cfelse>
			AND 	QuestionId  			= '#url.questionId#'
			</cfif>
		</cfquery>
	   
	   <cfoutput>
		<table cellspacing="0" cellpadding="0">
		<tr><td style="padding-left:5px;padding-right:5px"><cf_uitooltip tooltip="Record labels for score 1 to #url.inputmode# separated by a comma"><cf_tl id="Labels"></cf_uitooltip></td>
	    <td>
		<input type="text" name="InputModeStringList" value="#get.InputModeStringList#" maxlength="100" class="regularxl" style="width:600px">		
		</td></tr></table>
		</cfoutput>
	
	<cfelse>
	
		<input type="hidden" name="InputModeStringList" value="">
	
	</cfif>

</cfcase>

</cfswitch>