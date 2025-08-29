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
<cf_layoutScript>

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>
<cf_layout attributeCollection="#attrib#">
		
<cfparam name = "CLIENT.ActionCode" default = "">
<cfparam name = "url.scope"         default="regular">
<cfparam name = "url.mission"       default="">
	
<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">
<cf_CalendarViewScript>	
<cf_DialogAsset>	
<cf_dialogMaterial>
<cfinclude template = "AssetActionFormScript.cfm">			
	
<cf_screentop height="100%" 
	  scroll="Yes" 
	  user="yes"
	  jquery="yes" 
	  bannerheight="55" 
	  banner="gray" 
	  line="no"
	  html="no"
	  label="Asset Action Log">
  
<cfquery name="qActions" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AssetAction
		WHERE  Operational = 1
</cfquery>
	
<cf_layoutarea 
    position="left"
    name="controltree"          
    minsize="10"
    maxsize="390" 
    size="270"       		 
    overflow="auto"
    collapsible="true"
    splitter="true">
	  		  
	<cfform id="fheader" style="border:0px;height:100%">
	  
	  <table width="100%" height="100%" border="0">
	
		<cfoutput>
		
		<tr>
							
			<td width="260" height="100%" align="right" id="menuMaximized" valign="top">
				   
				 <table width="290" height="100%" 
				   border="0" cellspacing="0" cellpadding="0" style="padding:7px">
				  				  			
				   <tr>
					<td colspan="2" align="left" height="20" valign="top" style="padding:10px">		
					   
						<cfselect name = "sAction"
						          query    = "qActions"
						          value    = "Code"
						          display  = "Description"
						          visible  = "Yes"
						          enabled  = "Yes"
								  style    = "background-color:ffffff;font:18px;width:290px"
						          type     = "Text"
						          class    = "regularxl"
								  onchange = "do_change('','#URL.scope#','#URL.Mission#','','');"
								  selected = "#CLIENT.ActionCode#"/>					 
						
					</td>
				   </tr>
					
				   <tr><td height="5"></td></tr>
				   <tr><td colspan="2" class="linedotted"></td></tr>
				   <tr><td height="5"></td></tr>
									
				   <tr>
					<td width="200" valign="top" colspan="2" height="100%" style="padding:10px">

						<input type="hidden" value ="" name= "IDS" id= "IDS">	
						<input type="hidden" value ="" name= "HRS" id= "HRS">								
						<input type="hidden" value ="" name= "actions" id= "actions">	
						<input type="hidden" value ="" name= "memos" id= "memos">		
						<input type="hidden" value ="" name= "values" id= "values">		
						<input type="hidden" value ="" name= "transactions" id= "transactions">									
													
						    <cf_getLocalTime mission="#url.mission#">		
							
							<cf_calendarView
							 mode           = "picker"
							 title          = "mypicker"
							 FieldName      = "RecordingDate"
							 selecteddate   = "#Dateformat(localtime, '#CLIENT.DateFormatShow#')#"
							 pFunction      = "do_change_date"
							 cellwidth      = "23"
							 cellheight     = "23">
							 
							 <div id="RecordingDate_trigger"></div>
															  
					</td>		
					</tr>		
											
					</table>
			</td>
			
			</cfoutput>
			
		</tr>		

	</table>	
		
	</cfform>				  
	  
</cf_layoutarea>	  
	
<cf_layoutarea  
      position="center" 
	  overflow="hidden"	 
	  name="content">
	    
		<cf_divscroll style="height:100%"> 	  		  
	    	<cfdiv id = "fdetails" class="relative"></cfdiv>			
		</cf_divscroll>
		    
</cf_layoutarea>	 


<cf_layoutarea  
      position="bottom" 
	  overflow="hidden"	 
	  name="bottom">
		
		<table class="formpadding" cellspacing="0" align="center" cellpadding="0">
		 <tr>  
			<td>
			<button id="save" name="save"  class="button10g" style="height:30;width:140" onclick="javascript:do_save()"><cf_tl id="Save"></button>	
			</td>			
			<cfif URL.scope neq "portal">
			<td>
				<button id="saveclose" name="saveclose"  class="button10g" style="height:30;width:140" onclick="javascript:do_save_close()"><cf_tl id="Save"> & <cf_tl id="Close"></button>
			</td>
			</cfif>
		 </tr>
		 
		 <tr class="hide">
			<td width="100%" >
				<cfdiv id = "dreturn">
			</td>
		</tr>		
		
		</table>
		    
</cf_layoutarea>	
	
</cf_layout>			
		
<cfif CLIENT.ActionCode neq "">
	<cfset URL.Code = CLIENT.ActionCode> 
<cfelse>
	<cfset URL.Code = qActions.code> 
</cfif>	
<cfset URL.adate = "#DateFormat(now(),CLIENT.DateFormatShow)#"> 

<!--- get the selected items from the asset screen --->
<cfoutput>
<script language="JavaScript">
	do_change('#URL.adate#','#URL.scope#','#URL.Mission#','','')
</script>
</cfoutput>
