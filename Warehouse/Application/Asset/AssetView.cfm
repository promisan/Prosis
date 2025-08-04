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

<cfparam name="URL.ID" type="string" default="0">

<script>

function printme(loc) {
      window.open(loc, "printme", "unadorned:yes; edge:raised; status:yes; dialogHeight:620px; dialogWidth:780px; help:no; scroll:yes; center:yes; resizable:no")
}

</script>
	
<cfquery name="Asset" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   AssetItem
	    WHERE  AssetId = '#URL.ID#'
</cfquery>	
	
<body bgcolor="808080" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" style="background: ButtonFace;" ></body>
	
	<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	
	<td>
	
	<cf_screentop height="100%" jquery="Yes" html="No" title="#Asset.Model# #Asset.Description#">
	
	<cfif Asset.recordcount eq "0">
	
		<table align="center">
			<tr><td height="40"><font size="2" color="FF0000"><b>Asset record is no longer on file</td></tr>
		</table>
	
	<cfelse>
		
		<cfoutput>
		
		<table width="100%" height="100%" bordercolor="gray" border="1" cellspacing="0" cellpadding="0" bgcolor="white" rules="none">
		
			<tr>
				<td colspan="3" height="38" bgcolor="E7E7E7">
				
					<table width="100%" cellspacing="0" cellpadding="0" align="center">
					
					<cfajaximport>
					
					<tr><td id="banner">					
						<cfinclude template="AssetViewBanner.cfm">					
					</td>
									
					<td colspan="1" align="right" valign="bottom" background="../../../Images/BG_Header.jpg" style="background-repeat:repeat-x">
					   <table>					   
						   <tr><td>
						   <a href="javascript:printme(parent.right.location)">
						   <font face="Verdana" color="GRAY">
						   <b>Print View</font></a>&nbsp;&nbsp;&nbsp;
						   </td></tr>
						   <tr><td height="3"></td></tr>
					   </table>
					</td>
					</tr> 
					
					</table>
				</td>
			</tr>	
						
			<tr><td colspan="3" height="1" bgcolor="silver"></td></tr>	
		
			<tr>
							
				<td width="170" 
				   valign="top" 
				   height="100%"
				   id="leftexpanded" 
				   class="regular" 
				   style="border-right: 1px solid Silver;">
				   <cf_space spaces="53">
			
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					
						<tr style="cursor: pointer;" bgcolor="f3f3f3"
					        onclick="document.getElementById('leftcollapsed').className='regular';document.getElementById('leftexpanded').className='hide'">
							<td align="right">
						    <table width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td class="top4n">&nbsp;<cf_tl id="Options"></td>
								<td height="23" align="right" class="top4n">
									<img src="#SESSION.root#/images/collapse_left.gif" align="absmiddle" border="0">		
								</td>
								<td class="top4n">&nbsp;</td>
							</tr>
							</table>		
						    </td>
						</tr>
						
						<tr><td height="1" bgcolor="silver"></td></tr>
											
					    <tr><td align="center">
							<cfinclude template="AssetViewMenu.cfm"> 
							</td>
						</tr>
						
					</table>
			  				
			</td>	
				
			<td width="2%" 
			   bgcolor="gray" 
			   class="hide" 
			   height="100%"
			   id="leftcollapsed" 
			   style="cursor: pointer;"
		       onClick="document.getElementById('leftcollapsed').className='hide';document.getElementById('leftexpanded').className='regular'">
						
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr><td align="center" valign="top">
					<img src="#SESSION.root#/images/collapse_right.gif" alt="Show menu" border="0">				
					</td>
					</tr>
				</table>
			
			</td>
										
			<td style="border-left: 1px solid Silver;" height="100%" width="90%">
					<iframe src="#URL.Template#?ID=#URL.ID#&Caller=P"
			        name="right"
			        id="right"
			        width="100%"
			        height="100%"
			        align="middle"
			        scrolling="no"			
			        frameborder="0"></iframe>
			</td>
				
			</tr>
		</table>
		</cfoutput>
	
	
	</cfif>
	
	</td>
	</tr>
	</table>
	