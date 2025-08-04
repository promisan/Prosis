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
	
	function listing(box,fun,grd) {		
			
		se   = document.getElementById("d"+box);
		frm  = document.getElementById("i"+box);
		url  = "RecordListingDetail.cfm?FunctionNo="+fun+"&GradeDeployment="+grd+"&ifrm=" + box					 
		if (se.className == "hide") {		   		 
	    	 se.className  = "regular";				 	
			 ColdFusion.navigate(url,'i'+box)
		 } else {	   
	  		 se.className  = "hide"
		 }			 		
	  }
	
	function locate(idmenu) {
	    window.location = "RecordSearch.cfm?idmenu="+idmenu; 
	}	
	
	function reloadForm(page,vw,mode) {           
	    Prosis.busy('yes')
	    window.location = "RecordListing.cfm?idmenu=#url.idmenu#&Mode="+mode+"&Page=" + page + "&view=" + vw + "&id=#URL.ID#"; 
	}
	
	function recordRefresh(id,fld) {  
	    row = document.getElementById('myrow').value  
	    ColdFusion.navigate('RecordListingRefresh.cfm?row='+row+'&functionNo='+id+'&col='+fld,fld+'_'+row);
	}
	
	function recordadd(grp) {
	    ProsisUI.createWindow('functiondialog', 'Functional Title', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    						
		ptoken.navigate('RecordView.cfm?action=add&idmenu=#url.idmenu#','functiondialog') 	
	}
	
	function recordedit(id,row) {	
		ProsisUI.createWindow('functionedit', 'Functional Title', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    					
		ptoken.navigate('RecordView.cfm?action=edit&idmenu=#url.idmenu#&ID1=' + id ,'functionedit') 	
	    document.getElementById('myrow').value = row  
	}
	
	function bucketadd(id1,row) {
	    window.open("BucketAdd.cfm?currentrow="+row+"&FunctionNo=" + id1, "_blank", "left=80, top=80, width=400, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function gjp(fun,grd) {
	    window.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "toolbar=no, status=yes, scrollbars=yes, resizable=yes"); 
	}
	
	function maintain(id,id1) {   
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open("FunctionGrade.cfm?idmenu=#url.idmenu#&ID="+id+"&ID1=" + id1, "_blank", "left=30, top=30, width= " + w + ", height=" + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function showdocument(vacno) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 90;
		window.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function va(fun){
		window.open("#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?ID="+fun, "_blank", "width=800, height=600, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
	}
	
	function bucketedit(box,id1){
	     window.open("BucketEdit.cfm?ifrm="+box+"&FunctionId=" + id1, "_blank", "left=80, top=80, width=600, height=500, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>

</cfoutput>