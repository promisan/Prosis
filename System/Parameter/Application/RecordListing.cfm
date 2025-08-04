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

<cfset Header       = "application">
<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../../Parameter/HeaderParameter.cfm"></td></tr>

<cf_dialogOrganization>

<cfajaximport tags="cfform,cfdiv">

<cfoutput>

<script>

	function recordadd() {
	    // window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 240, toolbar=no, status=yes, scrollbars=no, resizable=no");
		ptoken.navigate('RecordListingDetail.cfm?code=new','listing');
	}
	
	
	function recordedit(code) {
	    // window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 240, toolbar=no, status=yes, scrollbars=no, resizable=no");
		ptoken.navigate('RecordListingDetail.cfm?code='+code,'listing');
	}

	function editApplication(code){
		alert('Under development');
	}
	
	function showModules(code){
		line = document.getElementById(code+'_list');
		if (line.className == "hide"){
			line.className ="regular";
			ptoken.navigate('List.cfm?code='+code,code+'_list');
		}else{
			line.className = "hide";
		}
	}
	
	function submitModule(application,module){
		cell = document.getElementById('td_'+application+'_'+module);

		if (cell.style.backgroundColor == '##ffffcf')
			cell.style.backgroundColor = 'ffffff'
		else
			cell.style.backgroundColor = 'ffffcf'
		
		ptoken.navigate('ListSubmit.cfm?application='+application,'submit_'+application,'','','POST','moduleform_'+application)
	}
	
	function save(action) {
	   document.applicationform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('RecordListingSubmit.cfm?action='+action,'listing','','','POST','applicationform')
		 }   
	 }
	 
	 function deleteApplication(application){
		if (confirm('Are you sure you want to delete this record?')){
			 ptoken.navigate('RecordListingPurge.cfm?application='+application,'listing');
		}
	 }
	
</script>

</cfoutput>

<tr><td>
<cf_divscroll>

<table width="98%">
	<tr>
		<td id="listing">
			<cfinclude template="RecordListingDetail.cfm">
		</td>
	</tr>
</table>

</cf_divscroll>

</td></tr>