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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Service Item" 
			  option="Record Service Item" 
			  scroll="Yes" 
			  layout="webapp" 			  
			  menuAccess="Yes" 
			  jQuery = "Yes"
			  systemfunctionid="#url.idmenu#">

<cfoutput>

	<cf_ColorScript>

	<script>
	
		function validate() {
			document.editform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {        
				ptoken.navigate('RecordSubmit.cfm?action=save','addItemDiv','','','POST','editform')
			 }   
		}	
	
	</script>

</cfoutput>

<cfdiv id="addItemDiv">
<cfinclude template="ServiceItemEdit.cfm">
</cfdiv>

