
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
 ColdFusion.navigate('RecordFile.cfm?portalid=#url.id1#&mode='+mde,'location')
 }
 
function ask() {
	if (confirm("Do you want to remove this link?")) {	
	return true 	
	}	
	return false	
}	

</script>

</cfoutput>

<cfform action="RecordSubmit.cfm?portalid=#url.id1#"  method="POST" enablecab="Yes" name="dialog" target="result">

<cfquery name="SearchResult"
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT *
		FROM Ref_ModuleControl
		WHERE SystemModule = 'SelfService'
		AND FunctionClass IN ('SelfService','Report')		
		AND MenuClass = 'Main'
 </cfquery>
	 

<!--- Entry form --->

<table width="94%" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">

    <tr><td height="10"></td></tr>

	<tr class="hide"><td colspan="2" height="200"><iframe name="result" id="result"></iframe></td></tr>
   	
	<TR>
    <TD width="200" class="labelmedium">Presentation:</TD>
    <TD>
	
		<select name="class" id="class" onchange="file(this.value)" class="regularxl">
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
				
 		<TD width="100" class="labelmedium">Language:</TD>
	    <TD>
		<select name="LanguageCode" id="LanguageCode" class="regularxl">
		  <option value="">Any</option>
		  <cfoutput query="Language">
		  <option value="#Code#" <cfif Get.LanguageCode eq Code>selected</cfif>>#LanguageName#</option>
		  </cfoutput>
		</select>
		</td>
	</tr>	
		
	<TR>
    <TD width="120" class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" 
	      name      = "Description" 
		  value     = "#Get.Description#" 
		  message   = "Please enter a description" 
		  required  = "Yes" 
		  size      = "50" 
		  maxlength = "60" 
		  class     = "regularxl">
    </TD>
	</TR>
		
	<tr> <TD class="labelmedium" width="120">Submission Date:</TD><td>
	
	<cf_calendarscript>
		
		<cfif Get.ActivityDate neq "">
		
			<cf_intelliCalendarDate9
			FieldName="ActivityDate" 
			Class="regularxl"
			Default="#dateformat(Get.ActivityDate,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cf_intelliCalendarDate9
			FieldName="ActivityDate" 
			Class="regularxl"
			Default="#dateformat(now(),CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			
		</cfif>	
						
	</td></tr>
		
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" 
	      name="ListingOrder" 
		  message="Please enter a order" 
		  validate="integer" 
		  required="Yes" 
		  value="#get.ListingOrder#"
		  size="2" 
		  maxlength="2" class="regularxl">
    </TD>
	</TR>
		
	<tr><td colspan="2">
			<cfdiv bind="url:RecordFile.cfm?portalid=#url.id1#&mode=#get.class#" id="location"/>
		</td>
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="Show only on the listed servers, comma delimited">Servers:</cf_UIToolTip></TD>
    <TD>
	
  	   <cfinput type="Text" 
	     name="HostNameList" 
		 message="Enter the hostnames that will show this link" 
		 required="No" 
		 value="#Get.HostNameList#"
		 size="50"
		 maxlength="80" 
		 class="regularxl">
		 
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Target:</TD>
    <TD class="labelmedium">
    	<INPUT class="radiol" type="radio" name="LocationTarget" id="LocationTarget" value="_blank" <cfif Get.LocationTarget neq "_self">checked</cfif>> New window
		<INPUT class="radiol" type="radio" name="LocationTarget" id="LocationTarget" value="_self" <cfif Get.LocationTarget eq "_self">checked</cfif>> In frame
     </TD>
	</TR>
			
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
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

