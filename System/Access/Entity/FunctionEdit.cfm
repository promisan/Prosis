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
<cfparam name="url.idmenu" default="">

 
<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT *
   FROM   MissionProfile
   WHERE  ProfileId = '#URL.ID1#'
</cfquery>

<cfoutput>
<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this profile ?")) {	
		return true 	
		}	
		return false	
	}	

    function Selected(no,description) {		
	    _cf_loadingtexthtml='';		
	    ptoken.navigate('setProfileFunction.cfm?action=add&id1=#url.id1#&functionno='+no,'functionbox')							    			 
	    // ProsisUI.closeWindow('myfunction')
	 }		
	 
	 function deletefunction(no) {		
	    _cf_loadingtexthtml='';					
	    ptoken.navigate('setProfileFunction.cfm?action=delete&id1=#url.id1#&functionno='+no,'functionbox')							    			 	   
	 }	

</script>

<cf_dialogstaffing>
</cfoutput>

<cf_screentop height="100%" 
	  label="User profile" 
	  html="Yes" 
	  line="No"			
	  jquery="yes" 
	  layout="webapp" 
	  banner="gray">

<cfform action="FunctionSubmit.cfm" name="dialog">
	
	<table width="93%" align="center" class="formpadding formspacing">
	
		 <tr><td height="5"></td></tr>
		 
	    <cfoutput>
	    <TR class="labelmedium2">
	    <TD>Function:</TD>
	    <TD class="labelmedium">
		
		    <cf_LanguageInput
			TableCode       = "MissionProfile" 
			Mode            = "Edit"
			Name            = "FunctionName"
			Value           = "#get.FunctionName#"
			Key1Value       = "#get.ProfileId#"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "40"
			Size            = "40"
			Class           = "regularxxl">	
					   
	  	   <input type="hidden" name="ProfileId" id="ProfileId" value="#get.ProfileId#" size="10" maxlength="10"class="regularxl">
		 </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Order:</TD>
    	<TD class="labelmedium">
	  	   <cfinput type="Text" name="ListingOrder" style="text-align:center" value="#get.Listingorder#" message="Please enter an Order" required="Yes" size="2" maxlength="2" class="regularxl">
	    </TD>
		</TR>	
		
		
		<TR class="linedotted">
	    <TD style="padding-top:4px" valign="top" class="labelmedium">
		<a href="javascript:selectfunction('webdialog','functionno','functiondescription','#get.mission#','','')">Associated Functions</a>:</TD>
    	<TD class="labelmedium" id="functionbox">
		<cfinclude template="setProfileFunction.cfm">
		</TD>	
		</TR>	
		
		<TR class="labelmedium2">
	    <TD>Operational:</TD>
	    <TD class="labelmedium">
		   <input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>>		 
		 </TD>
		</TR>
		
		<!---
		
		<tr><td height="3"></td></tr>
		
		<TR>
	    <TD class="labelmedium">eMail : </TD>
	    <TD class="regular">
	  	   <cfinput type="Text" name="emailaddress" value="#get.emailaddress#" message="Please enter a valid email address"  required="Yes" size="30" maxlength="40" class="regularxl">
	    </TD>
		</TR>
		
		--->
			
		</cfoutput>
		
		<cf_dialogBottom option="edit">
			
	</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">


	

