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

<!--- ATTENTION --->
<!--- -------------------------------------------------------------------------------------------------------------- --->
<!--- 19/7/2009 : code must be adjusted to allow several listings in the same page to add the box value to the field --->
<!--- -------------------------------------------------------------------------------------------------------------- --->

<cfoutput>

<!--- to be tuned to only load relevant scripts --->

<cfparam name="attributes.classheader"  default="labelnormal">
<cfparam name="attributes.classsub"     default="labelnormal line">
<cfparam name="attributes.mode"         default="extended">
<cfparam name="attributes.gadgets"      default="No">
<cfparam name="url.mission"             default="">

<cfif attributes.mode eq "Extended">

	<cfajaximport tags="cfform,cfdiv">
	
	<!---	
	<cfajaximport tags="cfform,cfinput-autosuggest,cfdiv">
	--->
		
<cfelse>

	<cfajaximport tags="cfform">
		
</cfif>

<cf_calendarscript>
<cf_annotationscript>

<cfif attributes.gadgets eq "Yes">
	<cf_UIGadgets>	
</cfif>

<script language="JavaScript">

function isAt(position) {

	var vDiv             = $("##_divContentFields");
	var vTable           = $("##_divSubContent");
	var vNavigationTable = vTable.find( ".navigation_table" );
	var id_table  = vNavigationTable.attr('id');
	console.log('id',id_table);
	var currentSelected = vNavigationTable.find(".focused");

	if (currentSelected && position=='bottom') {
		var currentIndex = currentSelected.index();
		console.log('currentIndex',currentIndex);
		var vRows = $("##"+id_table+" > tbody > tr.navigation_row:visible" );
		var nextRow = vRows.eq(currentIndex+5);

		var currentTD = currentSelected.find('td:first');
		console.log('currentTD',currentTD.html())

		currentSelected.removeClass('focused');
		currentSelected.css("backgroundColor",'transparent');
		currentSelected.css("background-color",'transparent');

		var navigationselected = "##A8EFF2";
		nextRow.addClass('focused');
		nextRow.css({background:navigationselected});
		nextRow.css("background",navigationselected);

		var nextTD = nextRow.find('td:first');
		console.log('nextTD',nextTD.html());
		
	}

	var limit = vNavigationTable.height()-5;
	console.log('limit', limit);
	
	
	if (position == 'bottom') {
		var currentPosition = vDiv.scrollTop() + vDiv.height();
		console.log('current', currentPosition);
		return currentPosition > limit;
	}

	if (position=='top') {
		var currentPosition = vDiv.scrollTop();
		console.log('current', currentPosition);
		return currentPosition == 0;
	}

	return false;
}

var counter_down = 0;

function doScroll() {

	$("##_divContentFields").on('scroll',function(){
		
		pga = document.getElementById('pages').value
		nav = document.getElementById('navigation').value

		if (isAt('bottom'))	{
			// going to next page
			counter_down = counter_down + 1;
			if (counter_down == 2) {
				counter_down = 0;
				pg = document.getElementById('page').value
				if (nav == 'auto') {
					if (pg == pga) {  //nada
					} else {
						applyfilter('1', '', 'append');
					}
				} else {
					if (pg == pga || nav == 'manual') {
						// nada
					} else {
						document.getElementById('page').value = pg++;
						applyfilter('', pg++, 'content') //the last page down will trigger a next page, then we highlight the first row.
					}
				}
			}
    	} else if (isAt('top'))	{
			//going to previous page
			pg = document.getElementById('page').value
			if (pg == 1 || nav != 'paging') { 
			    // nada
			} else {
				pg--;
				document.getElementById('page').value = pg;
				applyfilter('', pg, 'content') //get into the last row.
			}
		}
	});
}

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
	  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastListing.cfm?systemfunctionid="+id+"&functionserialno="+ser, "broadcast", "status=no, height=715px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

function attachopen(id) {
	  ptoken.open("#SESSION.root#/Tools/Document/FileRead.cfm?scope=actual&id="+id,"_blank");		
}

<!--- function to apply the selected value on the fly if enabled --->

function gofilter(mde,e) {
      
	   switch (mde) {
	    case 'text': keynum = e.keyCode ? e.keyCode : e.charCode; if (keynum == 13) { e.stopPropagation(); applyfilter('','1','content') };break; 
	    case 'list': applyfilter('','1','content');break; 
		case 'clck': applyfilter('','1','content');break; 	   
    }
}	
  
function resetfilter(id,ser,box) {
    Prosis.busyRegion('yes','_divSubContent');  
    ptoken.navigate('#SESSION.root#/tools/listing/listing/initListing.cfm?mission=#url.mission#&box='+box+'&systemfunctionid='+id+'&functionserialno='+ser,'locate'+box)	
	
} 

<!--- this option is used to refresh the content based on the selection or to refresh a value or to add records to the grid --->

function filtergroup(box,opt) {
	if (opt.value == 'none') {
		document.getElementById(box+'_groupselection').className = "hide"
	} else {
	    document.getElementById(box+'_groupselection').className = "regular"
	}
}

<!--- important change is to apply the box to the context allowing you to have several listings in a page : no urgent --->

function applyfilter(md,mypage,ajaxid,callback,groupvalue1,grouptarget,col1,col1value) {	

		treefld = document.getElementById("treefield").value
		treeval = document.getElementById("treevalue").value		  
	   
       	_cf_loadingtexthtml='';																				
		try { document.getElementById("treerefresh").click();} catch(e) {}	
						
	    try {	
					
		    if (mypage == '') {				    
			    pg = document.getElementById('page').value 					    
		    } else { 			    	 
			     pg = mypage
			}		
																																																					 					  	
			document.listfilter.onsubmit() 
																					
			if( _CF_error_messages.length == 0 ) {		
									   		 						  		   		  	  
			   lk    = document.getElementById('mylink').value			  
			   lkf   = document.getElementById('mylinkform').value  			   		     		  		  
			 			   			  		   				  		   		   
			   if (ajaxid == "content") {	
			   		   
	    		   Prosis.busyRegion('yes','_divSubContent');  		   		  
				   <!--- redirect if the action if to refresh a line itself --->
				   target   = document.getElementById('gridbox').value  
				   
			   } else {		
			   	      	   
				   target   = document.getElementById('ajaxbox').value  							    
				   se = document.getElementById(ajaxid)		  		 				  		   		   		  		   
				   if (se) {} else { 		   
					  // alert("View could not be updated : "+ajaxid); target="" 
					  }		   
				}
				
				// alert(target)
																																												  			  		   		   
				if (target != "") {							   		   	 					   		   
				
				   sfld  = document.getElementById('selectedfields').value	 					    			 		 
				   if (lkf == "") {					   
				   	  window['__printListingCallback'] = function(){ if (callback) callback(); };								 						  	  											  
				       ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&treefield='+treefld+'&treevalue='+treeval+'&groupvalue1='+groupvalue1+'&grouptarget='+grouptarget+'&col1='+col1+'&col1value='+col1value+'&selfld='+sfld+'&content=1&contentmode='+md,target,'__printListingCallback','','POST','listfilter')				  
				   } else {						   				         	      		   			 						  
				       ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&treefield='+treefld+'&treevalue='+treeval+'&groupvalue1='+groupvalue1+'&grouptarget='+grouptarget+'&col1='+col1+'&col1value='+col1value+'&selfld='+sfld+'&content=1&contentmode='+md,target,'','','POST',lkf)		  						  
				   }		   
				}	
							  
		     }   

		} catch(e) {	
					
		   // alert(e)		
		  	  												
	  	   if (!pg)
		   
		   pg=0
		   lk=""
		   
		   if (document.getElementById('mylink'))							
		   		lk    = document.getElementById('mylink').value		   
		        lkf   = ""
				
		   if (document.getElementById('mylinkform'))	
		   	    lkf   = document.getElementById('mylinkform').value	
				   
		   target = ""
		  		   
		   if (ajaxid == "content") {
		   		if (document.getElementById('gridbox'))		  
			   		target   = document.getElementById('gridbox').value  
		   } else {
			    if (document.getElementById('ajaxbox'))
			   		target   = document.getElementById('ajaxbox').value  
		   }	
		   		   
		   //  alert('target:'+target)	 
		   
		   sfld =""		  		   
		   if (document.getElementById('selectedfields'))
		    	sfld  = document.getElementById('selectedfields').value  			
		  	   		    
		   if (target != "") {
		   		   		        		   
			   	if (lkf == "") {			  	 			
			      ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&treefield='+treefld+'&treevalue='+treeval+'&groupvalue1='+groupvalue1+'&grouptarget1='+grouptarget+'&col1='+col1+'&col1value='+col1value+'&selfld='+sfld+'&content=1&contentmode='+md,target,'','','POST','listfilter')
			   	} else {			
			      ptoken.navigate(lk+'page='+pg+'&ajaxid='+ajaxid+'&treefield='+treefld+'&treevalue='+treeval+'&groupvalue1='+groupvalue1+'&grouptarget1='+grouptarget+'&col1='+col1+'&col1value='+col1value+'&selfld='+sfld+'&content=1&contentmode='+md,target,'','','POST',lkf)
			   	}
		   } else { Prosis.busyRegion('no','_divSubContent');
	 } }
}
	
function processrow(template,key,string,val) {   
	   ptoken.navigate('#SESSION.root#/'+template+key+'&'+string+'&value='+val,'listingaction')	;  
} 

// adding ajax lines to the listing rows

function listgroupshow(key,target,col1,col1value) {

	se1 = $('##'+target+'_exp');
	se2 = $('##'+target+'_col');
			
	if (se2.hasClass('regular')) {
	 	
		se1.removeClass('hide').addClass('regular');
		se2.removeClass('regular').addClass('hide');		
		$('.'+target+'_data').each(function(index) { $(this).remove()})	 
		 
	} else  {	
			
		se1.removeClass('regular').addClass('hide');		
		se2.removeClass('hide').addClass('regular');		
		applyfilter('0','','append','',key,target,col1,col1value) 			
		 
	}	 
 
}

function deleterow(box,dsn,table,field,keyvalue) {        

   if (confirm("Do you want to remove this record ?")) {		

   	   // remove record in the associated tables 	   	
	   ptoken.navigate('#SESSION.root#/tools/listing/listing/ListingDelete.cfm?box='+box+'&dsn='+dsn+'&table='+table+'&key='+field+'&val='+keyvalue,box+'_ajax')	
	   
	   // remove records in the interface	   
	   $('tr[name*='+box+'_'+keyvalue+']') .each(function() { this.remove(); });    	  	   	    
	   
	   try { 
	   } catch(e) {}
	   }	  
}

function listnavigateRow(box)	{
			
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
	 
	<!--- record down (40) is handled by class table navigate ---> 
		 
	<!--- page down page ---> 
	if (keynum == 34) {	
	
         try { 				   
		     if (document.getElementById('next')) {	
			 
			 	 pga = document.getElementById('pages').value
				 nav = document.getElementById('navigation').value
				 
				 if (isAt('bottom') && nav != 'manual')	{				 
					// going to next page
					pg = document.getElementById('page').value					
					if (nav == 'auto') {					
						applyfilter('1','','append');					
					} else {									
						if (pg == pga) {} else {			
							document.getElementById('page').value = pg++;			
							applyfilter('',pg++,'content') }						
					       }		 			 
					}	   
			  }	
		 } catch(e) {}		   
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
	
	<!--- << page up page ---> 
	if (keynum == 33) {	
	
		 nav = document.getElementById('navigation').value	  
	     if (document.getElementById('prior')) {

	     	if (isAt('top') && nav!='manual') {
				 pg = document.getElementById('page').value
				 document.getElementById('page').value = pg--;
				 applyfilter('', pg--, 'content')
			 }

		  }	 		   
	}	
	
	<!--- record up (38) is handled by class table navigate --->	 
		
	<!--- disable scroll of the scrollbar  --->
	document.onkeydown=function(){return event.keyCode==38 || event.keyCode==40 ? false : true;}		 	 		 		 			
	 
	} 
	   
	
 function navtarget(url,tgt) {  
   _cf_loadingtexthtml="<div style='padding-top:10px'><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";	
   ptoken.navigate(url,tgt)
 }	

function listingshow(itm) {

    se0 = $('##'+itm)
	se1 = $('##'+itm+'_exp');
	se2 = $('##'+itm+'_col');
    	
	if (se2.hasClass('regular')) {	 	
		se0.removeClass('regular').addClass('hide');
		se1.removeClass('hide').addClass('regular');
		se2.removeClass('regular').addClass('hide');				 
	} else  {			
		se0.removeClass('hide').addClass('regular');	
		se1.removeClass('regular').addClass('hide');		
		se2.removeClass('hide').addClass('regular');						 
	}				
}

function showtemplate(path,key) {
    ptoken.open("#SESSION.root#/System/Modification/PostFile/TemplateDetail.cfm?path="+path+"&file="+key,"doc"+key);	
}	

function toggledrill(mode,box,key,arg,drillbox,str) {
    
	if (str != '') {
	    str = "&"+str }
	
    // we pass the menu id to make it context sensitive 
	if (document.getElementById('systemfunctionid')) {
		idmenu = document.getElementById('systemfunctionid').value
	} else { idmenu = "" }		

	if (mode == "embed") {
				   
		    se = $('##'+box);			
			
			try { ex = $('##exp'+key)
				  co = $('##col'+key) } catch(e) {}
							
			if   (se.hasClass('hide')) { 
							  
			       se.removeClass('hide').addClass('regular') 
				   try {
				      co.removeClass('hide').addClass('regular')
					  ex.removeClass('regular').addClass('hide') 
				   } catch(e) {}
				   
					   
			   if (str == '') {
				   ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key,'c'+key)
			   } else {
				   ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key+'&'+str,'c'+key)
			   }
			   
			} else { 			         
			          se.removeClass('regular').addClass('hide')
			          try {
					    ex.removeClass('hide').addClass('regular')
			   	        co.removeClass('regular').addClass('hide') 
					  } catch(e) {} 
				   } 	
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
		   ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key,'c'+key)
		   } else {
		   ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key+'&'+str,'c'+key)
		   }
		   
		} else { 
		   se.className = "hide"
		   try {
				ex.className = "regular"
			    co.className = "hide" 
		   } catch(e) {} } 	
	  }	  	
	
	if (mode == "drillbox") {
	   ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key+'&'+str,drillbox);		   
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
		   ptoken.navigate('#SESSION.root#/tools/listing/listing/ListingDetailWorkflow.cfm?ajaxid=c'+key+'&drillid='+key,'c'+key)
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
		parent.ptoken.navigate('#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key+str,'adddetail') 					
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
			ProsisUI.createWindow('adddetail','Detail','#SESSION.root#/'+document.getElementById('drilltemplate').value+'?drillid='+key+str,{width:val[1],height:val[0],resizable:false,modal:val[2],center:val[3]});		
		}			
						
	  }  
	  
	if (mode == "default") {
		alert('Pending deployment')
		}  
	  	  	
	if (mode == "dialog") {	  		
		alert('Modal IE Dialog mode no longer supported. Check your administrator')
		// discontinued	
		}
	
	if (mode == "securewindow") {
		val = arg.split(";");	
		idKey = key.replace(/-/g,'');							
		ptoken.open('#SESSION.root#/'+document.getElementById('drilltemplate').value+key+str+'&idmenu='+idmenu, 'listingdialog_'+idKey,'left=20, top=20, width=' + val[1] + 'px, height= ' + val[0] + 'px, status=yes, toolbar=no, scrollbars=yes, resizable=yes')				
		}	
		
	if (mode == "window") {
		val = arg.split(";");		
		ptoken.open('#SESSION.root#/'+document.getElementById('drilltemplate').value+key+str+'&idmenu='+idmenu, 'listingdialog_'+drillbox,'left=20, top=20, width=' + val[1] + 'px, height= ' + val[0] + 'px, status=yes, toolbar=no, scrollbars=yes, resizable=yes')				
		}	
		
		// +'&ts='+new Date().getTime()
		
	if (mode == "windowfull") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;	
		ptoken.open('#SESSION.root#/'+document.getElementById('drilltemplate').value+key+str+'&idmenu='+idmenu, 'dialog'+key, 'left=20, top=20, width=' + w + ', height= ' + h + ', status=yes, toolbar=no, fullscreen=yes, scrollbars=yes, resizable=yes')				
		}	
		
	if (mode == "tab") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;			
		ptoken.open('#SESSION.root#/'+document.getElementById('drilltemplate').value+key+str+'&idmenu='+idmenu,'dialog'+key)				
		}	
		
	if (mode == "top") {
		val = arg.split(";");		
		w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;			
		ptoken.open('#SESSION.root#/'+document.getElementById('drilltemplate').value+key+str+'&idmenu='+idmenu,'_top')				
		}						
	}	

	function facttablexls2(controlid,format,filter,qry,dsn) {		   
	    w = #CLIENT.width# - 80;
		h = #CLIENT.height# - 120;						
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?dsn="+dsn+"&fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format+"&ts="+new Date().getTime(), "WExcelExport");		
	//	ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?dsn="+dsn+"&fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format+"&ts="+new Date().getTime(), "WExcelExport", "left=20, top=20,status=yes, height="+h+" px, width="+w+" px, scrollbars=no, center=yes, resizable=yes");			
	}
	
	function printListing(maxrows, pTarget) {
		window['__mainPrintListingCallbackRollback'] = function() {
			applyfilter('1','','content');
		};

		window['__mainPrintListingCallback'] = function(){ 
			applyfilter('1','','content', function(){
				Prosis.webPrint.print('##printTitle','.clsListingContent', true, function(){ 
					$('##_divContentFields').attr('style','width:100%;'); $('##_divContentFields').parent('div').attr('style','width:100%;');
				});
				ptoken.navigate('#session.root#/tools/listing/listing/defineRowsToShow.cfm?action=reset&maxRows='+maxrows, pTarget, '__mainPrintListingCallbackRollback');
			});
		};
		
		ptoken.navigate('#session.root#/tools/listing/listing/defineRowsToShow.cfm?action=all&maxRows='+maxrows, pTarget, '__mainPrintListingCallback');
	}
	
</script>

</cfoutput>