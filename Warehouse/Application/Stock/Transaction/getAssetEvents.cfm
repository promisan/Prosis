
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





