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

<cf_screentop html="No" jquery="Yes">
<cf_textareaScript>
<cf_calendarscript>

<cfoutput>
	
	<script>
	
		function saveTarget(programcode,period,targetid,cat,programaccess) {
				document.frmTarget.onsubmit() 
				if( _CF_error_messages.length == 0 ) {
	            	ptoken.navigate('#SESSION.root#/ProgramREM/application/Program/Target/TargetSubmit.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&programaccess='+programaccess,'targetsubmit','','','POST','frmTarget')
				 }   
			}	 
			
	</script>

</cfoutput>

<cfajaximport tags="cfform">

<table width="100%" style="height:100%"><tr><td style="height:100%;padding:15px">
	<cf_divscroll style="height:100%">
	<cfdiv bind="url:#session.root#/ProgramREM/application/Program/Target/TargetEdit.cfm?programcode=#url.programcode#&period=#url.period#&category=#url.category#&targetid=#url.targetid#&programaccess=#url.programaccess#">	
	</cf_divscroll>
</td></tr></table>