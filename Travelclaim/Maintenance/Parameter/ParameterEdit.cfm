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

 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<style>
 
 TD {
	padding : 2px; }
  
 </style>
  
<cfoutput>

<script src="#SESSION.root#/Tools/Ajax/AjaxRequest.js" type="text/javascript"></script>

<script>
	
	function recordadd() {
	          ret = window.showModalDialog("../FundValidation/RecordDialog.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:280px; dialogWidth:410px; help:no; scroll:no; center:yes; resizable:no");
			  if (ret)
			  { fund() }
	}
	
	function recordedit(id) {
	
	          ret = window.showModalDialog("../FundValidation/RecordDialog.cfm?idmenu=#url.idmenu#&id="+id+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:280px; dialogWidth:410px; help:no; scroll:no; center:yes; resizable:no");
			  if (ret)
			  { fund() }
	}
	
	function fund() {
	
		url = "../FundValidation/RecordListing.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()
		
		AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
		document.getElementById("fundbox").innerHTML = req.responseText;		
		},
						
	        'onError':function(req) { 
		document.getElementById("fundbox").innerHTML = req.responseText;}	
	         }
		 );					 
	}

</SCRIPT>	 

</cfoutput>

<cfquery name="Get" 
	datasource="AppsTravelClaim"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Parameter 
</cfquery>

<cfset Header = "">
<cfset page="0">
<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm"> 

<cf_divscroll>

<cfform name="myform" action="ParameterSubmit.cfm?idmenu=#URL.IdMenu#" method="post">

<table width="97%" align="center">

<tr>

<td>


	<table width="100%" align="center">
	
	<tr><td>
	
		
		
		<table width="100%" align="center">
	
			<tr>
				<td valign="top">
		
					<table width="100%" cellspacing="2" cellpadding="2">
				
						<tr><td height="1"></td></tr>
						<tr><td><b><font color="6688aa">Attention:</td></tr>
						<tr><td height="3"></td></tr>
						<tr><td><font color="808080"> Setup Parameters should <b>only</b> be changed if you are absolutely certain of their effect on the system. </td></tr>
						<tr><td height="5"></td></tr>			
						<tr><td><font color="808080">In case you have any doubt always consult your assignated focal point.</td></tr>
						<tr><td height="5"></td></tr>
				
					</table>
				</td>
			</tr>
			
			<tr>
			 	<td width="100%">
					<cfinclude template="ParameterTab.cfm"> 
				</td>
			</tr>
	
	
			<tr><td height="4"></td></tr>
		
	
		</table>	

	</td>
	
	</tr>
		
	</table>

	
	
</td>

</tr>

<tr><td class="linedotted"></td></tr>
		
	<tr><td align="center" height="30">

		<input type="submit" name="Update" value=" Save " class="button10g">

	</td></tr>

	<tr><td class="linedotted"></td></tr>

</table>

</cfform>

</cf_divscroll>
