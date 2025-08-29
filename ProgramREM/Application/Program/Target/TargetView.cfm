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
<cfparam name="url.portal" default="0">
<cfparam name="url.mode"   default="view">
	
<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">
	
<cfajaximport tags="cfdiv,cfform">
<cf_actionlistingscript>
<cf_FileLibraryScript>
<cf_textareaScript>
<cf_calendarscript>

<cf_tl id="Do you want to remove this target ?" var="vDeleteQuestion">

<cfoutput>
	
	<script>
	
		function saveTarget(programcode,period,targetid,cat,access) {
			document.frmTarget.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
            	ColdFusion.navigate('TargetSubmit.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&ProgramAccess='+access,'targetsubmit','','','POST','frmTarget')
			 }   
		}	 
		
		function editTarget(programcode,period,targetid,cat,access) {
			Prosis.busy('yes');
			ptoken.navigate('#SESSION.root#/ProgramREM/application/Program/Target/TargetEdit.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&ProgramAccess='+access, 'targetdetail_'+cat);
		}

		function targetrefresh(programcode,period,targetid,cat,access) {
			ptoken.navigate('#session.root#/ProgramREM/Application/Program/Target/TargetListing.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&ProgramAccess='+access, 'targetdetail_'+cat);
		}
		
		function removeTarget(programcode,period,targetid,cat,access) {
			if (confirm('#vDeleteQuestion#')) {
			    Prosis.busy('yes');
				 _cf_loadingtexthtml='';	
				ptoken.navigate('#SESSION.root#/ProgramREM/application/Program/Target/TargetPurge.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&ProgramAccess='+access, 'targetdetail_'+cat);
			}
		}
		
		function edit(id) {	  
     	  w = #CLIENT.width#  - 110;
	      h = #CLIENT.height# - 100;	 
		  ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#url.period#&ActivityId=" + id,"_blank","width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes")		  
		}
	
	</script>

</cfoutput>

<!--- get access levels based on top Program--->
<cfinvoke component="Service.Access"  
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
		
<table width="98%" height="100%" align="center" border="0">
	
		<cfset url.attach = "0">
		
		<tr class="line"><td height="10"><cfinclude template="../Header/ViewHeader.cfm"></td></tr>
		
		<tr class="hide"><td>
					
		<cfoutput>
			<input type="Button" 
			       id="targetrefresh" 
				   class="button10g" 
				   onclick="ColdFusion.navigate('TargetListing.cfm?programCode=#url.programcode#&period=#url.period#&ProgramAccess=#ProgramAccess#', 'targetdetail_')" value="refresh">
		</cfoutput>
		
		</td></tr>
		
		<tr>
			<td valign="top" class="labelmedium" style="height:100%;padding-top:4px;padding-left:10px;padding-right:15px">		
			  <cf_divscroll>		  
				<cfdiv id="targetdetail_" bind="url:TargetListing.cfm?programCode=#url.programcode#&period=#url.period#&ProgramAccess=#ProgramAccess#">	
			  </cf_divscroll>	
			</td>
		</tr>   
	
</table>
	
<cf_screenbottom html="No">

