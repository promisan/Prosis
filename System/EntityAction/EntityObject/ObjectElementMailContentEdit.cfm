

  <cfparam name="mailto" default="">
  <cfparam name="mailpriority" default="2">
  <cfparam name="mailtoDocumentId" default="">
  <cfparam name="mailsubject" default="">
  <cfparam name="mailsubjectCustom" default="">
  <cfparam name="mailbody" default="0">
  <cfparam name="mailbodyCustom" default="">
  
  <cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	E.*
		FROM   	Ref_EntityDocument D,
				Ref_Entity E
		WHERE  	E.EntityCode = D.EntityCode
		AND		D.DocumentId = '#URL.documentId#'	 	 
  </cfquery>
  
  <cfquery name="MailCustom" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   #CLIENT.lanPrefix#Ref_EntityDocument E
		WHERE  DocumentId = '#URL.documentId#'
    </cfquery>

<script>

function toggleBody(control){

	sa = document.getElementById('boxmail2script') ;
	if (control.value == 'script') { sa.className = 'regular'; } 
	else { sa.className = 'hide'; }
	
	/*se = document.getElementById('boxbodycustom');
	if (control.value == 'custom') { 
		se.className = 'regular';
		document.getElementById('mailbodyCustom').height = 300;
	} 
	else { se.className = 'hide';} */
}
</script>

<cf_textareascript>
	
<cf_screentop height="100%" 
    label="Mail Content" 
	option="Mail content edition [#MailCustom.documentCode# - #MailCustom.documentDescription#]" 
	scroll="No" 
	html="no"
	jquery="Yes"
	close="parent.parent.ColdFusion.Window.destroy('mydialog',true)"
	layout="webapp" 
	bannerheight="60" 
	bannerforce="yes"	
	banner="blue">
	
<cfform action="#SESSION.root#/System/EntityAction/EntityObject/ObjectElementMailContentSubmit.cfm" method="POST" name="formmailcontent" target="mailContentSubmit">
		
<table width="95%" align="center" height="99%">

<tr><td bgcolor="white" height="5"></td></tr>

<tr class="hide"><td><iframe name="mailContentSubmit" id="mailContentSubmit" frameborder="0"></iframe></td></tr>

 <cfinput type="Hidden" name="documentId" value="#URL.documentId#">

 <cfoutput>
  
  <tr><td valign="top">
  
  <table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  	   <tr>
	   <td width="100" class="labelmedium"><cf_UIToolTip  tooltip="Applies only for mail defined in the workfstep tab for [Mail and Performance Targets]"><cf_tl id="Send to">:</cf_UIToolTip></td>
	   <td width="90%" height="20">
		   <table width="100%" cellspacing="0" cellpadding="0">
		   	
			   <tr><td width="30">			   				   					   
				    <select name="mailto" id="mailto" class="regularxl enterastab" style="width:230"
					onChange="se = document.getElementById('boxmailtocustom');if (this.value == 'custom') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmailscript'); if (this.value == 'script') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmailtolist'); if (this.value == 'list') { se.className = 'regular' } else { se.className = 'hide'}">
					  <option value="default" <cfif MailCustom.mailto eq "Default">selected</cfif>>Actor for the step</option>
					  <option value="fly" <cfif MailCustom.mailto eq "Fly">selected</cfif>>Actors defined for the document (fly only)</option>					
					  <option value="Recipient" <cfif MailCustom.mailto eq "Recipient">selected</cfif>>Recipients as set for this action (OrganizationObjectRecipient)</option>					
					
					
					  <cfif Entity.PersonReference neq "">
					      <option value="holder" <cfif MailCustom.mailto eq "Holder">selected</cfif>>#Entity.PersonReference#</option>
					  </cfif>					  
										  
					  <option value="list" <cfif MailCustom.mailto eq "List">selected</cfif>>List</option>																  
					  <option value="manual" <cfif MailCustom.mailto eq "Manual">selected</cfif>>Manual</option>					
					  <cfif MailCustom.recordcount gte "1">
					  	<option value="custom" <cfif MailCustom.mailto eq "Custom">selected</cfif>>Custom Field</option>
					  </cfif>
					  <option value="script" <cfif MailCustom.mailto eq "Script">selected</cfif>>Scripted</option>
					</select>
					
				</td>
				
				<cfif MailCustom.mailto eq "List">
					<cfset ls = "regular">
				<cfelse>
				    <cfset ls = "hide">
				</cfif>
				
				<cfif MailCustom.mailto eq "Custom">
					<cfset cl = "regular">
				<cfelse>
				    <cfset cl = "hide">
				</cfif>
				
				<cfif MailCustom.mailto eq "Script">
					<cfset ml = "regular">
				<cfelse>
				    <cfset ml = "hide">
				</cfif>
				
				<td width="20" height="10"></td>
				
				<td id="boxmailscript" width="20" class="#ml#">
				
				<img src="#SESSION.root#/Images/help.gif" 
					style="cursor:pointer;height:20px;width:20px" 
					alt="Mail script" 
					
					onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?ts='+new Date().getTime(), 'maininfobox', 'left=40, top=40, width=800,height=800, status=yes, scrollbars=no, resizable=yes');"
					border="0">
				
				</td>				
								
				<td id="boxmailtocustom" class="#cl#" width="20">
				
					<cfif MailCustom.recordcount gte "1">
						<select name="MailToDocumentId" class="regularxl enterastab" id="MailToDocumentId" style="width:230">
							<cfloop query="MailCustom">
							    <option value="#url.DocumentId#" <cfif MailToDocumentId eq MailCustom.documentid>selected</cfif>>#MailCustom.DocumentDescription#</option>		
							</cfloop>
						</select>		
					</cfif>
				
				</td>
				
				</tr>
				
				<tr id="boxmailtolist" colspan="4" class="#ls#">
				<td height="10">

					<cfdiv bind="url:#SESSION.root#/system/entityaction/EntityObject/mailList/MailList.cfm?entitycode=#entity.entityCode#&documentid=#url.documentid#" 
					  id="maillist"/>
								
				</td>
				</td></tr>
			
		   </table>	   	   
	   </td>	   
	   </tr>	
	   	   
	   <tr>
	   <td class="labelmedium" height="20"><cf_tl id="Priority">:</td>
	   <td>
	   
	    <select name="mailpriority" id="mailpriority" class="regularxl enterastab" style="width:230">
		  <option value="1" <cfif MailCustom.mailpriority eq "1">selected</cfif>>High Priority</option>
		  <option value="2" <cfif MailCustom.mailpriority eq "2">selected</cfif>>Normal Priority</option>
		  <option value="3" <cfif MailCustom.mailpriority eq "3">selected</cfif>>Low Priority</option>		
		</select>
	 	   	   
	   </td>
	   
	   </tr>	
	   	   
	   <tr>
	   <td class="labelmedium" height="20"><cf_tl id="Subject">:</td>
	   <td>
	   
	    <select name="mailsubject" id="mailsubject" class="regularxl enterastab" style="width:230"
		onChange="se = document.getElementById('boxsubjectcustom');if (this.value == 'custom') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmail1script'); if (this.value == 'script') { se.className = 'regular' } else { se.className = 'hide'}">
	      <option value="object" <cfif MailCustom.mailsubject eq "Object">selected</cfif>>Document reference</option>
		  <option value="action" <cfif MailCustom.mailsubject eq "Action">selected</cfif>>Action Label</option>
		  <option value="custom" <cfif MailCustom.mailsubject eq "Custom">selected</cfif>>Custom Subject</option>
		  <option value="script" <cfif MailCustom.mailsubject eq "Script">selected</cfif>>Scripted</option>
		</select>
		
		<cfif MailCustom.mailsubject eq "Script">
				<cfset ml = "regular">
		<cfelse>
			    <cfset ml = "hide">
		</cfif>
		
		<img src="#SESSION.root#/Images/help1.gif" 
					style="cursor:pointer" 
					alt="Mail script" 
					id="boxmail1script" class="#ml#"
					onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?ts='+new Date().getTime(), 'maininfobox', 'left=40, top=40, width=800,height=800, status=yes, scrollbars=no, resizable=yes');"
					border="0">					
				
			   	   
	   </tr>	
	   
	   <cfif MailCustom.mailsubject eq "Custom">
			<cfset cl = "regular">
	   <cfelse>
		    <cfset cl = "hide">
	   </cfif>				
	   
	   <tr id="boxsubjectcustom" class="#cl#">
	     <td height="20"></td>
		 <td>
		 <input type="text" class="regularxl enterastab"
	       name="MailSubjectCustom"
		   id="MailSubjectCustom"
	       value="#MailCustom.MailSubjectCustom#"
	       size="60"
	       maxlength="80">
		 
		 </td>
	   </tr>
	   
	   <tr>
	   <td class="labelmedium" height="20"><cf_tl id="Body">:</td>
	   <td>
	   
	   <table cellspacing="0" cellpadding="0"><tr><td>
	    <select name="mailbody" id="mailbody" class="regularxl enterastab" style="width:230">
	      <option value="custom" <cfif MailCustom.mailbody eq "custom">selected</cfif>>Custom Mail Body</option>
		  <option value="script" <cfif MailCustom.mailbody eq "script">selected</cfif>>Scripted</option>
		</select>
		</td>
		
		<td style="padding-left:4px">
				
		<img src="#SESSION.root#/Images/help2.gif" 
				style="cursor:pointer" 
				alt="Mail script" 
				id="boxmail2script" 				
				onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?mailbody='+document.getElementById('mailbody').value, 'maininfobox', 'left=40, top=40, width=800,height=800, status=yes, scrollbars=no, resizable=yes');"
				border="0">		
				
		</td></tr></table>					
	   	   	   
	   </td>
	   
	   </tr>	
	  	 			
	    <tr id="boxbodycustom">	    
		 <td colspan="2" valign="top" style="padding-top:6px" height="100%">				 		 
		    <cf_textarea name="mailbodyCustom" height="240" color="ffffff" resize="Yes" skin="flat" init="Yes">#MailCustom.MailBodyCustom#</cf_textarea>			 
		 </td>
	   </tr>   
	    	   
	   <tr><td colspan="2" height="30" style="padding-bottom:8px" align="center">
	   		<input type="submit" name="Save"      id="Save"      value="Save" class="button10g" style="width:150px;font-size:13px">
			<input type="submit" name="SaveClose" id="SaveClose" value="Save & Close" class="button10g" style="width:150px;font-size:13px">
	    </td></tr>	
	   	  	   
  </table>
  
  </cfoutput>    
  
  </td></tr>
  
</table>

</cfform>



