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
	
	<cfset dateValue = "">
	<CF_DateConvert Value  = "#Form.ActionDateStart#">
	<cfset STR = dateValue>	
	<cfset STR = dateAdd("H",Form.ActionHourStart,STR)>
	<cfset STR = dateAdd("N",Form.ActionMinuteStart,STR)>
	
	<cfinvoke component = "Service.Process.System.Mail"  
	   method           = "MailContentConversion" 
	   objectId         = "#url.ObjectId#" 	
	   personno         = "#url.Personno#"
	   content          = "#Mail.MailToCustom#"			  
	   returnvariable   = "addressee">	  	
	
	<cfinvoke component = "Service.Process.System.Mail"  
	   method           = "MailContentConversion" 
	   objectId         = "#url.ObjectId#" 	
	   personno         = "#url.Personno#"
	   content          = "#Mail.MailSubjectCustom#"			  
	   returnvariable   = "subject">	
	   
	<cfinvoke component = "Service.Process.System.Mail"  
	   method           = "MailContentConversion" 
	   objectId         = "#url.ObjectId#" 	
	   personno         = "#url.Personno#"
	   functionid       = "#url.Functionid#"
	   datetime         = "#STR#"
	   content          = "#Mail.MailBodyCustom#"			  
	   returnvariable   = "body">	  		 				 

	<cfoutput>
	
	<table style="width:100%">
				
		<tr class="line labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Addressee"></td>
		    <td><input type="text" name="MailTo" style="border:0px;border-left:1px solid silver;width:98%" value="#addressee#" class="regularxxl"></td>
		</tr>	
		
		<tr class="line labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Subject"></td>
		    <td><input type="text" name="MailSubject" style="border:0px;border-left:1px solid silver;width:98%" value="#subject#" class="regularxxl"></td>
		</tr>	
		
		<cfquery name="Att" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT    *
				FROM      Attachment
				WHERE     DocumentPathName = 'VacDocument' 
				AND       Reference    = '#url.objectid#'	
				AND       FileStatus  != '9'		
		</cfquery>
		
		<cfif att.recordcount gte "1">
		
			<tr class="labelmedium"><td  style="height:33px;padding-left:10px"><cf_tl id="Attachment"></td>
			    <td style="border-left:1px solid silver">
									
					<table>
					<tr class="labelmedium">			
					<cfloop query="Att">
						<td style="padding-left:4px"><input type="checkbox" name="MailAttachment" value="'#attachmentid#'" class="radiol"></td>
						<td style="font-size:16px;padding-top:3px;padding-left:4px;padding-right:8px">#fileName#</td>			
					</cfloop>
					</tr>
					</table>
							
				</td>
			</tr>	
		
		</cfif>		
		
		<tr><td colspan="2" valign="top" style="padding-top:4px">
		
		   <cf_textarea name="MailBody" id="MailBody"                                            
			   height         = "240"
			   toolbar        = "basic"
			   resize         = "0"
			   color          = "ffffff">#body#</cf_textarea>		
		
		</td></tr>	
	
	</table>
	
	</cfoutput>

	<cfset ajaxonload("initTextArea")>

</cfif>
