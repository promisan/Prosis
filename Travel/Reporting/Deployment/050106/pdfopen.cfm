<!---
File:		pdfopen.cfm
Desc:		Process call to show_report.asp which in turn generates/displays the PDF report
Called by:	ParameterEdit.cfm
Calls:		show_report.asp
Modification history:
--->
<cf_PreventCache>

<cfoutput>
<table width="100%" border="0">
<tr><td height="150" align="center"><b><img src="#CLIENT.Root#/Images/equalizer.gif" alt="" width="61" height="50" border="0" align="middle"></td></tr>
<tr><td height="20" align="center"><b>Report being generated. Please stand by...</b></td></tr>
</table>
</cfoutput>

<cfflush>

<cfquery name="Get" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
       SELECT  *
       FROM  Ref_ModuleControl
	   WHERE ControlNo  = '#Form.report_file#'
</cfquery>
 
<cfoutput>

<form action="#CLIENT.root#/Tools/PDF/show_report.asp" method="POST" name="pdf" id="pdf">

   <input type="hidden" name="filetype" value="#FORM.filetype#" size="20">
   <input type="hidden" name="engine" value="#CLIENT.crystalengine#">
   
   <!---
   <input type="hidden" name="login" value="#SESSION.login#" size="20">
   <input type="hidden" name="password" value="#SESSION.dbpw#" size="20">
   <input type="hidden" name="dbase" value="REMProgram" size="20">
   <input type="hidden" name="dsn" value="AppsTest" size="20">
   --->
   
   <!--- crystal report file --->
   <input type="hidden" name="report_file" value="#CLIENT.rootpath#\#Get.FunctionPath#">
   
   <!--- crystal parameters --->
   <input type="hidden" name="pm_mission" value="#FORM.pm_Mission#">
   <input type="hidden" name="pm_mandateno" value="#FORM.pm_MandateNo#">
   <input type="hidden" name="pm_posttype" value="#FORM.pm_PostType#">   
   <input type="hidden" name="pm_startdate" value="#FORM.pm_StartDate#">
   <input type="hidden" name="pm_enddate" value="#FORM.pm_EndDate#">   
   
   <!--- resulting pdf file location --->
   <input type="hidden" name="filepath" value="#FORM.filePath#">
   <cfif #Form.filetype# eq "Microsoft Word">
       <input type="hidden" name="filename" value="#FORM.filename#_.doc">
   <cfelse>
       <input type="hidden" name="filename" value="#FORM.filename#_.pdf">
   </cfif>
   
   <!--- return to parameter edit screen --->
   <input type="hidden" name="caller" value="#FORM.caller#"> 
</form>   

<script language="JavaScript">
{
 document.pdf.filename.value = pdf.filepath.value+"#Get.FunctionName#_"+pdf.filename.value 
 pdf.submit()
 }
</script>

</cfoutput>