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
<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   FunctionOrganization
	WHERE  FunctionId = '#url.idfunction#'
</cfquery>


<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_SystemLanguage
	WHERE  LanguageCode = '#url.languagecode#'
	
</cfquery>

<cfoutput>

<cfquery name="check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_TextArea 
		WHERE    TextAreaDomain = 'Position' 			
</cfquery>	


<cfif check.recordcount eq "0">

	<table><tr class="labelmedium"><td align="center"><cf_tl id="No text areas set for domain : position"></td></tr></table>

<cfelse>

	<cfform name="profile#url.languagecode#">
	
	<table width="98%" align="center">
				
		<tr><td colspan="2" align="center">
			
				<table width="100%">
				<tr>
				<td width="60"></td>
				<td width="80%" align="center" style="padding-top:5px">
				<input type="button" 
				       name="Save" 
					   value="Save #Language.LanguageName#" 
					   style="width:140"
					   class="button10g" 
					   onclick="ptoken.navigate('../Bucket/BucketProfile/BucketProfileSubmit.cfm?idfunction=#url.idfunction#&languagecode=#url.languagecode#','process#url.languagecode#','','','POST','profile#url.languagecode#')">
				</td>
				<td id="process#url.languagecode#" width="60" align="right" class="labelit"></td>
				</tr>
				</table>
			</td>
		</tr>	
			
		<tr><td  colspan="2" style="padding:4px;">
			
			  <cf_ApplicantTextArea
					Table           = "Applicant.dbo.FunctionOrganizationNotes" 
					Domain          = "Position"
					FieldOutput     = "ProfileNotes"				
					LanguageCode    = "#url.languagecode#"
					Height			= "150"
					Mode            = "Edit"
					Format          = "Mini"
					Key01           = "FunctionId"
					Key01Value      = "#URL.IDFunction#">			
			
			</td></tr>
			
			<tr><td colspan="2" align="center">
			
			<table width="100%">
			<tr>
			<td width="60"></td>
			<td width="80%" align="center" style="padding-top:5px">
			<input type="button" 
			       name="Save" 
				   value="Save #Language.LanguageName#" 
				   style="width:140"
				   class="button10g" 
				   onclick="ptoken.navigate('../Bucket/BucketProfile/BucketProfileSubmit.cfm?idfunction=#url.idfunction#&languagecode=#url.languagecode#','process#url.languagecode#','','','POST','profile#url.languagecode#')">
			</td>
			<td width="60"></td>
			</tr>
			</table>
			</td>
			</tr>	
					
			<tr><td height="5"></td></tr>
	
		
	</table>
	
	</cfform>	

</cfif>
	
</cfoutput>

<cfset ajaxonload("initTextArea")>
