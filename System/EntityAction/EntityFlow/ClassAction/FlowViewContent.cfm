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

<cfset link = url.link>

<cfif URL.PublishNo eq "">

	<cfset tbl = "Ref_EntityClassAction">
	
	<cfquery name="Clean" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  DELETE FROM Ref_EntityClassActionProcess
		  	WHERE  EntityCode      = '#entityCode#' 
		    AND    EntityClass     = '#entityClass#' 
		    AND     (ProcessActionCode NOT IN
			             (SELECT     ActionCode
			               FROM      Ref_EntityClassAction
			               WHERE     EntityCode      = '#entityCode#' 
						   AND       EntityClass     = '#entityClass#')
					)
	</cfquery>		
	
<cfelse>

	<cfset tbl = "Ref_EntityActionPublish">
	
	<cfquery name="Clean" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  DELETE FROM Ref_EntityActionPublishProcess
		   WHERE   ActionPublishNo = '#URL.PublishNo#'  
		   AND     ProcessActionCode NOT IN
			             (SELECT     ActionCode
			               FROM      Ref_EntityActionPublish
			               WHERE     ActionPublishNo = '#URL.PublishNo#')
	</cfquery>		
	
</cfif>

<cfinclude template="FlowViewScript.cfm">

<cfparam name="type"   default="Action">
<cfparam name="lvl"    default="1">
<cfparam name="show"   default="''">
<cfparam name="order"  default="0">

<cfset w  = "140">
<cfset ht = "20">
<cfset b  = "140">
<cfset h  = "50">
<cfset l  = "12">

<cfset entitycode   = "#URL.EntityCode#">
<cfset entityclass  = "#URL.EntityClass#">
<cfset publishNo    = "#URL.PublishNo#">

<cfinvoke component = "Service.Access"  
	method          = "workflowadmin" 
	entitycode      = "#entitycode#" 
	entityclass     = "#entityclass#"
	returnvariable  = "accessWorkflow">		      
	   	
<!--- determine order fields --->

<cfif link eq "'INIT'">
	
	<cfquery name="ResetOrder" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE   #tbl#
		 SET      ActionBranch = NULL
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
			<tr><td align="center">
			<input type="button" name="Back" id="Back" value="Back to Top" style="width:240;height:26;font-size:14px" class="button10g" onClick="javascript:window.load('')"></td></tr>
			 <tr>
				 <td height="14" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
		  			 		<tr><td height="14" width="3" bgcolor="black"></td></tr>
			    	</table>
				 </td>
			 </tr>				 
		</table>
	</cfif>	
		
	<cfinclude template="FlowViewAction.cfm">
		
</cfsavecontent>

<table align="center" border="0" width="100%"  cellspacing="0"  
  style="padding-left:25px;padding-right:25px"  bgcolor="ffffff">

	<cfif url.scope eq "Config">
	
	<tr>
	<td style="padding-left:10px;font-size:30px;height:50px;font-weight:200" colspan="2" class="labelmedium fixlength">#Class.EntityDescription# : <font size="3">#Class.EntityClassName#</td>
	<td align="right" style="padding:3px">
	
			<table class="formspacing">
			<tr>
		
			<cfif PublishNo eq "">
	
				<cfquery name="CheckLog" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				    SELECT * 
					FROM   Ref_EntityClassActionLog
				  	WHERE  EntityCode   = '#url.entityCode#' 
				    AND    EntityClass  = '#url.entityClass#' 
				</cfquery>	
			
					<cf_UIToolTip tooltip="Last Log: #CheckLog.Created#">
					
					<td id="noRefresh">
					<cfif CheckLog.RecordCount neq "0">
					    
						<input type="button" 
						       style="width:70" 
							   name="Restore" 
							   id="RestoreButton" 
							   value="Restore" 
							   class="button10g" 
							   onClick="restore()">
							   
					</cfif>
					</td>
					</cf_UIToolTip>
						
				<td>
				    
					<input type="button" name="Log" id="Log" style="width:70" value="Log" class="button10g" onClick="log()">
					
				</td>	
			<cfelse>
				<td><input type="button" name="Copy" id="Copy" style="width:70" value="Copy" class="button10g" onClick="copyto()"></td>
				<td><input type="button" name="Compare" id="Compare" style="width:90" value="Compare To" class="button10g" onClick="compareto()"></td>
				<td><input type="button" name="Export" id="Export" style="width:90" value="Export" class="button10g" onClick="exportFlow()"></td>
			</cfif>			
			
			<td><input type="button" name="ConfigurePrint" id="ConfigurePrint" style="width:70" value="Print" class="button10g" onClick="javascript:PrintWFX()"></td>				
					
			<cfif URL.PublishNo eq "">
				<td><input type="button" name="Reset" id="Reset" style="width:70" value="Reset" class="button10g" onClick="javascript:flowreset()"></td>
			</cfif>
			
			</tr>
			</table>
			
	</td>
	</tr>
	
	</cfif>
			
	<cfif url.scope eq "Config">
	
		<cfif accessWorkflow eq "NONE" or accessWorkflow eq "READ">
		<tr><td colspan="3">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				 <td height="14" align="center" bgcolor="ffffcf" class="labelit">You have READ access only</td>
				</tr>	 
		    </table>
		</td>
		</tr>		
	    </cfif>
		
	<cfelse>
	
	    <!---
	
		<tr class="line"><td colspan="3">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				 <td style="height:40px" align="center" class="labelit">
				 <img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle"><font color="gray">Click on action description to view actors.
				 </td>
				</tr>	 
		    </table>
		</td>
		</tr>
		
		--->
		
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
		
		<tr class="labelmedium line fixlengthlist">
		<td style="height:29px;font-size:18px;padding-left:10px" ><cf_tl id="Published">:</td>
		<td style="font-size:18px;padding-left:10px">#dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)# at : #timeFormat(Publish.DateEffective, "HH:MM")# [#Publish.ActionPublishNo#]</td>
		<td align="center" style="padding-left:10px;font-size:18px;">
						
		<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT top 1 ActionPublishNo
			FROM     OrganizationObject
			WHERE    ActionPublishNo = '#PublishNo#' 
		</cfquery>
		Status:
		<cfif Check.recordcount gte "1">
			<b>Workflow IN USE
		<cfelse>
		 
		   <a title="Remove workflow" href="javascript:remove('#PublishNo#')"><font color="green"><cf_tl id="Workflow NOT IN USE">
		 
		   <img onclick="javascript:remove('#PublishNo#')"
		        src="<cfoutput>#SESSION.root#</cfoutput>/images/delete5.gif" 
				align="absmiddle" 
				alt="Delete" 
				border="0">
				
		   </a>
		</cfif>
		
		</td>
		</tr>
		
		
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
		 <cfif Publish.recordcount gte "0">
			
			<td class="labelmedium" style="height:30px;padding-left:10px"><cf_tl id="Select version">:</td>
			<td>
			
	            <select name="Published" id="Published" class="regularxl" style="width:250px" onChange="load(this.value)">
				<option value="">Draft workflow</option>
	            <cfloop query="Publish">
	            <option value="#ActionPublishNo#">#dateFormat(Publish.DateEffective, CLIENT.DateFormatShow)#</option>
	            </cfloop>
			    </select>		
				
				<cfif PublishNo eq "">
				
				<td align="right" style="font-size:16px;padding-top:4px;padding-right:8px" class="labelmedium2">
		
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
				
				    <cfif Check.recordcount gt "0" and (accessWorkflow eq "EDIT" OR accessWorkflow eq "ALL")>					 
					 <a href="javascript:stepadd()">[Insert additional workflow actions]</a>					 
					</cfif>
					  
				</cfif>		
				
				</td>	  									
			
			</td>
		
		</tr>	
				
		</cfif>						
			
	</cfif>
					
<cfif PublishNo eq "">	
	
	<tr><td height="1" colspan="3">
	<cfinclude template="FlowViewMissing.cfm">	
	</td></tr>
		
	<cfif Missing.recordcount gt "0">
		
		<script type="text/javascript">
			SET_DHTML(SCROLL, #replace(dr,"'",'"',"ALL")#);
		</script> 
		
	</cfif>	
	
	<tr>
	<td colspan="3" height="10">

		<table width="20%" cellspacing="0" cellpadding="0">
			<tr id="DragActionNone">
				<td>&nbsp;</td>
			</tr>
			<tr class="hide" id="DragActionInsert">
				<td class="labelit" bgcolor="cyan" align="center" style="padding-left:10px">Drop Mode: INSERT</td>
			</tr>
			<tr id="DragActionConcurrent" class="hide">
				<td class="labelit" bgcolor="orange" align="center" style="padding-left:10px">Drop Mode: CONCURRENT</td>
			</tr>								
		</table>
	
	</td>
	</tr>

</cfif>

													
<tr><td colspan="3" style="padding-top:4px;padding-left:19px;padding-right:19px;padding-bottom:10px" class="labelit" height="100%" valign="top">	
			
	<cfif trim(flowchart) eq "">
		
		<table id="d1" width="100%" height="400">
		 <tr><td id="bd1">
			<input type="hidden" name="action1" id="action1" value="init">
		    <input type="hidden" name="type1" id="type1" value="init">
		    <input type="hidden" name="leg1" id="leg1" value="">
			</tr></tr>
		</table>		
		
	<cfelse>
			
		<cfif PublishNo eq "">#flowchart#<cfelse>#flowchart#</cfif>
								
	</cfif>
		
</td></tr>
							
</table>

</cfoutput>
	