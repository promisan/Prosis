
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