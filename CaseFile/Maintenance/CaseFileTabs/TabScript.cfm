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
<script>

<cfoutput>

function recordadd(code) {
          window.open("#SESSION.root#/CaseFile/maintenance/CaseFileTabs/RecordAdd.cfm?id1="+code, "AddTab", "left=80, top=80, width= 700, height= 480, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2,id3) {
          window.open("#SESSION.root#/CaseFile/maintenance/CaseFileTabs/RecordEdit.cfm?ID1="+id1+"&ID2="+id2+"&ID3="+id3, "EditTab","left=80, top=80, unadorned:yes; edge:raised; status:yes; dialogHeight:480px; dialogWidth:640px; help:no; scroll:no; center:yes; resizable:no");
}

</cfoutput>
</script>	