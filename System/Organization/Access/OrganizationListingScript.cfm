
<cfajaximport tags="cfdiv">
<cf_dialoglookup>

<cfoutput>

<script language="JavaScript">

function broadcast(role,mission) {     
	  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastUser.cfm?role="+role+"&mission="+mission+"&ts="+new Date().getTime(), "broadcast", "status=yes, height=850px, width=920px, center=yes,scrollbars=no, toolbar=no, resizable=no");
}

function Process(action) {

	if (confirm("Do you want to " + action + " selected access roles ?")) {
	   return true;	  
	   } else { 
	   return false
	   }
	}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,s){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight"+s;
	 }else{
		
     itm.className = "regular";		
	 }
  }
  
function listing() {
    parent.window.open("OrganizationView.cfm","_top")
}  

function reloadForm(role,acc) {
    parent.ColdFusion.navigate('OrganizationTree.cfm?mission=#URL.Mission#&class='+role,'tree')
	location = "OrganizationListing.cfm?Mission=#URL.Mission#&ID4="+role+"&ID5="+acc
}  

function reloadView(role,acc) {  
   location = "OrganizationListing.cfm?mission=#URL.Mission#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4="+role+"&ID5="+acc
}  

function process(acc) {        
	ProsisUI.createWindow('myaccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true})    			
	ColdFusion.navigate(root + '/System/Organization/Access/UserAccessView.cfm?ID1=tree&ID=#URL.ID4#&ID2=#URL.ID1#&Mission=#URL.Mission#&ID4=#URL.ID3#&ACC=' + acc,'myaccess') 		
 } 

function reinstate(role,acc,accessid) {
    location = "OrganizationListingReinstate.cfm?ts="+new Date().getTime()+"&accessid="+accessid+"&mission=#URL.Mission#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&ID4="+role+"&ID5="+acc
}

function more(bx,row,enf) {
  	icM  = document.getElementById(row+"Min")
    icE  = document.getElementById(row+"Exp")	
	se   = document.getElementById(row);
		 		 
	if (se.className == "hide" || enf == "enforce") {
					
			 icM.className = "regular";
			 icE.className = "hide";
			 se.className  = "regular";
			 
			 ColdFusion.navigate('#SESSION.root#/system/Access/Membership/RecordListingDetail.cfm?mode=regular&mod=' + bx +'&row=' + row,'i'+row) 
			
	      }	else {
	   	 	icM.className = "hide";
			bus.className = "hide"
		    icE.className = "regular";
	    	se.className  = "hide"
		}
		 		
  }
  
function drilldown(account,box,con,mis,man,role,org) {    
	
	  se = document.getElementById("row_"+box);			  
	  if (se.className == "hide") {		  
		 se.className = "regular"
		 ColdFusion.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingDetail.cfm?box='+box+'&id='+account+'&id1='+con+'&mis=' + mis + '&man=' + man + '&org='+ org + '&role=' + role ,box)  
	     } else {		   
		 se.className = "hide"     
	  }
}	 

function group(row,act,id) {
     		
	icM  = document.getElementById("d"+row+"Min");
    icE  = document.getElementById("d"+row+"Exp");
	se   = document.getElementById("d"+row);
	frm  = document.getElementById("i"+row);
	 		 
	if (act=="show") {	 
     	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 window.open("../../Access/Membership/RecordListingDetail.cfm?Mode=limited&Mod="+id+"&now=#now()#&row=" + row, "i"+row)
		
	 } else {	 
	   	 icM.className = "hide";
	     icE.className = "regular";
     	 se.className  = "hide";
	 }		 		
  }

</script>	

</cfoutput>
