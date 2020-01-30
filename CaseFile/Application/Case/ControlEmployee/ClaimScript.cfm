
<cfoutput>

<cf_listingscript>
		
<cfajaximport tags="cfform,cfdiv,cftree,cfmenu,cfinput-datefield,cfinput-autosuggest">

<cf_dialogStaffing>
		
<script language="JavaScript">	

w = #CLIENT.width# - 61;
h = #CLIENT.height# - 120;

function showclaim(id,id2)	{
   ptoken.open("../CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
}

function showemployee(id) {
  window.open("../../../../Staffing/Application/Employee/PersonView.cfm?id="+id,id);
}

function list(id,id1,id2,id3,id4) {	    
   ColdFusion.navigate('ClaimListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&id='+id+'&id1='+id1+'&id2='+id2+'&id3='+id3+'&id4='+id4,'controllist') 			
}	

function listfilter(id,id1,id2) {	
	document.filterform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
	     ColdFusion.navigate('ClaimListContent.cfm?mission=#url.mission#&mde=0&id='+id+'&id1='+id1+'&id2='+id2,'listing','','','POST','filterform') 
	 }   
 }	

function listreload(id,id1,id2,page,sort,view,mde) {	     
	ColdFusion.navigate('ClaimListContent.cfm?mission=#url.mission#&mde='+mde+'&id='+id+'&id1='+id1+'&id2='+id2+'&Page='+page+'&Sort='+sort+'&view='+view,'listing','','','POST','filterform') 
}	

function facttable1(control,format,box) {
	w = #CLIENT.widthfull# - 80;
    h = #CLIENT.height# - 110;		
	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?box="+box+"&data=1&controlid="+control+"&format="+format, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");		
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
		  ColdFusion.Layout.collapseArea('container','bottom')
	  }
	 }	
		
function showdetail(claimid) {		   
       try {
	   ColdFusion.navigate('ClaimDetail.cfm?claimid='+claimid,'controldetail')		
	   } catch(e) {}
    }

		
function print(claimid) {
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  window.open("<cfoutput>#SESSION.root#</cfoutput>/Tools/Mail/MailPrepare.cfm?scale=100&Id=Print&ID1="+claimid+"&ID0=custom/fpd/memos/Potential.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}		
				
function payment(id) {
    box  = document.getElementById("i"+id);
	if (box.className=="hide") {
			 box.className  = "regular";	
			ColdFusion.navigate('ClaimPayment.cfm?caseNo='+id,'d'+id)			  
  } else {
		 box.className  = "hide";
	 }
					
}				
		
</script>

</cfoutput>