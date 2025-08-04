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
<cfparam name="url.Mission" default="'ALL'">
<cfparam name="url.action" default="1">

<cf_screentop height="100%" jquery="Yes" html="No" scroll="Vertical">

<cf_systemscript> 
<cf_ParameterSystemInit>
<cf_dialoglookup>
<cfset Page         = "0">
<cfset add          = "0"> 
<cfset back         = "0"> 
<cfset option       = "">

<cfinclude template="HeaderParameter.cfm">

<script language="JavaScript">

function detail(bx,sm) {
	se   = document.getElementById(bx);					 		 
	if (se.className == "hide") {	   	
		 se.className  = "regular";
		 url = "ParameterSystemLicense.cfm?systemmodule=" + sm
		 ptoken.navigate(url,bx)				
	 } else {		   	    
    	 se.className  = "hide"
	 }				 		
}

function addLDAP(){
	alert('add');
}

function editLDAP(LDAPServer){
	ptoken.navigate('ParameterSystemEditLDAP.cfm?LDAPServer='+LDAPServer,'idLDAP');
}

function deleteLDAP(){
	ptoken.navigate('ParameterSystemEditLDAP.cfm?action=delete&LDAPServer='+LDAPServer,'idLDAP');
}

function changePwdMode(val)
{
	if (val=='Basic') {
		$('#Basic_1').show();
		$('#Basic_2').show();		
		$('#Advance_1').hide();
		$('#Advance_2').hide();		
	} else {
		$('#Basic_1').hide();
		$('#Basic_2').hide();		
		$('#Advance_1').show();
		$('#Advance_2').show();		
	}	
	
}

</script>

<cfajaximport tags="cfform">
   
<div id="fSystem" style="width:100%">
	<cfinclude template = "ParameterSystemForm.cfm">
</div>
