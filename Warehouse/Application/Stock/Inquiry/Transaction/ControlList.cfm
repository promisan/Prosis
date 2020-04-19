

<cfparam name="url.mission"   default="">
<cfparam name="url.warehouse" default="">

<cfparam name="URL.ID1"       default="">
<cfparam name="URL.ID2"       default="">

<cfinvoke component     = "Service.Access"  
     method             = "function"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr>
		   <td align="center" height="40">
		   		<font face="Verdana" color="FF0000">
				<cf_tl id="Detected a Problem with your access"  class="Message">
			   </font>
		   </td>
		   </tr>
	</table>	
	<cfabort>	
		
</cfif>		
	   
<cfquery name="System"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ModuleControl
		WHERE  SystemFunctionId = '#url.systemfunctionid#'		
</cfquery>

<cfoutput>
	
<table width="98%" height="100%" cellspacing="0" cellpadding="0">

	 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.SystemFunctionId#"
		Key2Value       = "#url.mission#"				
		Label           = "Yes">			
			
		<cfparam name="lt_content" default="Stock Transactions">
										
		<tr>
		  <!---
		  
		    <td align="left" valign="bottom" style="border:0px dotted silver" height="50px">	 
				
				<table cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:5px; left:17px; ">
						<img src="#SESSION.root#/images/logos/warehouse/Transaction.png" height="56">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:7px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:4px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>			
				
				<cf_LanguageInput
					TableCode       = "Ref_ModuleControl" 
					Mode            = "get"
					Name            = "FunctionMemo"
					Key1Value       = "#url.SystemFunctionId#"
					Key2Value       = "#url.mission#"				
					Label           = "Yes">
							
				<tr>
					<td style="position:absolute; top:35px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
			   </table>
 				
		  </td>
		  
		  --->
		  
		  <cfif system.functioncondition eq "dataset">
		  
		  <td align="right" valign="bottom">
		  
			  <table cellspacing="0" cellpadding="0">
			  
				  <tr onclick="maximize('mainlocate')" style="cursor:pointer">
					<td height="21" style="padding-left;4px;padding-right:4px">
					<img src="#SESSION.root#/images/filter.gif" alt="" border="0" align="absmiddle">
					</td>
					<td style="padding-left;4px;padding-right:4px">	</td>
					<td align="right" style="padding-right:3px">
						<img src="#SESSION.root#/images/up6.png" 
						    id="mainlocateMin"
						    alt=""
							border="0" style="cursor: pointer;"
							class="#up#">
						<img src="#SESSION.root#/images/down6.png" 
						    alt="" style="cursor:pointer"
							id="mainlocateExp"
							border="0" 
							class="#down#">
					</td>
				  </tr>
						  
			  </table>		
			    
		   </td>
		   
		  </cfif>
		   
	   </tr>			  
	   	   
	   <cfif system.functioncondition eq "dataset">
	   
	       <cfset up = "regular">
	   
	   	    <tr><td colspan="2" style="padding-top:4px" class="linedotted"></td></tr>	 
		
		   <tr name="mainlocate" id="mainlocate" class="#up#">
		      <td colspan="2" height="1"><cfinclude template="ControlListFilter.cfm"></td>
		   </tr>
		   
		   <tr><td colspan="2" name="mainlisting" id="mainlisting" valign="top" height="95%"></td></tr>
	   
	   <cfelse>
	   	   
		    <tr>

			   <td colspan="1" height="100%" valign="top">			   
				<cfdiv id="divListingContainer" style="height:100%" bind="url:../Inquiry/Transaction/ControlListData.cfm?warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			 </td>	
	
			</tr>
	   	   
	   </cfif>  
	
</table>

</cfoutput>