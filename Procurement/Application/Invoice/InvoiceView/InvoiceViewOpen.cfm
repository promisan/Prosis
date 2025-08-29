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
<cfoutput>

	<script language="JavaScript">
		 
	   window.location="InvoiceViewView.cfm?time=#now()#&Period=" + parent.document.getElementById('PeriodSelect').value + 
	                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#"
	</script>

</cfoutput>

