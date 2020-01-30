
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
				   class="button10s" 
				   onclick="ColdFusion.navigate('../Bucket/BucketProfile/BucketProfileSubmit.cfm?idfunction=#url.idfunction#&languagecode=#url.languagecode#','process#url.languagecode#','','','POST','profile#url.languagecode#')">
			</td>
			<td id="process#url.languagecode#" width="60" align="right" class="labelit"></td>
			</tr>
			</table>
		</td>
	</tr>	
		
	<tr><td  colspan="2" style="padding:4px;" >
		
		  <cf_ApplicantTextArea
				Table           = "Applicant.dbo.FunctionOrganizationNotes" 
				Domain          = "Position"
				FieldOutput     = "ProfileNotes"				
				LanguageCode    = "#url.languagecode#"
				Height			= "150"
				Mode            = "Edit"
				Format          = "RichTextFull"
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
			   class="button10s" 
			   onclick="ColdFusion.navigate('../Bucket/BucketProfile/BucketProfileSubmit.cfm?idfunction=#url.idfunction#&languagecode=#url.languagecode#','process#url.languagecode#','','','POST','profile#url.languagecode#')">
		</td>
		<td width="60"></td>
		</tr>
		</table>
		</td>
		</tr>	
				
		<tr><td height="5"></td></tr>

	
</table>

</cfform>	
	
</cfoutput>

<cfset ajaxonload("initTextArea")>
