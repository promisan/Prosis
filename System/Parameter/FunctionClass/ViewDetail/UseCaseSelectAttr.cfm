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
 <proUsr>dev</proUsr>
�<proOwn>dev dev</proOwn>
 <proDes>Class Entry Attributes Edit</proDes>
 <!--- specific comments for the current change, may be overwritten --->
�<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Function class Entry/Edit</title>
</head>

<body leftmargin="2" topmargin="2" rightmargin="2" bottommargin="2">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="URL.ID" default="">
<cfparam name="URL.AttrName" default="">
<cfparam name="Form.Update" default="No">

<cfparam name="Form.ClassID" default="">
<cfparam name="Form.AttrOld" default="">
<cfparam name="Form.AttrName" default="">
<cfparam name="URL.Format" default="">
<cfparam name="URL.Required" default="">
<cfparam name="URL.DefaultValue" default="">



<cfif Form.ClassID eq "">
	<cfset Form.ClassID = '#URL.Id#'>
</cfif>

<cfoutput>

<script language="JavaScript">

var root = "#root#";



 
</script>  


<cfquery name="AttrList" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ClassFunctionAttribute
	WHERE ClassFunctionId = '#URL.ID#'
	order by created 
</cfquery>





<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td colspan="5" bgcolor="silver"></td></tr>	
<tr><td align="center" colspan="5"><input value="Add" type="button" class="button10g" name="Add" id="Add"  onclick="javascript:addattribute('#URL.ID#','#URL.AttrName#')"></td></tr>
	
<tr height="25">
<td width="10%" align="left"><b>Attribute</b></td>
<td width="10%" align="left"><b>Format</b></td>
<td width="10%" align="left"><b>Required?</b></td>
<td width="10%" align="left"><b>Default Value</b></td>
<td width="55%" align="left"><b>Description</b></td>
<td width="40" align="left"></td>
<td ></td>
</tr>

<cfset lines=0>
<cfloop query="AttrList">


	<cfif #Attribute# neq #URL.AttrName#>
	<tr>
		<td>#Attribute#</td>
		<td>#Format#</td>
		<td>
			<cfif #required# eq "0">
				No
			<cfelse>
				Yes
			</cfif>
			
		</td>
		<td>#DefaultValue#</td>
		<td colspan="1" style="border: 1px solid Gray;">#Description#</td>
		<td align="center" align="center" width="40">
		   <A href="javascript:addattribute('#URL.ID#','#Attribute#')">
			   <img src="#SESSION.root#/Images/edit.gif" alt="Edit"  border="0">
		   </a>

		   <A href="#AjaxLink('AttrPurge.cfm?ID=#URL.ID#&AttrName=#Attribute#')#">
			   <img src="#SESSION.root#/Images/delete4.gif" alt="Delete" border="0">
		   </a>
	   
		</td>
		
	</tr>
	<tr><td colspan="6" height="20"></td></tr>
	<tr><td colspan="6" bgcolor="silver"></td></tr>
	
	</cfif>	
</cfloop>
<cfif #URL.AttrName# neq "">
	<input type="hidden" id="update" name="update" value="Yes">
	<input type="hidden" id="AttrOld" name="AttrOld" value="#URL.AttrName#">
<cfelse>
	<input type="hidden" id="update" name="update" value="No">		
</cfif>


	


</cfoutput>

</body>
</html>
