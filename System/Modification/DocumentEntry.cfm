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

<cf_textareascript>
<cf_fileLibraryScript>
<cf_listingscript>


<cfparam name="url.systemmodule"       default="">
<cfparam name="url.mission"            default="">
<cfparam name="url.observationclass"   default="SysChange">
<cfparam name="url.application"        default="">

<cfif url.observationclass eq "Inquiry">

	<cfset entitycode = "SysTicket">			
	<cf_screentop height="100%" menuaccess="Context" band="no" scroll="Yes" label="Assistance / Bug Ticket" layout="webapp" line="no" banner="blue" jquery="yes">
	<cfset url.ObservationClass = "Inquiry">

<cfelse>

	<cfset entitycode = "SysChange">	
	<cf_screentop height="100%" menuaccess="Context" band="no" scroll="Yes" label="Request for Amendment / Services" layout="webapp" line="no" banner="red" jquery="yes">

</cfif>

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AuthorizationRoleOwner				
</cfquery>

<script language="JavaScript">

	function validate(){
	
			<cfif url.observationclass eq "Inquiry">
				
				app = document.getElementById('rapplication');
				if (app.selectedIndex == 0){
					alert('Please select an application');
					app.focus();
					return false;
				}
				
				module = document.getElementById('SystemModule');
				if (module.selectedIndex == 0){
					alert('Please select a Module');
					module.focus();
					return false;
				}
				
			<cfelse>
	
				<cfif Owner.recordcount gt "1">
				
				owner = document.getElementById('Owner');
				if (owner.selectedIndex == 0 ){
					alert('Please select a valid owner');
					owner.focus();
					return false;
				}
				</cfif>
			
				workgroup = document.getElementById('amendWorkgroup');
				if (workgroup.options[workgroup.selectedIndex].value == '0'){
					alert('Please select a valid Workgroup');
					workgroup.focus();
					return false;
				}
			
			</cfif>
										
			return true;
			Prosis.busy('yes')	
	}
</script>
 
<cfquery name="Parameter" 
	datasource="appsSystem">
		SELECT   *
	    FROM     Parameter
</cfquery>
 
<cfquery name="Site" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ParameterSite		
		WHERE    Operational = 1
		<cfif client.orgunit neq "">
		AND      OrgUnit = '#client.orgunit#'
		</cfif>
		
		ORDER    BY ListingOrder
</cfquery>
	
<cfif Site.recordcount eq "0">
		
	<cfquery name="Site" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     ParameterSite		
			WHERE    Operational = 1
			ORDER    BY ListingOrder		
	</cfquery>
	
</cfif>

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Usernames
	WHERE    Account = '#SESSION.acc#'	
</cfquery>

<cfoutput>
  
   <cfif url.observationclass eq "Inquiry">	
   	  <cfset string = replaceNoCase(cgi.query_string,"inquiry","amendment")>
   <cfelse>
     <cfset string = replaceNoCase(cgi.query_string,"amendment","inquiry")>
   </cfif>
       
   <script>
	 function reloadform(cls) {
	      Prosis.busy('yes')
		  ptoken.location('documententry.cfm?#string#')
	 }
	</script>
	
</cfoutput>

<cfform action="DocumentEntrySubmit.cfm?observationclass=#url.observationclass#" 
   method="POST" target="result" name="observationForm" id="observationForm" style="height:100%">

<table width="100%" height="100%" align="center" class="formpadding">

<tr class="line" style="background-color:e4e4e4;height:40px;padding-left:30px">	
	<td style="padding-left:40px">
	<table cellspacing="0" cellpadding="0">
	<tr style="font-size:20px">
		<td ><input type="radio" name="ObservationClass" class="radiol" <cfif url.observationclass neq "Inquiry">checked disabled <cfelse>onclick="javascript:reloadform('amendment')"</cfif> value="Amendment"></td>
		<td style="font-size:18px;padding-left:5px" class="labelmedium2">Amendment or Professional assessment</td>
		<td style="padding-left:20px"><input type="radio" name="ObservationClass" class="radiol" value="Inquiry" <cfif url.observationclass eq "Inquiry">checked disabled<cfelse>onclick="javascript:reloadform('inquiry')"</cfif>></td>
		<td style="font-size:18px;padding-left:5px" class="labelmedium2">Assistance / Bug or Inquiry</td>
		
	</tr>
	</table>
</tr>

<tr>
<td colspan="2" style="height:100%">

<cf_divscroll style="height:100%">

<table height="100%" width="93%" align="center" class="formpadding formspacing">

<cfoutput>
	
	<cfif getAdministrator("*") eq "1">
	
		<tr>
			<td style="width:10%" class="labelmedium2"><cf_tl id="Requester">: <font color="FF0000">*</font></td>
			<td>	
			<table>
			
				<tr>
				<td>				
				<input type="text" style="width:300px" name="RequesterName" class="regularxxl" id="requestername" value="#session.acc#">
				</td>
				
				<td style="padding-left:3px">
					<input type="hidden" id="requester" name="requester" value="#session.acc#">
				
					<cfset link = "getUser.cfm?id=user">
															
					<cf_selectlookup
						    box        = "requesterbox"
							title      = "Click here to add users"
							link       = "#link#"
							button     = "Yes"
							iconheight = "25"
							iconwidth  = "25"
							icon       = "search.png"
							close      = "Yes"
							class      = "user"
							des1       = "useraccount">						
				
				</td>
				
				<td id="requesterbox"></td>
				</tr>			
			
			<!--- select user and update the eMail address --->	
			</table>
			</td>
		</tr>
		
	<cfelse>
	
		<input type="hidden" id="Requester" name="Requester" value="#session.acc#">	
	
	</cfif>

</cfoutput>

<tr><td class="labelmedium2"><cf_tl id="eMail">: <font color="FF0000">*</font></td>
	    <td colspan="5">
		  <cfinput type="Text"
	       name="eMail"
		   id="email"
	       message="Please provide a valid email address"
	       validate="email"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"	      
		   style="width:300px"
		   value="#User.eMailAddress#"
	       maxlength="40"
	       class="regularxxl enterastab"></td>
   </tr>


<tr class="hide"><td colspan="6"><iframe name="result" id="result" width="100%"></iframe></td></tr>

<cfif url.observationclass eq "Inquiry">

	<!--- the workgroups align with the modules --->
		
	<cfquery name="SystemModule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT      *
			FROM        Ref_Application
			WHERE       Usage != 'System'
			AND         Operational = 1
			ORDER BY    ListingOrder
	</cfquery>
	
	<cfif systemModule.recordcount eq "0">
	
		<cfquery name="SystemModule" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
				FROM     Ref_Application
				WHERE    Operational = 1
				ORDER BY ListingOrder
		</cfquery>
		
	</cfif>
			      
<cfelse>
	
	<cfquery name="SystemModule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     A.ListingOrder, A.Description AS Application, S.SystemModule, S.Description, A.[Usage]
		FROM       Ref_SystemModule S INNER JOIN
                   Ref_ApplicationModule AM ON S.SystemModule = AM.SystemModule INNER JOIN
                   Ref_Application A ON AM.Code = A.Code
		WHERE      A.[Usage] = 'System'
		AND        S.Operational = 1
		AND        S.MenuOrder < '90'
		ORDER BY   A.ListingOrder, 
		           S.MenuOrder		
	</cfquery>

</cfif>

<cfif systemModule.recordcount eq "0">
	
	<tr><td height="60" align="center" class="label">
		<font size="3">
			<cf_tl id="Portal is not properly configured for this function to work." var="1" class="message">
			<cfset m1 = lt_text>
			<cf_tl id="Please check with your assigned focal point." var="1" class="message">
			<cfset m2 = lt_text>
			<cfoutput>
				#m1#<br><br>#m2#
			</cfoutput>
		</font>
	</td></tr>
	
<cfelse>
	
	<tr>
		
		<cfif url.context eq "Status">
		
			<cfif url.observationclass eq "Inquiry">
						
				<cfquery name="Mission" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT      DISTINCT Mission
						FROM        Organization.dbo.OrganizationAuthorization
						WHERE       UserAccount = '#session.acc#'
						AND         Mission is not NULL 
						AND         Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1 and MissionStatus = '0')
						UNION
						SELECT      Mission 
						FROM        Organization.dbo.Ref_Mission
						WHERE       Mission = '#url.mission#'
											
				</cfquery>
				
				<cfif Mission.recordcount eq "0">
				
					<cfquery name="Mission" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT      DISTINCT Mission
							FROM        Organization.dbo.Ref_Mission
							WHERE       Operational = 1 
							AND         MissionStatus = '0'
					</cfquery>
				
				</cfif>
							
				<!--- owners to show --->	
				<td width="80" class="labelmedium2"><cf_tl id="Organization">:</td>
			    <td>				
									
					<select class="regularxxl enterastab" name="Mission" id="Mission">
					
					   <cfif Mission.recordcount gt "1">
						<option value="0">[Select]</option>
					   </cfif>	
						
					    <cfoutput query="Mission">
												
								<option value="#Mission#" <cfif url.mission eq Mission>selected</cfif>>#Mission#</option>						
							
						</cfoutput>		
					
				    </select>
					
				 </td>								
			
			<cfelse>
						
				<!--- owners to show --->	
				<td width="80" class="labelmedium2"><cf_tl id="Owner">:</td>
			    <td>		
									
					<select class="regularxxl enterastab" name="Owner" id="Owner">
					
					   <cfif Owner.recordcount gte "1">
						<option value="0">[Select]</option>
					   </cfif>	
						
					    <cfoutput query="Owner">
						
							<cfinvoke component = "Service.Access"  
								method           = "ShowEntity" 
								entityCode       = "SysChange"				
								Owner            = "#owner.code#"
								returnvariable   = "access">
							
							<cfif Access eq "EDIT" or Access eq "ALL">	
								<option value="#Code#" <cfif User.AccountOwner eq Code>selected</cfif>>#Code#</option>
							</cfif>
							
						</cfoutput>		
					
				    </select>
					
				 </td>	
		
		    </cfif>	
		
		<cfelse>
		
		    <cfoutput>
			   <input type="hidden" name="Owner" id="Owner" value="#Site.owner#">
			</cfoutput>
		
		</cfif>	
		
	</tr>
	
	<cfif url.observationclass eq "Inquiry">
	
	<tr class="hide">
	    <td width="150" class="labelmedium2"><cf_tl id="Server">: <font color="FF0000">*</font></td>
	    <td width="20%"><select name="ApplicationServer" id="ApplicationServer" class="regularxxl enterastab">
		    <cfoutput query="Site">
				<option value="#ApplicationServer#" <cfif cgi.host eq ServerDomain>selected</cfif>>#ServerDomain#</option>
			</cfoutput>
		    </select>
		</td>
	</tr>	
		
	</cfif>	
	
	<tr>	
		
		<td width="100" class="labelmedium2">
			<cfif url.observationclass eq "Inquiry">
				<cf_tl id="Application">: <font color="FF0000">*</font>			
			<cfelse>
				<cf_tl id="Module">: <font color="FF0000">*</font>
			</cfif>
		</td>

	    <td width="80">					
			
			<cfif url.observationclass eq "Inquiry">
			
				<cfquery name="get" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   TOP 1 *
					FROM     Ref_ModuleControl D, Ref_ApplicationModule A, Ref_Application R
					WHERE    A.Code = R.Code  
					AND      D.SystemModule = A.SystemModule	
					AND      R.Code IN (#quotedvaluelist(SystemModule.code)#)
					<cfif url.systemfunctionid eq "" and (url.systemmodule eq "undefined" or url.systemmodule eq "")>						
					AND      1=1
					<cfelseif url.systemmodule neq "" and url.systemmodule neq "undefined">				
					AND      A.SystemModule = '#url.systemmodule#'								
					<cfelse>								
					AND     SystemFunctionId = '#url.systemfunctionid#'												
					</cfif>
					ORDER BY R.ListingOrder
				</cfquery>		
						
			    <select name="rapplication" id="rapplication"
				    class="regularxxl enterastab" onchange="_cf_loadingtexthtml='';ColdFusion.navigate('getDocumentEntryModule.cfm?application='+this.value,'module_div');ColdFusion.navigate('getDocumentEntryOwner.cfm?application='+this.value,'owner_div')">
				    <option value="">-- Select --</option>
				    <cfoutput query="SystemModule">
						<option value="#Code#" <cfif get.Code eq Code or currentrow eq "1">selected</cfif>>#Description#</option>
					</cfoutput>
			    </select>
			
			<cfelse>			
						
				<cfselect name="systemmodule" group="Application" query="SystemModule" value="SystemModule" display="Description" visible="Yes" enabled="Yes" class="regularxl enterastab"/>
			   			
			</cfif>
		</td>
		
	</tr>
			
		<cfif url.observationclass eq "Inquiry">
		
		<tr>	
		
			<!--- hidden owner --->
			<cfdiv bind="url:getDocumentEntryOwner.cfm?application={rapplication}" id="owner_div">
		
			<td width="70" class="labelmedium2" style="height:30px">
				<cf_tl id="Module">: <font color="FF0000">*</font>	
			</td>
			<td width="50%">			
				<!--- hidden owner --->
				<cfdiv bind="url:getDocumentEntryModule.cfm?application={rapplication}&selected=#get.SystemModule#" id="module_div">			
			</td>
						
		</tr>
		
		</cfif>
		
	
	<tr><td class="labelmedium2"><cf_tl id="Observation Date">:</td>
	    <td colspan="5">	
		
		<cf_calendarscript>
		
		<cf_intelliCalendarDate9
			FieldName="ObservationDate" 
			Default="#dateformat(now(),CLIENT.dateformatshow)#"
			Manual="True"	
			class="regularxxl enterastab"
			DateValidStart=""
			DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
			AllowBlank="False">	
		
		</td>
	</tr>
	
		
	<tr><td class="labelmedium2"><cf_tl id="Request Title">: <font color="FF0000">*</font></td>
	    <td colspan="5">
		
			<cfinput type="Text"
		       name="RequestName"
		       message="Please provide a name for your observation"
		       validate="noblanks"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"     
		       size="90"
			   style="width:95%"
		       maxlength="80"
	    	   class="regularxxl enterastab">
			   
	    </td>
	</tr>
			
	<tr><td class="labelmedium2"><cf_tl id="Priority">:</td>
	
	    <td colspan="5" style="border:0px dotted silver">
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr height="25">
	   	
	    <td class="labelmedium2">
		    <table><tr>
			<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="RequestPriority" id="RequestPriority" value="Low"></td><td class="labelit" style="padding-left:4px">Low</td>
			<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="RequestPriority" id="RequestPriority" value="Medium" checked></td><td class="labelit" style="padding-left:4px">Medium</td>
			<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="RequestPriority" id="RequestPriority" value="High"></td><td class="labelit" style="padding-left:4px">High</td>
			</tr>
			</table>
		</td>
		
		</tr>
		
		</table>
		
		</td>
		
	</tr>
	
	<tr>	
		
	    <td class="labelmedium2"><cf_UIToolTip
	          tooltip="Frequency the issue of this observation is giving problems"><cf_tl id="Frequency">:</cf_UIToolTip></td>
			  
		<td colspan="5" style="border:0px dotted silver">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
			<tr height="25">	  
				  
			    <td class="labelmedium2">
				  <table><tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="ObservationFrequency" id="ObservationFrequency" value="Low"></td><td class="labelit" style="padding-left:4px">Low</td>
					<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="ObservationFrequency" id="ObservationFrequency" value="Medium" checked></td><td class="labelit" style="padding-left:4px">Medium</td>
					<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="ObservationFrequency" id="ObservationFrequency" value="High"></td><td class="labelit" style="padding-left:4px">High</td>
					</tr>
				  </table>
				</td>
			
			</tr>
		
		</table>
		
		</td>
		
	</tr>	
	
	<tr>
		
	   <td class="labelmedium2"><cf_UIToolTip
	          tooltip="The impact the resolution will have on the usage of the system"><cf_tl id="Impact">:</cf_UIToolTip></td>
			  
	   <td colspan="5">
		
		<table width="100%" class="formpadding">
		
		<tr height="25">	  	  
			  
	    <td class="labelmedium2">
		  <table><tr>
			<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="ObservationImpact" id="ObservationImpact" value="Low"></td><td class="labelit" style="padding-left:4px">Low</td>
			<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="ObservationImpact" id="ObservationImpact" value="Medium" checked></td><td class="labelit" style="padding-left:4px">Medium</td>
			<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="ObservationImpact" id="ObservationImpact" value="High"></td><td class="labelit" style="padding-left:4px">High</td>
			</tr>
			</table>
		</td>	
		
		</tr>
		
		</table>
		
		</td>
		
	</tr>	
		
	<cfif url.observationclass neq "Inquiry">
			
		<tr><td class="labelmedium2" style="height:30px"><cf_tl id="Workgroup">:</td>
		    <td colspan="5" class="labelmedium2">	
			<cf_securediv bind="url:getDocumentEntryGroup.cfm?entitycode=#entitycode#&owner={Owner}" class="labelmedium2" id="workgrp">			
			</td>
		</tr>		
			
	</cfif>	
		
	  <tr><td class="labelmedium2" style="height:35px"><cf_tl id="Routing">:</td>
		<td colspan="5" class="labelmedium2">	
		<cfif url.observationclass eq "Inquiry">
			<cf_securediv bind="url:getDocumentEntityClass.cfm?entitycode=#entitycode#&application={rapplication}" id="workcls">						
		<cfelse>
			<cf_securediv bind="url:getDocumentEntityClass.cfm?entitycode=#entitycode#&owner={Owner}" id="workcls">	
		</cfif>
		</td>
		</tr>	
		
		
	<cf_assignId>
	
	<cfoutput>
	
		<input type="hidden" name="ObservationId" id="ObservationId" value="#rowguid#">
		
	</cfoutput>
	
	<tr><td colspan="1" class="labelmedium2" style="padding-right:10px">Attachments&nbsp;and&nbsp;Screenshots:</td><td width="71%" id="mod" colspan="5">
	
		<cf_filelibraryN
				DocumentPath  = "Modification"
				SubDirectory  = "#rowguid#" 
				Filter        = ""						
				LoadScript    = "1"		
				EmbedGraphic  = "no"
				Width         = "100%"
				Box           = "mod"
				Insert        = "yes"
				Remove        = "yes">	
	
	</td></tr>
		
	<tr class="labelmedium2"><td colspan="6"><font color="red"><b>Attention:</b> Please do <b>not</b> paste screenshots into the below text editor unless you are pasting from a webmail</td></tr>
		
	<tr valign="top"><td colspan="6" >
	
		<cfif url.observationclass eq "Inquiry">
		
		<cf_textarea name="ObservationOutLine"                 	          	         
			   resize         = "Yes" 	
			   height		  = "30%"
			   toolbar        = "basic"
			   color          = "fafafa"
			   init           = "Yes">	
		 </cf_textarea> 
		 
		 <cfelse>
		 
		 <cf_textarea name="ObservationOutLine"                 	          	         
			   resize         = "Yes" 	
			   height		  = "30%"
			   toolbar        = "basic"
			   color          = "fafafa"
			   init           = "Yes">	
		 </cf_textarea> 
		 
		 </cfif>		 
		 
		 <!--- <cf_textarea type="CK" script="yes" style="height:400px;width:900" name="ObservationOutLine"></cf_textarea> --->
		 
		</td>
	</tr>
		
	<tr><td colspan="6" height="35" align="center" id="save">
	
		<input type="button" name="Close" id="Close" class="button10g" style="font-size:13px;width:170;height:28px" value="Close" onclick="window.close()">
		<input type="submit" name="Save"  id="Save"  class="button10g" style="font-size:13px;width:170;height:28px" value="Save" onclick="updateTextArea();return validate();">
	
	</td></tr>
	
</cfif>

</table>

</cf_divscroll>

</td></tr>
</table>

</cfform>


