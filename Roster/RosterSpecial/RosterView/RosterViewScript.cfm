
<cfoutput>

<cfparam name="url.exerciseclass" default="">

<cfif findNoCase("&cache=0","#CGI.QUERY_STRING#")>
	  <cfset l = "">
	<cfelse>
	  <cfset l = "&cache=0">
</cfif>				

<cfset qrystring = replaceNoCase(CGI.QUERY_STRING,"exerciseclass","exer1","ALL")> 

<cf_actionlistingscript>

<script language="JavaScript">

var ID;
var P;

function reloadroster() {       
    Prosis.busy('yes');
	window.location = "RosterViewLoop.cfm?#qrystring##l#&exerciseclass="+document.getElementById('exerciseclass').value
}	

function reloadPosition(pos, edition){
	ptoken.navigate('#session.root#/Roster/Maintenance/RosterEdition/Position/getPositionEditionTitle.cfm?positionno='+pos+'&submissionedition='+edition,pos+'_title')
}

function editeditionposition(pos,edition,idmenu) {
	
	try { ColdFusion.Window.destroy('EditEditionPosition',true) } catch(e) {}
	ColdFusion.Window.create('EditEditionPosition', 'Edit title', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true,resizable:false});	    						
	ptoken.navigate("#SESSION.root#/Roster/Maintenance/RosterEdition/Position/PositionEditionView.cfm?idmenu="+idmenu+"&positionno="+pos+"&submissionedition="+edition,"EditEditionPosition")	
}

function referenceapply(edition,mission,grade) {
	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Position/setReference.cfm?op=update&id='+edition+'&mission='+mission+'&grade='+grade,'dresult','', '','POST','fReferences'); 	
}	

function broadcast(edition,mode) {
  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastEdition.cfm?mode="+mode+"&submissionedition="+edition, "broadcast", "status=yes, height=850px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

function processfunction(functionno,edition,position) {
   _cf_loadingtexthtml="";	
   ColdFusion.navigate('#session.root#/Roster/Maintenance/RosterEdition/Position/setFunction.cfm?functionno='+functionno+'&submissionedition='+edition+'&positionno='+position,'title'+position)  
   _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";					
}

function publishedition(id,p) {

	var stop = 0;
	
	$(':text:visible').each(function() {
		var id = $(this).attr('id');
		if ($(this).val()=='' && id)
		{
			$(this).css("backgroundColor", "##FFCFCF");
			var n = id.replace("Reference","row");
			$('##'+n).css("backgroundColor", "##FFCFCF");
			stop++;			
		}	
	}
	);	
	
	if (stop!=0) {
		if (stop == 1)
			alert('You have to select a proper reference before continue. There is one Position that needs a reference');
		else
			alert('You have to select a proper reference before continue. There are '+ stop + ' Positions that need a reference');	
	} else { ID = id;
		P  = p;		
		doVerify();
	}
}

function doVerify() {
		Ext.MessageBox.show({
           msg: 'Verifying all requisites before rendering documents...',
           progressText: 'Verifying...',
           width:300,
           wait:true,
           waitConfig: {interval:300}
       });		
  	ColdFusion.navigate('#SESSION.root#/Tools/Mail/Broadcast/BroadCastEditionVerification.cfm?submissionedition='+ID+'&sourcepath='+P,'dresult',doPublish);
}

function referencereset(id) {
	var r=confirm("Do you want to remove all assigned Job references in order to assign these again ?");
	if (r==true) {
	 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Position/setReference.cfm?op=remove&id='+id, 'dresult');
	}
}

function recipient(op,id,org) {
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op='+op+'&id='+id+'&org='+org, 'recipientprocess');
}

function togglePublishMode(edition,positionNo){
    
	_cf_loadingtexthtml='';	
	mode = document.getElementById('PublishMode_'+positionNo);
	img = document.getElementById('imgPublishMode_'+positionNo);
	if (mode.value==1){
		mode.value = 0;
		img.src = '#client.root#/images/light_red1.gif';
		img.title = 'Enable';
	}else if(mode.value==0){
		mode.value = 1;
		img.src = '#client.root#/images/light_green1.gif';
		img.title = 'Disable';
	}	
	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Position/setPublishMode.cfm?submissionedition='+edition+'&positionno='+positionNo+'&publishmode='+mode.value, 'dresult');
	
}

function recipientremoveall(id) {
	$(':checkbox:visible:checked').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',false); }
	);			
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=removeall&id='+id, 'recipients');		
	$('##lrecipients').html('<b>Recipients (0)</b>');
}

function recipientselectall(id) {
	$(':checkbox:visible').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',true); }
	);			
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=selectall&id='+id, 'recipients');	
}

function recipienttype(op,id,at) {
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientAddressTypeSet.cfm?op='+op+'&id='+id+'&at='+at, 'types');
}

function reloadAddressDetail(edition){
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetail.cfm?submissionedition='+edition, 'recipients');
}

function getUnitAddress(id, edition) {
	
	//ptoken.open('#SESSION.root#/System/Organization/Application/Address/UnitAddress.cfm?systemfunctionid=&ID='+id);
	ColdFusion.Window.create('UnitWindow', 'Edit unit address', '',{x:100,y:100,height:850,width:1050,modal:true,center:true});    
	ColdFusion.Window.show('UnitWindow'); 					
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewUnit.cfm?systemfunctionid=&ID='+id+'&closeAction=parent.ColdFusion.Window.hide(\'UnitWindow\'); parent.reloadAddressDetail(\''+edition+'\');',"UnitWindow")
}
	   
function assreview(postno) { 	
    ptoken.open("#SESSION.root#/Staffing/Application/Assignment/Review/AssignmentView.cfm?ID1=" + postno + "&caller=edition", "_blank", "width=950, height=800, status=yes,toolbar=no, scrollbars=yes, resizable=yes")	
}
 
function more(bx) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
		
	if (se.className=="hide") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
	} else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
	}
}

function search(tpe) {
	fld  = document.getElementById("search");	
	
	if (fld.value == "")
	   alert("Please enter your criteria")
	else {
	opt  = document.getElementById("option");
	if (opt.checked)
		{op = "1"}
	else
		{op ="0"}
	srt  = document.getElementById("sorting");	
	ColdFusion.navigate('RosterViewDetail.cfm?edition=#URL.Edition#&inquiry=#URL.Inquiry#&owner=#URL.Owner#&Status=#URL.Status#&occ=more&search=1&fld=' + fld.value + '&opt=' + op + '&tpe=' + tpe + '&sort=' + srt, 'imore')
	}
	
 }
 
function loadset() { 
  window.analysisbox.location = "../../RosterGeneric/Dataset.cfm?header=0&owner=#url.owner#&mode=#url.mode#"
} 
		
function listing(occ,act,mode,filter,level,line,cell,ecl) { 
       	
	$(".topn").attr("class","regular");	 		
	cell.className = "topn";
	
	try {		
		icM  = document.getElementById("d"+occ+"Min");
    	icE  = document.getElementById("d"+occ+"Exp");	
	} catch(e) {}
	
	if (ecl == "undefined") {
	   ecl = ""
	}	
	
	se   = document.getElementById("d"+occ);
			 		 
	if (se.className=="hide" || act=="show") {
	  
	  	try {	
     	
		 icM.className = "regular";
	     icE.className = "hide"; } catch(e) {}
    	 se.className  = "regular";
		 ColdFusion.navigate('RosterViewDetail.cfm?edition=#URL.Edition#&inquiry=#URL.Inquiry#&owner=#URL.Owner#&status=#URL.Status#&ExerciseClass=' + ecl + '&occ=' + occ + '&mode=' + mode + '&filter=' + filter + '&level=' + level + '&line=' + line , 'i'+occ)
		
	 } else {	 	
		 try {	    
     	 icM.className = "hide";
	     icE.className = "regular"; } catch(e) {}
     	 se.className  = "hide";		 	 
	 }
		 		
  }
		
function show(itm) {

	 icM  = document.getElementById(itm+"Min")
	 icM.className = "regular";
	 icM  = document.getElementById(itm+"Min2")
	 icM.className = "regular";
     icE  = document.getElementById(itm+"Exp")
	 icE.className = "hide";
		 	  
	 var loop=0;
	 
	 while (loop<100){
	     
		 loop=loop+1
		 
		 if (loop<10)
		 { sel = ".0"+loop }
		 else
		 { sel = "."+loop }
		 
		 se = document.getElementsByName("T"+itm+sel);
		 count=0
		 
		 while (se[count]) { se[count].className = "regular"; 
		                    count=count+1;
						  }
		 		 	 		 	 
		 se   = document.getElementById(itm+sel);
		 if (se) {se.className = "regular";}
		 else {loop=100}
		 		 		 
		}	 	 	 
		
  }
  
function hide(itm,len,lv) {

     icM  = document.getElementById(itm+"Min")
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 if (icM) {
     	 icM.className = "hide";
		 icM  = document.getElementById(itm+"Min2")
		 icM.className = "hide";
	     icE.className = "regular";
	 }
		 	  
	 var loop=0;
	 
	 while (loop<100){
	 	 
	     loop=loop+1
		 
		 if (loop<10)
		    { sel = ".0"+loop }
		 else
		    { sel = "."+loop }
			
		 se = document.getElementsByName("T"+itm+sel);
		 count=0
		 
		 while (se[count]) { se[count].className = "hide"; 
		                    count=count+1;
						  }
						 		 
      	 se   = document.getElementById(itm+sel);
		 if (se) {se.className = "hide";}
		 else {loop=100}
				 		 							 
		}	 	
  }  
  
function gjp(fun,grd) {   
    ptoken.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
}

w = 0
h = 0
if (screen) {
w = #CLIENT.width# - 60
h = #CLIENT.height# - 110
}

function showdocument(vacno) {

	ptoken.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function va(fun) {

	ptoken.open("#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?ID="+fun, "_blank", "width=800, height=600, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
}

function details(fun) {

    ptoken.open("../CandidateView/FunctionViewLoop.cfm?Idfunction=" + fun + "&status=#URL.Status#&Inquiry=#URL.Inquiry#", fun);
	 
}
 
function initial(funno,doctpe) {

    w = #CLIENT.width# - 60
    h = screen.height - 160;	
	ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1InitialClear.cfm?Inquiry=#URL.Inquiry#&Status=#URL.Status#&docno=" + funno + "&doctpe=" + doctpe, "_blank", "left=35, top=30, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	
}

function retire(id,no,occ,mode,filter,level,line) {

	if (confirm("Do you want to outdate (set to status 5) the "+no+" outstanding bucket submissions ?")) {
	
		url = "RosterViewRetire.cfm?Owner=#URL.owner#&Id="+id + "&occ="+occ + "&mode=" + mode + "&filter=" + filter + "&level=" + level + "&line=" + line
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')
		ptoken.navigate(url,'retire'+id)	
					
		}
	}
	
function recordadd(occ,act,mode,filter,level,line,cell,edit,edition) {
 	
	try { ColdFusion.Window.destroy('myfunction',true) } catch(e) {}
	ColdFusion.Window.create('myfunction', 'Bucket', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
	ColdFusion.navigate("#SESSION.root#/Staffing/Application/Function/Lookup/FunctionView.cfm?edition="+edition+"&occ="+occ+"&owner=#URL.Owner#&mode=Bucket&ts="+new Date().getTime(),'myfunction') 	   
}	

function Selected(no,description) {				
		
    ptoken.navigate('#SESSION.root#/roster/RosterSpecial/Bucket/BucketAddView.cfm?FunctionNo='+no+'&owner=#url.owner#&edition=','rightme')						
	
}

</script> 
  
</cfoutput>   
