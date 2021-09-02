<cfparam name="url.idmenu" default="">

<style type="text/css">
	.required {
		color:red;
	}
</style>


<script  language = "JavaScript">
	function validate(){
		var collectionPath = document.dialog.item("valCollectionPath");
		var indexTemplate =   document.dialog.item("valIndexDataTemplate");
		var collectionTemplate =  document.dialog.item("valCollectionTemplate");
		var message = "";
			
		if (collectionPath!= null && collectionPath.value == 0)
			message = "Please enter an existing Path collection storage\n";
		
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

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  html="Yes"
			  banner="blue" 
			  bannerheight="50" 
			  option="Define Collection and Indexing settings" 
			  label="Add Collection" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formspacing formpadding">

	<tr>
		<td colspan="3"><br></td>
	</tr>

	 <TR class="labelmedium">
	 <TD width="40%">Mission:<span class="required">*</span>&nbsp;</TD>  
	 <td colspan="2">
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
			<option value="#Mission#">#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>

	 <TR>
	 <TD class="labelmedium">Collection Name:<span class="required">*</span>&nbsp;</TD>  
	 <TD colspan="2">
			<cfinput class="regularxl" type="Text" name="CollectionName" value="" message="Please enter a collection name" required="Yes" size="30" maxlength="40">
	 </TD>
	 </TR>
	 

	 <!--- Field: Application server  --->
	 <tr class="labelmedium">
	 <td>
	 	Run from server:
	 </td>
	 <td colspan="2">
	 
	 	<cfquery name="AppServer" 
		datasource="AppsInit" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT ApplicationServer
			FROM Parameter
	 	</cfquery>
		
		<select name="ApplicationServer" class="regularxl" id="ApplicationServer">
			<cfloop query="AppServer">
				<option value="#ApplicationServer#"> #ApplicationServer#
			</cfloop>
		</select>
			
	 </td>
	 </tr>

	 <!--- Field: SearchEngine --->
	 <tr class="labelmedium">
		 <td>
		 	Search Engine:
		 </td>
		 <td colspan="2">
			<select name="SearchEngine" class="regularxl" id="SearchEngine">
				<option value="Solr" selected> Solr </option>
				<!---
				<option value="Verity"> Verity [deprecated] </option>
				--->
			</select>
		 </td>
	 </tr>
	 
	 <!--- Field: SystemModule --->
	 <tr class="labelmedium">
		 <td  >
		 	SystemModule:
		 </td>
		 <td colspan="2">
			<cfquery name="SystemModule" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SystemModule
				FROM Ref_SystemModule
		 	</cfquery>
			
			<select name="SystemModule" class="regularxl" id="SystemModule">		 
			 	<cfloop query="SystemModule">
					<option value="#SystemModule#"> #SystemModule# </option>
				</cfloop>
			</select>
		 </td>
	 </tr>
	 
	 
	 <!--- Field: DocumentPathName --->
	 <tr class="labelmedium">
		 <td valign="top" style="cursor:pointer" title="Select one or more document framework directories">
		 	Document Folders to be indexed:
		 </td>
		 <td colspan="2">
			
			<cfselect name="DocumentPathName" height="23"
				required   = "yes"				
				message    = "Please select a Document path"
				multiple   = "yes"
				bindOnLoad = "yes"
				class      = "regularxl"
		   		bind       = "cfc:service.Input.Input.DropdownSelect('AppsSystem','Ref_Attachment','DocumentPathName','DocumentPathName','SystemModule',{SystemModule},'','','Null')">				
		    </cfselect>
						
		 </td>
	 </tr>
	 	
	 <!--- Field: CollectionPath --->
	 <tr class="labelmedium">
		 <td>
		 	Path Collection storage:<span class="required">*</span>&nbsp;
		 </td>
		 <td>
		 				
		  		<cfinput type = "Text" 
				name		  = "CollectionPath" 
				onblur        = "ColdFusion.navigate('CollectionDirectory.cfm?path='+this.value+'&container=library&resultField=valCollectionPath','library')"
				size  		  = "40" 
				required	  = "yes" 
				value         = "D:\Collections\"
				message		  = "Please enter the Path of the Collection storage directory"
				maxlength	  = "80"
				class		  = "regularxl">
		 </td>
 		 <td >
		 	<cfdiv id="library" bind="url:CollectionDirectory.cfm">
		 </td>
	 </tr>
	 
	 <!--- Field: Extensions --->
	  <tr class="labelmedium">
		 <td  style="cursor:pointer">
 				<cf_tooltip  tooltip="File extensions: .html, .cfm, etc." content="Extensions">:
		 </td>
		 <td colspan="2">
		  		<cfinput type = "Text" 
				name		  = "Extensions" 
				size  		  = "40" 
				required	  = "no" 
				value         = ".html,.htm,.pdf,.doc,.docx,.xls,.xlsx,.rtf,.txt,.ppt"
				title		  = "File extensions: .html, .cfm, etc."
				maxlength	  = "80"
				class		  = "regularxl">
		 </td>
	 </tr>
	 
	 <!--- Field: IndexDataTemplate --->
	 <tr class="labelmedium">
		 <td>
		 	URL Data Index template:
		 </td>
		 <td>
				<cfinput type="Text" name="IndexDataTemplate" class="regularxl"
				value = "/system/Collection/CollectionIndex.cfm"
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template='+this.value+'&container=indexTemplate&resultField=valIndexDataTemplate','indexTemplate')"
				size="40" required="no" maxlength="80"  >
		 </td>
		 <td>
		 	<cfdiv id="indexTemplate" 
						   bind="url:CollectionTemplate.cfm">
		 </td>
	 </tr>

	 <!--- Field: IndexAttachmentLimit --->
	 <tr class="labelmedium">
		 <td>
		 	Index attachment limit:
		 </td>
		 <td colspan="2">
				<cfinput type = "Text" 
				name		  = "IndexAttachmentLimit" 
				size  		  = "50" 
				required	  = "no" 
				value         = "300"
				maxlength	  = "3"
				class		  = "regularxl">
		 </td>
	 </tr>
	  	 
	 <!--- Field: CollectionTemplate --->
	 <tr class="labelmedium">
		 <td>
		 	URL Drill down template:
		 </td>
		 <td>
				<cfinput type="Text" name="CollectionTemplate" class="regularxl"
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template='+this.value+'&container=colTemplate&resultField=valCollectionTemplate','colTemplate')" 
				size="40" required="no" maxlength="80"  >
		 </td>
		 <td>
		 	<cfdiv id="colTemplate" 
						   bind="url:CollectionTemplate.cfm">
		 </td>
	 </tr>

	
	<!--- Field: Language --->
	<TR class="labelmedium">
    <td>Language:</td>
    <td colspan="2">
	
		<cfquery name="Language" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT Code,LanguageName
				FROM   Ref_SystemLanguage
		</cfquery>
		
		<select name="LngCode" id="LngCode" class="regularxl">		
			<cfloop query="Language">
				<option value="#Code#"> #LanguageName# </option>
			</cfloop>
		</select>
	
	</td>
	</tr>
	
	<tr class="labelmedium">
    <td>Category support</td>
    <td colspan="2">
		<select name="CollectionCategories" id="CollectionCategories" class="regularxl">
			<option value="0"> No
			<option value="1" selected> Yes
		</select>
	</td>
	</tr>
	
	<tr><td></td></tr>
	<tr><td class="line" colspan="4" align="center" height="6">
		
	<tr>		
		<td align="center" colspan="4">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit " onClick="return validate()">
		</td>
	</tr>
    
</TABLE>
</cfoutput>
	

</CFFORM>

</BODY></HTML>