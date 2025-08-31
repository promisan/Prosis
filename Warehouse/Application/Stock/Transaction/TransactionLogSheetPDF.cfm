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
<cfparam name="url.warehouse" default="">
<cfparam name="url.location" default="">
<cfparam name="url.mode"   default="issue">

	<cfoutput>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		
		
		<!---
	    <tr><td align="right" colspan="2" style="padding-right:4px">		
		<a href="javascript:transactiontoggle('manual')">
			<font face="Verdana" size="2" color="0080FF">Go to : Manual Entry</font>
		</a>				
		</td>		
		</tr>
		---> 		
		
		<tr><td height="1" style="padding:4px" colspan="2" class="line"></td></tr>
	
		<tr id="submitbox0" class="hide">
		   <td bgcolor="d4d4d4" height="1"></td>
	    </tr>	
						
		<TR id="submitbox1" class="cchide"> 	
			<td style="padding:5px">
				
				<input type = "hidden" name="mode"  id="mode"  value="#URL.mode#">								
													
				<cf_filelibraryN
					DocumentPath="StockLogSheet"
					SubDirectory="#url.warehouse#" 
					Filter="#url.location#"
					Insert="yes"
					Remove="yes"
					Box="pdfbox"
					Label="Attach Logsheet"
					PDFScript="importpdf"
					LoadScript="false"
					rowHeader="no"
					ShowSize="yes">											
					
			</td>
		</tr>
				
	</table>
			
	</cfoutput>

