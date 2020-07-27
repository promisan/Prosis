
<!--- ATTENTION --->
<!--- -------------------------------------------------------------------------------------------------------------- --->
<!--- 19/7/2009 : code must be adjusted to allow several listings in the same page to add the box value to the field --->
<!--- -------------------------------------------------------------------------------------------------------------- --->

<cfoutput>

<!--- to be tuned to only load relevant scripts --->

<cfparam name="attributes.classheader"  default="labelnormal line">
<cfparam name="attributes.classsub"     default="labelnormal line">
<cfparam name="attributes.mode"         default="extended">
<cfparam name="attributes.gadgets"      default="No">

<cfif attributes.mode eq "Extended">
	
	<cfajaximport tags="cfform,cfinput-autosuggest,cfdiv,cftree">
		
<cfelse>

	<cfajaximport tags="cfform">
		
</cfif>

<cf_calendarscript>
<cf_annotationscript>
<cf_listingScriptNavigation>

<cfif attributes.gadgets eq "Yes">
	<cf_UIGadgets>	
</cfif>

<script language="JavaScript">

function recordedit(id1) {
	ptoken.open("#SESSION.root#/System/Modules/Functions/RecordEdit.cfm?ID=" + id1 + "&ts="+new Date().getTime(), "configure");
	//	if (ret) {	history.go() }	  
}
	
function panel(panelopen,panelclose) {
	document.getElementById(panelopen).className= "regular"
	document.getElementById(panelclose).className= "hide"
}

function filtertree(treefld,treeval) {
	
	document.listfilter.onsubmit() 
	
	if( _CF_error_messages.length == 0 ) {
	
	   <!--- set selected value of the tree for usage in the filter --->
	
	   try {
		   if (treeval != 'undefined') {
		   document.getElementById("treefield").value = treefld
		   document.getElementById("treevalue").value = treeval
		   } else {
		   document.getElementById("treefield").value = ''
		   document.getElementById("treevalue").value = ''
	       }
	   } catch(e) {}
	
	   lk    = document.getElementById('mylink').value	
	   lkf   = document.getElementById('mylinkform').value  	   
	   pg    = 1 	  
	   or    = document.getElementById('listorder').value	 
	   orala = document.getElementById('listorderalias').value  	  
	   ordir = document.getElementById('listorderdir').value  	  
	   box   = document.getElementById('gridbox').value  	 	   
	   fld   = document.getElementById('selectedfields').value
	   	   	  
	   _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy10.gif'/>";	  
	   
	   if (lkf == "") {		   
	   	ptoken.navigate(lk+'page='+pg+'&listorder='+or+'&selfld='+fld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1&treefield='+treefld+'&treevalue='+treeval,box,'','','POST','listfilter')	   
	   } else {	   	   
	    ptoken.navigate(lk+'page='+pg+'&listorder='+or+'&selfld='+fld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1&treefield='+treefld+'&treevalue='+treeval,box,'','','POST',lkf)		   
	   }	  
    }    
} 

function mail(id,ser) {
	  window.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastListing.cfm?systemfunctionid="+id+"&functionserialno="+ser+"&ts="+new Date().getTime(), "broadcast", "status=no, height=715px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

function gofilter(e) {

	   keynum = e.keyCode ? e.keyCode : e.charCode;
	   if (keynum == 13) {
	   	  e.stopPropagation()
	      applyfilter('','1','content')
	   }
  }

<!--- make ajax sensitive 26/08/2010 --->

function applyfilter(md,mypage,ajaxid,callback) {	

		_cf_loadingtexthtml='';		
												
		try { document.getElementById("treerefresh").click();} catch(e) {}
		
	    try {	
				
	    if (mypage == "") {		  				   
		   pg = document.getElementById('page').value 		   
	    } else {   		 
		   pg = mypage
		}		
																						 					  	
		document.listfilter.onsubmit() 	
									
		if( _CF_error_messages.length == 0 ) {						   
		   		 						  		   		  	  
		   lk    = document.getElementById('mylink').value			  
		   lkf   = document.getElementById('mylinkform').value   		     		  		  
		   or    = document.getElementById('listorder').value		  
		   orfld = document.getElementById('listorderfield').value		   
		   ordir = document.getElementById('listorderdir').value  		       
		   orala = document.getElementById('listorderalias').value 		
		   			  		   				  		   		   
		   if (ajaxid == "content") {	
		   
    		   Prosis.busy('yes')		  		   		  
			   <!--- redirect if the action if to refresh a line itself --->
			   target   = document.getElementById('gridbox').value  
		   } else {				   
			   target   = document.getElementById('ajaxbox').value  		   
			   se = document.getElementById(ajaxid)		  		 
		   		   		  		   
			   if (se) {} else { 		   
				  // alert("View could not be updated : "+ajaxid); target="" 
				  }		   
			   }		  
			  		   		   
			   if (target != "") {		   		   	  		   		   	 					   		   
				   sfld  = document.getElementById('selectedfields').value	 				 			 		 
				   if (lkf == "") {					   
				   	  window['__printListingCallback'] = function(){ if (callback) callback(); };
				      ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&listorder='+or+'&listorderfield='+orfld+'&selfld='+sfld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1&refresh='+md,target,'__printListingCallback','','POST','listfilter')				  
				   } else {				   	      		   			 
				      ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&listorder='+or+'&listorderfield='+orfld+'&selfld='+sfld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1&refresh='+md,target,'','','POST',lkf)		  
				   }		   
			   }	
		  
	       }   

	} catch(e) {	
								
  	   if (!pg)
	   
	   pg=0

	   lk=""
	   if (document.getElementById('mylink'))							
	   		lk    = document.getElementById('mylink').value
	   
	   lkf=""
	   if (document.getElementById('mylinkform'))	
	   	   lkf   = document.getElementById('mylinkform').value

	   or=""	   	  	   
	   if (document.getElementById('listorder')) 
	   		or    = document.getElementById('listorder').value
	   		
	   orfld=""
	   if (document.getElementById('listorderfield'))
	   		orfld = document.getElementById('listorderfield').value
	   		
	   ordir=""
	   if (document.getElementById('listorderdir'))		
	   		ordir = document.getElementById('listorderdir').value
	   		
	   orala=""
	   if (document.getElementById('listorderalias')) 		  	
	   		orala = document.getElementById('listorderalias').value
	   	 
	   target = ""
	   if (ajaxid == "content") {
	   		if (document.getElementById('gridbox'))		  
		   		target   = document.getElementById('gridbox').value  
		   } else {
		    if (document.getElementById('ajaxbox'))
		   		target   = document.getElementById('ajaxbox').value  
	      } 
	   
	   sfld =""
	   if (document.getElementById('selectedfields'))
	    	sfld  = document.getElementById('selectedfields').value  			
	  	   		    
	   if (target != "") {
	   
		   	if (lkf == "") {			  	 			
		     	ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&listorder='+or+'&listorderfield='+orfld+'&selfld='+sfld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1',target)
		   	} else {			
		      ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&listorder='+or+'&listorderfield='+orfld+'&selfld='+sfld+'&listorderalias='+orala+'&listorderdir='+ordir+'&content=1',target,'','','POST',lkf)
		   	}
	   } else { Prosis.busy('no') } }
	   Prosis.busy('no')
}

function processrow(template,key,string,val) {   
	   ColdFusion.navigate('#SESSION.root#/'+template+key+'&'+string+'&value='+val,'listingaction')	;  
} 

function deleterow(row,dsn,table,field,value) {   
     
	   ptoken.navigate('#SESSION.root#/tools/listing/listing/ListingDelete.cfm?row='+row+'&dsn='+dsn+'&table='+table+'&key='+field+'&val='+value,'listingaction')

	   // applynav()
	   // hide the line as it was removed
	     
	   document.getElementById('r'+row).className = "hide"
	   try {
	    document.getElementById('l'+row).className = "hide"  
	   } catch(e) {}
}

function listnavigateRow()	{
	
	vrowno  = document.getElementById("rowno").value

	if(window.event) {
		keynum = window.event.keyCode;
	} else {
		keynum = window.event.which;
	}
						
	if (keynum == 13) {		   
	   try { document.getElementById("exp"+vrowno).click() } catch(e) {} 	  
	}
	
	<!--- delete and move down --->
	if (keynum == 46) {	   
	     <!--- remove line --->
		 try { document.getElementById("del"+vrowno).click() 
		     <!--- move down --->
			 try { 	   
			   r = vrowno-1+2	  
			   listshowRow(r);	
			   <!--- document.getElementById("r"+r).click()	--->
			   } catch(e) {	 
		        <!--- temp removed --->    		       
			   }	
			   
		   } catch(e) {} 			 
	}
	 
	<!--- key down ---> 
	if (keynum == 40) {	
	   try { 	   
	   r = vrowno-1+2		  
	   listshowRow(r);	   
	   <!--- document.getElementById("r"+r).click()	   --->
	   } catch(e) {	     
	        if (document.getElementById('next')) {
			    pg = document.getElementById('page').value				 
		        document.getElementById('page').value = pg++;				 		
		        applyfilter('',pg++,'content')		 
		    }
	   }				   
	 }	
	 
	<!--- key down page ---> 
	if (keynum == 34) {	
	         try { 		  
		     if (document.getElementById('next')) {
				 pg = document.getElementById('page').value				 
			     document.getElementById('page').value = pg++;				 		
			     applyfilter('',pg++,'content')		 
			  }	} catch(e) {}		   
	}	
	
	
	<!--- >>! last page --->
	if (keynum == 35) {		  
	     if (document.getElementById('next')) {
			 pg = document.getElementById('pages').value				 		     		 		
		     applyfilter('',pg,'content')		 
		  }	 		   
	}	
	
	<!--- !<< home page --->	
	if (keynum == 36) {		  
	     if (document.getElementById('prior')) {				 
		     document.getElementById('page').value = 1;				 		
		     applyfilter('',1,'content')		 
		  }	 		   
	}			
	
	<!--- << key up page ---> 
	if (keynum == 33) {		  
	     if (document.getElementById('prior')) {
			 pg = document.getElementById('page').value				 
		     document.getElementById('page').value = pg--;				 		
		     applyfilter('',pg--,'content')		 
		  }	 		   
	}		 
	 
	<!--- < kep up reocrd  ---> 				 
	if (keynum == 38) {	
	   try { 
	   r = vrowno-1
	   se  = document.getElementById("r"+r).click()	  	  
	   } catch(e) {
	      if (document.getElementById('prior')) {
			 pg = document.getElementById('page').value				 
		     document.getElementById('page').value = pg--;				 		
		     applyfilter('',pg--,'content')		 
		  }	 		
	   }				   
	 } 	
	
	<!--- disable scroll of the scrollbar  --->
	 document.onkeydown=function(){return event.keyCode==38 || event.keyCode==40 ? false : true;}		 	 		 		 			
	} 
	
function listshowRow(rowno) {		
       	  	     		
	   document.getElementById("rowno").value = rowno		  	   
	   rows = document.getElementById("norows").value	   
	   try { document.getElementById('nav'+rowno).click() } catch(e) {}	   
	   	  	   	  	  	  	   	  	  	   		     
	   count = 1	
	     	   	     			  						 	   
	   while (document.getElementById("r"+count)) {
	   	   
	       if (rows == "1") {
	          rf = document.getElementById("r"+count)		
			 			  
			   <!--- check if already deleted --->
			   if (rf.className != "hide") { 
				   if (count != rowno) {
				       if (rf.className != "#attributes.classheader#") { 
					       rf.className  = "#attributes.classheader#"					  						   
						   } 
					   } else {
					       rf.className  = "#attributes.classheader# highlight4"					   						   			    					 
				       }				   			    	   
			   } 
			   count++ 
			  
	     	} 	
					
		   if (rows == "2")	{
		      rf = document.getElementById("r"+count)	
		      rs = document.getElementById("s"+count)
						  
			   <!--- check if already deleted --->
			   if (rf.className != "hide") { 
				   if (count != rowno) {
				       if (rf.className != "#attributes.classsub#") { 
					       rf.className  = "#attributes.classsub#"					  
						   rs.className  = "regular" 						  
						   } 
					   } else {
					       rf.className  = "#attributes.classsub# highlight4"					   
						   rs.className  = "highlight4" 						  			    					 
				       }				   			    	   
			   } 
			   count++ 			  
		   } 
		   
		   if (rows == "3")	{
		      rf = document.getElementById("r"+count)	
		      rs = document.getElementById("s"+count)	
		      rt = document.getElementById("t"+count)	
			  
			   <!--- check if already deleted --->
			   if (rf.className != "hide") { 
				   if (count != rowno) {
				       if (rf.className != "#attributes.classsub#") { 
					       rf.className  = "#attributes.classsub#"					  
						   rs.className  = "#attributes.classsub#" 
						   rt.className  = "regular" 
						   } 
					   } else {
					       rf.className  = "#attributes.classsub# highlight4"					   
						   rs.className  = "#attributes.classsub# highlight4"
						   rt.className  = "highlight4"					    					 
				       }				   			    	   
			   } 
			   count++ 			  
		   } 
		 }		 	   
    }   	   
	
function navtarget(url,tgt) {  
   _cf_loadingtexthtml="<div style='padding-top:10px'><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";	
   ptoken.navigate(url,tgt)
}	

function listingshow(itm) {
    		
	se = document.getElementById(itm) 	
	ex = document.getElementById(itm+"_exp") 	
	co = document.getElementById(itm+"_col") 				
		
	if (se.className == "hide") {
	   se.className  = "regular"	   	  
	   ex.className  = "hide"	   	   
	   co.className  = "regular"
	} else {
	   se.className = "hide"	 	  
	   co.className  = "hide"	 
	   ex.className  = "regular"	 
	}
}

function showtemplate(path,key) {
    window.open("#SESSION.root#/System/Modification/PostFile/TemplateDetail.cfm?path="+path+"&file="+key+"&ts="+new Date().getTime(), "dialog", "unadorned:yes; edge:raised; status:no; dialogHeight:#client.height-100#px; dialogWidth:#client.width-140#px; help:no; scroll:no; center:yes; resizable:yes");	
}	

	
// function addlistingentry(template,arg) {
   
//	val = arg.split(";");		
		
//	if 	(val[2] == "true") {				
   	
//			 ret = window.showModalDialog("#SESSION.root#/"+template+"&mode=insert&ts="+new Date().getTime(),window,"unadorned:yes; edge:raised; status:no; dialogHeight:"+val[0]+"px; dialogWidth:"+val[1]+"px; help:no; scroll:no; center:"+val[3]+"; resizable:yes");									

			 // feature to refresh a tree value upon return of the focus
			 
//			 try { document.getElementById("treerefresh").click(); } catch(e) {}				 
//			 if (ret) {	applyfilter('1','','content') }		
			 
//		} else {			   
// 		  ptoken.open("#SESSION.root#/"+template+"&mode=insert","Listing","left=20, top=20, width=" + val[1] + "px, height=" + val[0] + "px, status=yes, toolbar=no, scrollbars=yes, resizable=yes")						    
//		}				
// }


function toggledrill(mode,box,template,key,arg,drillbox,str) {

	if (str != '') {
	    str = "&"+str }
	
    // we pass the menu id to make it context sensitive 
	if (document.getElementById('systemfunctionid')) {
		idmenu = document.getElementById('systemfunctionid').value
	} else { idmenu = "" }		

	if (mode == "embed") {
		   
		se = document.getElementById(box)
		try {
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)	} catch(e) {}
		
		if (se.className == "hide") {
		   se.className = "regular" 
		   try {
			   co.className = "regular"
			   ex.className = "hide" } catch(e) {}
		   if (str == '') {
			   ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key,'c'+key)
		   } else {
			   ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key+'&'+str,'c'+key)
		   }
		} else {  se.className = "hide"
		          try {
				  ex.className = "regular"
		   	      co.className = "Hide" 
				  } catch(e) {} } 	
	  }
	  
	  // added 20/1/2015 
	  
	if (mode == "nav") {
		   
		se = document.getElementById(box)
		try {
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)		
		} catch(e) {}
		
		if (se.className == "hide") {
		   se.className = "regular" 
		   try {
		   co.className = "regular"
		   ex.className = "hide"
		   } catch(e) {}
		   if (str == '') {
		   ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key,'c'+key)
		   } else {
		   ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key+'&'+str,'c'+key)
		   }
		   
		} else { se.className = "hide"
		         try {
				 	ex.className = "regular"
			   	     co.className = "hide" 
				 } catch(e) {} } 	
	  }	  
	
	
	if (mode == "drillbox") {
	   ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key+'&'+str,drillbox);		   
    }	  
		  
	if (mode == "workflow") {
		
	    se = document.getElementById(box)
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "Hide"
		    _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy10.gif'/>";	
		   ColdFusion.navigate('#SESSION.root#/tools/listing/listing/ListingDialog.cfm?ajaxid=c'+key+'&drillid='+key,'c'+key)
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "Hide"  } 	
	  } 
	  
	// standard CF ajax window  
	
	if (mode == "dialogajax") {		
		    	
		val = arg.split(";");		
						
		if (val[0] == 0) {		
		  val[0] = document.body.clientHeight-60		 
		}  					
		if (val[1] == 0) {		
		  val[1] = document.body.clientWidth-100		 
		}  			
		if (drillbox != "drilldetail") {		    
		    drillboxopen()  <!--- launches the drillbox function --->
		} else {		
		    parent.ProsisUI.createWindow('adddetail','Detail','',{x:50,y:50,height:700,width:val[1],modal:val[2],center:val[3]})  <!--- creates the drillbox --->  	
		}							
		parent.ColdFusion.navigate('#SESSION.root#/'+template+'?drillid='+key+str,'adddetail') 					
	  }
	  
	// Prosis ajax window, to be discontinued  
	  
	if (mode == "dialogprosis") {			    
			
		val = arg.split(";");		
						
		if (val[0] == 0) {		
		  val[0] = document.body.clientHeight-60 }  	
				
		if (val[1] == 0) {		
		  val[1] = document.body.clientWidth-100 }  	
		
		if (drillbox != "drilldetail") {			       
		    drillboxopen()  <!--- launches the drillbox function --->
		} else {				   		   
			ProsisUI.createWindow('adddetail','Detail','#SESSION.root#/'+template+'?drillid='+key+str,{width:val[1],height:val[0],resizable:false,modal:val[2],center:val[3]});		
		}			
						
	  }  
	  
	if (mode == "default") {
		alert('Pending deployment')
		}  
	  	  	
	if (mode == "dialog") {	  		
		alert('Modal IE Dialog mode no longer support. Check your administrator')
		// discontinued	
		}
	
	if (mode == "securewindow") {
		val = arg.split(";");	
		idKey = key.replace(/-/g,'');							
		ptoken.open('#SESSION.root#/'+template+key+str+'&idmenu='+idmenu, 'listingdialog_'+idKey,'left=20, top=20, width=' + val[1] + 'px, height= ' + val[0] + 'px, status=yes, toolbar=no, scrollbars=yes, resizable=yes')				
		}	
		
	if (mode == "window") {
		val = arg.split(";");		
		ptoken.open('#SESSION.root#/'+template+key+str+'&idmenu='+idmenu, 'listingdialog_'+drillbox,'left=20, top=20, width=' + val[1] + 'px, height= ' + val[0] + 'px, status=yes, toolbar=no, scrollbars=yes, resizable=yes')				
		}	
		
	if (mode == "windowfull") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;	
		ptoken.open('#SESSION.root#/'+template+key+str+'&idmenu='+idmenu+'&ts='+new Date().getTime(), 'dialog', 'left=20, top=20, width=' + w + ', height= ' + h + ', status=yes, toolbar=no, fullscreen=yes, scrollbars=yes, resizable=yes')				
		}	
		
	if (mode == "tab") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;			
		ptoken.open('#SESSION.root#/'+template+key+str+'&idmenu='+idmenu+'&ts='+new Date().getTime(),'dialog'+key)				
		}	
		
	if (mode == "top") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;			
		ptoken.open('#SESSION.root#/'+template+key+str+'&idmenu='+idmenu+'&ts='+new Date().getTime(),'_top')				
		}		
					
	}	

	function facttablexls2(controlid,format,filter,qry,dsn) {	
	   
	    w = #CLIENT.width# - 80;
		h = #CLIENT.height# - 120;						
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?dsn="+dsn+"&fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format+"&ts="+new Date().getTime(), "WExcelExport");		
	//	ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?dsn="+dsn+"&fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format+"&ts="+new Date().getTime(), "WExcelExport", "left=20, top=20,status=yes, height="+h+" px, width="+w+" px, scrollbars=no, center=yes, resizable=yes");		
	
	}
	
	function printListing(maxrows, pTarget) {
		ColdFusion.navigate('#session.root#/tools/listing/listing/defineRowsToShow.cfm?maxRows='+maxrows, pTarget, function(){
			applyfilter('1','','content', function(){
				Prosis.webPrint.print('##printTitle','.clsListingContent', true, function(){ 
					$('##_divContentFields').attr('style','width:100%;'); $('##_divContentFields').parent('div').attr('style','width:100%;');
				});
				ColdFusion.navigate('#session.root#/tools/listing/listing/resetRowsToShow.cfm?maxRows='+maxrows, pTarget, function(){
					applyfilter('1','','content');
				});
			});
		});
	}
	
</script>

</cfoutput>