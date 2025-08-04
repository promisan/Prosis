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

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames
	WHERE  Account = '#SESSION.acc#'
</cfquery>
						
<cfquery name="Menu" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   xl#CLIENT.LANGUAGEID#_Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = '#url.id#'
	AND    MenuClass      = 'Process'
	AND    Operational = 1
	
	<cfif client.browser eq "Explorer">
	AND    (BrowserSupport = '1' OR BrowserSupport = '2')
	<cfelseif client.browser eq "Firefox" or client.browser eq "Chrome" or client.browser eq "Safari">
	AND    BrowserSupport = '2'
	<cfelse>
	AND    BrowserSupport = '0'
		<cfset BrowserSupport = "0">
	</cfif>	
	ORDER BY MenuOrder
</cfquery>

<cfset vThisMission = client.mission>

<cfparam name="show.PersonNo" default="yes">

<cfoutput>

	<cfset row = 0>
	
	<script language="JavaScript">	
		
		 function menuselect(d) {
			var myArray = new Array();
			var i;		
			
			<cfloop query="menu">
			
				<cfinvoke component="Service.Access"  
		          method="function"  
				  SystemFunctionId="#SystemFunctionId#"
				  Mission="#vThisMission#" 
				  returnvariable="access">
			
				<CFIF access is "GRANTED"> 		
					<cfset row = row+1>			
					myArray[#row#] = 'menu#row#';
				</cfif>	
				
			</cfloop>	
					
			if(document.getElementById(d).className == "submenuregular") { document.getElementById(d).className = "submenuselected"; }
			else { }		
			for ( i=1;i<=myArray.length-1;i++) {
				if(myArray[i] != d) 
				{document.getElementById(myArray[i]).className = "submenuregular";}
			}
		}
					
		function menulog(id) {
			 ColdFusion.navigate('#SESSION.root#/Tools/SubmenuLog.cfm?systemfunctionid='+id,'menulog')
		}
				 
	</script>

</cfoutput>


<style>
/*--------------------------------------------------------*/
/*---------------Sub Menu---------------------------------*/
/*--------------------------------------------------------*/
	td.submenuregular { 
		background-repeat:no-repeat; 
		background-Position:left;
		line-height:12px;
		font-family: Calibri, Trebuchet MS;
		font-size: 13px;
		font-weight:regular;
		color:gray;
		width:105px;
		height:42px;
		cursor:pointer;
		padding-top:9px;
	}
		
	td.submenuselected {
		background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/extended/images/menu/button_bg5.png'); 
		background-Repeat:no-repeat; 
		background-Position:center;
		color:white;
		cursor:pointer;
		line-height:13px;
		font-family: Calibri, Trebuchet MS;
		font-size: 13px;
		font-weight:bold;
		width:105px;
		padding-left:5px;
		padding-right:5px;
		height:42px;
		padding-top:0px;
	}

	html,
	body {
		background-color: transparent;
	}

</style>

<!--- instantiate the session validation script --->

<script language="JavaScript">   
	var _selectMenuClickTimer;
	var _selectMenuClickTimerDelay = 250;
	
    parent.cacc = "<cfoutput>#session.acc#</cfoutput>";
	parent.sessionvalidatestart();	
</script>

<!--- ----------------------------------------- --->

<cfparam name="url.mission"   default="">
<!--- --------------------------------------------------- --->
<!--- generic template for menu within the process portal --->
<!--- --------------------------------------------------- --->
	
<table cellpadding="0" cellspacing="0" border="0" width="100%">		  
								
	<tr>
	<td id="menulog" class="hide"></td>
	<cfif FileExists ("#SESSION.rootpath##Menu.FunctionDirectory##Menu.FunctionPath#")>
		
		<cfset row = "0">
		
		<cfoutput query="Menu">			
				
		    <!--- check for access granted --->
			
			<cfinvoke component="Service.Access"  
	          method="function"  
			  SystemFunctionId="#SystemFunctionId#" 
			  Mission="#vThisMission#" 
			  returnvariable="access">

			<CFIF access is "GRANTED"> 		
			
				<cfset row = row+1>	
										
			    <cfif functiontarget neq "iframe" and BrowserSupport neq "0">
								
					<!--- ajax embedding --->
												
					<td align   = "center" 
					    valign  = "middle" 				
						class   = "<cfif row eq "1">submenuselected<cfelse>submenuregular</cfif>"				
						id      = "menu#row#"
						name    = "menu#row#"
						ondblclick="return false;" 
							<cfif menu.enforcereload eq "0">							
								onclick = "if (_selectMenuClickTimer) clearTimeout(_selectMenuClickTimer); _selectMenuClickTimer = setTimeout(function() { if (this.className == 'submenuregular') { menuselect('menu#row#');ColdFusion.navigate('#SESSION.root#/#FunctionDirectory#/#FunctionPath#?scope=portal&height='+window.innerHeight+'&width='+window.innerWidth+'&webapp=#url.id#&mission=#url.mission#&id=#url.id#&systemfunctionid=#systemfunctionid#&#functioncondition#','menucontent'); } }, _selectMenuClickTimerDelay);  ">
							<cfelse>							
								onclick = "if (_selectMenuClickTimer) clearTimeout(_selectMenuClickTimer); _selectMenuClickTimer = setTimeout(function() { menuselect('menu#row#'); menulog('#systemfunctionid#'); ColdFusion.navigate('#SESSION.root#/#FunctionDirectory#/#FunctionPath#?scope=portal&height='+window.innerHeight+'&width='+window.innerWidth+'&webapp=#url.id#&mission=#url.mission#&id=#url.id#&systemfunctionid=#systemfunctionid#&#functioncondition#','menucontent'); }, _selectMenuClickTimerDelay); ">
							</cfif>														
							
							<cfif functionmemo neq "">
								#FunctionMemo#
							<cfelse>
								#FunctionName#
							</cfif>							
														 
					</td>
				
				<cfelseif BrowserSupport neq "0">
							
				<!--- iframe embedding ---> 
												
				<td align   = "center" 
				    valign  = "middle" 				
					class   = "<cfif row eq "1">submenuselected<cfelse>submenuregular</cfif>"				
					id      = "menu#row#"
					name    = "menu#row#"
					ondblclick="return false;" 
						<cfif menu.enforcereload eq "0">
							onclick = "if (_selectMenuClickTimer) clearTimeout(_selectMenuClickTimer); _selectMenuClickTimer = setTimeout(function() { if (this.className == 'submenuregular') { menuselect('menu#row#'); ptoken.location('#SESSION.root#/#FunctionDirectory#/#FunctionPath#?scope=portal&height='+window.innerHeight+'&width='+window.innerWidth+'&webapp=#url.id#&mission=#url.mission#&id=#client.personno#&systemfunctionid=#systemfunctionid#&#functioncondition#','window.contentframe');}  }, _selectMenuClickTimerDelay);">
						<cfelse>
							onclick = "if (_selectMenuClickTimer) clearTimeout(_selectMenuClickTimer); _selectMenuClickTimer = setTimeout(function() { menuselect('menu#row#'); menulog('#systemfunctionid#'); ptoken.location('#SESSION.root#/#FunctionDirectory#/#FunctionPath#?scope=portal&height='+window.innerHeight+'&width='+window.innerWidth+'&webapp=#url.id#&mission=#url.mission#&id=#client.personno#&systemfunctionid=#systemfunctionid#&#functioncondition#','window.contentframe');  }, _selectMenuClickTimerDelay); ">
						</cfif>
											
						<cfif functionmemo neq "">
							#FunctionMemo#
						<cfelse>
							#FunctionName#
						</cfif>
						
				</td>
			
				<cfelse>
				
					<td class="labelit">
						<cfoutput>
						<font color="red" size="2">#url.id# Menu configuration does not allow content to be viewed in your browser (#client.browser#).</font>
						<br>
						<font color="black" size="1">We recommend Internet Explorer 9 or later.</font>
						</cfoutput>
					</td>
				
				</cfif>
			
			</cfif>
				
		</cfoutput>		
			
	<cfelse>
	
		<td valign="middle"><font color="red">Process Menu has not been configured in Portal Maintenance</font></td>
		
	</cfif>	
	
		<cfoutput>
	
			<td align="right" style="padding-right:30px; padding-top:8px; font-family: Calibri; font-size: 13px; text-rendering: optimizeLegibility" valign="middle">#SESSION.first# #SESSION.last# &nbsp;<cfif show.PersonNo eq "yes"><font color="silver">|</font>&nbsp; #User.PersonNo#</cfif></td>
		
		</cfoutput>
		
	</tr>
	
</table>


