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

<!--- passtru template --->

<cfparam name="URL.ID1" default="">
<cfparam name="URL.ID2" default="">

<cfoutput>

<cf_systemscript>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script language="JavaScript">

   ptoken.location("RequisitionViewView.cfm?Mission=#URL.Mission#&Period="+parent.window.treeview.PeriodSelect.value+
   "&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Role="+parent.window.role.value)
					 
</script>

</cfoutput>


