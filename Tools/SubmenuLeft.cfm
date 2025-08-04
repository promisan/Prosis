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

<!--- filter settings --->

<cfparam name="mode"         			default="verify">
<cfparam name="anonymous"    			default="">
<cfparam name="url.mission"  			default="">
<cfparam name="except"                  default="''">

<!--- presentation settings --->

<cfparam name="display"        			default="Yes">
<cfparam name="titlecolor"				default="FFFFFF">
<cfparam name="url.systemfunctionid" 	default="">
<cfparam name="open"        			default="yes">
<cfparam name="img"          			default="">
<cfparam name="color"        			default="ffffff">
<cfparam name="fcolor"       			default="white">

<input type="hidden" name="action" id="action" value="0">

<!--- obtain a list of functions to be shown here --->

<cfparam name="role"    default="">
<cfparam name="orgunit" default="">

<cfinvoke component = "Service.Authorization.Function"  
	 method           = "AuthorisedFunctions" 
	 mode             = "View"			 
	 mission          = "#url.mission#" 
	 orgunit          = "#orgunit#"
 	 Role             = "#role#"
	 SystemModule     = "#module#"
	 FunctionClass    = "#selection#"
	 MenuClass        = "#menuclass#"
	 Except           = "#except#"
 	 Anonymous        = "#anonymous#"
	 returnvariable   = "searchresult">	  
		
<cfif display eq "Yes">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="SubMenuLeft-wrap">
	
	<cf_assignid>		
	<cfset vRowGuid = replace(rowguid,"-","","all")>
	
	 <cfif searchresult.recordcount gte "1">
		
		<cfoutput>
			
			<cfif heading neq "">	
							
				<tr><td style="height:4px"></td></tr>
						
				<tr id="header_#rowguid#_1">
								
				  <cfset vImgCollapse = "arrow-down-2015.png">
				  <cfset vImgExpand   = "arrow-right-2015.png">
				  
				  <td  
				  	class="labelit" 
					style="cursor:pointer; padding-left:5px; width:162px; height:12px"
					onclick="subMenuLeftToggle('trSubMenuDetail_#vRowGuid#','twistieSubMenuDetail_#vRowGuid#','#SESSION.root#/Images/#vImgCollapse#','#SESSION.root#/Images/#vImgExpand#');">
				
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="1%" style="padding-right:1px;" valign="middle">
								<cfset vTwistie = vImgCollapse>
								<cfif lcase(open) eq "no">
									<cfset vTwistie = vImgExpand>
								</cfif>
								<img src="#SESSION.root#/Images/#vTwistie#" style="width:9px;height:9px;margin-left:5px;" align="absmiddle" id="twistieSubMenuDetail_#vRowGuid#">
							</td>
							<td class="labelit" style="height:22px;padding-left:9px;font-size:15px;font-weight:normal">
								
								<!--- <cfif img neq "">
					   				<img src="#SESSION.root#/Images/#img#" height="15" width="14" alt="" border="0" align="absmiddle">&nbsp;
								</cfif>
								
								--->
								<font class="SubMenuLeft-ttl" color="gray">#Heading#
							</td>
						</tr>
					
					</table>
					
				  </td>
				
				</tr>
				
				<tr id="header_#rowguid#_2">				
					<td height="3"></td>	
				</tr>
					
			</cfif>   
		
		</cfoutput>
	
	</cfif>
	
	<cfset vDisplayDetail = "padding-top:2px;">
	
	<cfif lcase(open) eq "no">
		<cfset vDisplayDetail = "display:none;">
	</cfif>
	
	<tr id="trSubMenuDetail_<cfoutput>#vRowGuid#</cfoutput>" style="<cfoutput>#vDisplayDetail#</cfoutput>">
		<td height="100%">
			<table width="100%" height="100%" cellpadding="0" cellspacing="0">
			
				<!--- we loop through the menu items the person has access to --->
		
				<cfoutput query="searchresult">			
									   
					  <tr><td align="center"> 
					 				    
					  <cfset condition = FunctionCondition>
					  
					  <cfif FunctionPath neq "">
					  
					  	  <cfset seturl = "#FunctionPath#?mission=#url.mission#">
					      
					      <cfif FunctionCondition neq  "">
					      	<cfset seturl = seturl & "&#FunctionCondition#">
					      </cfif>
					  	  
						  <table width="100%" cellspacing="0" cellpadding="0" align="center" style="cursor:pointer;height:14px" 
						   onClick="loadform('#seturl#','#FunctionTarget#',this,'#SystemFunctionId#');selected(this)" 
						   onMouseOver="hlx(this,true,'#FunctionMemo#')" 
						   onMouseOut="hlx(this,false,'')" id="opt_#SystemFunctionId#" name="opt" class="regular1"> 	
						  		 		   
					  <cfelse>
					  
						  <cfset ScriptVariable = "">
						  
						  <cfif ScriptConstant neq "">
						       <cfset ScriptVariable = ScriptConstant>
						  </cfif>
						  
						  <cfif ScriptVariable1 neq "">
						  
						       <cfif ScriptVariable eq "">
							      <cfset ScriptVariable = '#evaluate(ScriptVariable1)#'>
							   <cfelse>  
							      <cfset ScriptVariable = ScriptVariable & ',#evaluate(ScriptVariable2)#'>
							   </cfif>	  
							   
						  </cfif>
						 					   	
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="height:14px;cursor:pointer;" 		  
							  onClick="#ScriptName#('#ScriptVariable#','#SystemFunctionId#'); selected(this);" 				  
							  onMouseOver="hlx(this,true)" 
							  onMouseOut="hlx(this,false);" id="opt_#SystemFunctionId#" name="opt" class="regular1"> 	
							  
							 			     				
					  </cfif>
					  
					  <cfif (CLIENT.browser eq "Explorer" and (BrowserSupport eq "1" or BrowserSupport eq "2")) 
								    or ((CLIENT.browser eq "Edge" or CLIENT.browser eq "Firefox" or CLIENT.browser eq "Safari" or CLIENT.browser eq "Chrome") and BrowserSupport eq "2")>								
						    <cfset functionsupport = "1">							 
					  <cfelse>							 
						    <cfset functionsupport = "0">		 						 
					  </cfif>	
					  
					  <cfif functionsupport eq "1">	 
					  		      	 	  
						  <tr class="SubMenuLeft-dtl">
						     <td width="12%" align="right" style="padding:2px 3px 0 12px;">
							 <img src="#SESSION.root#/Images/arrow-right-2015-2.png" style="height:8px" alt="#FunctionName#" align="absmiddle" border="0">
							 </td>			 
							 <td width="88%" style="padding-left:5px" class="labelit" valign="middle">#FunctionName#</td> 
						  </tr>	
							  					  
					  </cfif>
					       
					  </table>
					    
					  </td></tr>
				  				
				</cfoutput>
	
			</table>
		</td>
	</tr>
		
	</table>

</cfif>

