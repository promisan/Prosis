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

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Action" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

	<table width="93%" align="center" class="formpadding formspacing">
	
	<tr><td height="8"></td></tr>
	
		 <cfquery name="Src" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ActionSource		
		</cfquery>
		 
		<TR>
		 <TD width="150" class="labelmedium2">Source:&nbsp;</TD>  
		 <TD>
		 	<select name="ActionSource" class="regularxxl" onchange="javascript: ColdFusion.navigate('EntityClass.cfm?ActionSource='+this.value+'&entityClass=','divWorkflow');">
			<cfoutput query="Src">
			<option value="#ActionSource#">#ActionSource#</option>
			</cfoutput>
			</select>
		 </TD>
		</TR>
		
	    <TR>
	    <TD class="labelmedium2">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="ActionCode" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Effective Mode:</TD>
	    <TD class="labelmedium2" style="height:25px">
	  	   <input type="radio" class="radiol" name="ModeEffective" value="0" checked>Validate
		   <input type="radio" class="radiol" name="ModeEffective" value="1">Allow overlap
		   <input type="radio" class="radiol" name="ModeEffective" value="9">Disable Edit
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Workflow:</TD>
	    <TD style="height:25px" class="labelmedium">
			<cf_securediv id="divWorkflow" bind="url:EntityClass.cfm?ActionSource=#Src.ActionSource#&entityClass=">
	    </TD>
		</TR>
		
		
		<TR>
	    <TD class="labelmedium">Operational:</TD>
	    <TD>
	  	   <input type="checkbox" class="radiol" name="Operational" value="1" checked>
	    </TD>
		</TR>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>		
		<td align="center" colspan="2" height="40">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
		</td>		
		</tr>
		
	</TABLE>

</CFFORM>

