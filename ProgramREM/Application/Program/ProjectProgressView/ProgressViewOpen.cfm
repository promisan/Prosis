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

<cfparam name="URL.ID1" default="0">

<script language="JavaScript">

<cfoutput>

   window.location="ProgressViewGeneral.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Period=" + 
   parent.left.document.getElementById("PeriodSelect").value
   
</cfoutput>

</script>

