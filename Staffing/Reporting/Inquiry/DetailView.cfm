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

<!--- this is the drilldown view for the staffing table for the posts --->

<cfparam name="URL.cls" default="Vacancy">

<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">
<cfset client.graph = url.item>

<cfoutput>

<cfajaximport tags="cfform,cfdiv">

<cf_dialogStaffing>		
<cf_dialogPosition>	

<cfset FileNo = round(Rand()*10)>

<cfset base   = "\\Staffing\\Reporting\\Inquiry\\">
<cfset path   = "Vacancy">
<cfset parent = "Template">
								
<!--- storage for generated filter (right panel) --->
<cfset client.programgraphfilter = "">

<!--- storage for pivot selection --->

<cfparam name="client.programpivotfilter" default="">
<!--- storage for listing/pivot show filter --->
<cfparam name="client.programdetail" default="pivot">

<cfparam name="URL.scope" default="all">
		
<cfif fileExists("#SESSION.rootpath#\#base#\#path#\Property.cfm")>
	<cfset pty = "#path#">							
<cfelseif fileExists("#SESSION.rootpath#\#base#\#parent#\Property.cfm")>
	<cfset pty = "#parent#">					
</cfif>		

<cfif fileExists("#SESSION.rootpath#\#base#\#path#\Filter.cfm")>
	<cfset fil = "#path#">							
<cfelseif fileExists("#SESSION.rootpath#\#base#\#parent#\Filter.cfm")>		   
	<cfset fil = "#parent#">					
</cfif>	

<cfparam name="URL.link" default="">

<cfset link = "#replace('#url.link#','_','&','ALL')#">	
	
<script language="JavaScript">	

	function returnmain() {	 
	   ptoken.open("../PostView/Staffing/PostViewLoop.cfm?#link#","_self")
	}	
				
	function facttablexls1(control,format,box) {
	    ColdFusion.Ajax.submitForm('formselect','#SESSION.root#/#base#/#fil#/SelectedRecord.cfm')	
		if (confirm("Do you want to export to Excel ?")) { 
		    w = #CLIENT.width# - 80;
		    h = #CLIENT.height# - 110;	
			ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?fileno=#fileno#&data=1&controlid="+control+"&format="+format+"&ts="+new Date().getTime(), "facttable", "unadorned:yes; edge:raised; status:no; dialogHeight: "+h+" px; dialogWidth:"+w+" px; help:no; scroll:no; center:yes; resizable:no");	
		}
		return false	
	}	
		
	function reloadlisting() {		
	
		 crit = ''
		 count = 1								 
		
		 while (count < 3) {
		 			
		 try {	
					
		 selected = document.getElementById("cselect"+count).value								 			 	
		 itm      = document.getElementById("citem"+count).value				 	 			
		
		 if (itm != '') {
				 crit = crit+'&'+itm+'='+selected
				 }
			 } catch(e) {}
		 count++			 
		 }	
		 _cf_loadingtexthtml="";	 						 
		 ptoken.navigate('#SESSION.root#/#base#/#fil#/DetailNavigate.cfm','listing') 					  
		 
   	}   
				
	function list(mode) {   			
				 
	 if (mode == "undefined") { mode = "listing" }	
	   	
	   itm = document.getElementById('itemselected').value			   					    
	   ptoken.navigate('#SESSION.root#/#base#/#path#/Listing.cfm?mode='+mode+'&fileno=#fileno#&item='+itm+'&series='+graphseries.value+'&select='+graphselect.value+crit,mode) 			
	   // ProsisUI.createWindow('rightpanel', 'Selection Summary', '',{height:340,width:350,modal:false,center:true})				  
  	   // ProsisUI.closeWindow('rightpanel')	 
	   _cf_loadingtexthtml="";	 
   	   // ptoken.navigate('#SESSION.root#/#base#/#pty#/Property.cfm?fileno=#fileno#&item='+itm+'&series='+graphseries.value+'&select='+graphselect.value+crit,'rightpanel') 						 	  
	 }						
				
	function pivot() {
	   itm = document.getElementById('itemselected').value	
	   _cf_loadingtexthtml="";	
	   ptoken.navigate('#SESSION.root#/#base#/#path#/PivotData.cfm?fileno=#fileno#&item='+itm+'&series='+graphseries.value+'&select='+graphselect.value,'listing') 						 
	}
	
	function pivotsubmit() {	
	   itm = document.getElementById('itemselected').value		
	   _cf_loadingtexthtml="";		   
	   ptoken.navigate('#SESSION.root#/#base#/#path#/PivotData.cfm?fileno=#fileno#&item='+itm+'&series='+graphseries.value+'&select='+graphselect.value,'listing','','','POST','pivotform') 						 		   	
	}
		
    function listener(val,series) {
	    <!--- document.getElementById("graphitem").value   = '#url.item#' --->
		document.getElementById("graphselect").value = val
		document.getElementById("graphseries").value = series
		reloadlisting()
		expandArea('vacancyDB','listing');		
	 }
	
    function request(id,alias,node,section,frame,mode,af,av,as,bf,bv,bs,yf,yv,ys,xf,xv,xs,header,srt,condition) {			    
	   
	    try {
	    ProsisUI.createWindow('drillbox', 'Listing', '',{height:600,width:800,modal:true,center:true})	
		// ProsisUI.closeWindow('rightpanel')				
		} catch(e) {}
	    // ColdFusion.Window.show('drillbox')
		ptoken.navigate('#SESSION.root#/#base#/#fil#/PivotDrillSubmit.cfm?xf='+xf+'&yf='+yf+'&xv='+xv+'&yv='+yv,'drillbox') 						
	}	
				
	function inspect(mde) {
		   
	    ProsisUI.createWindow('rightpanel', 'Selection Summary', '',{height:340,width:350,modal:false,center:true})				
		// if (mde == "all") { 
		// Hanno better to show the content of the listing here
		  ptoken.navigate('#SESSION.root#/#base#/#pty#/Property.cfm?fileno=#fileno#','rightpanel') 						 
	    // }		
	}	
	
	function reload(itm,fil,scp) {

	    document.getElementById('itemselected').value  = itm
		document.getElementById('scopeselected').value = scp
	    fmt = document.getElementById('formatselected').value
		Prosis.busy('yes')
		//var iframe = document.getElementById('graphdata'); 
		//iframe.src = "#SESSION.root#/#base#/#path#/GraphData.cfm?scope="+scp+"&format="+fmt+"&ts="+new Date().getTime()+"&fileno=#fileno#&item="+itm; 
	    _cf_loadingtexthtml='';			
		ptoken.navigate("#SESSION.root#/#base#/#path#/GraphData.cfm?scope="+scp+"&format="+fmt+"&ts="+new Date().getTime()+"&fileno=#fileno#&item="+itm,"graphdata")  				
		_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy10.gif'/>";	
		reloadlisting() 
		if (fil == 'yes') {
		ptoken.navigate('#SESSION.root#/#base#/#fil#/Filter.cfm?fileno=#fileno#&item='+itm+"&scope="+scp,'filter') 						 			
	    } 	
	}						
											 
	function printdetail(itm,sel,mode) {
		fmt = document.getElementById('formatselected').value	
		if (mode != 'pivot') {
		ptoken.open("#SESSION.root#/#base#/#path#/Listing.cfm?format="+fmt+"&mode="+mode+"&fileno=#fileno#&print=yes&item="+itm+"&select="+sel,"_blank", "left=35, top=15, width=700, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=yes")  			 		 
		} else {
		ptoken.open("#SESSION.root#/#base#/#path#/PivotData.cfm?format="+fmt+"&mode="+mode+"&fileno=#fileno#&print=yes&item="+itm+"&select="+sel,"_blank", "left=35, top=15, width=700, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=yes")  			 		 			
		}
	} 
									
   function filterapply(itm,no,scp) {
	    ptoken.navigate('#SESSION.root#/#base#/#fil#/FilterSubmit.cfm?item='+itm+'&scope='+scp,'filterapply','','','POST','filterform')		
	}	
		 
</script>

<cf_screenTop height="100%" 
              title="#url.cls#" 
			  border="0" 
			  scroll="no" 
			  jquery="Yes"
			  html="No">
			  
	<table width="100%" height="100%">
	
		 <cfset url.fileNo = fileNo>	 		  
	     <tr><td id="mainbox" style="height:100%" valign="top">
		      <cfinclude template="DetailViewBase.cfm">
		 	 </td>
		 </tr>
	 
	</table>
	
</cfoutput>
