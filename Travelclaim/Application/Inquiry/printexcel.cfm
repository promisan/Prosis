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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
<title>Print</title>
</head>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="1">

<link rel="stylesheet" type="application/msexcel"  href="#SESSION.root#/#client.style#">





	<cfsavecontent  variable="MySummary">
			 
				<cfinclude template="ClaimviewDetails.cfm">
			 
	</cfsavecontent>
			<!--- this coldfusion function creates the excel file  output="#replace(MySummary,"   " ,"","all")#" --->
			<!---
			<cfheader name="Content-Disposition" value="attachment; filename=#SESSION.rootpath#\Summaryexcel.xls">
			<cfcontent type="application/msexcel" reset="yes"> 
			<cfoutput >
			#MySummary#
			</cfoutput>
--->

		<cffile action="WRITE" 
    	 file="#SESSION.rootpath#\Summaryexcel.xls" 
				 output="#MySummary#" 
		 addnewline="yes" fixnewline="no"> 
		
		<!--- this coldfusion function  inport the data contained in MyContent variable --->
		



		
		
		<cfcontent
			type = "application/vnd.ms-excel" 
			deleteFile = "no"   
			file = "#SESSION.rootpath#\Summaryexcel.xls"   
			reset = "no">
			



</body>
</html>
