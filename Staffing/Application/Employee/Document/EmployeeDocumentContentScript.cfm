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
<cf_CalendarScript>
<cf_FileLibraryScript>
<cf_dialogPosition>


<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">
  
<cfoutput>
	
	<script language="JavaScript">
		
		function issuedocument(persno) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEntry.cfm?ID=' + persno,'dialog');
		}
		
		function edit(persno,doc) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEdit.cfm?ID=' + persno + '&id1=' + doc,'dialog');
		}
						
		function reloadDocument(id,st) {
		    _cf_loadingtexthtml='';			
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm?ID='+id+'&Status=' + st,'dialog');
		}
		
		function checkfile() {
			var uController = new systemcontroller();					
			document.documententry.action = document.documententry.action + '&mid='+ uController.GetMid();					
		}
		
	</script>

</cfoutput>