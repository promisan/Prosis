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

<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>
</cfoutput>
</head>

<cfparam name="URL.ID"      default="">
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period"  default="">
<cfparam name="URL.Header"  default="0">
<cfparam name="URL.menu"    default="1">
<cfparam name="URL.search"  default="">

<div id="drefresh" class="hide"></div>

<cfparam name="url.role" default="ProcReqReview">

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#url.Mission#'
</cfquery>

<cf_tl id="REQ028" var="1">
<cfset vReq028=lt_text>
	
<cfif Parameter.recordcount eq "0">
	<cf_message message = "#vReq028#"
     return = "">
	 <cfabort>
</cfif>

<cfif URL.Period eq "">	
	<cfset URL.Period = "#Parameter.DefaultPeriod#">
</cfif>

<!--- now define the scripts, do not put these above the period --->

<cf_listingscript>
<cf_DialogREMProgram>
<cf_DialogProcurement>
<cf_DialogMaterial>
<cf_AnnotationScript>
<cf_FileLibraryScript>
<cf_menuScript>
<cf_DialogStaffing>


<cfajaximport tags="cfwindow,cfform,cfdiv">

<cf_tl id="Do you want" var="1">
<cfset dyw=#lt_text#>

<cf_tl id="selected requisition lines" var="1">
<cfset srl=#lt_text#>


<cf_tl id="process" var="1">
<cfset vprocess =#lt_text#>

<cf_tl id="assign" var="1">
<cfset vassign =#lt_text#>


<cfset fun = "0">	

<cfoutput>

<script>

function facttablexls1(control,format,box) {  
    // here I could capture the client variable if this is better for large selections 
	ptoken.navigate('RequisitionViewSelected.cfm','process','','','POST','req')  	
	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&box="+box+"&data=1&controlid="+control+"&format="+format, "facttable");
}	

// function AddVacancy(pos,req) {
//	 ret = window.showModalDialog("#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?Mission=#URL.Mission#&ID1=" + pos + "&box=" + req + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:640px; dialogWidth:700px; help:no; scroll:yes; center:yes; resizable:yes");
//	 ColdFusion.navigate('../Position/PositionFunding.cfm?reqid='+req,'pos'+req)			 		   			 	 	
//}


function mail2(mode,id) {
	  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}	

function process(id) {
	   ptoken.open("#SESSION.root#/ActionView.cfm?id=" + id, id);	   
	}

function hl(val,line){	 
		 
     ln1 = document.getElementById(line+"_1");
	 //ln2 = document.getElementById(line+"_2");
	 //ln3 = document.getElementById(line+"_3");
	 //ln5 = document.getElementById(line+"_5");	 	 		 	
	 if (val == '1'){		    
		 ln1.className = "highLight2";
		// ln2.className = "highLight2";
		// ln3.className = "highLight2";
		// ln5.className = "regular";				 
	 }else{	 
	 ln1.className = "header";		
	 //ln2.className = "header";
	 //ln3.className = "header";
	 //ln5.className = "hide";	
	 }
	
  }
  
function hla(itm,val,fld){

     se = document.getElementById(itm+'_0')	
	
	 if (fld != false) {
		 se.className = "highLight5";
		 document.getElementById(itm).value = val		
		  try {				
			 document.getElementById(itm+'_1').className = "regular"						
			 document.getElementById(itm+'_2').className = "regular"			
			 } catch(e) {}	
	 } else { 
	      se.className = "header"; 
		   document.getElementById(itm).value = ""
		  try {
			 document.getElementById(itm+'_1').className = "hide"
			 document.getElementById(itm+'_2').className = "hide"
			 } catch(e) {}	
	 }
	 	
  }    
      

function reason(row,box,req,cls,st) {   
    _cf_loadingtexthtml='';	 
    ptoken.navigate('RequisitionProcessReason.cfm?row='+row+'&requisitionno='+req+'&statusclass='+cls+'&status='+st,box+'_reason')	
}   


function search(itm) {
	 if (window.event.keyCode == "13") {	
    	reqsearch()	
		try {
		document.getElementById(itm).onkeyup=new Function("return false")  } catch(e) {} 		
     } 	
}
 
function reqsearch() {  
    pag   = document.getElementById('page').value
    per   = document.getElementById('periodsel').value       
	unit  = document.getElementById('pending_unit').value
	val   = document.getElementById('pending_search').value
	ann   = document.getElementById('annotationsel').value	
	fun   = document.getElementById('fundsel').value			
	fund  = document.getElementById('fundcode').value		
    ptoken.navigate('RequisitionClearPending.cfm?page='+pag+'&role=#url.role#&mission=#url.mission#&period='+per+'&search='+val+'&unit='+unit+'&annotationid='+ann+'&fun='+fun+'&fund='+fund,'contentbox1')
}  
  

function processdata(txt,per,role) {
	
	if (txt == 'process')
	{
		txt = '#vprocess#'
	}

	if (txt == 'assign')
	{
		txt = '#vassign#'
	}
	
	if (confirm("#dyw# "+txt+" #srl# ?"))	{
	 Prosis.busy('yes')  
	ptoken.navigate('RequisitionClearSubmit.cfm?role='+role+'&mode=process&mission=#URL.Mission#&period='+per,'contentbox1','','','POST','req')
	}
}
	
</script>


<cfsavecontent variable="option">
	<cfinclude template="RequisitionPeriod.cfm">			
</cfsavecontent>		

</cfoutput>			

<cfif url.header eq "1">
	<cfset html = "Yes">
<cfelse>
	<cfset html = "no">
</cfif>			

<cfif url.role eq "ProcReqReview">
	<cf_screentop html="#html#" banner="Gray" jQuery="Yes" height="100%" label="Requisition - Clearance" scroll="no" layout="webapp" user="yes">	
<cfelse>
	<cf_screentop html="#html#" banner="Gray" jQuery="Yes" height="100%" label="Requisition - Approval" scroll="no" layout="webapp"  user="yes">
</cfif>
   
  
<table width="100%" height="100%">

<tr><td>

<table width="100%" height="100%" style="padding-left:10px;padding-right:10px">

<tr class="line"><td style="height:10px">

	    <!--- ---------------------------------- --->
		<!--- ---------- TOP MENU -------------- --->
		<!--- ---------------------------------- --->
				
		<cfoutput>
		
		<table width="100%">		  		
						
			<cfset ht = "48">			
			<cfset wd = "48">
			
			<cfset add = 1>
					
				<tr>			
				
					<cf_tl id="Process Pending Requests" var="vProcess">
					<cf_tl id="Recent Clearances" var="vRecent">
				
					<cfif url.role eq "ProcReqReview">
						<cf_tl id="Review" var="1">
					<cfelse>
						<cf_tl id="Approval" var="1">
					</cfif>					
					
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/Procurement/Submit.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight"
								name       = "#vProcess#"
								script     = "document.getElementById('periodlist').className = 'regular'"
								source     = "RequisitionClearPending.cfm?role=#url.role#&mission=#url.mission#&period={periodsel}">			
				
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos/Procurement/Recent.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "#vRecent#"
								script     = "document.getElementById('periodlist').className = 'hide'"
								source     = "RequisitionProcessLog.cfm?systemfunctionid=#url.systemfunctionid#&role=#url.role#&mission=#url.mission#&period={periodsel}">			
								
					<!--- check for report --->
					
					<cfset item = 2>
					
					<cftry>
										
					<cfquery name="Module" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ModuleControl
						WHERE    SystemFunctionId = '#url.systemfunctionid#'
					</cfquery>
					
					<cfif Module.recordcount eq "1">
						
						<cfquery name="Report" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_ReportControl
							WHERE    Operational = 1
							AND      SystemModule = '#module.SystemModule#'
							AND      SystemFunctionName = '#module.FunctionName#'
						</cfquery>
												
						<cfif report.recordcount gte "1">
						
							<cfloop query = "Report">
							
								<cfset item = item+1>
							
								<cf_menutab item  = "#item#" 
						            iconsrc       = "Logos/Procurement/Listing.png" 
									iconwidth     = "#wd#" 
									iconheight    = "#ht#" 
									name          = "<i><u>rpt:</u></i>&nbsp;#FunctionName#"
									source        = "report:#controlid#">			
					
							</cfloop>
						
						</cfif>					
					
					</cfif>
					
					<cfcatch></cfcatch>
					
					</cftry>
											
					<cfset item = item+1>		
										
					<cf_tl id="Extended Inquiry" var="1">
					<cfset tInquiry = "#Lt_text#">
						
					<cfinvoke component="Service.Analysis.CrossTab"  
						  method      = "ShowInquiry"
						  buttonName  = "Analysis"
						  buttonClass = "variable"		  
						  buttonIcon  = "Logos/Procurement/Inquiry.png"
						  buttonText  = "#tInquiry#"
						  buttonStyle = "height:29px;width:120px;"
						  reportPath  = "Procurement\Application\Requisition\Portal\"
						  SQLtemplate = "RequisitionFactTable.cfm"
						  queryString = "mission=#URL.Mission#&period={periodsel}"
						  dataSource  = "appsQuery" 
						  module      = "Procurement"
						  reportName  = "Facttable: Requisition"
						  olap        = "1"
						  target      = "analysisbox"
						  table1Name  = "Funded Requisitions"							
						  filter      = "1"
						  returnvariable = "script"> 	
						  
				  	<cf_menutab item       = "#item#" 
			            iconsrc    = "Logos/Procurement/Inquiry.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#tInquiry#"
						script     = "document.getElementById('periodlist').className = 'hide'"
						source     = "javascript:#script#">		
																										 		
				</tr>
		</table>
					
		</cfoutput>			

	 </td>
</tr>

<cfoutput>

	<tr style="height:10px"><td>#option#</td></tr>
		
</cfoutput>
 
<tr><td height="100%">
	
	<!--- ------------------------------------ --->
	<!--- ---------- CONTAINERS -------------- --->
	<!--- ------------------------------------ --->
	
	<table width="100%" height="100%">	  
	 		
			<tr class="hide"><td valign="top" height="100" id="result"></td></tr>
					
			<!--- container 1 for processing advanced --->	
			<tr id="box1" name="box1">
									  
			   <td height="100%" width="100%" valign="top" style="padding-right:10px">
			   
			   	   <cfoutput>				   
				   <cfform name="req" method="post" style="height:100%">		   
				  			  
						 <cf_securediv bind="url:RequisitionClearPending.cfm?role=#url.role#&mission=#url.mission#&period=#url.period#&search=#URL.search#" id="contentbox1">							 						  
						
				   </cfform>					
				   </cfoutput>
			   
			   </td>
		    </tr>
				
			<!--- container 2 --->			
			<cf_menucontainer item="2" class="hide">	
				
			<!--- report containers --->
			<cfset item = "2">						
			
			<cftry>
			
			<cfif report.recordcount gte "1">
						
				<cfloop query = "Report">
				
					<cfset item = item+1>					
					<cf_menucontainer item="#item#" class="hide" iframe="reportbox#item#">
				
				</cfloop>
			
			</cfif>
			
			<cfcatch></cfcatch>
			
			</cftry>
			
			<!--- last container --->			
			<cfset item = item+1>						
			<cf_menucontainer item="#item#" class="hide" iframe="analysisbox">
						 
			</tr>
			
	</table>
	
</td></tr>

</table>
</td></tr>

</table>

<cf_screenbottom layout="webapp">