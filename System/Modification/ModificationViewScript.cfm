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
<cfparam name="url.owner" default="">

<cfoutput>

<script>
	
// function editRequest(documentid,page,fil,id,id1) {  
//   w = #CLIENT.width# - 60;
//   h = #CLIENT.height# - 120;
//   ret = window.showModalXXXDialog("#SESSION.root#/System/Modification/DocumentView.cfm?id="+documentid+"&tc="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:auto; center:yes; resizable:yes");
//   reloadForm(page,fil,id,id1)											
// }	

function reloadForm(page,fil,id,id1) {
   try {cond = document.getElementById("conditionvalue").value } catch(e) { cond="" }
   loc = document.getElementById("find").value  
   ColdFusion.navigate('#SESSION.root#/System/Modification/ModificationViewListing.cfm?find='+loc+'&Condition='+cond+'&Owner=#URL.Owner#&ID='+id+'&ID1='+id1+'&filter='+fil+'&Page=' + page,'detail');
}

function filter() {
	document.formlocate.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
	   	ColdFusion.navigate('#SESSION.root#/System/Modification/ModificationViewListingPrepare.cfm?Owner=#URL.Owner#','detail','','','POST','formlocate')
	 }   
}	 

</script>	

</cfoutput>