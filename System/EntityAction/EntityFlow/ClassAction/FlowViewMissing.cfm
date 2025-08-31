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
<cfoutput>

<cfparam name="URL.entityCode" default="">	
<cfparam name="URL.entityClass" default="">	
<cfparam name="URL.publishNo" default="">		
<cfparam name="URL.print" default="0">		
				
	<cfquery name="ResetMissing" 
    datasource="AppsOrganization"
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE #tbl#
	SET ActionParent = NULL,
		ActionGoToYes = NULL,
		ActionGoToNo  = NULL
	<cfif url.PublishNo eq "">	   
    	WHERE  EntityCode   = '#url.entityCode#' 
	    AND    EntityClass  = '#url.entityClass#'
	<cfelse>
		WHERE  ActionPublishNo = '#url.publishNo#' 
	</cfif>
    AND  ActionOrder is NULL
	</cfquery>	
						
	<cfquery name="Missing" 
    datasource="AppsOrganization"
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   * 
    FROM     #tbl#
    <cfif url.PublishNo eq "">	   
    	WHERE  EntityCode   = '#url.entityCode#' 
	    AND    EntityClass  = '#url.entityClass#'
	<cfelse>
		WHERE  ActionPublishNo = '#url.publishNo#' 
	</cfif>
    AND    ActionOrder is NULL
    </cfquery>	
	
	<cfset dr = "">
							
<cfif Missing.recordcount gt "0">
						
	<table width="100%" class="formpadding">
	
	<tr><td colspan="5"></td></tr>
	<tr style="border-top:1px solid silver;height:30px" class="line labelmedium2">
	<td colspan="5" align="center">
	<cfif missing.recordcount eq "1">
	<font color="FF0000"><b>Attention : </b>#Missing.recordcount# action is not properly configured, and requires your action.</b>
	<cfelse>
	<font color="FF0000"><b>Attention : </b>#Missing.recordcount# actions are not properly configured, and requires your action.</b>
	</cfif>
	</td></tr>	
	<tr><td colspan="5"></td></tr>
	
	<cfset ln = 1>
	
	<cfloop query="Missing">
	
		<cfif dr eq "">
	      <cfset dr = "'#actionCode#'+TRANSPARENT">
		<cfelse>
		  <cfset dr = "#dr#,'#actionCode#'+TRANSPARENT">
		</cfif>
							
		<cfif ln eq 6><tr></cfif>	
		
		<td align="center" style="padding:0px">

			<div id="#ActionCode#" style="width:130px;height:35px; position:relative; cursor: pointer;">
				
				<table width="140" height="35" border="0" align="center" bgcolor="transparent"
				style="cursor: pointer; border:1px solid silver;padding:3px" 
				onDblClick="stepedit('#Missing.ActionCode#','#URL.PublishNo#')" > 
				
				    <tr class="labelit" bgcolor="f3f3f3">
						<td height="14" width="40" align="center" bgcolor="ffffcf" class="labelit">
							<img src="#SESSION.root#/images/group3.gif" alt="Connector" border="0" align="absmiddle">
						</td>
						<td width="70%" style="padding-left:3px;padding-right:4px">#ActionCode#</td>
						<td align="right" style="padding-top:1px;padding-right:1px">	
							  <img src="#SESSION.root#/images/canceln.jpg" alt="" border="0" style="cursor: pointer;"
							  onclick="stepreset('#ActionCode#','RemoveAction','#ActionType#','','');">
						</td>	  				
					</tr>
					
					<tr>
					<cfif ActionType eq "Action">
						<td colspan="3" style="padding-left:3px;padding-right:3px" align="center" bgcolor="EAFAAB" class="labelit">
					<cfelse>
						<td colspan="3" style="padding-left:3px;padding-right:4px" align="center" bgcolor="BDE2F0" class="labelit">
					</cfif>	
					<cfif len(Missing.ActionDescription) gt "16">
					  <a href="##" title="#Missing.ActionDescription#">#left(ActionDescription,16)#..</a>
					<cfelse>  
					  #ActionDescription#
					</cfif>
					</td></tr>
				</table>
						
			</div>
		
		</td>
		
		<cfif ln eq "5">
		  </tr>
		  <cfset ln="1">
		<cfelse>
		  <cfset ln=#ln#+1>
		</cfif>	
		
	</cfloop>
	
	<tr><td colspan="5"></td></tr>
	<tr><td colspan="5" class="line"></td></tr>
	
	</table>
						
<cfelse>
		
	<cfif url.PublishNo eq "">		
	
		<cfquery name="Check" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * FROM #tbl#
		  	WHERE  EntityCode   = '#url.entityCode#' 
		    AND    EntityClass  = '#url.entityClass#' 
		</cfquery>	
		
		<cfif Check.recordcount gt "0" and url.publishNo eq "">
				
		<table width="100%">
		    
			<tr class="line" style="border-top:1px solid silver">
			<td style="min-width:420px;font-size:18px;padding-left:10px;height:35px" class="labelmedium">			
			<font color="008000">This workflow is consistent and can be published !
			</td>
			<td style="padding-left:10px">
			<cfif URL.Print eq "0">
				<cfif URL.PublishNo eq "">
					<input type="button" style="width:180px" name="Publish" id="Publish" value="Publish it now" class="button10g" onClick="javascript:publish()">				
				</cfif>
			</cfif>
			</td>
			<td style="width:100%"></td>
			</tr>
			
		</table>	
						
		</cfif>
	
	</cfif>
		
</cfif>	

	
</cfoutput>	