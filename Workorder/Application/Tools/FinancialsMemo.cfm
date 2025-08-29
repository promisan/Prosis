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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/print.css</cfoutput>" media="print"> 

<style type="text/css">
	td.memocontent{
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 8pt;
			font-weight:normal;
			align : justify;
		}
</style>
</head>
<body>

<cfparam name="url.mission" default="O">
<cfparam name="url.serviceitem" default="CU001">
<cfparam name="sel" default="#createdate(2012,4,1)#">
<cfparam name="selend" default="#createdate(2012,4,30)#">
<cfparam name="url.memo" default="0">

<cfquery name="Parameter" 
	datasource="NovaInit" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT *
	FROM   Parameter
</cfquery>

<cfif isdefined("ProcessService") eq "0" or ProcessService eq "">
	<cfset ProcessService = url.serviceitem>
</cfif>

<cfset DirName = DateFormat(selend,"YYYYMM")>	

<cfoutput>
	<cfset vPath = "#Parameter.DocumentRootPath#\ServiceFinancialsMemo\#URL.Mission#\#DirName#\#ProcessService#">

	<cfif not DirectoryExists(vPath)>				
		<cfdirectory action="CREATE" 
		   directory="#vPath#">	   
	</cfif>

</cfoutput>



<cfdocument 
	    filename="#vPath#\FinancialMemo.pdf"
	    format="PDF"
	    pagetype="letter"
		margintop="0.3" 
		marginright="0.5" 
		marginleft="0.5" 
		marginbottom = "1" 
	    orientation="portrait"
	    unit="in"
	    encryption="none"
	    fontembed="Yes"
	    overwrite="Yes"
	    backgroundvisible="Yes"
	    bookmark="True"
	    localurl="No">		

	<cfoutput>		

<!---	
	<cfdocumentitem type="footer">
		<table width="100%" height="100%" cellspacing="0" cellpadding="3">
		<tr><td style="#td05#"><cfinclude template="StatementOfAwardFooter.cfm"></td></tr>
		</table>
	</cfdocumentitem>	 
--->	


	<cfdocumentsection name="subject" marginbottom="0.3" >

		<table width="100%" height="100%" cellspacing="0" cellpadding="3">
		<tr><td><cfinclude template="FinancialsMemoData.cfm"></td></tr>
		</table>	

	</cfdocumentsection>

	</cfoutput>

</cfdocument>	



	<cfquery name="User" 
		datasource="NovaSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *
		FROM   UserNames
		WHERE Account = '#SESSION.acc#'
	</cfquery>
		
<cfif url.memo eq "1">
	<cfif User.recordcount gt "0">
		<cfif User.eMailAddress neq "">
		
			 	<cfset mailFromName = "O - Cost Recovery">
				<cfset mailFromAddress = "dev@email">
				<cfset mFrom	= "#mailFromName#<#mailFromAddress#>">		
		
				<cfmail TO          = "#User.eMailAddress#" 
						FROM        = "#mFrom#"
						SUBJECT     = "Financial Memo - #getServiceItem.Description#"
						TYPE        = "html"
						spoolEnable = "Yes"
						wraptext    = "100">
												
					<cfmailparam file="#vPath#\FinancialMemo.pdf">
					
				</cfmail>
		
		</cfif>
	</cfif>
</cfif>


</body>
