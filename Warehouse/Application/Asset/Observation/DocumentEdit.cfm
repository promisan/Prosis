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

<cfparam name="url.id" default="#url.drillid#">

<cfoutput>
	<script>
	function save() {
		ColdFusion.navigate('DocumentEditSubmit.cfm?id=#url.id#','result','','','POST','formedit')
	}
	</script>
</cfoutput>

<cfajaximport tags="cfdiv,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_textareascript>
<cf_calendarscript>

<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   OrganizationObject
	 WHERE  ObjectKeyValue4   = '#URL.drillid#' or ObjectId = '#URL.drillid#' 
</cfquery>	

<cfquery name="Observation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    AssetItemObservation
		WHERE   ObservationId = '#URL.drillid#' <cfif Object.recordcount eq "1">or ObservationId = '#Object.ObjectKeyValue4#'</cfif>
</cfquery>

<cfif Observation.recordcount eq "0">
    <cf_message message="Problem, could not find this observation request">
    <cfabort>
</cfif>

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  I.Category
    FROM    AssetItem A INNER JOIN
            Item I ON A.ItemNo = I.ItemNo
    WHERE     (A.AssetId = '#Observation.assetid#')
</cfquery>	

<cfquery name="Group" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_EntityGroup
		WHERE  EntityCode = 'AssObservation'		
</cfquery>

<cfoutput>
	<cf_screentop height="100%" bannerheight="55" scroll="no" band="no" layout="webapp" user="yes"
	    banner="gray" label="#Observation.ObservationClass#: #Observation.ObservationNo#">
</cfoutput>

<cf_divscroll>

<table width="96%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<cfform name="formedit" action="DocumentEditSubmit.cfm?category=#observation.category#&observationid=#url.id#" method="POST">

<cfoutput query="Observation">

<tr><td class="xxhide" id="result" align="center" colspan="2"></td></tr>
	
<cfif Observation.ActionStatus eq "0" or getAdministrator(object.mission) eq "1">
	   <cfset edit = "1">
<cfelse>
	   <cfset edit = "0">   
</cfif>
	
<cfif edit eq "1">	
	
	<tr>
		<td colspan="3" height="30" align="center">		 
		  <input class="button10g" type="button" name="Cancel" id="Cancel" value="Delete" onClick="ColdFusion.navigate('DocumentEditCancel.cfm?id=#url.id#','result')">
	      <input class="button10g" type="button" name="Save" id="Save" value="Save" onClick="ColdFusion.navigate('DocumentEditSubmit.cfm?category=#observation.category#&id=#url.id#','result','','','POST','formedit')">     		 
		</td>
	</tr>
	<tr><td colspan="3" height="1" bgcolor="silver"></td></tr>

</cfif> 

<cfquery name="Action" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AssetAction R, Ref_AssetActionCategory C
	 WHERE   R.Code = C.ActionCategory	
	 AND     C.Category = '#get.Category#'	 
	 AND     R.Code IN (SELECT ActionCategory 
	                    FROM   AssetItemAssetAction 
						WHERE  AssetId = '#Observation.assetid#')
						
</cfquery>

<tr><td height="20" class="labelmedium">Class: <font color="FF0000">*</font></td>
    <td colspan="2" height="30">
    <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	
	<td width="20%">
	    <select name="actioncategory">
	    <cfloop query="Action">
			<option value="#ActionCategory#" <cfif ActionCategory eq Observation.ActionCategory>selected</cfif>>#Description#</option>
		</cfloop>
	    </select>
	</td>
	
    <td width="100" class="labelmedium">Observation: <font color="FF0000">*</font></td>
    <td width="10%">
	   <cfdiv bind="url:DocumentEntryObservation.cfm?selected=get.observation&category=#get.category#&actioncategory={actioncategory}" id="observ"/>		  
	</td>

    <td style="padding-left:14px" class="labelmedium">Priority:</td>
   		
    <td>
	<cf_space spaces="60">
	<cfif edit eq "1">
	<input type="radio" name="ObservationPriority" value="Low" <cfif "Low" eq ObservationPriority>checked</cfif>>Low
		<input type="radio" name="ObservationPriority" value="Normal" <cfif "Normal" eq ObservationPriority>checked</cfif>>Normal
		<input type="radio" name="ObservationPriority" value="High" <cfif "High" eq ObservationPriority>checked</cfif>>High
	<cfelse>
	 	<b>#ObservationPriority#</b>
	</cfif>	
	</td>    
	
	 <td align="right" >
	     <cf_space spaces="100">	 
		 <cfdiv bind="url:DocumentGetStatus.cfm?observationid=#Observation.ObservationId#" id="statusbox">	 
	 </td>
	</table>
</td>	
</tr>

<tr><td colspan="3" height="1" class="linedotted"></td></tr>	

<tr><td class="labelmedium">Date: <font color="FF0000">*</font></td>
    <td colspan="5">
	<cfif edit eq "1">
	<cf_intelliCalendarDate9
			FieldName="ObservationDate" 
			Manual="True"													
			Default="#dateformat(Observation.ObservationDate,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
	<cfelse>
	<b>#dateformat(Observation.ObservationDate,CLIENT.DateFormatShow)#
	</cfif>		
			
	</td>
</tr>			

<tr><td colspan="6" class="linedotted"></td></tr>

<tr><td style="height:25" class="labelmedium">Observation&nbsp;Briefs: <font color="FF0000">*</font></td>
    <td colspan="5">
	 <cfif edit eq "1">
		<cfinput type = "Text"
	       name       = "ObservationMemo"
	       message    = "Please provide a name for your observation"
	       validate   = "noblanks"
	       required   = "Yes"
		   Value      = "#Observation.ObservationMemo#"
	       visible    = "Yes"
	       enabled    = "Yes"     
	       size       = "90"
	       maxlength  = "120"
    	   class      = "regularh">
	  <cfelse>
	    <b>#Observation.ObservationMemo#</b>
	  </cfif>	   
    </td>
</tr>


<tr><td colspan="3" height="1" class="linedotted"></td></tr>	


<tr><td class="labelmedium" style="height:25">Workgroup:</td>
    <td colspan="5">	
	<cfdiv bind="url:DocumentEntryGroup.cfm?selected=#object.entitygroup#&owner=" id="workgrp"/>			
	</td>
</tr>


<tr><td colspan="1" class="labelmedium">Attachments:</td><td width="80%" id="mod" colspan="5">

	<cf_filelibraryN
			DocumentPath  = "AssObservation"
			SubDirectory  = "#url.drillid#" 
			Filter        = ""						
			LoadScript    = "1"		
			EmbedGraphic  = "no"
			Width         = "100%"
			Box           = "mod"
			Insert        = "yes"
			Remove        = "yes">	

</td></tr>

<tr><td colspan="6" style="padding:4px;padding-right:10px">

    <table width="100%"><tr><td style="border: 1px solid d4d4d4;">
		
	 <cfif edit eq "1">	

			<cf_textarea name="ObservationOutLine"                 	           
			   height         = "200"	                     
	           toolbar        = "Full"
			   init           = "Yes"
	           skin           = "Flat">#Observation.ObservationOutline#</cftextarea>
			   
	 <cfelse>
	 
	 		#Observation.ObservationOutline#
	 
	 </cfif>
	 
	 </td></tr></table>
	 
	</td>
</tr>
  
<tr class="hide">
   <td>

   <cfset wflnk = "DocumentEditWorkflow.cfm">   
  
    <input type="hidden" 
     name="workflowlink_#url.id#" 
	 id="workflowlink_#url.id#"
     value="#wflnk#"> 
	 	 	 
	<input type="hidden" 
	   name="workflowlinkprocess_<cfoutput>#url.id#</cfoutput>" 
	   id="workflowlinkprocess_<cfoutput>#url.id#</cfoutput>"
	   onclick="ColdFusion.navigate('DocumentGetStatus.cfm?observationid=#url.id#','statusbox')">		
	 
	</td>
	
</tr>  
	 
</cfoutput>	 

<tr>
	<td colspan="3" height="100%" style="border: 0px solid Silver;">
	<div class="relative">	
		<cfdiv id="#url.id#" bind="url:#wflnk#?ajaxid=#url.id#">
	</div>
	</td>
</tr>
	
</cfform>

</td></tr>

</table>
</cf_divscroll>

<cf_screenbottom layout="webapp">
