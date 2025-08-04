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

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../../../../print.css" media="print">

<cfparam name="URL.Connector"    default="INIT"> <!--- JOB0080 / INIT --->
<cfparam name="url.link"         default="'#URL.Connector#'">
<cfparam name="URL.PublishNo"    default="">
<cfparam name="URL.ActionNoShow" default="000">
<cfparam name="URL.Print"        default="0">

<cfset link = url.link>

<cfif URL.PublishNo eq "">
	<cfset tbl = "Ref_EntityClassAction">
<cfelse>
	<cfset tbl = "Ref_EntityActionPublish">
</cfif>

<cfparam name="type" default="Action">
<cfparam name="lvl" default="1">
<cfparam name="show" default="''">
<cfparam name="order" default="0">

<cfset w  = "140">
<cfset ht = "20">
<cfset b  = "140">
<cfset h  = "50">
<cfset l  = "12">

<cfset entitycode  = "#URL.EntityCode#">
<cfset entityclass = "#URL.EntityClass#">
<cfset publishNo   = "#URL.PublishNo#">

<cfinvoke component="Service.Access"  
	   method="workflowadmin" 
	   entitycode="#entitycode#" 
	   entityclass="#entityclass#"
	   returnvariable="accessWorkflow">		      
		
<!--- determine order fields --->

<cfif link eq "'INIT'">
	
	<cfquery name="ResetOrder" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE #tbl#
	 SET      ActionBranch = NULL,
	          ActionOrder = NULL
	 <cfif PublishNo eq "">	   
	   	WHERE  EntityCode      = '#entityCode#' 
	    AND    EntityClass     = '#entityClass#' 
	 <cfelse>
		WHERE  ActionPublishNo = '#publishNo#' 
	 </cfif>
	</cfquery>	

</cfif>

<cfset drag = 0>

<!--- generate the flow chart --->
<cfsavecontent variable="flowchart">
	<cfif link neq "'INIT'">	<!--- add connector if displaying subbranch --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td height="14"></td></tr>
			<cfif URL.Print eq "0">
				<tr><td align="center">
				<input type="button" name="Back" id="Back" value="Back to Top" class="button10g" onClick="javascript:window.load('')">
				</td></tr>
			</cfif>
			 <tr>
				 <td height="14" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
		  			 		<tr><td height="14" width="3" bgcolor="black"></td></tr>
			    	</table>
				 </td>
			 </tr>				 
		</table>
	</cfif>	
	
	<cfinclude template="FlowViewActionPrint.cfm">
	
</cfsavecontent>


<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Class" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Ref_Entity E, Ref_EntityClass R
	 WHERE    R.EntityCode  = '#entityCode#'
	 AND      R.EntityClass = '#entityClass#'
	 AND      R.EntityCode  = E.EntityCode 
</cfquery>	

<cfoutput>
<cfif URL.Print neq "0">

	<table width="99%" height="60" border="0" cellspacing="0" align="center" cellpadding="0" class="formpadding">
		<tr>
		<td height="20" width="15%" align="right"><b>WORKFLOW</b><td colspan="2"></td>
		</tr>
		<tr>
		<td height="10" align="right"><strong>ENTITY:</strong></td><td><strong>&nbsp;#Entity.EntityDescription# [#Entity.EntityCode#]</strong></td>
		</tr>
		<td height="10" align="right"><strong>CLASS:</strong></td><td><strong>&nbsp;#Class.EntityClassName# [#URL.EntityClass#]</strong></td>
		<td align="right">#DateFormat(NOW(),"dd/mm/yyyy")#</td>
		</tr>
		<tr><td height="5"></td></tr>
		
	<cfif PublishNo neq "">
	
		<cfquery name="Publish" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Ref_EntityClassPublish P
			 WHERE    EntityCode      = '#entityCode#'
			 AND      EntityClass     = '#entityClass#'
			 AND      ActionPublishNo = '#PublishNo#'
		</cfquery>	
		
		<tr>
		<td align="right">Published:</td>
		<td><b>&nbsp;#dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)# at : #timeFormat(Publish.DateEffective, "HH:MM")# [#Publish.ActionPublishNo#]</td>
		</tr>
		<tr>
		<td align="right">Status:</td>
		<td>
		<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT top 1 ActionPublishNo
			FROM     OrganizationObject
			WHERE    ActionPublishNo = '#PublishNo#' 
		</cfquery>

		<cfif Check.recordcount gte "1">
			Workflow is in use
		<cfelse> 
			Workflow is NOT in use</cfif>
		</td>
		</tr>
		
		<tr><td class="line" colspan="3"></td></tr>
		<tr><td height="3" colspan="3"></td></tr>
		
	<cfelse>
		
		<tr>
		<td align="right">Draft workflow:</td>
		
			<cfquery name="Publish" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Ref_EntityClassPublish P
				 WHERE    EntityCode = '#entityCode#'
				 AND      EntityClass = '#entityClass#'
				 Order by DateEffective DESC  
			</cfquery>	
			
			 <cfif Publish.recordcount gt "0">			
				<td>Last Published: #dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)# at : #timeFormat(Publish.DateEffective, "HH:MM")# [#Publish.ActionPublishNo#]</td>
			<cfelse>
				<td>Not Published</td>
			</cfif>			
			</tr>								
	</cfif>
		
		<tr><td height="10" colspan="9" class="line"></td></tr>
		</tr>
	</table>	
	
<cfelse>

<table width="99%" height="60" border="0" cellspacing="0" align="center" cellpadding="0" class="formpadding">

	<tr>
	<td width="40" height="28">&nbsp;Entity:</td>
	<td width="25%"><b>&nbsp;#Class.EntityDescription#</td>
	<td align="right">

		<cfquery name="CheckLog" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * FROM Ref_EntityClassActionLog
		  	WHERE  EntityCode   = '#url.entityCode#' 
		    AND    EntityClass  = '#url.entityClass#' 
		</cfquery>	
	
		<cfdiv id="noRefresh" style="display: inline; width: 20px">
			<cf_UIToolTip tooltip="Last Log: #CheckLog.Created#">
			<cfif CheckLog.RecordCount neq "0">
				<input type="button" name="Restore" id="RestoreButton" value="Restore" class="button10g" onClick="javascript:restore()">; 
			</cfif>
			</cf_UIToolTip>
		</cfdiv>

	<input type="button" name="Log" id="Log" value="Log" class="button10g" onClick="javascript:log()">	
	<input type="button" name="ConfigurePrint" id="ConfigurePrint" value="Config Print" class="button10g" onClick="javascript:PrintDetails()">				
	<input type="button" name="Print" id="Print" value="WF Print" class="button10g" onClick="javascript:PrintWF()">
	<cfif URL.PublishNo eq "">
	<input type="button" name="Reset" id="Reset" value="Reset" class="button10g" onClick="javascript:flowreset()">&nbsp;
	</cfif>
	</td>
	</tr>
	<tr><td height="1" colspan="3" class="line"></td></tr>
	<tr>
	<td colspan="2" height="24">&nbsp;&nbsp;
	<img src="<cfoutput>#SESSION.root#/images/workflow_manager.gif</cfoutput>" align="absmiddle" alt="" border="0">
	<b>&nbsp;#Class.EntityClassName#</td>
	<td align="right">
		<cfif PublishNo eq "">
		
		    <cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_EntityAction 
			WHERE ActionCode NOT IN (SELECT ActionCode 
									FROM Ref_EntityClassAction 
									WHERE EntityCode    = '#URL.EntityCode#'
									AND   EntityClass   = '#URL.EntityClass#') 
			</cfquery>
		
		    <cfif #Check.recordcount# gt "0" and (accessWorkflow eq "EDIT" OR accessWorkflow eq "ALL")>
			 <a href="javascript:stepadd()">Insert workflow step&nbsp;&nbsp;</a>
			</cfif>
			  
		</cfif>			  
		</td>
		</tr>
		
		<cfif accessWorkflow eq "NONE" or accessWorkflow eq "READ">
		<tr><td colspan="3">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			 <td height="14" align="center" bgcolor="ffffcf">You have READ access only</td>
			</tr>	 
		</table>
		</td>
		</tr>
	    </cfif>
		
	<cfif PublishNo neq "">
	
		<cfquery name="Publish" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Ref_EntityClassPublish P
			 WHERE    EntityCode      = '#entityCode#'
			 AND      EntityClass     = '#entityClass#'
			 AND      ActionPublishNo = '#PublishNo#'
		</cfquery>	
		
		<tr>
		<td height="20">&nbsp;&nbsp;&nbsp;&nbsp;Published:</td>
		<td><b>&nbsp;#dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)# at : #timeFormat(Publish.DateEffective, "HH:MM")# [#Publish.ActionPublishNo#]</td>
		<td align="center">
		
		<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT top 1 ActionPublishNo
			FROM     OrganizationObject
			WHERE    ActionPublishNo = '#PublishNo#' 
		</cfquery>
		<font color="0080FF">Status:</font>
		<cfif Check.recordcount gte "1">
			Workflow is in use
		<cfelse> 
		   <a title="Remove workflow" href="javascript:remove('#PublishNo#')">Workflow is NOT in use
		   <img onclick="javascript:remove('#PublishNo#')"
		        src="<cfoutput>#SESSION.root#</cfoutput>/images/delete4.gif" 
				align="absmiddle" 
				alt="" 
				border="0">
		   </a>
		</cfif>&nbsp;
		</td>
		</tr>
		
		<tr><td class="line" colspan="3"></td></tr>
		<tr><td height="3" colspan="3"></td></tr>
		
	<cfelse>
		
			<cfquery name="Publish" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Ref_EntityClassPublish P
				 WHERE    EntityCode = '#entityCode#'
				 AND      EntityClass = '#entityClass#'  
			</cfquery>	
			
			<tr>
			 <cfif Publish.recordcount gt "0">			
				<td height="20">&nbsp;Published:</td>
				<td>
		            <select name="Published" id="Published" onChange="load(this.value)">
					<option value="">Draft workflow</option>
		            <cfloop query="Publish">
		            <option value="#ActionPublishNo#">#dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)#</option>
		            </cfloop>
					</select>					
				</td>
			</cfif>			
			</tr>								
	</cfif>
		
</table>		
				
</cfif>

<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td height="5"></td></tr>
													
	<tr><td colspan="3" height="99%" valign="top">	
			
		  	#flowchart#

	</td></tr>
							
</table>
				
</cfoutput>				
					
</body>
</HTML>

