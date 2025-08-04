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

<cfparam name="Layout.ControlId" default="#URL.ControlId#">
<cfparam name="tblInit" default="">
<cfparam name="url.reportid" default="">
<cfparam name="url.mode" default="regular">

<cfajaximport tags="cfprogressbar,cfdiv">

<cfif url.reportId eq "" and url.mode eq "regular">
	<cf_tl id="Export Data to MS Excel" var="1">
	<cf_screentop height="100%" jquery="Yes" scroll="No" layout="webapp" label="#lt_text#" banner="gray" line="no">	 
<cfelse>
    <cf_screentop height="100%" jquery="Yes" scroll="No" html="No" banner="gray">	 
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</cfif>

<cfquery name="TableOutput" 
	datasource="appsSystem">
	SELECT   *
    FROM     Ref_ReportControlOutput
	WHERE    ControlId = '#Layout.ControlId#'  
	ORDER    BY ListingOrder
	<!--- AND Operational = 1 --->
</cfquery>

<div id="divExcelExportWaitText" style="display:none; text-align:center; margin:20%; margin-top:5%; padding:5%; font-size:28px; color:FAFAFA; background-color:rgba(0,0,0,0.7); border-radius:8px;">
	<cf_tl id="Please wait, while your excel file is being generated">
	<br><br>
	<cfprogressbar name="pBar" 
	    style="bgcolor:000000; progresscolor:DB996E; textcolor:FAFAFA;" 
		bind="cfc:Service.Excel.Excel.getstatus()" 
		height="20" 
		onComplete="hideprogress"
		interval="800" 
		autoDisplay="false" 
		width="600"/> 
</div>

<cfoutput>

<script language="JavaScript">

 	 function reload(cur,id,tbl)	{
	
		 count = 1
		 $('##mainmenu').addClass('hide');
		 $('##menu1').click();
	
		 while (count < 10)  {
		  se = document.getElementById("r"+count)
		  if (se) { se.bgColor = "white" }
		  count++
		 }
	  	
	   	 se = document.getElementById("r"+cur)
	   	 se.bgColor = "f4f4f4"
		 Prosis.busy('yes')		
	     ptoken.navigate('#SESSION.root#/Tools/Cfreport/ExcelFormat/FormatExcelDetail.cfm?mode=#url.mode#&reportid=#url.reportid#&ID='+id+'&Table='+tbl,'contentbox1')
	
	     }
								  		
		 function fieldadd(name,cls,id,tbl,format) {
		     _cf_loadingtexthtml='';									 
			 ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcelAddField.cfm?mode=#url.mode#&name='+name+'&class='+cls+'&reportid=#url.reportid#&id='+id+'&table='+tbl+'&format='+format,'contentbox1')			 			 
		 }
		 
		 function pointeradd(val,cls,id,tbl) {
		     _cf_loadingtexthtml='';	
			 ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcelPointer.cfm?mode=#url.mode#&value='+val+'&class='+cls+'&reportid=#url.reportid#&id='+id+'&table='+tbl,'aggregate')			
		 }
		 
		 function update(mode,name,action,id,box,tbl,ds) {
		     _cf_loadingtexthtml='';	
		 	 ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcelUpdateField.cfm?ds='+ds+'&table='+tbl+'&mode='+mode+'&name='+name+'&action='+action+'&id='+id+'&box='+box,box,'','','POST','formselectedfields')			
		 }
		 
		 function fielddelete(name,id,tbl) {
		     _cf_loadingtexthtml='';				 
		 	 ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcelDeleteField.cfm?mode=#url.mode#&name='+name+'&reportid=#url.reportid#&id='+id+'&table='+tbl,'contentbox1')			 
		 }
		 
		 function savefilter(id,tbl) {
		     _cf_loadingtexthtml='';			
		     ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcelSaveFilter.cfm?mode=#url.mode#&id='+id,'filterbox','','','POST','filterform')			  
		 } 
		 
		 function openexcel(mode,id,tbl) {		 
		 	if (mode == "open") {
			    ptoken.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/"+tbl+".xls?ts="+new Date().getTime(),"_blank")
			} else {			  
				ProsisUI.createWindow('maildialog', 'Mail Excel', '',{x:100,y:100,height:625,width:860,resizable:false,modal:true,center:true});
				ptoken.navigate('FormatExcelMail.cfm?ID1=Extracts&ID2='+tbl+'.xls&Source=ReportExcel&Sourceid='+id+'&Mode=cfwindow&GUI=HTML','maildialog')		
			}		 
		 }
		 
		 function prepare(mode,id,tbl) {
		 
		 	 //disable buttons
		 	 Prosis.busy('yes', 'divExcelExportWaitText');
		 	 $('##divExcelExportContainer').animate({
    			scrollTop: $("##divExcelExportContainer").position().top
			 });
		 	 window['__cbPrepareExcel'] = function(){ Prosis.busy('no', 'divExcelExportWaitText'); };

		 	 // show progress bar
			 ColdFusion.ProgressBar.stop('pBar', true)		
			 ColdFusion.ProgressBar.start('pBar'); 			 
			 
			 if (mode == "view") {
			    ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/ExcelPrepare.cfm?acc=#SESSION.acc#&mode=view&id='+id+'&tbl='+tbl,'processpreview', '__cbPrepareExcel');				
			 } else {
		 	    ptoken.navigate('#SESSION.root#/Tools/CFReport/ExcelFormat/ExcelPrepare.cfm?acc=#SESSION.acc#&mode=mail&id='+id+'&tbl='+tbl,'processpreview', '__cbPrepareExcel');
			 }
			 
		 }
		 
		 function hideprogress() {		 
		     ColdFusion.ProgressBar.hide('pBar')
		     ColdFusion.ProgressBar.stop('pBar', true)			   			
		 }
		 
		 function mailclose() {		 
		 	 ProsisUI.closeWindow('maildialog')
		 }
		 		
</script>

</cfoutput>

<cfif isDefined("url.table1")>
	<cfset table1 = url.table1>	
</cfif>
<cfif isDefined("url.table2")>
	<cfset table2 = url.table2>	
</cfif>
<cfif isDefined("url.table3")>
	<cfset table3 = url.table3>	
</cfif>
<cfif isDefined("url.table4")>
	<cfset table4 = url.table4>	
</cfif>
<cfif isDefined("url.table5")>
	<cfset table5 = url.table5>	
</cfif>
<cfif isDefined("url.table6")>
	<cfset table6 = url.table6>	
</cfif>
<cfif isDefined("url.table7")>
	<cfset table7 = url.table7>	
</cfif>
<cfif isDefined("url.table8")>
	<cfset table8 = url.table8>	
</cfif>
<cfif isDefined("url.table9")>
	<cfset table9 = url.table9>	
</cfif>
<cfif isDefined("url.table10")>
	<cfset table10 = url.table10>	
</cfif>

<table style="height:100%;width:100%">
<tr><td style="height:100%" id="divExcelExportContainer"><cfinclude template="FormatExcelSelect.cfm"></td></tr>
</table>	

<cfif url.reportId eq "" and url.mode eq "regular">
	<cf_screenbottom layout="webapp">
</cfif>

