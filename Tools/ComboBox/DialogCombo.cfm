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
<!---
<cf_ajaxRequest>
--->

<cfoutput>

<script language="JavaScript">

	function combomulti(fld,alias,table,pk,desc,order) {
		
		val = document.getElementById(fld).value;		
		ProsisUI.createWindow('combomulti', 'Selection', '',{x:100,y:100,width:700,height:document.body.offsetHeight-200,resizable:false,modal:true,center:true});	
	    ptoken.navigate('#SESSION.root#/tools/combobox/Combo.cfm?fld='+fld+'&alias='+alias+'&table='+table+'&pk='+pk+'&desc='+desc+'&order='+order+'&selected='+val,'combomulti');	  
							
	}	 
			
</script>	

<cf_comboMultiScript>	

</cfoutput>
 