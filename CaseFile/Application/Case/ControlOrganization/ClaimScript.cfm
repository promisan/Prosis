
<cfoutput>

<cfif Client.googlemap eq "1">
    <cfajaximport tags="cfmap,cfwindow" 
     params="#{googlemapkey='#client.googlemapid#'}#"> 
</cfif>
	
<cf_textareascript>
<cfajaximport tags="cfform,cfdiv,cftree,cfmenu">
<cf_dialogStaffing>
<cf_listingscript>
		  
<script language="JavaScript">	

function orgunit(org,tpe) {
	
	se = document.getElementById("r"+org)
	
	if (se.className = "hide") {
		se.className = "regular"
		ColdFusion.navigate('#SESSION.root#/System/Organization/Application/Address/UnitAddressInfo.cfm?orgunit='+org+'&addresstype='+tpe,org)		
	} else { se.className = "hide" }		
	}


w = #CLIENT.width# - 61;
h = #CLIENT.height# - 120;

function showclaim(id,id2)	{
   ptoken.open("../CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank");
}

function list(id,id1,id2,id3,id4) {	    
   ColdFusion.navigate('ClaimListing.cfm?id='+id+'&id1='+id1+'&id2='+id2+'&id3='+id3+'&id4='+id4,'controllist') 			
}	

function ShowCaseFileCandidate(personno){
    window.open("#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=" + personno + "&scope=casefile&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function elementlist(id,id1,id2,id3) {	    
   ColdFusion.navigate('../../Element/Listing/ElementListingContent.cfm?elementclass='+id+'&mission='+id1+'&claimtypeclass='+id2+'&claimid='+id3,'controllist') 			
}	

function listfilter(id,id1,id2) {	    
	document.filterform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
	     ColdFusion.navigate('ClaimListContent.cfm?mde=0&id='+id+'&id1='+id1+'&id2='+id2,'listing','','','POST','filterform') 
	 }   
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

<!--- not longer needed --->

function detail(act) {
	 
	  bt1 = document.getElementById("DetailShow")
	  bt2 = document.getElementById("DetailHide")
	  if (act == 'show') {
		  bt1.className = "hide"
		  bt2.className = "button10g"
		  ColdFusion.Layout.expandArea('container','bottom')
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
		
function print(claimid)	{
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  window.open("<cfoutput>#SESSION.root#</cfoutput>/Tools/Mail/MailPrepare.cfm?scale=100&Id=Print&ID1="+claimid+"&ID0=custom/fpd/memos/Potential.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}				
		
</script>

</cfoutput>