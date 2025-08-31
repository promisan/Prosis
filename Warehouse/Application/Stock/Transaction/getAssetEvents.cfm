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
<cfparam name="Get.Category" 		default="">
<cfparam name="URL.adate" 		default="">
<cfparam name="URL.category" 	default="">
<cfparam name="URL.assetid" 	default="">
<cfparam name="URL.hour" 		default="">
<cfparam name="URL.minute" 		default="">

<cfoutput>

<script>
	function doinsert()	{
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/AssetEventSubmit.cfm?aid=#URL.assetid#&adate=#URL.adate#&category=#URL.category#','dreturn','','','POST','fevents')
		window.close();		
	}	
</script>

</cfoutput>

<cfif Get.Category eq "">

	<cfajaximport tags="cfdiv,cfform">  			
	<cf_filelibraryScript>
	<cf_screentop layout="webapp" banner="blue" height="100%" bannerheight="60" label="Event Details">

	<div id="dreturn" class="hide"></div>

	<CF_DateConvert Value="#URL.adate#">
	<cfset tDate = dateValue>	

	<cfform id="fevents">
	
		<table border="0" width="94%" align="center">
		<cfinclude template="AssetEvents.cfm">
		<tr>
		<td colspan="2">
						<cfset vdate = Replace(URL.adate,"/","","ALL")>
						<cf_filelibraryN 
							DocumentPath="Warehouse" 
							SubDirectory="#URL.AssetId#" 
							Filter="#vdate#_#URL.Hour#_#URL.Minute#" 
							Insert="yes" 
							Remove="yes" 
							LoadScript="false" 
							rowHeader="no" 
							box = "#URL.AssetId#_#URL.Hour#_#URL.Minute#"
							ShowSize="yes">	
		</td>
		</tr>
		<tr>
			<td align="right" style="padding-top:10px; padding-right:5px">
				<cf_button mode="silver" label="Cancel" width="120px" onclick="window.close()">
			</td>
			<td style="padding-top:10px">
				<cf_button mode="silver" label="Submit" width="120px" onclick="doinsert()">
			</td>
		</tr>
		</table>
		
	</cfform>	

<cfelse>

	<cfinclude template="AssetEvents.cfm">
	
</cfif>





