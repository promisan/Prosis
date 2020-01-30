
<cfquery name="get" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT *
	 FROM   FunctionOrganizationMessage
	 WHERE  MessageId = '#MessageId#'			
</cfquery>

<cfoutput>

<cfform name="messageform_#box#">

<table width="100%" height="100%" cellspacing="0" class="formpadding">

<tr>

	<td class="labelit">Name:</td>
	<td>
	<input type="text"
       name="MessageName_#box#"
       value="#get.MessageName#"
       size="30"
       maxlength="30"
       class="regular">
	</td>
</tr>

<tr>	
	<td class="labelit">Subject:</td>
	<td>
	<input type="text" 
	   name="MessageSubject_#box#" 
	   value="#get.MessageSubject#" 
	   size="80"  
	   maxlength="80" 
	   class="regular">
	</td>
</tr>

<tr>	
	
	<td height="100%" colspan="2" style="padding:5px">
	<cf_textarea name="MessageText_#box#"
       enabled="Yes"
       visible="Yes"
	   style="height:100%;width:100%"
	   skin="silver"
       richtext="Yes">#get.MessageText#</cf_textarea>
	
	</td>

</tr>

<tr><td colspan="2">
		
		<table width="100%">
		<tr>	
		<td width="60"></td>	
		<td width="100%" align="center" style="padding-left:5px">
		<input type="button" 
		       name="Save" 
			   value="Save" 
			   style="width:140"
			   class="button10s" 
			   onclick="ColdFusion.navigate('../Bucket/BucketMessage/MessageEditSubmit.cfm?messageid=#messageid#&box=#box#','process_#box#','','','POST','messageform_#box#')">
		</td>
		<td width="60" id="process_#box#" align="right" class="labelit"></td>
		</tr>
		</table>
		</td>
	</tr>	

</table>

</cfform>

</cfoutput>