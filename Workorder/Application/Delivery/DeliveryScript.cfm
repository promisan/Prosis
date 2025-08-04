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

<cf_layoutscript>
<cf_CalendarScript>
<cf_menuscript>
<cf_DialogOrganization>
<cf_PresentationScript>
<cfajaximport tags="cfmap,cfdiv,cfform,cfprogressbar" params="#{googlemapkey='#client.googleMAPId#'}#">
<cf_MapScript map="gmap">

<cfinclude template="Notification/SMS/SMSScript.cfm">
<cfinclude template="Notification/TTS/TTSScript.cfm">
<cfinclude template="Notification/SMTP/SMTPScript.cfm">

<cfoutput>

<cfset vInfoBox="true">

<script language="JavaScript">	
	
	var INFO_BOX = #vInfoBox#;
	var URL_INFO_BOX = "MAP/MAPInsert.cfm";
	var URL_INFO_PARAM = "?date=#url.date#&mission=#URL.mission#";
	var INFO_BOX_CONTENT = "mapmetadata";
  
	 
	function applydate(argOb) {			
		dt = argOb.dd+'/'+argOb.mm+'/'+argOb.yyyy		 
	    _cf_loadingtexthtml='';	
		Prosis.busy('yes')							
		unblock_selection();		
		document.getElementById("menu").value = 'map'
		ptoken.navigate('DeliveryViewContent.cfm?init=0&mission=#url.mission#&mode=reload&date='+dt,'mycontentbox')			
		reloadmap(dt)						    
    }
	
	function orderadd() {	
	    w = "#client.width-130#";
	    h = "#client.height-130#";	
	    ptoken.open("#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?mission=#url.mission#&scope=entry","_blank", "left=20, top=20, width=" + w + ", height= " + h + ", menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes");						  		  
	}
	
	function detail(key,box) {
	    w = "#client.width-130#";
	    h = "#client.height-130#";	
	    ptoken.open("#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderEdit.cfm?scope=edit&drillid="+key+"&box="+box,"form_"+key);						  		  
	}	
	
	function reloadtree(dt) {
		_cf_loadingtexthtml='';			
		se = document.getElementById('DateEffective_date').value;		
		if (dt) {
		  ptoken.navigate('DeliveryViewContent.cfm?init=1&mission=#url.mission#&mode=reload&date='+dt,'mycontentbox')			
		} else {		
		  ptoken.navigate('DeliveryViewContent.cfm?init=0&mission=#url.mission#&mode=reload&date='+se,'mycontentbox')
		}			
	}
	
	// option to close the workorder 
	
	function setlock() {
	    _cf_loadingtexthtml='';	
	    se = document.getElementById('DateEffective_date').value;
	    ptoken.navigate('setLock.cfm?mission=#url.mission#&date='+se,'addmarker')
	}
	
	try{
		$(window).on('orientationchange resize', function() { resizemap() });
	} catch(ex) {}
	
	function resizemap() {	
		if (document.getElementById("menu").value == "map") {
			reloadmap()		
		}	
	}
			
	function reloadmap(dt) { 	    
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')		
		size = isAreaVisible('mybox','treebox')				
		se = document.getElementById('DateEffective_date').value;	
		document.getElementById('menu').value = 'map'
		if (dt) {
		    ptoken.navigate('MAP/MAPContent.cfm?infobox=#vInfoBox#&size='+size+'&height='+$(window).height()+'&width='+$(window).width()+'&mission=#url.mission#&date='+dt,'mapcontent','','','POST','mapform');
		} else {		
		    ptoken.navigate('MAP/MAPContent.cfm?infobox=#vInfoBox#&size='+size+'&height='+$(window).height()+'&width='+$(window).width()+'&mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform');
		}			
		$("##mapmetadata").show();
		unblock_selection();		
	}
	
	function setoperation(val) {
		
	    if (val == 'inquiry') {
	    	INFO_BOX = true;
			collapseArea('mybox', 'rightbox');
			expandArea('mybox', 'treebox');
		} else {
			
		   if ($(".selector:checked").length>0)  {
		   	INFO_BOX = false;
		   	collapseArea('mybox', 'treebox');
			expandArea('mybox', 'rightbox');
		  	ColdFusion.navigate(URL_INFO_BOX+URL_INFO_PARAM,INFO_BOX_CONTENT);
		   } else {
		   		$("##mapmode").prop('checked', true);
		   		alert('Please select a particular scope for the quick planner to show');
		   }
		}
	
	}
			
	function dssplanning(dt) {
	    _cf_loadingtexthtml='';	
	    se = document.getElementById('DateEffective_date').value;
	    document.getElementById('menu').value = 'dss'
	    unblock_selection();
	    ptoken.navigate('#session.root#/Workorder/Application/Delivery/DeliveryViewContent.cfm?mission=#url.mission#&mode=reload&loadmode=dss&date='+se,'mycontentbox')
	    ptoken.navigate('Planner/DSS/WorkCluster.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
	}
	
	function planning() {
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')
		se = document.getElementById('DateEffective_date').value;	  	   
		document.getElementById('menu').value = 'planning'	   
		$("##mapmetadata").hide();	   
		unblock_selection();
		ptoken.navigate('Planner/PlannerView.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
	}
	
	// sublitsing on this page 
	
	function planninglist() {
		_cf_loadingtexthtml='';			   
		se = document.getElementById('DateEffective_date').value;  
		document.getElementById('menu').value = 'planning'
		ptoken.navigate('Planner/PlannerListing.cfm?mission=#url.mission#&date='+se,'plannercontent','','','POST','mapform')
	}
		
	function notification(tpe) {
	
		document.getElementById('menu').value = tpe
		se = document.getElementById('DateEffective_date').value;
		$("##mapmetadata").hide();
		unblock_selection();
		Prosis.busy('yes')
		if (tpe == 'sms') {
		    ptoken.navigate('Notification/SMS/SMSListing.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
		} else if (tpe == 'tts'){
		   ptoken.navigate('Notification/TTS/TTSListing.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
		}
		else if (tpe == 'smtp')
		{
			ptoken.navigate('Notification/SMTP/SMTPListing.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
		}	 
	}	
	
	function reloadcontent(mode) {
		  		     
		 menu = document.getElementById("menu").value
		 		  		 		  
		 if (menu == 'map') {
	      	   se = document.getElementById('DateEffective_date').value;						  
			   if (mode != 'partial') {		  	 				
		  			mapclear()
		  		} 		
					  
		  		ptoken.navigate('MAP/MAPContentRefresh.cfm?mission=#url.mission#&date='+se,'addmarker','','','POST','mapform')
			  		  
		 } else {
		  
		     if (menu == 'dss' || menu == 'pending') {
		     	se    = document.getElementById('DateEffective_date').value;
		     	rid   = document.getElementById('RouteId').value;
		     	step  = document.getElementById('Step').value;
		     	
		     	if (mode=='full') { mapclear(); }	
		     	ptoken.navigate('Planner/DSS/WorkClusterMap.cfm?mission=#url.mission#&date='+se+'&loadmode=refresh'+'&Id='+rid+'&step='+step,'addmarker','','','POST','mapform')
		     	ptoken.navigate('Planner/DSS/WorkClusterSteps.cfm?date='+se+'&step='+step,'dDSteps');
				
			 } else {	
			 							
		     	se = document.getElementById('plannercontent')
				if (mode == 'full') {			
				   planning() // refreshes the full content 
				} else {
				
			 	if (se) { planninglist() } else { planning() }
				}
				
			 }		
		  } 	
	}
	
	function positionselect(pos,dts,mode) {		
		 
		 // toggle presentation
		 se = document.getElementsByName('position')		  
		 cnt = 0
		 while (se[cnt]) {		   		   
		   se[cnt].className = "hide" 
		   cnt++
		 }  					 
		 if (dts) {} 
		 else {
		 	dts = document.getElementById('DateEffective_date').value;		
		 }		 		 
		 document.getElementById('position_'+pos).className = "regular"					 		 
		 		 
		 $('.PositionSync').each(function(index) {
			  $(this).val(pos);
		 });
		 
		 var f004_pos = $('##f004_'+pos).val();
		 $('.f004Sync').each(function(index) {
			  $(this).val(f004_pos);
		 });		 
		 
		 
		 // load the workplan map
		 mapPlan(pos)							
		 // this is for the workplan right box 
		 ptoken.navigate('Planner/setPosition.cfm?mission=#url.mission#&dts='+dts+'&positionno='+pos,'positionbox')	 
		 // this is for the workplan details
		 ptoken.navigate('Planner/WorkPlanActorDetail.cfm?mission=#url.mission#&mode=drill&dts='+dts+'&positionno='+pos,'positioncontent_'+pos)
		 // load the total scheduled counter on the left
		 ptoken.navigate('Planner/setScheduled.cfm?mission=#url.mission#&date='+dts,'scheduled')			
		 
	}		
		
	// apply manual planning		
	function applyPlan(id,dts,row) {			   
	     ptoken.navigate('Planner/WorkPlanSubmit.cfm?row='+row+'&mission=#url.mission#&dts='+dts+'&workactionid='+id,id+'_workplan','','','POST','mapform')					
	}	
	
	// refresh the manual planning map screen	
	function mapPlan(pos) {
	
	     se = document.getElementById('DateEffective_date').value;	
		 mapclear()
	 	 ptoken.navigate('MAP/MAPContentRefresh.cfm?mode=workplan&mission=#url.mission#&positionno='+pos+'&dts='+se,'addmarker')	
		
	}	
	
	function mapclear() {
	
	     var mapObj = ColdFusion.objectCache['gmap'];
	     var sobj = mapObj.mapPanelObject;	  		
	     Ext.each(sobj.cache.marker, function (marker){		  	
			marker.setMap(null);				
	     });	  
	  	
	}
	
	// adding checkboxes which then does a complete rewrite 
	function toggle(val,box,mde,det,org) {
		
	    if (val == true) {
    	   document.getElementById(box).className = "regular"
    	   console.log('add:'+org);
    	   mde = 'partial'; 		  
		  
	    } else {
		
	      document.getElementById(box).className = "hide" 
    	  document.getElementById(det).className = "hide" 
	      document.getElementById('detail_'+org).checked = false	 
	      se = document.getElementById('DateEffective_date').value
	      console.log('remove:'+org);
	      mde = 'full';
	      ptoken.navigate('DeliveryViewDetail.cfm?mission=#url.mission#&date='+se+'&orgunit=0','rowdetail_'+org+'_content')	   
	   }

		var vtotal = 0;
		$(".selector:checked").each(function() {
			vtotal = vtotal + 1;
		});			
	   
	   if (vtotal==1)
	   	 mde = 'full';
	   	 
	   reloadcontent(mde);	  
	}		
	
	// adding checkboxes which then does a complete rewrite 
	function unitdetail(val,box,unit) {
		
	  se = document.getElementById('DateEffective_date').value	 
	  if (val == true) {
		   document.getElementById(box).className = "regular" 		   
		   ptoken.navigate('DeliveryViewDetail.cfm?mission=#url.mission#&date='+se+'&orgunit='+unit,box+'_content')		   
	   } else {
	   	   document.getElementById(box).className = "hide" 	
		   ptoken.navigate('DeliveryViewDetail.cfm?mission=#url.mission#&date='+se+'&orgunit=0',box+'_content')	   
	   }
	  
	}			

	function resetdate(se) {			    
		ptoken.navigate('#session.root#/workorder/application/Delivery/DeliveryViewContent.cfm?mission=#url.mission#&mode=reload&date='+se,'tdAdding')				
	}

			
</script>
	 		
</cfoutput>


