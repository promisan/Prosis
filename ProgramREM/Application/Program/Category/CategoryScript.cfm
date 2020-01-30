
<cfoutput>

   <cf_tl id="Do you want to remove this target ?" var="vDeleteQuestion">

	<script language="JavaScript">
	
		function hlsave(val,prg,cat,mod,per){
		
		     box = document.getElementById('main'+cat)
			 			 			 			 	 		 	
			 if (val != false){				
				 box.className = "highLight4";	
				 if (mod == 'fly') {							 
				    categorysave('1',prg,cat,per)
				 }
				 document.getElementById('textbox'+cat).className   = "regular line"
				 try { document.getElementById('targetbox'+cat).className = "regular line" } catch(e) {}
				 _cf_loadingtexthtml='';	
				 ColdFusion.navigate('#SESSION.root#/programrem/application/program/Category/getTextArea.cfm?mode='+mod+'&programcode='+prg+'&code='+cat+'&period='+per,'textboxcontent'+cat)
							 
			 }else{
			     box.className = "regular line";	
				 document.getElementById('textbox'+cat).className   = "hide"	
				 try { document.getElementById('targetbox'+cat).className = "hide" } catch(e) {}
				 if (mod == 'fly') {					 	
				 categorysave('9',prg,cat,per)
				 }
			 }
		}
		
		function categorysave(sta,prg,cat,per) {		  
		      ColdFusion.navigate('#SESSION.root#/programrem/application/program/Category/CategoryEntrySubmitItem.cfm?status='+sta+'&programcode='+prg+'&code='+cat+'&period='+per,'process','','','POST','program')		
		}
		
		function edit(id) {	  
     	  w = #CLIENT.width#  - 110;
	      h = #CLIENT.height# - 100;	 
		  ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ActivityId=" + id,"_blank","width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes")		  
		}
		
		function targetrefresh(programcode,period,targetid,cat,programaccess) {
			ptoken.navigate('#session.root#/ProgramREM/Application/Program/Target/TargetListing.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&programaccess='+programaccess, 'targetdetail_'+cat)	
		}	
		function editTarget(programcode,period,targetid,cat,programaccess) {
			 w = #CLIENT.width# - 60;
		     h = #CLIENT.height# - 120;		
		     ptoken.open('#SESSION.root#/ProgramREM/application/Program/Category/TargetEdit.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&programaccess='+programaccess, "target");
		}
		
		function removeTarget(programcode,period,targetid,cat,programaccess) {
			if (confirm('#vDeleteQuestion#')) {
			    Prosis.busy('yes');		
			    _cf_loadingtexthtml='';			
				ptoken.navigate('#SESSION.root#/ProgramREM/application/Program/Target/TargetPurge.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&programaccess='+programaccess, 'targetdetail_'+cat);
			}
		}
				  
		function areaexpand(itm){
				    			 
			 se  = document.getElementById(itm)
			 icM  = document.getElementById(itm+"Min")
		     icE  = document.getElementById(itm+"Exp")			
			 if (se.className == "regular") {
			 	 se.className   = "hide";
				 icM.className  = "hide";
				 icE.className  = "regular";	
			 } else {
				 se.className   = "regular line";
				 icM.className  = "regular";
				 icE.className  = "hide";			
			 }
		  }    
		
	</script>

</cfoutput>