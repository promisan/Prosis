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
<table width="92%" align="center" border="0" class="formpadding formspacing"  cellspacing="0" cellpadding="0">
		   	
		<cfoutput query="get">	
		<input type="hidden" name="ParameterKey" id="ParameterKey" value="#ParameterKey#">
		</cfoutput>	
							
		<!--- Field: Release --->
	
	    <TR>
	    <td style="padding-left:10px" class="labelmedium2" width="170">Release:</td>
	    <td>
	  	    <cfoutput query="get">
			<cfinput class="regularxxl" style="font-size:20px;text-align: center;" type="Text" name="Version" value="#Version#" message="Please enter the release version" required="Yes" size="8" maxlength="8">
			</cfoutput>
		</td>
		</tr>
		<tr>
		<td class="labelmedium2" style="padding-left:10px">Remote support server:</td>
		<td><cfoutput query="get">
			<input class="regularxl" style="text-align: left;" type="Text" name="PromisanServer" id="PromisanServer" value="#PromisanServer#" size="40" maxlength="40">
			</cfoutput></td>
		</tr>
		<tr>	
		<td class="labelmedium2" style="padding-left:10px">Remote support account:</td>
		<td><cfoutput query="get">
			<input class="regularxl" style="text-align: left;" type="Text" name="PromisanAccount" id="PromisanAccount" value="#PromisanAccount#" size="20" maxlength="20">
			</cfoutput></td>
		</tr>
		<tr>	
		<td class="labelmedium2" style="padding-left:10px">Local Synchronization Directory:</td>
		<td><cfoutput query="get">
			<input class="regularxl" style="text-align: left;" type="Text" name="ExchangeDirectory" id="ExchangeDirectory" value="#ExchangeDirectory#" size="50" maxlength="50">
			</cfoutput></td>
		</tr>
		
		<!---
		
		<TR>
	    <td style="padding-left:10px">Browser Support Portal Functions only:</td>
		<TD>
			<table><tr>
		    <td>
	  	    <cfoutput query="get">
			<INPUT type="radio" name="BrowserSupport" id="BrowserSupport" value="1" <cfif Get.BrowserSupport eq "1">checked</cfif>>
			</td>
			<td>Explorer 7/8/9
			<img src="#SESSION.root#/Images/explorer_icon.gif" alt="" border="0" align="absmiddle">
			</td>
			<td>&nbsp;</td>
			<td>
			<INPUT type="radio" name="BrowserSupport" id="BrowserSupport" value="2" <cfif Get.BrowserSupport eq "2">checked</cfif>>
			</td>
			<td>Explorer 7/8/9 
			<img src="#SESSION.root#/Images/explorer_icon.gif" alt="" border="0" align="absmiddle">
			and Firefox 3
			<img src="#SESSION.root#/Images/firefox_icon.gif" alt="" border="0" align="absmiddle">
			</td>
			</cfoutput>
			</tr>
			</table>
		</td>
		</tr>
		
		<tr><td></td><td class="label">Attention : Browser support for back-office and portal backoffice functions is set for each module/function under Module Control.</td></tr>
		
		<cfoutput>
			<script language="JavaScript">
			
			function sourcecode() {
				se   = document.getElementById("PromisanServer")
				site = document.getElementById("PromisanAccount")
				w = #CLIENT.width# - 100;
			    h = #CLIENT.height# - 150;
				
				window.open(se.value+"/system/template/TemplateLog.cfm?site="+site.value+"&root="+se.value,"_blank","left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no")
			}	
			
			</script>
		</cfoutput>
		
		--->
	
		<tr>	
		<td class="labelmedium2" style="padding-left:10px" height="24" >Master source code:</td>
		<td><table border="0" cellspacing="0" cellpadding="0">
			
			<tr>		
			<cfoutput>			
			<td class="labelmedium2"><a href="javascript:sourcecode()">
			List Application files that are pending synchronisation with the master version</a>
			</td></tr>
			</cfoutput>
			</table>
		</td>
		</tr>

		<tr>	
		<td class="labelmedium2" style="padding-left:10px" height="24" >Master Source code Encode engine:</td>
		<td>
			<cfoutput query="get">
			<input class="regularxl" style="text-align: left;" type="Text" name="EncodeEngine" id="EncodeEngine" value="#EncodeEngine#" size="80" maxlength="80">
			</cfoutput>
		</td>
		</tr>
		
		<tr><td height="5" colspan="2"></td></tr>
		
		<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" align="center" height="30">
	
			<input type="submit" name="Update" id="Update" value=" Apply " class="button10g">	
	
		</td></tr>
					
</table>