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
<cf_screentop scroll="Yes" html="Yes" height="100%" layout="webapp" label="Content Management - Portal Link">

<cf_assignId>
<cfparam name="URL.ID1" default="#rowguid#">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PortalLinks
WHERE PortalId = '#URL.ID1#'
</cfquery>

<cfoutput>

<script>
 function file(mde) {
	 ptoken.navigate('RecordFile.cfm?portalid=#url.id1#&mode='+mde,'location')
 }
 
function ask() {
	if (confirm("Do you want to remove this link?")) {	
	return true 	
	}	
	return false	
}	

</script>

</cfoutput>

<cfform action="RecordSubmit.cfm?portalid=#url.id1#"  method="POST" name="dialog" target="result">

<cfquery name="SearchResult"
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT *
		 FROM   Ref_ModuleControl
		 WHERE  SystemModule = 'SelfService'
		 AND    FunctionClass IN ('SelfService','Report')		
		 AND    MenuClass = 'Main'
 </cfquery>
	 

<!--- Entry form --->

<table width="94%" class="formpadding formspacing" align="center">

    <tr><td height="10"></td></tr>

	<tr class="hide"><td colspan="2" height="200"><iframe name="result" id="result"></iframe></td></tr>
   	
	<TR>
    <TD width="200" class="labelmedium2">Presentation:</TD>
    <TD>
	
		<select name="class" id="class" onchange="file(this.value)" class="regularxxl">
			<option value="Reference" <cfif Get.Class eq "Reference">selected</cfif>>Main Menu - Tab:Reference</option>
			<option value="Announcement" <cfif Get.Class eq "Announcement">selected</cfif>>Main Menu - Tab:Announcement</option>
			<option value="Self service" <cfif Get.Class eq "Self service">selected</cfif>>Main Menu - Tab:Self Service</option>
			<cfif SearchResult.recordcount neq "0">
			<option value="Custom" <cfif Get.Class eq "Custom">selected</cfif>>Portal - MenuBanner</option>
			<option value="CustomLeft" <cfif Get.Class eq "CustomLeft">selected</cfif>>Portal - Menu:Left</option>
			</cfif>
			<option value="Press" <cfif Get.Class eq "Press">selected</cfif>>Press Release</option>	
		</select>
	
	</TD>
	</TR>
		
		<cfquery name="Language" 
		 datasource="AppsSystem"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN ('1','2')
		</cfquery> 		
				
 		<TD width="100" class="labelmedium2">Language:</TD>
	    <TD>
		<select name="LanguageCode" id="LanguageCode" class="regularxxl">
		  <option value="">Any</option>
		  <cfoutput query="Language">
		  <option value="#Code#" <cfif Get.LanguageCode eq Code>selected</cfif>>#LanguageName#</option>
		  </cfoutput>
		</select>
		</td>
	</tr>	
		
	<TR>
    <TD width="120" class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="text" 
	      name      = "Description" 
		  value     = "#Get.Description#" 
		  message   = "Please enter a description" 
		  required  = "Yes" 
		  size      = "50" 
		  maxlength = "60" 
		  class     = "regularxxl">
    </TD>
	</TR>
		
	<tr> <TD class="labelmedium2" width="120">Submission Date:</TD><td>
	
	<cf_calendarscript>
		
		<cfif Get.ActivityDate neq "">
		
			<cf_intelliCalendarDate9
			FieldName="ActivityDate" 
			Class="regularxxl"
			Default="#dateformat(Get.ActivityDate,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cf_intelliCalendarDate9
			FieldName="ActivityDate" 
			Class="regularxxl"
			Default="#dateformat(now(),CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			
		</cfif>	
						
	</td></tr>
		
	<TR>
    <TD class="labelmedium2">Order:</TD>
    <TD>
  	   <cfinput type="Text" 
	      name="ListingOrder" 
		  message="Please enter a order" 
		  validate="integer" 
		  required="Yes" 
		  value="#get.ListingOrder#"
		  size="2" 
		  maxlength="2" class="regularxxl">
    </TD>
	</TR>
		
	<tr><td colspan="2">
			<cf_securediv bind="url:RecordFile.cfm?portalid=#url.id1#&mode=#get.class#" id="location">
		</td>
	</tr>
	
	<TR>
    <TD class="labelmedium2"><cf_UIToolTip tooltip="Show only on the listed servers, comma delimited">Servers:</cf_UIToolTip></TD>
    <TD>
	
  	   <cfinput type="Text" 
		     name="HostNameList" 
			 message="Enter the hostnames that will show this link" 
			 required="No" 
			 value="#Get.HostNameList#"
			 size="50"
			 maxlength="80" 
			 class="regularxxl">
		 
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Target:</TD>
    <TD class="labelmedium">
    	<INPUT class="radiol" type="radio" name="LocationTarget" id="LocationTarget" value="_blank" <cfif Get.LocationTarget neq "_self">checked</cfif>> New window
		<INPUT class="radiol" type="radio" name="LocationTarget" id="LocationTarget" value="_self" <cfif Get.LocationTarget eq "_self">checked</cfif>> In frame
     </TD>
	</TR>
			
	<tr><td colspan="2" height="1" class="line"></td></tr>
	
	<tr>		
	<td align="center" colspan="2" height="30">
	
	<cfif get.recordcount eq "0">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	<cfelse>
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</cfif>
	
	</td>	
	</tr>
	
</TABLE>

</CFFORM>

