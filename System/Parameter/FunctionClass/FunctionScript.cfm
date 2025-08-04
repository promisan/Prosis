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

<cf_textareascript>		
<cfajaximport tags="cfform,cfdiv,cftree,cfmenu,cfinput-datefield,cfinput-autosuggest,cflayout-tab">
<cf_dialogStaffing>
<cf_FileLibraryScript>
				  
<script src="#SESSION.root#/Tools/DialogHandling/Navigation.js"></script>	

<script language="JavaScript">	

w = #CLIENT.width# - 70;
h = #CLIENT.height# - 160;

function showclaim(id,id2)	{
   window.open("../ClaimView/ClaimView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
}

function ClassEdit(clid,dialog) {
   w = #CLIENT.width# - 90;
   h = #CLIENT.height# - 140;
   window.open(root + "/System/Parameter/FunctionClass/ViewDetail/FunctionView.cfm?ID="+ clid + "&mode=" + dialog,"Print", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=NO, resizable=no");
}

function ClassAdd(clcode,dialog) {
   w = #CLIENT.width# - 90;
   h = #CLIENT.height# - 140;
   window.open(root + "/System/Parameter/FunctionClass/ViewDetail/FunctionView.cfm?ID1="+ clcode + "&mode=" + dialog,"Print", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=no");
	
}	

function ClassList(clcode) {
   ColdFusion.navigate('FunctionListing.cfm?ID=' +clcode,'controllist') 			
}	

function ClassListType(clcode,Type) {
   ColdFusion.navigate('FunctionListing.cfm?ID=' +clcode+'&Type='+Type,'controllist') 			
}	

function asearch() {	    
   ColdFusion.navigate('../ClaimView/ClaimLocate.cfm?mission=#url.mission#','controllist') 			
}	

function listfilter(id,id1,id2) {	  
   ColdFusion.navigate('ClaimListContent.cfm?mde=0&id='+id+'&id1='+id1+'&id2='+id2,'listing','','','POST','filterform') 
}	

function listreload(id,id1,id2,page,sort,view,mde) {	    
	ColdFusion.navigate('ClaimListContent.cfm?mde='+mde+'&id='+id+'&id1='+id1+'&id2='+id2+'&Page='+page+'&Sort='+sort+'&view='+view,'listing','','','POST','filterform') 
}	

function maximize(itm) {
	
	 	 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
		 
		 if (se[0].className == "regular") {
			   while (se[count]) { 
			      se[count].className = "hide"; 
	  		      count++
			   }		   
		 	   icM.className = "hide";
			   icE.className = "regular";
			 } else {
			    while (se[count]) {
			    se[count].className = "regular"; 
			    count++
			 }	
			 icM.className = "regular";
			 icE.className = "hide";			
		   }
}  		

function detail(act) {
	 
	  bt1 = document.getElementById("DetailShow")
	  bt2 = document.getElementById("DetailHide")
	  if (act == 'show') {
		  bt1.className = "hide"
		  bt2.className = "button10g"
		  ColdFusion.Layout.showArea('container','bottom')
	  } else {
	 	  bt1.className = "button10g"
		  bt2.className = "hide"
		  ColdFusion.Layout.hideArea('container','bottom')
	  }
	 }	
		
function showdetail(id) {		   
     try {
   ColdFusion.navigate('FunctionDetail.cfm?id='+id,'controldetail')		
   } catch(e) {}
}
	
function PrintAll(dialog)
{
    w = #CLIENT.width# - 90;
    h = #CLIENT.height# - 140;
	window.open(root + "/System/Parameter/FunctionClass/Report/UseCaseAllofThem.cfm?mode=" + dialog, "Print", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=yes");
}

function PrintOne(clid,dialog)
{
    w = #CLIENT.width# - 90;
    h = #CLIENT.height# - 140;
	window.open(root + "/System/Parameter/FunctionClass/Report/UseCase.cfm?ID=" + clid + "&mode=" + dialog, "Print", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=yes");
}
		
		
</script>

</cfoutput>