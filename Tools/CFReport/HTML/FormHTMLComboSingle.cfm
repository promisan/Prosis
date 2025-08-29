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
<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	  AND    	CriteriaName  = '#URL.par#'  
</cfquery>
 	
<table width="100%"
       border="0"
	   height="100%"
	   cellspacing="0"
       cellpadding="0">

<tr><td colspan="2" bgcolor="white" valign="top" style="padding:10px;border: 0px solid gray;">  
	   			  
<table width="100%" height="99%" border="0" cellspacing="0" cellpadding="0" align="center">

 <cfoutput>
  
 <tr>
  
   <td class="labelmedium" style="height:47px">
   <table>
  
   
   <tr>
	   <td style="padding-left:5px" class="labelmedium">
	   						
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Search.png?id=1" 
								height="32" 
								title="find" 
								style="cursor:pointer;">
												
	   </td>
	   <td style="padding-left:9px">
	   <input type="text" class="regularxl" style="height:32px" value="" id="combovalue" name="combovalue" size="26" onclick="document.getElementById('value').value=''" onKeyUp="combosearch('1','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
	   </td>
	   <td style="padding-left:4px" class="labelmedium">
	   <input type="checkbox" name="combovariant" id="combovariant" value="1" onClick="search('1')"><cf_tl id="advanced"></td>
   </tr>
   </table>
   </td>
   
   <td align="right" height="28" style="padding-right:4px">
   
   <input class="button10g" type="button" name"Submit" id="Submit" value="Search" onclick="combosearch('1','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
  
   </td>
 </tr> 	
   
 </cfoutput>
   
 <tr><td height="1" colspan="2" class="line"></td></tr>

 <tr>
  
    <td colspan="2" valign="top">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<cfif Base.CriteriaHelp neq "">
			<tr>
				<td colspan="3" class="labelmedium" style="border: 1px solid #silver;">: 
				<cfoutput query="Base"><b>#CriteriaHelp#</cfoutput>
				</td>
			</tr>	
		</cfif>
				
		<TR>
		<td height="200" colspan="3" id="comboresult" valign="top">		    
			<cfinclude template="FormHTMLComboSingleResult.cfm">
		</td>
		</TR>
	
	</table>
	
	</td>
	</tr>
	
	<tr><td class="line" height="1" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="27" style="padding-top:5px">
		<cfoutput>
		<cf_tl id="Clear" var="1">
		<input type="button" class="button10g" name="TestReturn" id="TestReturn" onclick="comboselect('#url.par#','#url.shw#','blank','blank');combosearch('1','#url.par#','','#url.fly#','#url.shw#')" value="#lt_text#">
		<cf_tl id="Close" var="1">
		<input type="button" class="button10g" name="TestReturn" id="TestReturn" onclick="try { ProsisUI.closeWindow('combo',true)} catch(e){};" value="#lt_text#">
		</cfoutput>
	</td></tr>
	
	</table>	
	
</td></tr>
</table>

<cf_screenbottom layout="webapp">	
