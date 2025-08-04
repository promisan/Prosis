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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Progress report outputs</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.ID"        default="">
<cfparam name="URL.OutputId"  default="">
<cfparam name="URL.completed" default="0">


<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT   *,
		(SELECT Description 
		 FROM   Ref_ProgramCategory
		 WHERE  Code = O.ProgramCategory
		 ) as CategoryDescription
		 
    FROM     ProgramActivityOutput O
	WHERE    ActivityId = '#URL.ID#'
	AND      RecordStatus != '9' 
	AND      Targetid is NOT NULL
	ORDER BY ActivityOutputDate
</cfquery>


<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT   *,
		(SELECT Description 
		 FROM   Ref_ProgramCategory
		 WHERE  Code = O.ProgramCategory
		 ) as CategoryDescription
		 
    FROM     ProgramActivityOutput O
	WHERE    ActivityId = '#URL.ID#'
	AND      RecordStatus != '9' 
	AND      Targetid is NULL
	ORDER BY ActivityOutputDate
</cfquery>


<cf_tl id="Default" var="1">
<cfset vDefault="#lt_text#">

<cf_tl id="Date" var="1">
<cfset vDate="#lt_text#">
	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   
	  <tr>
	  
	    <td width="100%" class="def">
		
		    <table width="100%" class="navigation_table formpadding">
							
		    <tr class="labelmedium line">
			  
			   <td style="width:1%">
			
			   <cfif URL.outputid eq "" and (URL.ProgramAccess eq "EDIT" or URL.ProgramAccess eq "ALL") and completed eq "0">
			   
				   <cfset jvlink = "ProsisUI.createWindow('outputdialog', 'Milestone / Deliverable', '',{x:0,y:0,height:document.body.clientHeight-150,width:document.body.clientWidth-150,resizable:false,modal:true,center:true});ptoken.navigate('OutputEntryDialog.cfm?id=#url.id#&outputid=0','outputdialog')">		
			
				   <cfoutput>
				   <a href="javascript:#jvlink#"><cf_tl id="New"></a>
				   </cfoutput>
			   
			   </cfif>
			   
			   </td>
			   <td height="17" width="28"></td>	
			   <td width="40%" height="18"><cf_tl id="Description"></td>	
			   <td height="18"><cf_tl id="Category"></td>		 
			   <td><cf_tl id="Reference"></td>		 
			   <td><cf_tl id="TargetDate"></td>
			  
		    </tr>	
			
			<cfif Output.recordcount eq "0">
			
			<tr class="labelmedium"><td align="center" colspan="6"><cf_tl id="No outputs defined"></td></tr>
			
			</cfif>
								
			<cfoutput>
			
				<cfloop query="Output">
						
					<TR class="labelmedium line navigation_row">
						
					   <td style="width:40px">	
					   <table><tr>
					   
					   <cfif (URL.ProgramAccess eq "EDIT" or URL.ProgramAccess eq "ALL") and completed eq "0">
					   
						   <cfset jvlink = "ProsisUI.createWindow('outputdialog', 'Deliverable', '',{x:220,y:300,height:document.body.clientHeight-50,width:document.body.clientWidth-50,resizable:false,modal:true,center:true});ptoken.navigate('OutputEntryDialog.cfm?id=#url.id#&outputid=#outputid#','outputdialog')">		
						   
						   <td colspan="2">
						   <table><tr>
							   
						   <td width="20" style="padding-top:1px;padding-left:2px">
						       <cf_img icon="edit" navigation="Yes" onClick="#jvlink#">
						   </td>
						   
						   <td width="20" style="padding-top:1px;padding-right:7px">
						   
						    <cfif Output.recordcount gt "1" or Check.recordcount gte "1">							
							   <cf_img icon="delete" onClick="outputact('delete','#outputid#')">							     
							</cfif>
							
						   </td>
						   
						   </tr></table>
						   
						</cfif> 
						
						</tr></table>
						
					   </td>	  
									
					   <td width="20">#currentrow#.</td>	
					   					   
					   <td style="width:50%">#Output.ActivityOutput#</td>
					   <td>#Output.CategoryDescription#</td>
					   <td>#Output.Reference#</td>
					   <td>
					   
						   <cfif Output.ActivityOutputDefault eq "1">
						      <font color="gray"><cf_tl id="Activity End"></FONT>
						   <cfelse>
						      #Dateformat(Output.ActivityOutputDate, CLIENT.DateFormatShow)#
						   </cfif>
					   
					   </td>
					   
				    </TR>			
				
				</cfloop>
			
			</cfoutput>
											
		</table>

	</td>
	</tr>
		  			
</table>	
	
<cfoutput>	
	<input type="hidden" name="output" id="output" value="#output.recordcount#">	
</cfoutput>

<cfset ajaxonload("doHighlight")>
