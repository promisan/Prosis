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
	
<cf_wait Text="Preparing Personal History Profile">

<cfflush>

<cfquery name="Clear" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      DELETE RosterSearch 
   	  WHERE  Status = '0' 
	  AND    OfficerUserId = '#SESSION.acc#'
	  AND    Created > GetDate()-1
	  AND    SearchId NOT IN (SELECT SearchId FROM RosterSearchLine)
     </cfquery>
	 
<cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter SET SearchNo = SearchNo+1
     </cfquery>

<cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM Parameter</cfquery>
	 
<cfset LastNo = #LastNo.SearchNo#>
        
<cfquery name="InsertSearch" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RosterSearch
         (SearchId,
		 Owner,
		 Description,
		 Mode,
		 SearchCategory,
		 SearchCategoryId,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
      VALUES ('#LastNo#',
	  	  'DPKO',
	      'Print from Applicant', 
		  'Applicant',
		  'Applicant',
		  'Applicant',
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.DateSQL)#')
    </cfquery>


<!---
<cfquery name="Empty" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   DELETE FROM RosterSearchResult
	   WHERE SearchId = '#LastNo#'
	  </cfquery>
--->

<cfquery name="Add" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO RosterSearchResult
	    (SearchId, PersonNo, Status)
	    VALUES 
		(#LastNo#,'#URL.ID1#',1)
</cfquery>	

<cfoutput>

<cfif not DirectoryExists("#SESSION.rootPath#\rptFiles\pdfLibrary\Staffing\#SESSION.acc#")>
      <cfdirectory action="CREATE" 
      directory="#SESSION.rootPath#\rptFiles\pdfLibrary\Staffing\#SESSION.acc#">
</cfif>

<form action="#SESSION.root#/Tools/PDF/show_report.asp" method="post" name="pdf" target="php">

   <input type="hidden" name="filetype" value="Adobe PDF" size="20">
   <input type="hidden" name="filename" value="PHP.pdf">
      
   <!--- crystal report file --->
   <input type="hidden" name="engine" value="#CLIENT.crystalengine#">
   <input type="hidden" name="report_file" value="#SESSION.rootpath#\rptFiles\Roster\php.rpt">
   
   <!--- crystal parameters --->
   <input type="hidden" name="pm_SearchID" value="#lastNo#">

   <!--- location --->
   <input type="hidden" name="filepath" value="#SESSION.rootPath#\rptFiles\PDFLibrary\Staffing\#SESSION.acc#\">
   <input type="hidden" name="caller" value="#SESSION.root#/rptFiles/PDFLibrary/Staffing/#SESSION.acc#/PHP.pdf">
     
  
</form>   

<script language="JavaScript">

{
// alert (#lastno#)
 document.pdf.filename.value = pdf.filepath.value+pdf.filename.value 
 this.focus()
 pdf.submit() 
   
 }
 
</script>


</cfoutput>


  

