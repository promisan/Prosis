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

    <!---
	
	<cfpdfform
		action = "read"
		source = "#SESSION.rootPath#\Procurement\Application\Quote\Invitation\RequestForQuote.pdf"
		result = "pdfdata"/>				
		<cfdump var="#pdfdata#" output="browser">
	--->
		
	<style>
	TD {
		padding : 1px;
		font : Times New Roman;
		height : 10;
	}
	</style>
	
	<cfdocument 
          filename="#SESSION.rootDocumentPath#\WFObjectReport\RequestForQuote_data.pdf"
          format="PDF"
          pagetype="letter"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          overwrite="Yes"
          backgroundvisible="No"
          bookmark="True"
          localurl="No">
	
		<cfdocumentsection  name="Invitation">
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td></td></tr>
		<!---
		<tr><td><cfinclude template="InvitationToBidHeader.cfm"></td></tr>
		<tr><td><cfinclude template="InvitationToBidRequest.cfm"></td></tr>
		--->	
		</table>
		
		</cfdocumentsection>
			
		<cfpdfform action="POPULATE"        
	         source="#SESSION.rootPath#\Procurement\Application\Quote\Invitation\RequestForQuote.pdf"
	         overwrite="yes"
	         overwritedata="yes">
			 
			 <!---  destination="#SESSION.rootPath#\Procurement\Application\Quote\Invitation\RequestForQuote_data.pdf" --->
			 <cfpdfsubform name="form1">
			 
			 <cfpdfformparam name="Fax" value="456-123-456">
			 	  
			 </cfpdfsubform>
		
		</cfpdfform>
	
	</cfdocument>
