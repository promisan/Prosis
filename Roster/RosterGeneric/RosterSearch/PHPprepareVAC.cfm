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
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Applicant profile (PHP)</title>
</head>



<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
<cf_wait Text="Preparing Personal History Profile - vacancy module">

<cfflush>
 
<cfoutput>

<form action="#SESSION.root#/Tools/PDF/show_report.asp" method="post" name="pdf" target="php">

   <input type="hidden" name="filetype" value="Adobe PDF" size="20">
   <input type="hidden" name="filename" value="PHPvac.pdf">
      
   <!--- crystal report file --->
   <input type="hidden" name="engine" value="#CLIENT.crystalengine#">
   <input type="hidden" name="report_file" value="#SESSION.rootpath#\rptFiles\Roster\PHPvac.rpt">
   
   <!--- crystal parameters --->
   <input type="hidden" name="pm_pPersonNo" value="#URL.ID1#">
  
   <!--- location --->
   <input type="hidden" name="filepath" value="#SESSION.rootPath#\rptFiles\PDFLibrary\Staffing\#SESSION.acc#\">
   <input type="hidden" name="caller" value="#SESSION.root#/rptFiles/PDFLibrary/Staffing/#SESSION.acc#/PHPvac.pdf">
     
  
</form>   

<script language="JavaScript">

{
 
 document.pdf.filename.value = pdf.filepath.value+pdf.filename.value 
 this.focus()
 pdf.submit() 
   
 }
 
</script>


</cfoutput>

  

