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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
		      scroll="No" 
			  layout="webapp" 
			  title="Edit Collection" 
			  label="Edit Collection" 
			  html="yes"
			  banner="yellow" 
			  bannerheight="55"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
 <style type="text/css">
	.required {
		color:red;
	}
</style>
 
 
<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Collection
	WHERE CollectionName = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this collection ?")) {	
		return true 	
	}	
	return false	
}	

function validate(){

	var indexTemplate =   document.dialog.item("valIndexDataTemplate");
	var collectionTemplate =  document.dialog.item("valCollectionTemplate");
	var message = "";
	
	if (indexTemplate != null && indexTemplate.value == 0)
		message = message+"Please enter a valid URL data index template\n";
		
	if (collectionTemplate!=null && collectionTemplate.value == 0)
		message = message + "Please enter a valid URL drill down template";
	
	if (message.length > 0)
	{
		alert(message);
		return false;
	}
		
	return true;
}

</script>


<CFFORM action="RecordSubmit.cfm?collectionid=#collection.collectionid#" method="post" enablecab="yes" name="dialog">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	 <tr><td height="4"></td></tr>
	 <cfoutput>
	 <!--- Field CollectionName (readonly) --->
	 <TR>
	 <TD width="40%" class="labelmedium">Collection Name:&nbsp;</TD>  
	 <td height="20" class="labelmedium" colspan="2">#Collection.CollectionName# 
	 	<cfinput type="hidden" name="CollectionName" value="#Collection.CollectionName#">
	 </td>
	 </tr> 
	
	 
	 <!--- Field: Application server  --->
	 <tr>
	 <td height="23" class="labelmedium">Run from server:&nbsp;</td>
	 <td colspan="2" class="labelmedium">
	 	 #Collection.ApplicationServer#
	 </td>
	 </tr>

	 <!--- Field: SearchEngine --->
	 <tr>
		 <td height="23" class="labelmedium">
		 	Search Engine:&nbsp;
		 </td>
		 <td colspan="2" class="labelmedium">
			#Collection.SearchEngine#
		 </td>
	 </tr>
	 
	 <!--- Field: SystemModule --->
	 <tr>
		 <td height="23" class="labelmedium">
		 	SystemModule:&nbsp;
		 </td>
		 <td colspan="2" class="labelmedium">
			#Collection.SystemModule#
		 </td>
	 </tr>
	 
	 <tr>
		 <td valign="top" class="labelmedium">Document path name: </td>
		 <td colspan="2">
			
			<cfquery name="AttachmentFolder" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT DocumentPathName
					FROM   Ref_Attachment
					WHERE SystemModule = '#Collection.SystemModule#'
			</cfquery>
			
			<select name = "DocumentPathName" id="DocumentPathName" multiple style="height:120" class="regularxl">
				<cfloop query="AttachmentFolder">
				
					<cfquery name="Check" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT DocumentPathName
							FROM   CollectionFolder
							WHERE DocumentPathName = '#DocumentPathName#'
							AND   CollectionId = '#Collection.CollectionID#'
					</cfquery>
				
					<option value="#DocumentPathName#" <cfif Check.RecordCount gt 0> selected</cfif> >#DocumentPathName#</option>
				</cfloop>
			</select>
			
			
		 </td>
	 </tr>
	 
	  <!--- Field: Mission --->
	 <TR>
	 <TD class="labelmedium" height="23">Mission:<span class="required">*</span>&nbsp;</TD>  
	 <TD colspan="2">
		<cfquery name="Mission" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Mission
			FROM Ref_Mission
	 	</cfquery>
		<select name="mission" id="mission" class="regularxl">
			<option value="">ALL</option>
		<cfloop query="Mission">
			<option value="#Mission#" <cfif Collection.Mission eq '#Mission#'>selected</cfif>>#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	 
	 <!--- Field: CollectionPath --->
	 <tr>
		 <td height="23" class="labelmedium">
		 	Path Collection storage:&nbsp;
		 </td>
		 <td colspan="2" class="labelmedium">
		  	#Collection.CollectionPath#
		 </td>
	 </tr>
	 
	 <!--- Field: Extensions --->
	  <tr>
		 <td class="labelmedium">
			<cf_tooltip  tooltip="File extensions: .html, .cfm, etc." content="Extensions">:
		 </td>
		 <td class="regular" colspan="2">
		  		<cfinput type = "Text" 
				name		  = "Extensions" 
				value		  = "#Collection.Extensions#"
				size  		  = "40" 
				required	  = "no" 
				title		  = "File extensions: .html, .cfm, etc."
				maxlength	  = "80"
				class		  = "regularxl">
		 </td>
	 </tr>

	 <!--- Field: IndexDataTemplate --->
	 <tr>
		 <td class="labelmedium">
		 	URL Data Index template:
		 </td>
		 <td class="regular">
				<cfinput type="Text" name="IndexDataTemplate" value="#Collection.IndexDataTemplate#" 
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template='+this.value+'&container=indexTemplate&resultField=valIndexDataTemplate','indexTemplate')"
				size="40" required="no" maxlength="80"class="regularxl">
		 </td>
		 <td>
		 	<cfdiv id="indexTemplate" 
						   bind="url:CollectionTemplate.cfm?template=#Collection.IndexDataTemplate#">
		 </td>
	 </tr>

	  <!--- Field: IndexAttachmentLimit --->
	 <tr>
		 <td class="labelmedium">
		 	Index attachment limit:
		 </td>
		 <td colspan="2">
				<cfinput type = "Text" 
				name		  = "IndexAttachmentLimit" 
				size  		  = "40" 
				required	  = "no" 
				value		  = "#Collection.IndexAttachmentLimit#"
				maxlength	  = "3"
				class		  = "regularxl">
		 </td>
	 </tr>
	 
	 <!--- Field: CollectionTemplate --->
	 <tr>
		 <td class="labelmedium">
		 	URL Drill down template:
		 </td>
		 <td>
				<cfinput type="Text" name="collectionTemplate" value="#Collection.CollectionTemplate#" 
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template='+this.value+'&container=colTemplate&resultField=valCollectionTemplate','colTemplate')"
				size="40" required="no" maxlength="80" class="regularxl">
		 </td>
		 <td>
		 	<cfdiv id="colTemplate" 
				  bind="url:CollectionTemplate.cfm?template=#Collection.CollectionTemplate#">
		 </td>
	 </tr>
	 
	 <tr>
	 <TD class="labelmedium">Index Timestamp:&nbsp;</td>
	 <TD colspan="2">
		<cf_calendarscript>

		<cf_intelliCalendarDate9
		FieldName="IndexTimeStamp" 
		class="regularxl"
		Default="#dateformat(Collection.IndexTimeStamp,'#CLIENT.DateFormatShow#')#"
		AllowBlank="True">		
		
	 </TD>
	 </TR>
	 
	  <tr>
	 <TD class="labelmedium">
	 	Language:&nbsp;
	 </td>
	 <TD colspan="2">
	 
		<cfquery name="Language" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT Code,LanguageName
				FROM Ref_SystemLanguage
		</cfquery>
		
		<select name="LngCode" id="LngCode" class="regularxl">
		
			<cfloop query="Language">
				<option value="#Code#" <cfif Collection.LanguageCode eq '#Code#'>selected</cfif>> #LanguageName# </option>
			</cfloop>
		
		</select>
	 </TD>
	 </TR>
	 
	   <tr>
	 <TD class="labelmedium">
	 	Categories support:
	 </td>
	 <TD class="regular" colspan="2">
	 		<select name="Categories" id="Categories" class="regularxl">
				<option value="0" <cfif Collection.CollectionCategories eq 0>selected</cfif>> no
				<option value="1" <cfif Collection.CollectionCategories eq 1>selected</cfif>> yes
			</select>
	 </TD>
	 </TR>
	
		
	<tr><td colspan="4" class="linedotted"></td></tr>
	
	<tr>	
		<td align="center" colspan="4">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Update " onClick="return validate()">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
