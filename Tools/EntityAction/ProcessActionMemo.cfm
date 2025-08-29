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
<cfparam name="Action.EnableHTMLEdit" default="1">
<cfparam name="url.textmode" default="edit">

<cfoutput>

<cfquery name="Doc" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SET TEXTSIZE 10000000
			SELECT * FROM OrganizationObjectAction
			WHERE  ActionId   = '#MemoActionID#'			
	  </cfquery>	
		   			   
		   <cfif url.textmode eq "edit">
			   
			<table width="100%" border="0" cellspacing="0" cellpadding="0">  
						 				  
			<cfelse>
			   
			   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">  
							   				  
				  <tr class="line labelmedium">
				  <td style="padding-left:4px;width:100%;font-size:20px" ><cf_tl id="Comments"></td>
				  <td align="right" width="20" style="padding-right:3px">			  	 			     
				  <button type="button" 
				  name="Mail"  id="Mail"
				  style="width:41;height:23"
				  class="button10g" onclick="docoutput('mail','#URL.MemoActionid#','')">
				 	 <img src="#SESSION.root#/Images/mail_new.gif" align="absmiddle" alt="Send eMail" border="0">
				  </button>
				  </td>
				  <td align="right" width="20">				 			 
				  <button type="button" 
				     name="Print" id="Print"	
					 style="width:41;height:23"						 
					 class="button10g" onclick="docoutput('pdf','#URL.MemoActionid#','')">
					 <img src="#SESSION.root#/Images/pdf_small.gif" align="absmiddle" alt="PDF" border="0">
				  </button>							  
				  </td>
				  
				  <td align="right" width="20">				 			 
				  <button type="button" 
				     name="Print" id="Print"	
					 style="width:41;height:23"						 
					 class="button10g" onclick="docoutput('print','#URL.MemoActionid#','')">
					 <img src="#SESSION.root#/Images/print.gif" align="absmiddle" alt="Print" border="0">
				  </button>					
     			</td>		
				
			</tr>	 
									  
		   </cfif>	  	
		   		   		   		  		 		    			   
		   	<cfif url.textmode eq "read">	
				
	    		  <tr><td style="padding:8px">#Doc.ActionMemo#</td></tr>											
				
			<cfelse>
			
				<cfif Action.EnableHTMLEdit eq "1">
				
					 <tr id="memoblock">
					 <td colspan="3"
					    valign="top"
					    style="padding-top:0px;padding-left:7px;padding-right:8px;border: solid 1px silver;border-top:0px">
						
						<!--- removed toolBar="Basic" --->
					
						 <cfset text = replace(Doc.ActionMemo,"<script","disable","all")>
						 <cfset text = replace(text,"<iframe","disable","all")>		
						 
						 <cfif findNoCase("cf_nocache",cgi.query_string)> 
						 												 
						 	<cf_textarea height="100"  color="ffffff" resize="Yes" name="ActionMemo" toolbar="mini">#text#</cf_textarea>													 
						
						 <cfelse>
						 
						 	<cf_textarea height="140"  color="ffffff" init="Yes" resize="Yes" name="ActionMemo" toolbar="mini">#text#</cf_textarea>													 
												 
						 </cfif>	
					  
					</td>
					</tr>
									
				<cfelse>
				
		    	   	<tr id="memoblock">	
					  <td colspan="3" valign="top" style="padding-top:4px;padding-left:4px;padding-right:7px">
					  					  
					  <table width="100%" height="100%" border="0" bcellspacing="0" cellpadding="0">
					  
						  <tr><td width="190" style="padding-left:5px" class="labelmedium"><cf_tl id="Memo">:</td></tr>			
						  		 
						  <tr><td height="100%" style="padding-left:15px;padding-right:16px">	
						  								
						  <textarea name   = "ActionMemo"
						            class  = "regular"							
						            style  = "border-radius:4px;font-size:13px;height:60; width:100%; padding:7px;border:1px solid d4d4d4;background: fafafa">#Doc.ActionMemo#</textarea>
						  </td></tr>		
						  			 				
						  <tr><td height="3"></td></tr>
				
				      </table>
					  
					  </td>
					  </tr>
				  
				</cfif>	
					
			</cfif>						
						
</table>		
</cfoutput>		

<cfif Action.EnableHTMLEdit eq "1">

	<cfif findNoCase("cf_nocache",cgi.query_string)>
		<cfset ajaxonload("initTextArea")>
	</cfif> 

</cfif>

