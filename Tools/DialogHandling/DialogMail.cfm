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

<cfoutput>

<script>

var root = "#SESSION.root#";

function email(to,subj,att,filter,src,srcid) {
	ptoken.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj + "&source=" + src + "&sourceid=" + srcid, "_blank", "width=1000, height=735, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

function excelformat(id,tables) {
     ptoken.open(root + "/Tools/CFReport/Analysis/SelectSource.cfm?ControlId="+id+tables,"excelformat", "width=800, height=800, status=yes, toolbar=no, scrollbars=no, resizable=no");   
}

</script>

</cfoutput>
