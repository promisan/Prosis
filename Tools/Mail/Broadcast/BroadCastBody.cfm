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
<cfparam name="URL.ReadOnly" default="No">
<cfparam name="URL.SourcePath" default="">

<cf_textareascript>

<cf_screentop height="98%" html="No" jquery="Yes">

<cfform name="formbody" 
    action="BroadCastSubmit.cfm?mode=#url.mode#&broadcastid=#url.id#&scope=body&readonly=#url.readonly#&sourcepath=#URL.sourcepath#&mid=#url.mid#"				
	method="POST"
	target="savebody">		
				
<cfif url.id neq "">
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT *
		  FROM  Broadcast
		  WHERE BroadcastId = '#URL.ID#'
	</cfquery>

<cfelse>
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT TOP 1 *
		  FROM  Broadcast
		  WHERE OfficeruserId = '#SESSION.acc#'
		  ORDER BY Created DESC
	</cfquery>
	
	<cfset url.id = Broadcast.BroadcastId>	

</cfif>  
	  				
		<cfif Broadcast.BroadcastStatus eq "0">			
		
		 <table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">	
		  		  
		   <tr><td height="20" style="padding-bottom:2px" colspan="2">
		   
			   <table><tr><td>
			  
			  	<input type="submit" 
					 name="savebody" 
					 id="savebody"
					 value="Save" 
					 class="button10g"
					 style="height:25;width:180">
											
	   		  <cfif broadcast.broadcaststatus eq "1">
							
				<input type="submit" 
					  name="SendAgain"
					  id="SendAgain" 
					  value="Send Again" 
					  class="button10g"
					  style="height:25;width:180">
				  
				<cfelse>
				
				<input type="submit" 
					  name="Send" 
					  id="Send"
					  value="Send Now" 
					  class="button10g"
					  style="height:25;width:180">				
	
				</cfif>
										
			  </td>
			  <td height="8" id="sendbox"></td>			  
			  </tr>
			  </table>
		  </td>
		
		  </tr>		
		  
		   <tr>
				<td width="80" height="20" style="height:30px;font-width:200;font-size:15px;padding-left:10px;padding-right:10px" class="labelmedium">To:</td>
				<td width="94%" style="padding-right:1px" class="labelmedium">
									
					  <cfquery name="Recipient" 
				   datasource="AppsSystem" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					  SELECT *
					  FROM  BroadcastRecipient
					  WHERE BroadcastId = '#URL.ID#' 
					  AND Selected = 1
				  </cfquery>
				  <font color="0080C0">
				  <cfoutput>#recipient.recordcount#</cfoutput><cf_tl id="Recipients">
	  
				
				</td>
				
		 </tr>		
		  
		  <tr>
				<td width="80" height="20" style="height:30px;min-width:200px;font-size:15px;padding-left:10px;padding-right:10px" class="labelmedium"><cf_tl id="Subject">:</td>
				<td width="94%" style="padding-right:1px">
									
					<cfinput type="Text"
				       name="BroadcastSubject"
				       required="Yes"
				       visible="No"
				       enabled="Yes"				   
					   value="#broadcast.broadcastSubject#"
				       showautosuggestloadingicon="False"
				       typeahead="No"					  
					   maxlength="80"
					   style="width:99.5%;height:30px;font-size:16px"
					   class="regularxl"
				       size="80">	
				
				</td>
				
		 </tr>					

	 	 <cfset text = replace(Broadcast.BroadcastContent,"<script","disable","all")>
		 <cfset text = replace(text,"<iframe","disable","all")>
		 		 
		 <cfif URL.ReadOnly eq "No">
		 
	 		 <tr><td valign="top" colspan="2" align="center" style="padding-left:10px;padding-right:10px;padding-top:8px;border:0px solid silver" height="100%">	
						 
				 <cf_textarea name="broadcastContent"		             
					 init="Yes"
					 width="100%"
					 height="400"
					 toolbar="full"
					 resize="no"
					 color="ffffff"><cfoutput>#text#</cfoutput></cf_textarea>	 
			  	
			  </td>
			  </tr>
			  		  
		  <cfelse>
		  
			  <cfoutput>
			  <tr><td valign="top" colspan="2" align="left" style="padding:10px" height="100%">		 
				   #text#
				   <textarea name="broadcastContent" class="hide">#text#</textarea>
			  </td>
			  </tr>
			  </cfoutput>
			  
		  </cfif>		 
		  		  
		  </table>
	  
	  <cfelse>
	  
		  <cfoutput>
		  
		  <table width="99%" 
			align="center" 
			class="formpadding">
		  
		  <cfif broadcast.broadcaststatus eq "1">
		  
			<tr>
			 <td height="3" colspan="2" align="center">
			
				<input type    = "button" 
					   name    = "SendAgain" 
					   id      = "SendAgain" class="button10g"
					   value   = "Send Again" style="width:180;height:25"					  
					   onclick = "parent.ptoken.navigate('BroadCastSend.cfm?BroadcastId=#URL.id#&mode=#url.mode#&sourcepath=#URL.sourcepath#','boxsend')">			  
					  
			  </td>
			</tr>			
			  
		  </cfif>	  			
		  
		  <tr><td height="3"></td></tr>
		  
		  <tr>
				<td width="80" height="22"><font face="Verdana" size="1" color="black">&nbsp;&nbsp;Subject:</td>
				<td width="90%">
				   
				   		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
						<tr>
							<td style="border: 1px solid Silver;padding:6px" class="labelmedium">
				   			<cfoutput><b>#broadcast.broadcastSubject#</cfoutput>						
							</td>
						</tr>
						</table>
				 					 
				</td>
				
		  </tr>
		  
		  <tr><td height="100%" colspan="2" align="center" class="labelmedium">
		  <cfif Broadcast.BroadcastContent eq "">
		  <b>Attention: <font color="FF0000"><i>No body content</font>
		  <cfelse>
			  <table width="100%" height="98%" cellspacing="0" cellpadding="0" class="formpadding">
				  <tr><td height="3"></td></tr>				  
				  <tr><td style="padding:6px;border: 1px solid dadada;" valign="top">
				  #Broadcast.BroadcastContent#
				  </td></tr>
			  </table>
		  </cfif>
		  </td>
		  </tr>
		  </table>
		  </cfoutput>
			  
	  </cfif>
									
 </cfform>		
 