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
<!--- 
<cf_screentop height="100%" scroll="Yes" html="No">
--->
 
<cfinclude template="EntityScript.cfm">

<cfparam name="url.mode" default="dialog">

<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Entity R, 
	       Ref_AuthorizationRole Role
	WHERE  R.EntityCode = '#URL.ID#'
	AND    R.Role = Role.Role
</cfquery>


<cfform onsubmit="return false" name="entityform" style="height:98%">

<cfif url.mode eq "dialog">
	
	<table width="100%" height="98%" bgcolor="ffffff" align="center">
	
<cfelse>

	<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">
	
	<table height="100%" width="96%" align="center" class="formpadding">
	
	<!---	
    <tr>
     <td height="20" colspan="4" style="padding-top:5px" class="labellarge">
     &nbsp;&nbsp;<img src="<cfoutput>#SESSION.root#/images/Workflow_action.gif</cfoutput>" align="absmiddle" alt="" border="0">
     <b>Configuration</b>
     </td>  
    </tr>
	---> 
		
	<tr class="line">
	  <td colspan="4" valign="top">
	
			<table width="98%" align="center">
			
			<cfoutput query="Entity">
		
				<TR class="labelmedium2">	   
				    <TD height="23"><b>#EntityDescription# [#EntityCode#]</TD>				    
					<TD><i><cf_tl id="Role">:</i>&nbsp;#Description#</TD>
				    <TD align="right" style="padding-right:4px" class="labelmedium2">#DateFormat(Created, "#CLIENT.DateFormatShow#")#</td>
					<cfif url.mode neq "Dialog">
					<td width="120" id="result" align="right"></td> 			
					</cfif>
			    </tr>					
			
			</cfoutput>
			
			</table>
	 </td>
	</tr> 	
			

</cfif>


<tr>

  <td height="20" colspan="4" align="left" valign="top">
 		
    <table width="100%" align="center">
			
	<tr>
 			
	<cfoutput>
	<input type="hidden" name="mission" id="mission" value="#url.mission#">
	</cfoutput>
	
	<cf_menuscript>
	
	<cfset ht = "64">
	<cfset wd = "64">
	
	<cf_menutab base = "entity"
	        item       = "1" 
            iconsrc    = "Logos/System/Settings.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#" 
			target     = "entitytg"
			class      = "highlight1"
			name       = "General Entity Settings">		
				
			
	<cf_menutab item       = "2" 
	        base = "entity"
			target="entitytg"
            iconsrc    = "Logos/Workflow.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#" 
			name       = "Workflow Settings">			
			
	<cf_menutab item       = "3"
	        base = "entity" 
			target="entitytg"
            iconsrc    = "Table.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#" 
			name       = "Master Table">									
									
	<cf_menutab item       = "4" 
	        base = "entity"
			target="entitytg"
            iconsrc    = "Reset.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#" 
			name       = "Workflow Reset">		
			
		
	
	</table>

</td></tr>

<tr><td height="100%" colspan="4">

	 <table width="100%" height="100%" align="center">
	 
	 <cf_menucontainer name="entitytg" item="1" class="regular">			
	 
	 	 <cfinclude template="EntityEditGeneral.cfm">
	 
	 </cf_menucontainer>
	 
	 <cf_menucontainer name="entitytg" item="2" class="hide">			
	 
	 	 <cfinclude template="EntityEditWorkflow.cfm">
	 
	 </cf_menucontainer>
	 
	 <cf_menucontainer name="entitytg" item="3" class="hide">	
	 
		 <table width="95%" align="center" class="formpadding">  
			
			<tr><td height="7"></td></tr>	
			<tr><td colspan="2" class="labelmedium"><font color="0080C0">Please do not change this section unless instructed by Vendor</td></tr>
			<tr><td height="5"></td></tr>	
			<TR>
		    <td class="labelmedium">Source table:</td>
			<td><cfinput type="Text" name="EntityTableName" value="#Entity.EntityTableName#" size="50" maxlength="50" class="regularxxl">
			</td>
			</TR>	
				
			<TR>
		    <td class="labelmedium">Key field 1:</td>
			<td><cfinput type="Text" name="EntityKeyField1" value="#Entity.EntityKeyField1#" size="30" maxlength="30" class="regularxxl">
			</td>
			</TR>	
					
			<TR>
		    <td class="labelmedium">Key field 2:</td>
			<td><cfinput type="Text" name="EntityKeyField2" value="#Entity.EntityKeyField2#" size="30" maxlength="30" class="regularxxl">
			</td>
			</TR>	
				
			<TR>
		    <td class="labelmedium">Key field 3:</td>
			<td><cfinput type="Text" name="EntityKeyField3" value="#Entity.EntityKeyField3#" size="30" maxlength="30" class="regularxxl">
			</td>
			</TR>		
			<TR>
		    <td class="labelmedium">Key field 4:</td>
			<td><cfinput type="Text" name="EntityKeyField4" value="#Entity.EntityKeyField4#" size="30" maxlength="30" class="regularxxl">
			</td>
			</TR>	
						
			<tr>	
			<cf_UIToolTip tooltip="Removes workflow objects for objects of this class that do not appear in the Master Document anymore">
			<td class="labelmedium" style="cursor:pointer">Object Integrity: </td>
			</cf_UIToolTip>
			    
			<td class="regular">	
				<input type="radio" class="radiol" name="EnableIntegrityCheck" id="EnableIntegrityCheck" value="1" <cfif "1" eq Entity.EnableIntegrityCheck>checked</cfif>>Yes
				<input type="radio" class="radiol" name="EnableIntegrityCheck" id="EnableIntegrityCheck" value="0" <cfif "0" eq Entity.EnableIntegrityCheck>checked</cfif>>No
		    </td>
			</TR>	
			
			<tr><td height="5"></td></tr>
			<tr><td height="1" class="line" colspan="2"></td></tr>
			<tr><td height="5"></td></tr>
			
			<tr><td align="center" colspan="2">
			  <input type="button" name="save" id="save" value="Apply" class="button10g" onclick="validate()"> 
			</td></tr>		
			
		</table>		
	 	 
	 </cf_menucontainer>
	  
	 <cf_menucontainer item="4" name="entitytg" class="hide">	
	   
		    <table width="98%" align="center" class="formpadding">
			  <tr><td height="9"></td></tr>
			  <tr>
			  	<td colspan="2" class="labels">
				  <b>Note:</b><font color="gray">&nbsp;This section sets the condition under which a workflow object may be reopened by the administrator or authorised user.
				  <br><br>
				  [<b>Example</b>: A Procurement Job should not be re-opened if the lines of the Purchase order have been (partially) received.]
			  	  </font>
			    </td>
	 		  </tr>
			  <tr><td height="6"></td></tr>
			  <tr><td colspan="2"  class="labelmedium2" align="center"><b>The below query needs to return 0 records (no records returned) in order to reopen a workflow.</td></tr>
			  <tr><td height="12"></td></tr>
			   <tr>
			  	<td colspan="2"  class="labelmediumn2">
				 Datasource alias:  <input type="text" name="ConditionAlias" value="<cfoutput>#entity.ConditionAlias#</cfoutput>" class="regular" size="20" maxlength="20">				 
				</td>
			  </tr>
			  <tr>
			  	<td colspan="2">
				  <textarea class="regular" name="ConditionScript" style="font-size:13px;padding:4px;height:240;width:100%"><cfoutput>#Entity.ConditionScript#</cfoutput></textarea>
				</td>
			  </tr>
			  <tr><td height="12"></td></tr>
			  <TR>
		      	<td height="10" colspan="2" class="labelmedium2">Use <b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification</td>
			  </tr>
			   <tr><td height="12"></td></tr>
			   <tr><td colspan="2" class="line"></td></tr> 
			  <tr>
			  <td height="20" class="labelmedium">
			    <a href="javascript:ptoken.navigate('EntityVerifyScript.cfm','verify','','','POST','entityform')">Verify script</a>
			  </td>
			  <td align="right" id="verify" class="labelmedium"></td>
			  </tr>
			  <tr><td colspan="2" class="line"></td></tr>
			  </table>
	 
 	    </cf_menucontainer>
	 
	 </table>

	</td></tr>
			
	<cfif url.mode eq "dialog">
				
		<tr bgcolor="FfFfFf" class="hide">
	    <td width="100%" colspan="4" id="result" align="center" height="21" style="border-left: 1px silver;"></td>    
		</tr>			
		
	</cfif>
			
</TABLE>

</CFFORM>	
						

<cfif Entity.EnableCreate eq "0" >
	
	<script>		
		try { toggleval(false)	} catch(e) {}
	</script>	
	
</cfif>
