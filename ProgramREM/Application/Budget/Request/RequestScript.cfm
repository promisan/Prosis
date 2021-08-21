
<cf_dialogREMProgram>

<cfparam name="url.EditionId"  default="">
<cfparam name="url.ACTIVITYID" default="">
<cfparam name="url.Objectcode" default="">

<cfajaximport tags="cfform,cfdiv">
<cfoutput>
  	
  <cf_tl id="Budget Request Form" var="1">
  <cfset vBudget=#lt_text#> 	
  
  <cf_tl id="View Instructions" var="vExpandInstructionsMessage">
  <cf_tl id="Hide Instructions" var="vCollapseInstructionsMessage">
 
 	
	<script>
	
	function reloadmatrix(per,id) {
	    
		if (document.getElementById('matrixbox')) {
		
			fund    = document.getElementById('fund').value
			imaster = document.getElementById('itemmaster').value
			loc     = document.getElementById('requestlocationcode').value				
			ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDialogFormMatrix.cfm?planperiod=#url.period#&period='+per+'&requirementid='+id+'&fund='+fund+'&objectcode=#url.objectcode#&itemmaster='+imaster+'&location='+loc+'&programcode=#url.programcode#&mission=#url.Mission#&editionid=#URL.Editionid#','matrixbox')							
		}
		
	}
				
	function alldet(cell,edi,obj) {			
				
		se = document.getElementById(cell)
					
		if (se.className == "hide") {
		   se.className = "regular"		  		
		   ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestList.cfm?programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'box'+cell)
		 } else {		 
		   se.className = "hide"
		}   
	}
	
	function getcontribution(id,fd,prg,per) {	
			
		ProsisUI.createWindow('mycontribution', 'Contribution', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:false,resizable:false,center:true})    						
		ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Request/getContribution.cfm?requirementid='+id+'&programcode='+prg+'&fund='+fd+'&period='+per,'mycontribution') 			

	}
	
	w = "#client.width-100#"
	h = "#client.height-100#"	
			
	function alldetinsert(cell,edi,obj,id,mode,scope,itm) {
		
		if (scope == "dialog") {
		
		    // not sure if this is still in use, can be removed i think : Hanno 23/3/2015 
	       		  	  	
		    try {
		    se = dialogview.document.getElementById("entrydialog")			
			if (se) {											
			    Prosis.busy('yes')
				dialogview.ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDialogForm.cfm?mode='+mode+'&requirementid='+id+'&programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'entrydialog')						
			} else {
			  				    
			  reload(obj)			  
			}
			} catch(e) {
				
			    se = document.getElementById("entrydialog")							
				if (se) {		
					Prosis.busy('yes')
				    if (itm) {													
					ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDialogForm.cfm?mode='+mode+'&requirementid='+id+'&programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj+'&cell='+cell+'&itemmaster='+itm,'entrydialog')	
					} else {
						ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDialogForm.cfm?mode='+mode+'&requirementid='+id+'&programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'entrydialog')						
					}					
				} else {			  
				  reload(obj)			  
				}
			}
			
		} else {	
		
		    if (mode == "resource") {
			
			   ptoken.open("#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode="+mode+"&requirementid="+id+"&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid="+edi+"&objectcode="+obj+"&cell="+cell,"requirement")
						
			} else {
			
			    // not sure if this is still in use hanno 22/9/2015						
					    							
				if (id == "") {
				 alert("please contact administrator code:modaldialog")
				 //   ret = window.showModalXXXDialog("#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode=add&requirementid="+id+"&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid="+edi+"&objectcode="+obj+"&cell="+cell+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:no; center:yes; resizable:yes");			
				} else {	
				 alert("please contact administrator code:modaldialog")		   
			   	 //   ret = window.showModalXXXDialog("#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode="+mode+"&requirementid="+id+"&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid="+edi+"&objectcode="+obj+"&cell="+cell+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:no; center:yes; resizable:yes");
				}	
															 			   
			    if  (ret) {
							
					<!--- refresh listing --->				
					count=0
					obj = ret.split(",") 
					while (obj[count]) {					
					<!--- refresh listing --->
					ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestList.cfm?programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj[count]+'&cell='+cell,'box'+edi+'_'+obj[count])			
					<!--- refresh total amount  --->
					ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/Amount.cfm?programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj[count],edi+'_'+obj[count]+'_total')	
					count++
				    }
								
			
				} else {
				
					ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestList.cfm?programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'box'+cell)
					<!--- refresh total amount  --->
					ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/Amount.cfm?programcode=#url.programCode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj,edi+'_'+obj+'_total')									
				
				}										
						
			}
			
		}	
		
	}
	
	function domatrix() {
	   li = document.getElementById('listcount').value
	   co = document.getElementById('colncount').value	   
	   ptoken.navigate('RequestDialogFormMatrixCopy.cfm?row=99&col=1&rows='+li+'&cols='+co,'ctotal')	
	}
	
	function more(bx) {
	 		
		frm  = document.getElementById("detail"+bx);			 		 
		if (frm.className=="hide") {		   	
			frm.className   = "regular";			
		} else {		   	 
		    frm.className  = "hide";
		}			 		
	  }					
	
	function alldetdelete(cell,edi,obj) {	
		ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestList.cfm?programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid='+edi+'&objectcode='+obj,'box'+cell)	
	}
	
	function requestvalidate(cell,id,mode,par) {
	
		document.formrequest.onsubmit() 
		if( _CF_error_messages.length == 0 ) {   		  
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';
    	    ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestSubmit.cfm?&activityid=#url.activityid#&mode='+mode+'&requirementid='+id+'&requirementidparent='+par+'&cell='+cell,'entrydialogsave','','','POST','formrequest')
		 }   
	
	}
	
	// applies the standard cost from the selection of the topic item of the item master 
	function applycost(itm,topic,line,selected,mis,loc) {	
			    
	    try {
		   var qty = document.getElementById('requestquantity_'+line).value 	   
		} catch(e) {
		   var qty = 1
		}		
		_cf_loadingtexthtml='';		
		ptoken.navigate('RequestDescriptionAmount.cfm?itemmaster='+itm+'&topicvaluecode='+topic+'&quantity='+qty+'&line='+line+'&selected='+selected+'&mission='+mis+'&location='+loc,'entrydialogsave')			
	}
	
	function addBudgetEntryLine(code,t) {
			    
		var cnt;
		var vShow = 0;		
		cnt = 1;
		$('.clsBudgetRow_'+code).each(function(i){
			if (cnt <= t) {
				if($('.clsBudgetRow_'+code+'_'+cnt).is(':visible')) {
					vShow = cnt+1;
					document.getElementById('itm_'+code+'_'+vShow).value = "1"					
				}
			}
			cnt++;
		});
		
		if (vShow != 0) {
		 	$('.clsBudgetRow_'+code+'_'+vShow).show();
		}
						
		if (vShow === t) {
			$('##twistieBudgetRow_'+code).hide();
		}											
		
	}
	
	function removeBudgetEntryLine(code,s,t,row) {
		 
		document.getElementById('itm_'+code+'_'+s).value      = "0"		
	    document.getElementById('resourcequantity_'+row).value  = "";
		document.getElementById('resourcedays_'+row).value      = "1";
		
		try {
		document.getElementById('requestquantity_'+row).value   = ""		
		} catch(e) {}
		
		document.getElementById('quantity_'+row).innerHTML      = "";		
		document.getElementById('requestamountbase_'+row).value = "";
		document.getElementById('total_'+row).innerHTML         = "";

		$('.clsBudgetRow_'+code+'_'+s).css('display','none');		
		if (s <= t) {
			$('##twistieBudgetRow_'+code).css('display','inline');
		}
		ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/getRequestDescription.cfm?setlabel=0&line='+row+'&id=&itemmaster='+code,'description_'+row);		
	}
	
	function syncAmounts() {

		var element = $('input[name^="resourcequantity_"]:visible').first();
		var id = $(element).attr('id');
		var v  = $(element).val();		

		if ($.trim(v) != '') {
			$('input[name^="resourcequantity_"]:visible').each(function() {
					if ($(this).attr('id') != id && $(this).val()=='')	{
						$(this).val(v);
						ColdFusion.Event.callBindHandlers($(this).attr('id'),null,'change')
					}	
			});
		}		
	}		
	
	function getItemObjectInstructions(obj,itm,prg,per,edi,target,ct,collapseIcon,expandIcon) {
		ptoken.navigate('getItemObjectInstructions.cfm?object='+obj+'&itemmaster='+itm+'&programCode='+prg+'&period='+per+'&editionId='+edi,'div'+target);
		$('##'+target).toggle();
		if ($('##'+target).is(':visible')) { 	
			$(ct).attr('src','#session.root#/images/'+collapseIcon);
			$("label[for='" + $(ct).attr('id') + "']").html('#vCollapseInstructionsMessage#');
		}else{
			$(ct).attr('src','#session.root#/images/'+expandIcon);
			$("label[for='" + $(ct).attr('id') + "']").html('#vExpandInstructionsMessage#');
		}
	}
	
	</script>

</cfoutput>
