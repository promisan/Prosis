<!--
    Copyright © 2025 Promisan

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


<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT     *
     FROM       OrganizationObject
     WHERE      ObjectId = '#URL.ObjectId#'	
</cfquery>

<cfquery name="Name" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_EntityDocument R 
		WHERE     R.DocumentCode = 'fnts'
		AND       R.EntityCode = '#Object.EntityCode#'	
</cfquery>	

<cf_screentop height="100%" label="#Name.DocumentDescription# - #url.type#" scroll="No" jquery="Yes" banner="red" layout="webapp">

<cfoutput>
	<script>
	
	 function noteask(objectid,threadid,ser,mode,box,action,tpe) {
	   	    ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteDelete.cfm?box='+box+'&mode='+mode+'&objectid='+objectid+'&threadid='+threadid+'&serialno='+ser+'&actioncode='+action,'#url.box#') 							
	  }
		 
	</script>
</cfoutput>

<cf_textareascript>
<cf_calendarscript>

<cfinclude template="../DetailsScript.cfm">

<cfparam name="url.ThreadId" default="">
<cfparam name="url.to"       default="">
<cfparam name="url.SeriaLNo" default="">
<cfparam name="url.type"     default="Notes">
<cfparam name="url.Mode"     default="regular">
<cfparam name="url.sitem"    default="">

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObjectActionMail
<cfif url.ThreadId neq "">
	WHERE ThreadId = '#URL.ThreadId#'
	AND   SerialNo = '#URL.SerialNo#'
<cfelse>
	WHERE 1=0
</cfif>
</cfquery>
	
<cfoutput>	

<cf_divscroll style="height:99%">

<cfform name="noteentry" id="noteentry" style="height:97%">

<table width="100%" height="95%" align="center" valign="top">

<tr><td align="center" valign="top" style="padding-left:20px;padding-right:20px">
	
	<table width="100%" align="center" class="formpadding">
	
	<tr class="line"><td height="35" colspan="2" style="padding-left:5px" id="<cfoutput>#url.box#</cfoutput>">
	
	<cfif url.serialNo eq "">
	
		<cf_tl id="Close" var="1">
		<cfset tClose = "#Lt_text#">
		
		<cfif url.type eq "Mail">
	
		<cf_tl id="Send" var="1">
		<cfset tSend = "#Lt_text#">	
		  <input class="button10g" type="button" name="Update" id="Update" value="#tSend#" onclick="updateTextArea();ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteSubmit.cfm?mode=#url.mode#&box=#url.box#&type=#url.type#&actioncode=#url.actionCode#','#url.box#','','','POST','noteentry')">
		
		<cfelse>
		
		<cf_tl id="Save" var="1">
		<cfset tSave = "#Lt_text#">		
		  <input class="button10g" type="button" name="Update" id="Update" value="#tSave#" onclick="updateTextArea();ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteSubmit.cfm?mode=#url.mode#&box=#url.box#&type=#url.type#&actioncode=#url.actionCode#','#url.box#','','','POST','noteentry')">
		
		</cfif>
		
	<cfelse>	
		
		<cf_tl id="Delete" var="1">
		<cfset tDelete = "#Lt_text#">
	
	    <input class="button10g" type="button" name="Delete" id="Delete" value="#tDelete#" onclick="noteask('#url.objectid#','#url.threadid#','#url.serialno#','#url.mode#','#url.box#','#url.actioncode#','#url.type#')">
		
		<cf_tl id="Save" var="1">
		<cfset tSave = "#Lt_text#">
		
	    <input class="button10g" type="button" name="Update" id="Update" value="#tSave#" onclick="updateTextArea();ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteSubmit.cfm?mode=#url.mode#&box=#url.box#&type=#url.type#&actioncode=#url.actionCode#','#url.box#','','','POST','noteentry')">
			
	</cfif>
	</td>
	
	</tr>
		   
	<cfif get.recordcount eq "0">
		<cf_assignid>   
		<cfset att = rowguid>	
	<cfelse>
	    <cfset att = get.attachmentid> 
	</cfif>	
	   
	<cfoutput>
		<input type="hidden" name="Mode" id="Mode"              value="#URL.Mode#">
		<input type="hidden" name="ObjectId" id="ObjectId"      value="#URL.ObjectId#">
		<input type="hidden" name="ThreadId" id="ThreadId"      value="#URL.ThreadId#">
		<input type="hidden" name="SerialNo" id="SerialNo"      value="#URL.SerialNo#">
		<input type="hidden" name="AttachId" id="AttachId"      value="#att#">
		<input type="hidden" name="EntityCode" id="EntityCode"  value="#Object.EntityCode#">
	</cfoutput>      
	   
	<tr><td height="2"></td></tr>
	
	<cfif url.type eq "mail" or url.type eq "Exchange">
	
	<tr><td class="labelmedium" style="height:24;padding-left:7px"><cf_tl id="Priority">:</td>
	<td style="padding-right:20px">
	<select name="Priority" id="Priority" class="regularxl" style="width:100%" <cfif url.serialno neq "">disabled</cfif>>
			<option value="1" <cfif "1" eq get.priority>selected</cfif>><cf_tl id="High Priority"></option>
			<option value="3" <cfif "3" eq get.priority or get.priority eq "">selected</cfif>><cf_tl id="Normal Priority"></option>
			<option value="5" <cfif "5" eq get.priority>selected</cfif>><cf_tl id="Low Priority"></option>
	</select>
	</td>
	</tr>
	
	 <cfif url.serialno neq "">
		   <cfset ena = "no">	   
	 <cfelse>
		   <cfset ena = "yes">
	 </cfif>
	
	<tr><td class="labelmedium" style="height:24;padding-left:7px"><cfif ena eq "yes"><a title="click to select from address book" href="javascript:address()"></cfif><cf_tl id="To">:</a></td>
	
	<td style="padding-right:20px">
		  
	  <cfif ena eq "yes">
	  
	  		<cfif url.to eq "">
			   <cfset to = get.MailTo>
			<cfelse>
			  <cfset to = url.to>
			</cfif>
	  		
			<cfinput type="Text"
		       name="sendTO"
			   id="sendTO"
	    	   value="#to#"
		       message="Please enter a correct to: address"	   
		       required="Yes"
	    	   visible="Yes"	
			   maxlength="200"
	    	   class="regularxl"
		       style="width:100%">
	  
	  <cfelse>
		
			 <cfinput type="Text"
		       name="sendTO"
			   id="sendTO"
		       value="#get.MailTo#"
		       message="Please enter a correct to: address"	   
		       required="Yes"
		       visible="Yes"	
			   disabled		      
		       maxlength="200"
		       class="regularxl"
		       style="width:100%">
	  </cfif>
	  
	</td>
	
	</tr>
	
	<tr><td class="labelmedium" style="height:24;padding-left:7px"><cfif ena eq "yes"><a title="click to select from address book" href="javascript:address()"></cfif>Cc:</a></td>
	<td style="padding-right:20px">
	  <cfinput type="Text"
	       name="sendCC"
		   id="sendCC"
	       value="#get.MailCC#"
	       message="Please enter a correct to: address"
	       required="No"
	       visible="Yes"
		   maxlength="200"
	       class="regularxl"
	       style="width:100%">
	</td>
	</tr>
	
	<tr><td class="labelmedium" style="height:24;padding-left:7px"><cfif ena eq "yes"><a title="click to select from address book" href="javascript:address()"></cfif>Bcc:</a></td>
	<td style="padding-right:20px">
	  <cfinput type="Text"
	       name="sendBCC"
		   id="sendBCC"	   
	       message="Please enter a correct to: address"
	       required="No"
	       visible="Yes"
	       maxlength="200"
	       class="regularxl"
	       style="width:100%">
	</td>
	</tr>
	
	<input type="Hidden"
	       name="MailDate"
		   id="MailDate"
	       value="#dateformat(now(),CLIENT.DateFormatShow)#">
	
	<cfelse>
	
	<tr>
	   <td class="labelmedium" style="height:24;padding-left:7px" width="120"><cf_tl id="Date">:</td>
	   <td width="420" style="padding-right:20px">
	   <cfif url.serialno eq "">
	   
			 <cf_intelliCalendarDate9
				FieldName="MailDate" 
				Default="#dateformat(now(),CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Class="regularxl">	
						
	   <cfelse>
	  
				 <cf_intelliCalendarDate9
				FieldName="MailDate" 
				Default="#dateformat(get.MailDate,CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Class="regularxl">	
	   
	   </cfif>						
	   </td>
	</tr>	
	
	</cfif>
	
	<tr><td class="labelmedium" style="height:24;padding-left:7px"><cf_tl id="Step">:</td> 
	
	<cfif url.actioncode neq "" and url.actioncode neq "undefined">
	
		<cfquery name="Current" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   ActionCode 
	    FROM     OrganizationObjectAction 
	    WHERE    ObjectId = '#ObjectId#'
		AND      ActionCode = '#URL.actionCode#'	
	   </cfquery>	
	
		<cfquery name="Step" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT O.EntityCode, R.ActionDescription, R.ActionCode, R.ActionOrder
		FROM      Ref_EntityActionPublish R INNER JOIN
	              OrganizationObject O ON R.ActionPublishNo = O.ActionPublishNo
		WHERE     (O.ObjectId = '#ObjectId#')
		AND       R.ActionCode = '#URL.actionCode#'	
		</cfquery>	
		
	<cfelse>
		
		<cfquery name="Current" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   ActionCode 
		    FROM     OrganizationObjectAction 
		    WHERE    ObjectId = '#URL.ObjectId#'
			AND      ActionStatus = '0'
			ORDER BY ActionFlowOrder 
		</cfquery>	
		
		<cfquery name="Step" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT O.EntityCode, R.ActionDescription, R.ActionCode, R.ActionOrder
			FROM         Ref_EntityActionPublish R INNER JOIN
		                 OrganizationObject O ON R.ActionPublishNo = O.ActionPublishNo
			WHERE     (O.ObjectId = '#URL.ObjectId#')
			AND        (R.ActionCode IN (SELECT ActionCode 
			                             FROM   OrganizationObjectAction 
									     WHERE  ObjectId = '#URL.ObjectId#'
									     AND    ActionStatus >= '2') 
										 
									  OR R.ActionCode = '#current.actionCode#')
			ORDER BY R.ActionOrder 
		</cfquery>	
		
	</cfif>
	<td style="padding-right:20px">
		<cfif get.actionCode eq "">
	
	    <select name="ActionCode" id="ActionCode" class="regularxl" style="width:100%;">
			<cfloop query="step">
			<option value="#actionCode#" <cfif actioncode eq current.actioncode>selected</cfif>>#ActionDescription#</option>
			</cfloop>
	    </select>
		
		<cfelse>
		
		 <select name="ActionCode" id="ActionCode" class="regularxl" style="width:100%;">
			<cfloop query="step">
			<option value="#actionCode#" <cfif actioncode eq get.actioncode>selected</cfif>>#ActionDescription#</option>
			</cfloop>
	    </select>
		
		</cfif>
		
	</td>
	
	<cfquery name="Group" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    L.DocumentItem, L.DocumentItemName, L.DocumentId
			FROM      Ref_EntityDocument R INNER JOIN
		              Ref_EntityDocumentItem L ON R.DocumentId = L.DocumentId
			WHERE     R.DocumentMode = 'Notes'
			AND       R.EntityCode = '#Step.EntityCode#'	
			ORDER BY  L.ListingOrder
	</cfquery>	 
		
	<cfif group.recordcount gte "1">
	
	<tr>
		<td class="labelmedium" style="height:24;padding-left:7px"><cf_tl id="Classification">:</td>
		
		<input type="hidden" name="DocumentId" id="DocumentId" value="#Group.DocumentId#">	
		<td style="padding-right:20px">
		
			<select name="DocumentItem" id="DocumentItem" style="width:100%;" class="regularxl">
				<cfloop query="group">
					<option value="#documentitem#" <cfif documentitem eq get.documentitem or documentitem eq url.sitem>selected</cfif>>#DocumentItemName#</option>
				</cfloop>
		    </select>
			
		</td>
	</tr>
	
	</cfif>	
	
	<tr>
	   <td class="labelmedium" style="height:24;padding-left:7px" width="120">
	   <cfif url.type eq "mail" or url.type eq "Exchange">
	  	 <cf_tl id="Subject">:
	   <cfelse>
	  	 <cf_tl id="Action">:
	   </cfif>
	   </td>
	   <td width="80%" style="padding-right:20px">
	   
	   <cfif url.ThreadId neq "" and url.serialNo eq "">
			   
			<cfquery name="Prior" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *
			FROM       OrganizationObjectActionMail
			WHERE ThreadId = '#URL.ThreadId#'		
			</cfquery>
			
			<cfinput type = "Text" 
		        name      = "MailSubject" 
				required  = "Yes" 
				style     = "width:100%"
				MaxLength = "200"
				value     = "re:#prior.MailSubject#"
				visible   = "Yes" 
				message   = "Please enter a subject" 				
				class     = "regularxl">
			
		<cfelse>	
		
			<cfinput type = "Text" 
			    name      = "MailSubject" 
				required  = "Yes" 
				style     = "width:100%"
				MaxLength = "200"
				value     = "#get.MailSubject#"
				visible   = "Yes" 
				message   = "Please enter a subject" 				 
				class     = "regularxl">
			
		</cfif>	
	   				
	   </td>
	</tr>	
	
	
	<tr>
	   <td class="labelmedium" style="height:24;padding-left:7px" width="120"><cf_tl id="Attach">:</td>
	   <td width="80%" id="#att#" style="padding-right:20px">
	   
	   <cfif url.serialno eq "" or SESSION.isAdministrator eq "Yes">
	
			<cf_filelibraryN
					DocumentPath="#Object.EntityCode#"
					SubDirectory="#att#" 
					Filter=""				
					Width="100%"
					Box = "#att#"
					Insert="yes"
					Remove="yes">	
					
		<cfelse>
		
			<cf_filelibraryN
					DocumentPath="#Object.EntityCode#"
					SubDirectory="#att#" 
					Filter=""				
					Width="100%"
					Box = "#att#"
					Insert="no"
					Remove="no">	
				
		</cfif>	
						
		</td>
	</tr>			
		
	<tr><td style="height:10px"></td></tr>
	
	<tr>
	  <td valign="top" colspan="2" height="100%">
	  
		  <cfif url.type eq "Exchange">#Get.MailBody# <cfelse>			
		  
		  <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		  
		   <tr><td bgcolor="white" valign="top">
		   
			   <cfif url.type eq "notes">
			   		        
		        <cftextarea name="MailBody"	           				
					 init="Yes"			
					 color="ffffff" style="padding:3px;font-size:14px;height:390;width:100%">#Get.MailBody#</cftextarea>
					 
				<cfelse>
				
				 <cf_textarea name="MailBody"	           				
					 init="Yes"		
					 color="ffffff"		 
					 toolbar="Basic" height="230">#Get.MailBody#</cf_textarea>			
				
				</cfif>	 
						
			</td></tr>
			
		   </table>
			
		   </cfif>
	   			 
	  </td>
	</tr>		
	   
	</table>
	
</td></tr>
</table>

</cfform>

</cf_divscroll>

</cfoutput>

<cfset ajaxonload("initTextArea")>