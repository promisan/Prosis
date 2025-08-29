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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Indicator</TITLE></HEAD>

<body leftmargin="1" topmargin="3" rightmargin="1">

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT I.*, C.ClaimSection, C.Description as CategoryDescription
	FROM Ref_Indicator I, Ref_IndicatorCategory C
	WHERE I.Category = C.Code
	ORDER BY C.ClaimSection, C.CategoryDescription, I.ListingOrder
</cfquery>

<cf_divscroll>

<cfset Header = "">
<cfset page="0">
<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm">  

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cf_ajaxRequest>	

<cfoutput>
		
	<script language="JavaScript"> 
	
	function toggle(code) {
	url = "IndicatorToggle.cfm?ts="+new Date().getTime()+"&code="+code;
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 
						
			    document.getElementById("b"+code).innerHTML = req.responseText;},
							
		        'onError':function(req) { 
					      
			     document.getElementById("b"+code).innerHTML = req.responseText;}	
		         }
			 );	
	}
		
	function recordedit(id)	{

          ret = window.showModalDialog("RecordDialog.cfm?id="+id+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:350px; dialogWidth:590px; help:no; scroll:no; center:yes; resizable:no");
		  if (ret)
		  { history.go() }
	}

</SCRIPT>	

</cfoutput>
	

<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="1" align="center">
 	
	<tr style="height:20px;">
	    <td width="4%" align="center"></td>
	    <td>Code</td>
		<td align="left">Description</td>
		<td align="right">Perc.</td>
		<td align="left">Officer</td>
		<td >Oper.</td>
	</tr>
	<tr><td colspan="6" class="linedotted"></td></tr>

<cfoutput query="SearchResult" group="ClaimSection"> 

<tr><td colspan="6" class="labellarge"><i>&nbsp;#ClaimSection#</i></td></tr>

	<cfoutput group="CategoryDescription"> 
		
		<cfif ClaimSection eq "Cost">
		<tr><td colspan="6" class="labelmedium" style="padding-left:18px;"><i>#CategoryDescription#</i></td></tr>
		</cfif>
		
			<cfoutput>
			     
			    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#">
				<td width="6%" style="padding-top:3px;" align="center">
					<cf_img icon="open" onclick="recordedit('#Code#')">
				</td>
				<td width="7%"><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td width="50%"><a href="javascript:recordedit('#Code#')">#Description#</a></td>
				<td width="6%" align="right"><cfif #LinePercentage# gt "0">#LinePercentage#%<cfelse></cfif>&nbsp;&nbsp;</td>
				<td width="20%">#OfficerFirstName# #OfficerLastName#</td>
				<td width="40" id="b#code#"><cfif operational eq "0">
					 
						 <img src="#SESSION.root#/Images/light_red3.gif"
					     alt="Activate"
					     width="24"
					     height="15"
					     border="0"
					     style="cursor: hand;"
					     onClick="toggle('#code#')">
				 
					 <cfelse>
					 
						  <img src="#SESSION.root#/Images/light_green2.gif"
					     alt="Disabled"
					     width="24"
					     height="15"
					     border="0"
					     style="cursor: hand;"
					     onClick="toggle('#code#')">
					
					 </cfif>
					</td>
				
				</td>
				</tr>
				<cfif #currentRow# neq "#SearchResult.recordcount#">
				<tr><td colspan="6" class="linedotted"></td></tr>
				</cfif>
				
			</cfoutput>			
	</cfoutput>		
	
</cfoutput>

</table>

</td>
</tr>

</table>

</cf_divscroll>

</BODY></HTML>