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
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Ref_ReportControl L
	WHERE ControlId = '#URL.ID#'
</cfquery>

<cf_textareascript>

<cf_screentop height="100%" jQuery="yes" scroll="no" 
    label="About this report" html="yes" line="no" layout="webapp" banner="blue">

<cfform action="RecordSubmit.cfm?ID=#URL.ID#" method="POST" name="entry" target="result">

<table width="100%" height="100%" align="center">
			
		<tr>
	        <td colspan="2" height="100%">
													
				<cf_textarea
				 	name = "FunctionAbout"                 
					 height="680"
					 color="ffffff"
					 resize="false"
					 init="Yes">
				 <cfoutput>#Line.FunctionAbout#</cfoutput></cf_textarea>
				
			</td>					
		</TR>
		
		<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>
		
		<tr>
		<td height="35" 
		    colspan="2" 
			align="center"><input type="submit" class="button10g" style="width:160px;height:24px" name="About" id="About" value="Save">
		</td>
		</tr>

</table>	

</cfform>

<cfset ajaxonload("initTextarea")>
	
<cf_screenbottom layout="webapp">	