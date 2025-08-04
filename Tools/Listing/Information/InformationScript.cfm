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
<script language="JavaScript">

function informationdetail(sf,fc, cc, path, mission, id, cde) {
	if (path)
		window.open('../../../'+path+'?fid='+sf+'&FunctionSection='+fc+'&CellCode='+cc+'&mission='+mission+'&id='+id+'&code='+cde,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=NO, scrollbars=no, resizable=no") 
}
</script>
</cfoutput>
