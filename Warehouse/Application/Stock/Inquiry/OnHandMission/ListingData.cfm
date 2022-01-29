<!--- check for access --->

<cfparam name="url.mission"          default="">
<cfparam name="url.systemfunctionid" default="">

<cf_tl id="Stock Inquiry" var="1">

<cf_screenTop border="0" 
		  height="100%" 
		  label="#lt_text# #URL.Mission#" 
		  html="yes"
		  layout="webapp"	
		  banner="blue"	 
		  bannerforce="Yes"
		  jQuery="Yes"
		  validateSession="Yes"
		  busy="busy10.gif"
		  MenuAccess="No"
		  bannerheight="50"		
		  line="no"   
		  band="No" 
		  scroll="yes">

<cfinvoke component = "Service.Access"  
	      method             = "function"  
		  role               = "'WhsPick'"
		  mission            = "#url.mission#"		  
		  SystemFunctionId   = "#url.idmenu#" 
		  returnvariable     = "access">	 		  
	
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">								  

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40">
		    <font face="Verdana" color="FF0000">
			<cf_tl id="Detected a Problem with your access"  class="Message">
			</font>
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>	

<cf_listingscript>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_#url.mission#_ItemStock"> 

<!--- disalbed the table round for better performance in cf7/8 --->
	  
<table width="100%" height="100%" align="center">

<tr>
	
	<td colspan="1" height="100%" valign="top" style="padding:4px">	
		<cf_securediv id="divListingContainer" style="height:100%;" 
		bind="url:../OnHandMission/ListingDataGet.cfm?mission=#url.mission#&SystemFunctionId=#url.idmenu#">        	
	</td>	

</tr>	

</table>

