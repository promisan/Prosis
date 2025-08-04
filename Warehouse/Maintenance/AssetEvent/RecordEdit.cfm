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
<cfajaximport tags="cfform">
<cf_tl id = "Do you want to remove this event and all its details ?" var = "vAsk"> 
<cf_tl id = "Do you want to remove this event category ?" var = "vAsk2"> 

<cfoutput>

	<script>
		function purgeEvent(code) {
			if (confirm('#vAsk#')) {
				ColdFusion.navigate('RecordPurge.cfm?id1='+code,'divHeader');
			}
		}
		function eventCatEdit(id1,cat) {
			var vWidth = 475;
		   	var vHeight = 225;    
		   
		   	ColdFusion.Window.create('mydialog', 'Category', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		   	ColdFusion.Window.show('mydialog'); 				
		   	ColdFusion.navigate('RecordEditCategory.cfm?idmenu=#url.idmenu#&ID1=' + id1 + '&category='+cat+'&ts='+new Date().getTime(),'mydialog'); 
			
		}
		function purgeEventCat(code,cat) {
			if (confirm('#vAsk2#')) {
				ColdFusion.navigate('RecordCategoryPurge.cfm?idmenu=#url.idmenu#&id1='+code+'&category='+cat,'divDetail');
			}
		}
	</script>
	
</cfoutput>

<cfif url.id1 eq "">
	<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  label="Add Operation Event" 
	  layout="webapp" 
	  banner="blue" 
	  jquery="Yes"
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">
<cfelse>
	<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  jquery="Yes"
	  label="Edit Operation Event" 
	  layout="webapp" 
	  banner="yellow"
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">
</cfif>

<table width="92%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<cfdiv id="divHeader" bind="url:RecordEditHeader.cfm?id1=#url.id1#&idmenu=#url.idmenu#">
		</td>
	</tr>
	<cfif url.id1 neq "">
		<tr><td height="1"></td></tr>
		<tr><td style="height:30px" class="labelmedium"><cf_tl id="Enabled for Equipment Category"></td></tr>
		<tr><td class="line"></td></tr>
		<tr>
			<td>
				<cfdiv id="divDetail" bind="url:RecordEditDetail.cfm?id1=#url.id1#&idmenu=#url.idmenu#">
			</td>
		</tr>
	</cfif>
</table>