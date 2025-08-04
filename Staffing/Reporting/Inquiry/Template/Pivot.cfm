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

<cfparam name="url.print" default="0">

<cfoutput>

<cfparam name="client.ProgramXax" default="">
<cfparam name="client.ProgramYax" default="">

<cfparam name="form.Xax" default="#client.ProgramXax#">
<cfparam name="form.Yax" default="#client.ProgramYax#">

<cfset client.ProgramXax  = form.xax> 
<cfset client.ProgramYax  = form.yax> 
<cfset client.ProgramDetail = "pivot">

<cfloop index="ax" list="X,Y">

<cfset val = #evaluate("form.#ax#ax")#>

<cfswitch expression="#val#">

	<cfcase value="PostGradeBudget">
	    <cfparam name="#Ax#axLbl" default="Post Grade">
		<cfparam name="#Ax#axOrd" default="PostOrderBudget">
		<cfparam name="#Ax#axFld" default="PostGradeBudget">		
	</cfcase>
	
	<cfcase value="OccGroupAcronym">
		<cfparam name="#Ax#axLbl" default="Occupational Group">
		<cfparam name="#Ax#axOrd" default="OccGroupAcronym">
		<cfparam name="#Ax#axFld" default="OccGroupDescription">				
	</cfcase>
	
	<cfcase value="Gender">
		<cfparam name="#Ax#axLbl" default="Gender">
		<cfparam name="#Ax#axOrd" default="Gender">
		<cfparam name="#Ax#axFld" default="Gender">				
	</cfcase>
	
	<cfcase value="Nationality">
		<cfparam name="#Ax#axLbl" default="Nationality">
		<cfparam name="#Ax#axOrd" default="Nationality">
		<cfparam name="#Ax#axFld" default="Nationality">				
	</cfcase>
	
	<cfcase value="ParentNameShort">
		<cfparam name="#Ax#axLbl" default="Unit">
		<cfparam name="#Ax#axOrd" default="HierarchyCode">
		<cfparam name="#Ax#axFld" default="OrgUnitName">				
	</cfcase>
	
	<cfcase value="PostClass">
		<cfparam name="#Ax#axLbl" default="Post Class">
		<cfparam name="#Ax#axOrd" default="PostClass">
		<cfparam name="#Ax#axFld" default="PostClass">				
	</cfcase>
	
	<cfdefaultcase>
		<cfparam name="#Ax#axLbl" default="">
		<cfparam name="#Ax#axOrd" default="">
		<cfparam name="#Ax#axFld" default="">		
	</cfdefaultcase>

</cfswitch>

</cfloop>

<cfif url.print eq "0">

<table width="100%" border="0">

<tr>
	<td align="right" height="40">
		
	<form method="POST" name="pivotform">  	
				 
	<table width="100%" align="center">
	
	  <tr>
	  <td width="70" class="labelit" style="padding-left:10px;"><b>#url.select#</b></td>	
	  
	  <td>
	  	  	
		  <table><tr>
		  <td class="labelit" style="padding-left:5px"><cf_tl id="Vertical"></td>
		  
		  <td style="padding-left:5px">	
		   
		  <select id="yax" name="yax" class="regularxl" style="width: 150px;">
		     <cfif url.item neq "PostGradeBudget">
			 	<option value="PostGradeBudget" <cfif "PostGradeBudget" eq Client.ProgramYax>selected</cfif>>Grade</option>
			 </cfif>
			 <cfif url.item neq "OccGroupAcronym">
			 	<option value="OccGroupAcronym" <cfif "OccGroupAcronym" eq Client.ProgramYax>selected</cfif>>Occupational Group</option>
			 </cfif>
			<option value="ParentNameShort" <cfif "ParentNameShort" eq Client.ProgramYax>selected</cfif>>Unit</option>
			<cfif url.item neq "PostClass">
			 	<option value="PostClass" <cfif "PostClass" eq Client.ProgramYax>selected</cfif>>Post Class</option>
			</cfif>
			<cfif url.item neq "Gender">
			 	<option value="Gender" <cfif "Gender" eq Client.ProgramYax>selected</cfif>>Gender</option>
			</cfif>	
			<cfif url.item neq "Nationality">
			 	<option value="Nationality" <cfif "Nationality" eq Client.ProgramYax>selected</cfif>>Nationality</option>
			</cfif>					
		  </select>
		  
		  </td>
		  <td style="padding-left:10px" class="labelit"><cf_tl id="Horizontal">:</td>

		  <td style="padding-left:5px">
		  <select id="xax" name="xax" class="regularxl" style="width: 150px;">
		     <cfif url.item neq "PostGradeBudget">
			 	<option value="PostGradeBudget" <cfif "PostGradeBudget" eq Client.ProgramXax>selected</cfif>>Grade</option>
			 </cfif>
			 <cfif url.item neq "OccGroupAcronym">
			 	<option value="OccGroupAcronym" <cfif "OccGroupAcronym" eq Client.ProgramXax>selected</cfif>>Occupational Group</option>
			 </cfif>
			 <cfif url.item neq "PostClass">
			 	<option value="PostClass" <cfif "PostClass" eq Client.ProgramXax>selected</cfif>>Post Class</option>
			 </cfif>
			 <cfif url.item neq "Gender">
			 	<option value="Gender" <cfif "Gender" eq Client.ProgramXax>selected</cfif>>Gender</option>
			 </cfif>	
			 <cfif url.item neq "Nationality">
			 	<option value="Nationality" <cfif "Nationality" eq Client.ProgramXax>selected</cfif>>Nationality</option>
			 </cfif>						
		  </select>
		  
		  </td> 	
		  <td style="padding-left:5px">
			<input type="button" onclick="pivotsubmit()" name="Apply" style="height:23" class="button10g" value="Apply">
		  </td>
		  
		  </tr>
		  </table>
	 	  
	  </td>
	 
	  <td width="30%">	
	      <cfinclude template="PivotMenu.cfm">		 
      </td>	
	
	</tr>
	
	</table>
	
	 </form>
		
</tr>

<tr><td class="line"></td></tr>

</table>

<cfelse>

	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	<link href="<cfoutput>#SESSION.root#/print.css</cfoutput>" rel="stylesheet" type="text/css" media="print">
	
	<table height="20" width="100%">
	
	<!---
	<tr>
	<td><cfinclude template="../../../Application/Indicator/Details/DetailViewBaseTop.cfm"></td>
	</tr>
	--->
		
	<tr><td class="label">Filter : <b>#URL.Select#</b></td></tr>
	
	<script> print() </script>
	
	<cfset form.yax = Client.ProgramYax>
	<cfset form.xax = Client.ProgramXax>
	
	</table>

</cfif>

</cfoutput>

