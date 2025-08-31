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

<cfajaximport tags="cfwindow">

<script>
	
	w = #CLIENT.width# - 70;
	h = #CLIENT.height# - 160;
	
	function showclaim(id,id2)	{
	   ptoken.open("#SESSION.root#/CaseFile/Application/Case/CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function elementedit(elementid,claimid) {   
		
		try { ColdFusion.Window.destroy('editelement',true) } catch(e) {}
		ColdFusion.Window.create('editelement', 'Edit Element', '',{x:100,y:100,height:#client.height-140#,width:#client.widthfull-160#,modal:true,resizable:false,center:true})    
		ptoken.navigate('#SESSION.root#/CaseFile/Application/Element/Create/ElementEditView.cfm?claimid='+claimid+'&elementid='+elementid,'editelement') 

	}

</script>

</cfoutput>