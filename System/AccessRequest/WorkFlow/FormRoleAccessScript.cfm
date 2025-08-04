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

<!--- scripts for workflow embedded dialog --->

<cfoutput>

<input type="text" id="requestidcontent">

<script language="JavaScript">
	
	function applyaccess(id,mis,org,role,acc) {
		
		if (mis == "") {	
		   id1 = "global"	
		} else {	
		   id1 = "tree"	
		}	
		
		document.getElementById('requestidcontent').value = id
			
		
		ProsisUI.createWindow('myaccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
		ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessView.cfm?requestid='+id+'&id1='+id1+'&ID='+role+'&Mission='+mis+'&acc=' + acc ,'myaccess') 		
				
	}
	
	function refreshaccess(acc,id) {
	   ptoken.navigate('#SESSION.root#/System/AccessRequest/Workflow/FormRoleAccessDetail.cfm?account='+acc+'&requestid='+document.getElementById('requestidcontent').value,'box'+acc)	
	}

</script>

</cfoutput>
