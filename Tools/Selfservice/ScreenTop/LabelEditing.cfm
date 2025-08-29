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
<cfif client.editing eq "1">

	<cfoutput>

	<script language="JavaScript">
			function tl_edit(cls,id) {
			
				<cfif client.browser eq "Explorer">
				
					ret = window.showModalDialog("#SESSION.root#/tools/language/TL_edit.cfm?ts="+new Date().getTime()+"&cls="+cls+"&clsid="+id, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:390px; dialogWidth:500px; help:no; scroll:no; center:yes; resizable:no");
					if (ret) {
					history.go()
					}
				
				<cfelse>						
					window.open("#SESSION.root#/tools/language/TL_edit.cfm?ts="+new Date().getTime()+"&cls="+cls+"&clsid="+id, null, "width=400, height=535, status=no, toolbar=no, scrollbars=no, resizable=no, modal=yes");				   
				</cfif>
			}		
		</script>
	</cfoutput>	
	
</cfif>