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
<!--- 1. this is the container for the 3 elements of the drill down  --->

<cf_screentop height="100%" scroll="Yes" html="No">

<!--- do not change --->

<cfparam name="URL.Date" default="">
<cfparam name="URL.HideTop" default="true">

<cfif URL.Date neq "">
	
	<cfquery name="Audit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Audit
	WHERE Period = '#URL.Period#'
	</cfquery>
	
	<cfparam name="URL.AuditId" default="{3334053E-18D9-49F5-BD14-3553F17D3DC7}">
	
	<cfoutput query="Audit">
	
		<cfif DateFormat(AuditDate,"MMM YY") eq #URL.Date#>
			<cfset URL.AuditId = "#AuditId#">
		</cfif>
			
	</cfoutput>

<cfelse>

	<cfquery name="Audit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Audit
	WHERE AuditId = '#URL.AuditId#'	
	</cfquery>
	
	<cfset url.period = audit.period>
	
</cfif>


<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM  Program P, ProgramPeriod Pe, ProgramIndicator PI
	WHERE PI.TargetId = '#URL.TargetId#'
	AND PI.ProgramCode = Pe.ProgramCode
	AND PI.Period = Pe.Period
	AND Pe.ProgramCode = P.ProgramCode
</cfquery>

<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Indicator
	WHERE IndicatorCode = '#Program.IndicatorCode#'
</cfquery>

<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td height="100%">

<cfif Indicator.IndicatorTemplate neq "" and Indicator.IndicatorTemplateAjax eq "1">
	
		<link href="<cfoutput>#SESSION.root#/tools\pivot\crosstab.css</cfoutput>" rel="stylesheet" type="text/css">
	
	    <cfajaximport tags="cfform,cfdiv,cfmenu,cfwindow">
		
		<cfset FileNo = round(Rand()*100)>
		
		<cfset l    = len(Indicator.IndicatorTemplate)>		
		<cfset path = left(Indicator.IndicatorTemplate,l)>	
		<cfset cnt = 0>
		<cfloop index="itm" list="#Indicator.IndicatorTemplate#" delimiters="/">
		   <cfset cnt = cnt+1>		   
		</cfloop>
		
		<cfset parent = "">
		<cfset par = 0>
		<cfloop index="itm" list="#Indicator.IndicatorTemplate#" delimiters="/">
		   <cfset par = par+1>
		   <cfif par lt cnt-1>
			   	<cfif parent eq "">
					<cfset parent = "#itm#">
				<cfelse>
					<cfset parent = "#parent#/#itm#">
				</cfif>		     
		   </cfif>		   
		</cfloop>	
		
		<cfset parent = "#parent#/template">
								
		<!--- storage for generatel filter --->
		<cfset client.programgraphfilter = "">
		<!---
		<cfparam name="client.programgraphfilter" default="">
		--->
		<!--- storage for pivot selection --->
		<cfset client.programgraphfilter = "">
		<cfparam name="client.programpivotfilter" default="">
		<!--- storage for listing/pivot show filter --->
		<cfparam name="client.programdetail" default="pivot">
				
		<cfif fileExists("#SESSION.rootpath#\#path#\Property.cfm")>
			<cfset pty = "#path#">							
		<cfelseif fileExists("#SESSION.rootpath#\#parent#\Property.cfm")>
			<cfset pty = "#parent#">					
		</cfif>	
		
		<cfif fileExists("#SESSION.rootpath#\#path#\Filter.cfm")>
			<cfset fil = "#path#">							
		<cfelseif fileExists("#SESSION.rootpath#\#parent#\Filter.cfm")>
			<cfset fil = "#parent#">					
		</cfif>	
		
		<cfif fileExists("#SESSION.rootpath#\#path#\IndicatorTarget.cfm")>
			<cfset par = "#path#">							
		<cfelseif fileExists("#SESSION.rootpath#\#parent#\IndicatorTarget.cfm")>
			<cfset par = "#parent#">					
		</cfif>	
								
		<cfoutput>
		
		<cf_dialogStaffing>		
		
		
		<input type="hidden" name="graphitem" id="graphitem">
		<input type="hidden" name="graphselect" id="graphselect">
		<input type="hidden" name="graphseries" id="graphseries">
		
			<script>
						
			function facttablexls1(control,format,box) {
			    ColdFusion.Ajax.submitForm('formselect','#SESSION.root#/#fil#/SelectedRecord.cfm')
				w = #CLIENT.width# - 80;
			    h = #CLIENT.height# - 110;	
				<!---	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?data=1&controlid="+control+"&format="+format, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");	--->
			    window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?data=1&controlid="+control+"&format="+format+"&ts="+new Date().getTime(), "facttable", "unadorned:yes; edge:raised; status:no; dialogHeight: "+h+" px; dialogWidth:"+w+" px; help:no; scroll:no; center:yes; resizable:no");
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
			 ColdFusion.navigate('#SESSION.root#/#par#/DetailNavigate.cfm','listing') 						 
						  
	    	}   
			
			function list(mode) {   			
						 
			 if (mode == "undefined") {
			   mode = "listing"
			 }							 					    
			   ColdFusion.navigate('#SESSION.root#/#path#/Listing.cfm?mode='+mode+'&fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item='+graphitem.value+'&series='+graphseries.value+'&select='+graphselect.value+crit,mode) 			
			   ColdFusion.Window.create('rightpanel', 'Selection Summary', '',{height:340,width:350,modal:false,center:true})				  
    		   ColdFusion.Window.hide('rightpanel')
	    	   ColdFusion.navigate('#SESSION.root#/#pty#/Property.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item='+graphitem.value+'&series='+graphseries.value+'&select='+graphselect.value+crit,'rightpanel') 						 
			  
			 }						
						
			function pivot() {
			   ColdFusion.navigate('#SESSION.root#/#path#/PivotData.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item='+graphitem.value+'&series='+graphseries.value+'&select='+graphselect.value,'listing') 						 
			}
			
			function pivotsubmit() {			   
			   ColdFusion.navigate('#SESSION.root#/#path#/PivotData.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item='+graphitem.value+'&series='+graphseries.value+'&select='+graphselect.value,'listing','','','POST','pivotform') 						 		   	
			}
			
		    function request(id,alias,node,section,frame,mode,af,av,as,bf,bv,bs,yf,yv,ys,xf,xv,xs,header,srt,condition) {			    
			    try {
			    ColdFusion.Window.create('drillbox', 'Listing', '',{height:600,width:800,modal:true,center:true})	
				ColdFusion.Window.hide('rightpanel')				
				} catch(e) {}
			    ColdFusion.Window.show('drillbox')
				ColdFusion.navigate('#SESSION.root#/#fil#/PivotDrillSubmit.cfm?xf='+xf+'&yf='+yf+'&xv='+xv+'&yv='+yv,'drillbox') 						
			}
			
			function inspect(mde) {
			
			    ColdFusion.Window.create('rightpanel', 'Selection Summary', '',{height:340,width:350,modal:false,center:true})		
				ColdFusion.Window.show('rightpanel')
				if (mde == "all") { 
				  ColdFusion.navigate('#SESSION.root#/#pty#/Property.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#','rightpanel') 						 
			    }
				
			}						
							
		 	function reload(itm,fil) {
			window.open("#SESSION.root#/#path#GraphData.cfm?ts="+new Date().getTime()+"&fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item="+itm,"graphdata")  
			reloadlisting()
			if (fil == 'yes') {
			ColdFusion.navigate('#SESSION.root#/#fil#/Filter.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item='+itm,'filter') 						 			
			} 
			
			} 
									 
			function printdetail(itm,sel,mode) {
			if (mode != 'pivot') {
			window.open("#SESSION.root#/#path#Listing.cfm?mode="+mode+"&fileno=#fileno#&print=yes&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item="+itm+"&select="+sel,"_blank", "left=35, top=15, width=700, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=yes")  			 		 
			} else {
			window.open("#SESSION.root#/#path#Pivotdata.cfm?mode="+mode+"&fileno=#fileno#&print=yes&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#&item="+itm+"&select="+sel,"_blank", "left=35, top=15, width=700, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=yes")  			 		 			
			}
			} 
			
						
		   function filterapply(itm) {
		      
			    ColdFusion.navigate('#SESSION.root#/#fil#/FilterSubmit.cfm?item='+itm,'filterbox','','','POST','filterform')
				<!--- is done by the method reload(itm,'No') --->
			}			
			 
			</script>
			
					
		</cfoutput>
					
	    <!--- load container ---> 	
		
		<cfset attrib = {type="Border",name="mainbox",fitToWindow="Yes"}> 
		
		<cflayout attributeCollection="#attrib#">	
						
			<cflayoutarea  
			position      = "top"
			title         = "Indicator" 
			name          = "indicator"	
			collapsible   = "true"	
			style         = "height:170"
			initcollapsed = "#url.hidetop#"
			overflow      = "auto"
			source        = "DetailViewBaseTop.cfm?period=#url.period#&targetid=#url.targetid#&auditid=#url.auditid#"
			splitter      = "true"/>	
				
			<cflayoutarea  
				position      = "center"			
				name          = "graph"				
				style         = "height:330"	
				overflow      = "hidden">					
				
				<cfif fileExists("#SESSION.rootpath#\#path#\Graph.cfm")>
						<cfinclude template="../../../../#path#/Graph.cfm">																			
				<cfelseif fileExists("#SESSION.rootpath#\#parent#\Graph.cfm")>
					    <cfinclude template="../../../../#parent#/Graph.cfm">											
				<cfelse>
				  Not found				
				</cfif>	
				
			</cflayoutarea>		
			
			<cflayoutarea 
	          position="right"
	          name="filter"          
			  source="#SESSION.root#/#fil#/Filter.cfm?fileno=#fileno#&indicator=#Program.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#" 						 						
	          maxsize="750"
	          size="150"
	          overflow="hidden"
	          collapsible="true"
	          initcollapsed="false"
	          splitter="true"/>
			
			<cflayoutarea 
		          position    = "bottom"
				  collapsible = "true"
				  style       = "height:#client.height-466#"				  
				  splitter    = "true"
				  overflow    = "auto"
				  title       = "Details"
		          name        = "listing"/>
				  							   		
		</cflayout>
		
		
</cfif>

</td></tr>
</table>
