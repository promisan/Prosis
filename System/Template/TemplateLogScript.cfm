<!--
    Copyright © 2025 Promisan B.V.

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

    <cf_ajaxRequest>
	
	<script language="JavaScript">
		
	function filter() {
	document.formlocate.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		ColdFusion.navigate('TemplateLog.cfm?filter=1','detail','','','POST','formlocate')
	 }   
	}	 
	
	function show(cde) {

	se1 = document.getElementById(cde+"_col")
	se2 = document.getElementById(cde+"_exp")
	se = document.getElementById(cde)
	if (se.className == "hide") {
		se2.className = "regular"
	    se1.className = "hide"
		se.className  = "regular" 
	} else {
		se2.className = "hide"
	    se1.className = "regular"
		se.className  = "hide"
	}
	
	}
	
	function reload(val) {
	window.location = "TemplateLog.cfm?site=#URL.Site#&distribution="+val
	}
		
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function selall(chk,grp) {
		se = document.getElementById(grp)
		cnt = 0
		while (se[cnt]) {
		if (chk == true) {
		   se[cnt].checked = true
		} else {
		   se[cnt].checked = false
		}
		cnt++
		}
	}

	function hl(itm,val){

     if (ie){
          while (itm.tagName!="TD")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TD")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (val != false) {itm.className = "highLight";}
	 else {itm.className = "regular";}
	}
	
	function distribute() {
		if (confirm("Do you want to prepare a Release distribution package ?")) {				
			ColdFusion.navigate('ReleasePackageInit.cfm?ts='+new Date().getTime()+'&site=#URL.site#&group=#url.group#','prepare')		
		}	
	}
	
	function cancel(site) {
	if (confirm("Do you want to cancel this distribution package ?")) {
		window.location = "ReleasePackageDelete.cfm?ts="+new Date().getTime()+"&site="+site;
	}
	
	}
			
	function comparison(newver,oldver) {
	  w = #CLIENT.width# - 30;
	  h = #CLIENT.height# - 100;
	  window.open("TemplateComparison.cfm?new="+newver+"&old="+oldver,"_blank","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes")
    }
			
	/*
	function batch(id) {
	  window.location = "#url.root#/tools/template/TemplateCheckContent.cfm?ts="+new Date().getTime()+"&site="+id;
	}*/
	
	function batch(site){
		_cf_loadingtexthtml="";	
		Prosis.busy('yes', 'divCodeScannerWaitText');
		
		window['__cbCodeScanner'] = function(){ Prosis.busy('no', 'divCodeScannerWaitText'); };

		ptoken.navigate('#Session.root#/Tools/Template/TemplateCheckContent.cfm?site='+site,'templatescan','__cbCodeScanner');
		ColdFusion.ProgressBar.start('pBar') ;
	}
	
	
	function history(id,row) {
		frm = document.getElementById("d"+row)
		if (frm.className == "regular") {
		   frm.className = "hide"
 	    } else {
		   frm.className = "regular"
		   ColdFusion.navigate('TemplateHistory.cfm?id='+id,'i'+row)
		}  		
	}
	
	function deletetemplate(id,mde) {
	    try {
		se = document.getElementById("confirm").checked				
		} catch(e) { se = true }
		
		if (se == true) {			
	    	if (confirm("Do you want to remove this template ?")) {			
				url = "TemplateActionPurge.cfm?id="+id
				ColdFusion.navigate(url,'d'+id)	}			 		 
		    } else {		 
		 	url = "TemplateActionPurge.cfm?id="+id
			ColdFusion.navigate(url,'d'+id)							 
		  }	 
				
	}
	
	function inserttemplate(id) {
		url = "TemplateActionMasterInsert.cfm?id="+id
		ColdFusion.navigate(url,'d'+id)				
	}
	
	function updatemaster(newver,oldver) {
	
	    se = document.getElementById("confirm").checked				
		if (se == true) {				
			if (confirm("Do you want to replace the master copy with the development copy ?")) {
				url = "TemplateActionMasterUpdate.cfm?mode=log&new="+newver+"&old="+oldver;
				ColdFusion.navigate(url,'u'+oldver)	}	 					 
		 } else {		 
			 url = "TemplateActionMasterUpdate.cfm?mode=log&new="+newver+"&old="+oldver;
			 ColdFusion.navigate(url,'u'+oldver)					 
		 }		
	}	
	
	function deploybatch(grp) {
	
	  count = 0
	  cnt=0
	  temps = ''
	  se = document.getElementsByName("templates")
	  while (se[count]) {
		  if (se[count].checked == true) {
		     cnt++
		     if (temps == '') {  
		        temps = se[count].value
		     } else {  
    		    temps = temps+":"+se[count].value}
		  }
		 count++ 
	  }
	 	
	  if (confirm("Do you want to replace the content of the "+cnt+" selected files in the replica directory ?")) {		 
	     r = document.getElementById('result');
		 f = document.getElementById('formlocate');
		 console.log(r);
		 console.log(f);
	      ColdFusion.navigate('TemplateActionDeployBatch.cfm?group='+grp+'&site=#URL.site#','result','','','POST','formlocate')	  		  	  
		  prg = setInterval('showprogress()', 1000)	 
		}	
	}	
		
   function showprogress() {
     
	  det = document.getElementById("detail")
	  url = "TemplateActionDeployProgress.cfm"
	   
	   AjaxRequest.get({
      'url':url,
	  'onSuccess':function(req){ 
	      det.innerHTML = req.responseText;		  
	   },		  
    	  'onError':function(req) { 
		  det.innerHTML = req.responseText;		 
		 }
		});
				
     <!--- ColdFusion.navigate('TemplateActionDeployProgress.cfm','detail') --->
   }

   function stopprogress() {
	 clearInterval ( prg );
   }	 

	function deployclient(template,oldtemplate,client,reviewid) {
	
	    se = document.getElementById("confirm").checked
				
		if (se == true) {
		
			if (confirm("Do you want to update "+client+" with the master copy ?")) {
				    	
			url = "TemplateActionDeploy.cfm?client="+client+"&reviewid="+reviewid+"&mode=log&new="+template+"&old="+oldtemplate;
			ColdFusion.navigate(url,'u'+template)	
					
			}	 	
				 
		 } else {
		 
			 url = "TemplateActionDeploy.cfm?client="+client+"&reviewid="+reviewid+"&mode=log&new="+template+"&old="+oldtemplate;
			 ColdFusion.navigate(url,'u'+template)	
		 
		     }
		
	}	
		
	function detail(id,compare,version) {

	 w = #CLIENT.width# - 30;
	 h = #CLIENT.height# - 100;
	 window.open("TemplateDetail.cfm?site=#url.site#&id="+id+"&compare="+compare + "&ts="+new Date().getTime(), id);	 
	 if (compare == 'Prior') { }
	 else {
	     try { 
		 
		 if  (document.getElementById('u'+id)) {
		 ColdFusion.navigate('TemplateDetailProcess.cfm?templateid='+id+'&templatecompareid='+compare+'&reviewid='+ret,'u'+id)	
		 } 
		 } catch(e) {}
		 }
	}
		
	</script>
	
</cfoutput>	