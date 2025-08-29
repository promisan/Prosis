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
<cfparam name="url.assetid" default="">

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Usernames
	WHERE    Account = '#SESSION.acc#'	
</cfquery>

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  I.Category
    FROM    AssetItem A INNER JOIN
            Item I ON A.ItemNo = I.ItemNo
    WHERE     (A.AssetId = '#url.assetid#')
</cfquery>	

<cf_textareascript>
<cf_calendarscript>

<cf_screentop height="100%" jquery="Yes" band="no" scroll="Yes" label="#url.ObservationClass# : New Record" layout="webapp" banner="gray">

<cfajaximport tags="cfwindow">

<cfform style="height:99%" action="DocumentEntrySubmit.cfm?assetid=#url.assetid#&category=#get.category#&observationclass=#url.observationclass#" method="POST" target="result">
  
<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="7"></td></tr>

<tr class="hide"><td colspan="6"><iframe name="result" id="result" width="100%"></iframe></td></tr>
	
<cfquery name="Action" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  DISTINCT ActionCategory, Description
	 FROM    Ref_AssetAction R, Ref_AssetActionCategory C
	 WHERE   R.Code     = C.ActionCategory	
	  
	 AND    (
	 
	         R.Code IN (SELECT ActionCategory 
	                    FROM   AssetItemAssetAction 
						WHERE  AssetId = '#url.assetid#')
						
			 OR 
			
			 C.Category = '#get.Category#'				
			 
			) 
						
</cfquery>

<tr><td width="100" class="labelmedium">Class: <font color="FF0000">*</font></td>
    <td width="20%">
	    <select name="actioncategory" class="regularxl">
	    <cfoutput query="Action">
			<option value="#ActionCategory#">#Description#</option>
		</cfoutput>
	    </select>
	</td>
	
    <td width="100" class="labelmedium">Observation: <font color="FF0000">*</font></td>
    <td width="20%">
	   <cfdiv bind="url:DocumentEntryObservation.cfm?category=#get.category#&actioncategory={actioncategory}" id="observ"/>		  
	</td>

   <td class="labelmedium">Priority:</td>
   	
   <td>
   
	    <table>
			<tr>
			<td><input type="radio" class="radiol" name="ObservationPriority" value="Low"></td><td style="padding-left:3px" class="labelmedium">Low</td>
			<td><input type="radio" class="radiol" name="ObservationPriority" value="Normal" checked></td><td style="padding-left:3px" class="labelmedium">Normal</td>
			<td><input type="radio" class="radiol" name="ObservationPriority" value="High"></td><td style="padding-left:3px" class="labelmedium">High</td>
			</tr>
		</table>
		
	</td>
	   	
</tr>


<tr><td class="labelmedium">Date: <font color="FF0000">*</font></td>
    <td colspan="5">
	
	<cf_intelliCalendarDate9
			FieldName="ObservationDate" 
			Manual="True"	
			class="regularxl"												
			Default="#dateformat(now(),CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			
	</td>
</tr>			

<tr><td class="labelmedium">Observation&nbsp;Briefs: <font color="FF0000">*</font></td>
    <td colspan="5">
		<cfinput type = "Text"
	       name       = "ObservationMemo"
	       message    = "Please provide a name for your observation"
	       validate   = "noblanks"
	       required   = "Yes"
	       visible    = "Yes"
	       enabled    = "Yes"     
	       size       = "90"
	       maxlength  = "120"
    	   class      = "regularxl">
    </td>
</tr>

<tr><td class="labelmedium" style="height:25">Workgroup:</td>
    <td colspan="5">	
	<cfdiv bind="url:DocumentEntryGroup.cfm?owner=" id="workgrp"/>			
	</td>
</tr>

<cf_assignId>

<cfoutput>
	<input type="hidden" name="ObservationId" id="ObservationId" value="#rowguid#">	
</cfoutput>

<tr><td colspan="6" valign="top" style="padding-top:10">

    <cf_textarea skin="flat" color="ffffff" toolbar = "Full" init="Yes" height="370" name="ObservationOutLine"></cf_textarea>		
	 
	</td>
</tr>

<tr><td colspan="1" class="labelmedium"><cf_tl id="Attachments">:</td><td width="80%" id="mod" colspan="5">

	<cf_filelibraryN
			DocumentPath  = "AssObservation"
			SubDirectory  = "#rowguid#" 
			Filter        = ""						
			LoadScript    = "1"		
			EmbedGraphic  = "no"
			Width         = "100%"
			Box           = "mod"
			Insert        = "yes"
			Remove        = "yes">	

</td></tr>

<tr><td height="4"></td></tr>

<tr><td colspan="6" height="40" align="center" id="save">

	<input type="button" name="Save" id="Save" class="button10g" value="Close" onclick="window.close()">
	<input type="submit" name="Save" id="Save" class="button10g" value="Save">

</td></tr>

</table>

</cfform>


<cfset AjaxOnload("initTextArea")>	

<cf_screenbottom layout="webapp">
