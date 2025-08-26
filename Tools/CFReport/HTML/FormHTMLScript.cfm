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
	
<cf_dialogMail>
<cf_calendarscript>

<cfset head = "regular">
<cfset btn  = "button10g">

<script>
	
	function resetme(ctr,rpt) {
	    toggle("reportcriteria",'menu1')
		document.getElementById('menu2').className = "hide"
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')
	    ptoken.navigate('HTML/FormHTMLMenu.cfm?controlid='+ctr+'&reportid='+rpt,'reportmenu')
   		ptoken.navigate('HTML/FormHTMLVariant.cfm?controlid='+ctr+'&reportid='+rpt,'criteria')
	}
	
	function toggle(box,menu) {
	
	   document.getElementById("reportcriteria").className = "hide"
	   document.getElementById("reportother").className    = "hide"
	   document.getElementById("reportbox").className      = "hide"
	   	   
	   cnt = 1
	   while (cnt != 7) {
	       try {
		   document.getElementById('menu'+cnt).className = "regular"
	       } catch(e) {}	
		   cnt++	   
	   }
	   document.getElementById(box).className = "regular"
	   document.getElementById(menu).className = "highlight"	   

	}
	
	function updatedate(st,to) {
	 se = document.getElementById(st).value
	 document.getElementById(to).value = se
	}
	
	function resetmenu(ctr,rpt,cls) {
	    ptoken.navigate('HTML/FormHTMLMenu.cfm?controlid='+ctr+'&reportid='+rpt,'reportmenu')   		
	}

   function reload(id,portal)	{
	 	ptoken.location('SubmenuReportView.cfm?Context=report&id=' + id + '&portal=' + portal)
	}
	
   function newwindow() {
      ptoken.open(report.location,'_blank',"status=yes, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes")		
   }	  
	
   function printmenu() { 
						
		se  = document.getElementById("preview");		
		if (se)	{se.className = "btn"}
						
		se  = document.getElementById("buttons");
		if (se)	{se.className = "regular"}			
			
		se  = document.getElementById("stop");
		if (se)	{se.className = "hide"}
			
		se  = document.getElementById("stopping");
		if (se)	{se.className = "hide"}
													
		}
	
   function init()	{
									
		document.getElementById("buttons").className  = "hide"
					
		se = document.getElementById("stopping").className 
		if (se) { se.className = "hide"; }
		document.getElementById("stop").className     = "regular";
		
		ptoken.navigate('#SESSION.root#/Tools/Control/Abort.cfm?id=resume&id1=#controlid#&ts='+new Date().getTime(),'stopping')									
		}

   function abort() {
   			
		document.getElementById("buttons").className  = "regular"
		
		se  = document.getElementById("stop");
		if (se)	{se.className = "hide"}
	
		se  = document.getElementById("stopping");
		if (se)	{se.className = "regular"}
	
		se  = report.document.getElementById("requestabort");
		if (se)	{se.className = "regular";}	
	   			
		ptoken.navigate('#SESSION.root#/Tools/Control/Abort.cfm?id=abort&id1=#controlid#','stopping')		
		
		// added by Hanno		
		printmenu()					
					
	}
	
	function getclass(id,sel,ctr,rpt) {	  
	    _cf_loadingtexthtml='';	 
		ptoken.navigate('HTML/FormHTMLLayoutFormat.cfm?ts='+new Date().getTime()+'&layoutid='+id+'&sel='+sel,'fmode');	
		ptoken.navigate('HTML/FormHTMLMenu.cfm?layoutid='+id+'&controlid='+ctr+'&reportid='+rpt,'reportmenu')   
		
	}	
	 				
	function mail(to,subj,att,filter,src,srcid) {
		ptoken.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj + "&source=" + src + "&sourceid=" + srcid, "MailDialog", "width=800, height=615, status=yes, toolbar=no, scrollbars=no, resizable=no");
	}
	
	var doit = 0

		
	function validation() {
		if( _CF_error_messages.length == 0 ) {
		   doit = 1
		 } else {
		   doit = 0
		 }  
		 return false  
	}
	
	function perform(option,rep) {	
	
	      if (option == "preview" || option == "email" || option == "sql")	{ 
		  		    
		  	<!--- save client variable for progress management --->
		  	ptoken.navigate('#SESSION.root#/Tools/CFReport/HTML/FormHTMLSelect.cfm?id='+option,'gobox')	
			<!--- -------------------------------------------- --->
			
			document.forms['selection'].onsubmit();
								
			<!--- this will trigger the validation of the form and the result [doit] will be used to continue or not --->	
		  								  	
			if (doit == 1) {		
			    				
			    // not needed again ColdFusion.navigate('#SESSION.root#/Tools/CFreport/HTML/FormHTMLSelect.cfm?id='+option,'report')		 
				
				init()	
				document.getElementById("reportshow").className = "regular"
							
			    <!--- ----------------------------------- --->
				<!--- ----hide the process button-------- --->
				<!--- ----------------------------------- --->
				 
				se  = document.getElementById("preview");		
																				
				if (se)	{ se.className = "hide" }	
						          				
				<!--- start the progress bar --->			
				ColdFusion.ProgressBar.stop('pBar', true)					
				ColdFusion.ProgressBar.start('pBar')				
				ColdFusion.ProgressBar.show('pBar')
				
				document.getElementById('myprogressbox').className = "regular"
				document.getElementById('myreportcontent').className = "hide"

				<!--- ----------------------------------- --->
	            <!--- process the criteria selection form --->
				<!--- ----------------------------------- --->
								
				<!---- dev changed this line on 25 Feb 2012, as a way of improving the cfprogressbar document.selection.submit() ---->
				var rpt = document.getElementById ('report');
								
				if (rpt)
					rpt.src = "about:blank";															
				ptoken.navigate('#SESSION.root#/tools/CFreport/ReportSQL8.cfm?formselect='+option+'&mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML','report','',validation,'POST','selection');
										
				<!--- show the report content box --->
				toggle('reportbox','menu2')												
														
				}  
				  		 	 		  
		  } else {
		  		
		    if (option == "sql") {				
				ptoken.navigate('#SESSION.root#/Tools/CFreport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML&formselect='+option,'reportselection','','','POST','selection')									
			} else {
			
				if (option == "insert") {				  
					ptoken.navigate('#SESSION.root#/Tools/CFReport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML&formselect='+option,'subscriptions','','','POST','selection')											
				} else {
				  
					if (rep == "undefined")	{		
	   				ptoken.navigate('#SESSION.root#/Tools/CFReport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML&formselect='+option,'subscriptions','','','POST','selection')						
					} else {					
					ptoken.navigate('#SESSION.root#/Tools/CFReport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId='+rep+'&GUI=HTML&formselect='+option,'subscriptions','','','POST','selection')															
					}
				}
			}
		  }
 	}
			
	
	function verifyaction(text,sel,rep) {		
			document.forms['selection'].onsubmit()
			if (doit == 1) {	
			if (confirm("Do you want to "+text+" this report variant ?")) {		
			    perform(sel,rep)						
			}						
		}	
	}			
			 
    function check(fld) {
	  
	    se = document.getElementById("dow")
		se1 = document.getElementById("condition")
		se2 = document.getElementById("mail")
		se3 = document.getElementById("dom")
		
	    if (fld == "Weekly") {
		  se.className = "regular"
		  se3.className = "hide"
		  
	    } else {
		 
			 if  (fld == "Monthly") {
			   se3.className = "regular"
			   se.className = "hide"
			 } else {
			  se.className = "hide"
			  se3.className = "hide"
			 }	 
		}
		 
		if (fld != "Manual") {
		  se1.className = "regular"
		  se2.className = "regular" 
	    } else {
		  se1.className = "hide"
		  se2.className = "hide" 
		}
  
    }
  	
	// single combo
							
	function combo(fld,val,shw,parent)	{
			
			old    = document.getElementById(fld).value
			olddes = document.getElementById(fld+"_des").value
			
			try { ProsisUI.closeWindow('combo',true)} catch(e){};
			ProsisUI.createWindow('combo', 'Selection', '',{x:100,y:100,width:700,height:document.body.offsetHeight-100,resizable:false,modal:true,center:true});			  	  
			_cf_loadingtexthtml='';		
		    ptoken.navigate('HTML/FormHTMLComboSingle.cfm?shw='+shw+'&controlid=#url.id#&par='+fld+'&cur='+old+'&fly='+parent,'combo');	        																
	}
			
	function combosearch(pg,par,cur,fly,shw) {		 
		
		 val = document.getElementById("combovalue")		 
		 adv = document.getElementById("combovariant")
				 
		 if (adv.checked)
			{v = 1}
		 else
			{v = 0}
		
		 _cf_loadingtexthtml='';			
		 ptoken.navigate('HTML/FormHTMLComboSingleResult.cfm?controlid=#url.id#&par='+par+'&shw='+shw+
			   '&cur='+cur+'&val='+val.value+'&adv='+v+'&page='+pg+'&fly='+fly,'comboresult')	   			  						 
		 
	  }  			
			
	function comboselect(fld,shw,key,des) {	
				
		document.getElementById(fld).value = key;
		
		if (shw == "0")	{
		document.getElementById(fld+"_des").value = des;
		} else {
		document.getElementById(fld+"_des").value = key+" - "+des;
		}
		if (document.getElementById(fld).value == "blank")
			    { document.getElementById(fld).value = "" 
				  document.getElementById(fld+"_des").value = ""	
				  				  
				}  else {
				try { ProsisUI.closeWindow('combo',true)} catch(e){};	
				}				
		}		
		
	// multiple combo	
			
	function combomulti(fld,val,fly) {
		  
		try { ProsisUI.closeWindow('combomulti',true)} catch(e){};			
		ProsisUI.createWindow('combomulti', 'Selection', '',{x:100,y:100,width:700,height:document.body.offsetHeight-200,resizable:false,modal:true,center:true});			  	  
		ptoken.navigate('HTML/FormHTMLComboMulti.cfm?controlid=#controlid#&CriteriaName='+fld+'&CriteriaDefault='+val+'&fly='+fly,'combomulti');	   
								
	}	
				
	function multivalue(act,val,fld,fly,pag) {	    	        	    
		ptoken.navigate('HTML/FormHTMLComboMultiAction.cfm?action='+act+'&value='+val+'&fld='+fld+'&fly='+fly+'&page='+pag,'selectedvalues','','','POST','multiform')		
	}
	
	function multisearch(fld,fly,pg) {					
				
		val = document.getElementById("multifind")		
		adv = document.getElementById("multivariant")			
				
		/*			
		if (adv.checked) {
		    v = 1
		} else {
			v = 0
		}	*/
		
		//set advanced by default
		v = 1;
		
		_cf_loadingtexthtml='';		
		ptoken.navigate('HTML/FormHTMLComboMultiResult.cfm?controlid=#controlId#&par='+fld+'&val='+val.value+'&adv='+v+'&page='+pg+'&fly='+fly ,'multiresult','','','POST','multiform')			 					 				
	}		

	function multiselected(fld,fly,pag) {			
																						 
			ptoken.navigate('HTML/FormHTMLComboMultiSelected.cfm?fly='+fly+'&controlid=#controlId#&criteriaName='+fld+
				             '&mode=edit&page='+pag,'multiselectbox','','','POST','multiform')							 				 					 			 
			 
			}				
				
	function multiapply(fld,fly) {
	      						
			url = "#SESSION.root#/Tools/CFReport/HTML/FormHTMLComboMultiSelected.cfm?controlid=#controlId#&criteriaName="
			            +fld+"&mode=view&fly="+fly;
			ptoken.navigate(url,'combo'+fld,'','','POST','multiform')										
		}		
		
	// more 	
		
    function showlayout(nme) {
     	 ptoken.navigate('HTML/FormHTMLLayout.cfm?layoutfilter='+nme+'&reportid=#reportid#&controlid=#controlid#','mylayout')
	}		
								
	function selcluster(grp,par,cnt,nme,rfrsh) {
		var count=1;				 		   
		while (count < 10) {
			if ($('##'+grp+count+'_box').length > 0) {
				$('##'+grp+count+'_box').removeClass('regularxl').addClass('hide');
			}
			count++;		 
		} 
		$('##'+grp+par+'_box').removeClass('hide').addClass('regularxl');
		if (rfrsh == '1') { showlayout(nme); }
	}
	
	 
	function filtermult(id,rpt,param,width,row) {
	  
    	w = width - 0 + 250;
		if (w > #client.width#) {w = #client.width#-80}
		if (w < 800) {w = 800}
		h = 740;
		
		ProsisUI.createWindow('myextension', 'Select', '',{x:100,y:100,height:h,width:w,modal:true,center:true})    						
		ptoken.navigate('#session.root#/Tools/CFReport/HTML/FormHTMLExtView.cfm?x=2&row='+row+'&controlid=' + id + '&reportid=' + rpt + '&CriteriaName=' + param + '&width=' + width,'myextension') 		
						
	}
	
	function filterdelete(id,rpt,param,width,row,pk) {	
	    _cf_loadingtexthtml="";		  
	    ptoken.navigate('HTML/FormHTMLExtListPurge.cfm?pk='+pk+'&mult=1&Init=0&row='+row+'&ControlID=' +id + '&ReportId=' + rpt + '&CriteriaName=' + param,'i'+row)					
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
	}

	ie = document.all?1:0
	ns4 = document.layers?1:0
	 
	function hl(itm,fld){
 
     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	
					 	
	 if (fld != false){
		 itm.className = "highLight2";
	 }else{
		 itm.className = "regular";		
	 }
	 
	 }
  
	function selall(itm,fld) {

     sel = document.getElementsByName('select')
	 
	 count = 0
	 
	 while (sel[count]) {
	 	 	 	 		 	
		 if (fld != false){
			
		 sel[count].checked = true
		 itm = sel[count]
		 
		 if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }	 
		 itm.className = "highLight2";	 	 
		 }else{	 
		 sel[count].checked = false	 
		 itm = sel[count]
		 
		 if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
		 itm.className = "regular";
		 
		 }
		 count++
	 }
	
  }
       
function reportme(id) {
    w = #CLIENT.width# - 16;
    h = #CLIENT.height# - 127;
	ptoken.open("#SESSION.root#/Tools/CFReport/ReportLinkOpen.cfm?reportid=" + id, "_blank", "left=0, top=0, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function purge(del,ctr,rpt) {  
	if (confirm("Do you want to remove selected report(s) from your archive ?"))	{
		ptoken.navigate('HTML/FormHTMLSubscription.cfm?del='+del+'&controlid='+ctr+'&reportid='+rpt,'subscriptions')
	}
}

function more(id,act,row) {

	icM  = document.getElementById(row+"Min")
    icE  = document.getElementById(row+"Exp")
	se   = document.getElementById(row);
		
	if (se.className=="hide") {
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 ptoken.navigate('#SESSION.root#/System/Modules/Subscription/Criteria.cfm?id='+id,'s'+row)				 
		 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide"
	 }
	 		
  }

</script>	

		
</cfoutput>	
