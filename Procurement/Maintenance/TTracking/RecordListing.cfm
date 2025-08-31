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
<cf_screentop height="100%" scroll="yes" html="No">

<cfajaximport tags="cfform">

<script>

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?id2=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ColdFusion.navigate('RecordListingSubmit.cfm?id2='+code,'listing','','','POST','mytopic')
	 }   
 }
 

</script>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" align="center" class="formpadding">

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		<cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>
