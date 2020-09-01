
<!--- apply mail message content --->

<cfif url.documentid neq "hide">

<cfquery name="Mail" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_EntityDocument
		<cfif url.documentid neq "">
		WHERE     DocumentId = '#url.documentId#' 
		<cfelse>
		WHERE     1=0
		</cfif>
</cfquery>	

<cfoutput>

<table style="width:100%" class="formpadding">
			
	<tr class="labelmedium"><td><cf_tl id="Addressee"></td>
	    <td><input type="text" name="MailTo" style="width:200px" class="regularxxl"></td>
	</tr>	
	<tr class="labelmedium"><td><cf_tl id="Subject"></td>
	    <td><input type="text" name="MailSubject" style="width:95%" class="regularxxl"></td>
	</tr>	
	<tr><td colspan="2" valign="top" style="padding-top:4px">
	
	   <cf_textarea name="MailBody" id="MailBody"                                            
		   height         = "200"
		   toolbar        = "mini"
		   resize         = "0"
		   color          = "ffffff">#Mail.MailBodyCustom#</cf_textarea>		
	
	</td></tr>		
	
	<tr class="labelmedium"><td><cf_tl id="Attachment"></td>
	    <td><input type="text" name="MailAttachment" style="width:95%" class="regularxxl"></td>
	</tr>			

</table>

</cfoutput>

<cfset ajaxonload("initTextArea")>

</cfif>

