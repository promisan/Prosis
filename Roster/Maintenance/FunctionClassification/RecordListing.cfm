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

<cfajaximport tags="cfform,cfdiv">

<script>

function recordadd() {
   ptoken.navigate('RecordListingDetail.cfm?code=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ptoken.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','mytopic')
	 }   
 }
 
function show(cde) {

	se = document.getElementById(cde);

	if (se.className == "hide") {
		se.className  = "regular" 
		ColdFusion.navigate('List.cfm?parentcode='+cde,cde+'_list')
	} else {
		se.className  = "hide"				
	}
	
}

</script> 

<cf_screentop html="No" jquery="Yes">
	
<cfset add          = "1">
<cfinclude template = "../HeaderRoster.cfm"> 		

<cf_divscroll>
<table width="97%" cellspacing="0" cellpadding="0" align="center">
		
	<tr>
	
	    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
		</td>		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>
