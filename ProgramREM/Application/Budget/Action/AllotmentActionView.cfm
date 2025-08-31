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
<cf_screentop label="Process Budget Action" 
     height="100%" line="no" 
	 jQuery="Yes" 	
	 banner="red" 
	 bannerforce="Yes"
	 scroll="Yes" 
	 layout="webapp" 
	 html="Yes">
	 
<!--- view of the action to be processed --->

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_dialogREMProgram>
<cfajaximport tags="cfform">
<cfoutput>

<script language="JavaScript">

	function changeReference(id) {
	   _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEdit.cfm?editreference=1&id='+id, 'tdReference');
	}
	
	function submitActionReference(id) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEditSubmit.cfm?id='+id, 'tdReference','','','POST','editreference');	
	}

</script>
</cfoutput>

<cf_divscroll>

<cfinclude template="AllotmentActionViewContent.cfm">

</cf_divscroll>

<cf_screenbottom layout="webapp">
