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

	<script>
	
	function showservice(id,mode) {	   

	   if (id != '') {
	   
	     document.getElementById('selectlineid').value = id;
		 
		 if (mode != "usage") {
		 
			collapseArea('myservices','inspect');
		 	ColdFusion.navigate('ServiceProvision.cfm?mode='+mode+'&workorderlineid='+id,'body');
			enableBorderSection('myservices', 'right', false);
			 
		 } else {
		 	
			 // clean out as this is loaded from the inspect
			 ColdFusion.navigate('ServiceLayoutBody.cfm?workorderlineid=','body');	
			 // load the inpsection box
			_cf_loadingtexthtml='';	  			 
		     ptoken.navigate('ServiceUsageInspect.cfm?mode='+mode+'&workorderlineid='+id,'inspect');
			 <!--- populate the top menu --->
     		_cf_loadingtexthtml='';	
			ptoken.navigate('getYear.cfm?mode='+mode+'&workorderlineid='+id,'boxyear'); 
			// enableBorderSection('myservices', 'right', true);
			 						 
		 } 
	   }   	 	   
	 }	  
		  
	 function dayselect(id,yr,mt,dy,cnt) { 	
	  
	      var count=0;
		  var se = document.getElementsByName("selectday")	
		  var itm = dy-1  				 		  
		  while (se[count]) {   		  
		    if (count != itm) {				   
			    se[count].className = "label" 							    
			} else {			
			  if (count == itm)	{			
				  if (se[count].className == "highlight2") {
				      se[count].className = "label"						    			 
					  document.getElementById("dayselected").value = ""		
					  showusage(id,yr,mt,'',cnt,'','')					  	
					  document.getElementById('filtersearch').value = ""	  		 
				  } else {		     
				  	  se[count].className = "highlight2"	
					  document.getElementById("dayselected").value = dy	 
					  showusage(id,yr,mt,dy,cnt,'','')
					  document.getElementById('filtersearch').value = ""
				  } 	 					  
			  }			
			}
			count++;			
		  }			  		
	  }	 	
	
	function showusage(id,yr,mt,dy,content,selmonth) {		
		_cf_loadingtexthtml='';	    
	    document.getElementById("yearselected").value  = yr
		document.getElementById("monthselected").value = mt;	
		document.getElementById("dayselected").value   = dy;	
	    ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/serviceUsageInspectLines.cfm?content='+content+'&workorderlineid='+id+'&year='+yr+'&month='+mt+'&day='+dy+'&reference=','inspectlines')
		// '+document.getElementById('servicesearch').value
		_cf_loadingtexthtml='';	
		
	  }
	  
	function showusageDetail(cnt,wlid,yr,mt,dy,ref,dir) {	 	
	       
		  _cf_loadingtexthtml='';
		  Prosis.busy('yes');  		  
		  ptoken.navigate('#SESSION.root#/workorder/portal/user/usage/serviceUsageBody.cfm?content='+cnt+'&workorderlineid='+wlid+'&year='+yr+'&month='+mt+'&day='+dy+'&reference='+ref+'&calldirection='+dir,'body');		 
		  _cf_loadingtexthtml='';	
	 	}  	  
	
	function userpref(wid,ref,row) {
	  
		  ex = document.getElementById('det_'+row+'exp')
		  mi = document.getElementById('det_'+row+'min')
		  se = document.getElementById('ref_'+row)
		  
		  if (se.className == "hide") {	  
		    
			  ex.className = "hide"
			  mi.className = "regular"
			  se.className = "regular"
						  
		      ColdFusion.navigate('ServiceUsageInspectLinesUser.cfm?workorderlineid='+wid+'&reference='+ref+'&row='+row,'refcontent_'+row)
			  
		  } else {
		  
		      se.className = "hide"
		      mi.className = "hide"
			  ex.className = "regular" 
			  
		  }	 
	  
	}		  
	  
	function userprefset(wid,ref,row) {
	   ColdFusion.navigate('ServiceUsageInspectLinesUserSet.cfm?workorderlineid='+wid+'&reference='+ref+'&row='+row,'set_'+row,'','','POST','user_'+row)	  		
	}  
		  
	function chargedetail(wid,lid,yr,mt,mode,tot) {
	  var cnt;
	  if ((mode == 'unplanned')&&(tot==0))
	  	{cnt = 'Nonbillable';}
	  else
	  	{cnt = '';}		
	    window.open("#SESSION.root#/Workorder/Application/Workorder/Servicedetails/Charges/ChargesUsageDetail.cfm?workorderid="+wid+"&workorderline="+lid+"&year="+yr+"&month="+mt+"&mode="+mode+"&content="+cnt,"_blank","left=20, top=20, width=<cfoutput>#client.width-140#</cfoutput>,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")		
	  }		  
  	  
	 function printme(id,line,ref,yr,mt,dy,cnt,dir) {
	    win = window.open("#SESSION.root#/Workorder/Application/Workorder/Servicedetails/Charges/ChargesUsageDetail.cfm?scope=print&print=1&workorderid="+id+"&workorderline="+line+"&reference="+ref+"&year="+yr+"&month="+mt+"&day="+dy+"&content="+cnt+"&calldirection="+dir,"_blank","left=20, top=20, width=800, height=800, status=yes, toolbar=no, scrollbars=yes, resizable=yes");	  
	  	setTimeout('win.print()', 2000);
	  }
	
	 function dochange(pid,ptid,charged,woid,wolid,year,month,day,ref,dir,mode) {	
		_cf_loadingtexthtml="";				
		ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/charges/ChargesUsageDetailApply.cfm?mission=#url.mission#&scope=data&action=update&id='+pid+'&charged='+charged+'&workorderid='+woid+'&workorderline='+wolid+'&year='+year+'&month='+month+'&reference='+ref+'&calldirection='+dir+'&mode='+mode,'applystatus');	
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";	
	  }
	  
	 function dochangebatch(charged,woid,wolid,year,month,day,ref,dir,mode) {	   
	   
	    var txt;
		
	    if (charged == '1') {
		   txt = 'BUSINESS'
		} else {
		   txt = 'PERSONAL'
		} 
		
	    if (confirm("Do you want to set all listed transactions as " + txt)) {
	    	se = document.getElementById('transactionlistcontent').value 	  			
			Prosis.busy('yes')	
			ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/charges/ChargesUsageDetailApply.cfm?mission=#url.mission#&scope=data&action=updatebatch&charged='+charged+'&workorderid='+woid+'&workorderline='+wolid+'&year='+year+'&month='+month+'&reference='+ref+'&calldirection='+dir+'&mode='+mode,'applystatus','','','POST','transactionform');			
			
		}
		
	 }	
	 	 
	 // refresh the body as shown for easy handling in the portal 
	 function refreshlines(compare) {
	 			
	    lnk = document.getElementById("templatequerystring").value		
	    if (compare == '') {			    	 
			Prosis.busy('yes')		
			ptoken.navigate('#SESSION.root#/workorder/portal/user/usage/serviceUsageBody.cfm?'+lnk,'body')	 
		
		} else {	
		    
	       if (compare != lnk) {		        	      		      
			   Prosis.busy('yes')	
				ptoken.navigate('#SESSION.root#/workorder/portal/user/usage/serviceUsageBody.cfm?'+compare,'body')	 
			} else {			
			}			
		}	
	 }
	
  
  	  function showReferences(scope) { 	 
	      var count=0;	
		  var se;
		  var pse;
		  var lse;
		  var lpse;		  
		  var sd  = document.getElementById('sdirection');		    			 
		  
			pse  = document.getElementsByName('referenceselect'+sd.value);	
		  		while (pse[count]) {   					
		      		pse[count].className = "hide" ;
		      		count++;  }	

			count=0;
			lpse  = document.getElementsByName('line'+sd.value);	
		  		while (lpse[count]) {   					
		      		lpse[count].className = "hide" ;
		      		count++;  }	
					
			count=0;
		  	se  = document.getElementsByName('referenceselect'+scope);
		  		while (se[count]) {    					
		      		se[count].className = "regular" ;
		      		count++;  }				  			  

			count=0;
		  	lse  = document.getElementsByName('line'+scope);
		  		while (lse[count]) {    					
		      		lse[count].className = "regular" ;
		      		count++;  }					

			document.getElementById('sdirection').value=scope;					
	  }	 	  
		
	  function changeApprovalview(viewtype,serviceItem,mission) {

	  	if (viewtype=='Approved'){
			ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Submission/SubmissionCenter.cfm?mission='+mission+'&serviceitem='+serviceitem,'center');
		}else{
			ColdFusion.navigate('#SESSION.root#/workorder/Application/WorkOrder/ServiceDetails/Action/ClosingListing.cfm?serviceitem='+serviceitem+'&scope=portal','center');
		}	
	  }		
	</script>	
	
	
	
</cfoutput>

