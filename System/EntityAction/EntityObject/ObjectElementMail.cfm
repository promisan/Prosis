<cfoutput>

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
	    SELECT *
		FROM   Ref_Entity
		WHERE  EntityCode = '#URL.EntityCode#'					 
  </cfquery>
  <table width="100%"><tr><td bgcolor="white" height="5"></td></tr>
  
  <tr><td>
  <table width="100%"
       cellspacing="0"
       cellpadding="0"
	   class="formpadding"
       bordercolor="c1c1c1"      
	   bgcolor="ffffff"
	   align="center"
	   border="1">
           
  	   <tr>
	   <td width="100"><cf_UIToolTip  tooltip="Applies only for mail defined in the workfstep tab for [Mail and Performance Targets]">&nbsp;Address To:</cf_UIToolTip></td>
	   <td width="90%">
		   <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		   
			   <tr><td width="30">
			   
				   	<cfquery name="MailCustom" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Ref_EntityDocument E
						WHERE  EntityCode = '#URL.EntityCode#'
					    AND    DocumentType = 'field'
						AND    FieldType = 'email'
				    </cfquery>
				   
				    <select name="mailto" id="mailto" style="width:230;font:10px"
					onChange="se = document.getElementById('boxmailtocustom');if (this.value == 'custom') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmailscript'); if (this.value == 'script') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmailtolist'); if (this.value == 'list') { se.className = 'regular' } else { se.className = 'hide'}">
					  <option value="default" <cfif mailto eq "Default">selected</cfif>>Actor for the step</option>
					  <option value="fly" <cfif mailto eq "Fly">selected</cfif>>Actors defined for the document (fly only)</option>					
					  <cfif Entity.PersonReference neq "">
					  
					      <option value="holder" <cfif mailto eq "Holder">selected</cfif>>#Entity.PersonReference#</option>
						  
					  </cfif>					  
					 
						<cfquery name="MissionList" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Ref_Mission
							WHERE Mission IN (SELECT Mission 
							                  FROM   Ref_MissionModule 
							                  WHERE  SystemModule IN (SELECT SystemModule 
											  						 FROM Ref_AuthorizationRole 
																	 WHERE Role IN (SELECT Role 
											                                        FROM   Ref_Entity 
																			        WHERE  EntityCode = '#URL.EntityCode#'
																				   )
																	 )
											 )						 				
						</cfquery> 
						
					  <cfif MIssionList.recordcount neq "0">			  
					  
					  <option value="list" <cfif mailto eq "List">selected</cfif>>List</option>		
					  
					  </cfif>		
					  
					  <option value="manual" <cfif mailto eq "Manual">selected</cfif>>Manual</option>					
					  <cfif MailCustom.recordcount gte "1">
					  	<option value="custom" <cfif mailto eq "Custom">selected</cfif>>Custom Field</option>
					  </cfif>
					  <option value="script" <cfif mailto eq "Script">selected</cfif>>Scripted</option>
					</select>
					
				</td>
				
				<cfif mailto eq "List">
					<cfset ls = "regular">
				<cfelse>
				    <cfset ls = "hide">
				</cfif>
				
				<cfif mailto eq "Custom">
					<cfset cl = "regular">
				<cfelse>
				    <cfset cl = "hide">
				</cfif>
				
				<cfif mailto eq "Script">
					<cfset ml = "regular">
				<cfelse>
				    <cfset ml = "hide">
				</cfif>
				
				<td width="20">&nbsp;</td>
				
				<td id="boxmailscript" width="20" class="#ml#">
				
				<img src="#SESSION.root#/Images/help1.gif" style="cursor:pointer" alt="Mail script" 
					onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?ts='+new Date().getTime(), 'MailInfo', 'unadorned:yes; edge:raised; status:no; dialogHeight:420px; dialogWidth:640px; help:no; scroll:yes; center:yes; resizable:yes');"
					border="0">
				
				</td>				
								
				<td id="boxmailtocustom" class="#cl#" width="20">
				
					<cfif MailCustom.recordcount gte "1">
						<select name="MailToDocumentId" id="MailToDocumentId" style="width:230;font:10px">
							<cfloop query="MailCustom">
							    <option value="#DocumentId#" <cfif MailToDocumentId eq documentid>selected</cfif>>#DocumentDescription#</option>		
							</cfloop>
						</select>		
					</cfif>
				
				</td>
				
				</tr>
				
				<tr id="boxmailtolist" colspan="4" class="#ls#">
				<td>

					<cfdiv bind="url:#SESSION.root#/system/entityaction/EntityObject/mailList/MailList.cfm?entitycode=#url.entityCode#&documentid=#documentid#" 
					  id="maillist"/>
								
				</td>
				</td></tr>
			
		   </table>	   	   
	   </td>	   
	   </tr>	
	   
	     <tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
	   
	   <tr>
	   <td>&nbsp;Priority:</td>
	   <td>
	   
	    <select name="mailpriority" id="mailpriority" style="width:230;font:10px">
		  <option value="1" <cfif mailpriority eq "1">selected</cfif>>High Priority</option>
		  <option value="2" <cfif mailpriority eq "2">selected</cfif>>Normal Priority</option>
		  <option value="3" <cfif mailpriority eq "3">selected</cfif>>Low Priority</option>		
		</select>
	 	   	   
	   </td>
	   
	   </tr>	
	   
	   <tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
	   
	   <tr>
	   <td>&nbsp;Subject:</td>
	   <td>
	   
	    <select name="mailsubject" id="mailsubject" style="width:230;font:10px"
		onChange="se = document.getElementById('boxsubjectcustom');if (this.value == 'custom') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmail1script'); if (this.value == 'script') { se.className = 'regular' } else { se.className = 'hide'}">
	      <option value="object" <cfif mailsubject eq "Object">selected</cfif>>Document reference</option>
		  <option value="action" <cfif mailsubject eq "Action">selected</cfif>>Action Label</option>
		  <option value="custom" <cfif mailsubject eq "Custom">selected</cfif>>Custom Subject</option>
		  <option value="script" <cfif mailsubject eq "Script">selected</cfif>>Scripted</option>
		</select>
		
		<cfif mailsubject eq "Script">
				<cfset ml = "regular">
		<cfelse>
			    <cfset ml = "hide">
		</cfif>
						
				<img src="#SESSION.root#/Images/help1.gif" style="cursor:pointer" align="absmiddle" alt="Mail script" id="boxmail1script" class="#ml#"
				onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?ts='+new Date().getTime(), 'MailInfo', 'unadorned:yes; edge:raised; status:no; dialogHeight:420px; dialogWidth:640px; help:no; scroll:yes; center:yes; resizable:yes');"
				border="0">
				
				
			   	   
	   </tr>	
	   
	   <cfif mailsubject eq "Custom">
			<cfset cl = "regular">
		<cfelse>
		    <cfset cl = "hide">
		</cfif>
				
	   
	   <tr id="boxsubjectcustom" class="#cl#">
	     <td></td>
		 <td>
		 <input type="text"
	       name="MailSubjectCustom"
		   id="MailSubjectCustom"
	       value="#MailSubjectCustom#"
	       size="80"
	       maxlength="80">
		 
		 </td>
	   </tr>
	   
	   <tr><td colspan="2" height="1"  bgcolor="silver"></td></tr>
	   
	   <tr>
	   <td>&nbsp;Body:</td>
	   <td>
	   
	    <select name="mailbody" id="mailbody" style="width:230;font:10px"
		onChange="se = document.getElementById('boxbodycustom');if (this.value == 'custom') { se.className = 'regular' } else { se.className = 'hide'} ; se = document.getElementById('boxmail2script'); if (this.value == 'script') { se.className = 'regular' } else { se.className = 'hide'}">
	      <option value="custom" <cfif mailbody eq "Custom">selected</cfif>>Custom Mail Body</option>
		  <option value="script" <cfif mailbody eq "Script">selected</cfif>>Scripted</option>
		</select>
		
		<cfif mailbody eq "Script">
			<cfset ml = "regular">
		<cfelse>
			 <cfset ml = "hide">
		</cfif>
						
				<img src="#SESSION.root#/Images/help1.gif" style="cursor:pointer" align="absmiddle" alt="Mail script" id="boxmail2script" class="#ml#"
				onclick="window.open('#SESSION.root#/system/entityaction/EntityObject/ObjectElementMailInfo.cfm?ts='+new Date().getTime(), 'MailInfo', 'unadorned:yes; edge:raised; status:no; dialogHeight:420px; dialogWidth:640px; help:no; scroll:yes; center:yes; resizable:yes');"
				border="0">
	   	   	   
	   </td>
	   
	   </tr>	
	  	 	   
	    <tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
		
	    <tr id="boxbodycustom" class="regular">
	    
		 <td colspan="2" style="border: 1px solid Silver;">
		 
		     <cf_textarea name="mailbodyCustom"
             height         = "300"
             enabled        = "Yes"			 
			 skin           = "Silver"
             visible        = "Yes"
             richtext       = "Yes">#MailBodyCustom#</cf_textarea>		
			 
		 </td>
	   </tr>   
	    
	   <tr><td colspan="2" height="1" align="center">
		 
		  	 <input type="submit" 
				value="Save Mail Object" 			
				class="button10s" 
				style="width:200;height:22">
				
	    </td></tr>	
	   	  	   
  </table>
  
  </td></tr>
  </table>
      
  
</cfoutput>    
