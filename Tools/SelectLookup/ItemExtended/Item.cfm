
<!--- retrieve the items that were selected --->

<!--- ------------------------------------- --->
<!--- ------------------------------------- --->
<!--- -------to be made generic------------ --->
<!--- ------------------------------------- --->

<cfparam name="url.module" default="Workorder">
<cfparam name="itemlist" default="">	

<cfif url.module eq "workorder">

   <cfinclude template="FormWorkOrder.cfm">			
   
<cfelse>
  		
   <!--- nada --->
   
</cfif>	

<cfset cnt = 0>

<!---
<cf_screentop html="no" label="Asset/Device Request" layout="webapp" busy="busy10.gif" banner="blue" scroll="no" user="no">
--->

		<table width="100%" height="100%" bgcolor="white">
		
		<cfset show = int((url.width-400)/200)>
		
		<cfif url.module eq "workorder">
					
	<cfelse>
					 
	    <cfset setlink = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemExtended/ItemList.cfm?show=#show#&search='+this.value+'&module=#url.module#&link=#link#&filter1=#url.filter1#&filter1value=#url.filter1value#&filter2=#url.filter2#&filter2value=#url.filter2value#&close=#url.close#&des1=#url.des1#&box=#url.box#&onhand='+document.getElementById('onhand').checked,'itemlisting')">	
							
			<tr>						
			
			    <td colspan="2" height="36">
				
					<table width="100%">
					<tr>
					
					<td width="90%" style="padding-left:4px">
					
					   <cfoutput>
					
					   <input type = "text"
					       onfocus = "this.style.border='2px solid gray'" 
						   onblur  = "this.style.border='1px solid silver'"	
						   name    = "Search" 
						   id      = "Search" 
						   style   = "border:1px inset gray;width:300px; height:33px;font-size:20px"
						   onkeyup = "#setlink#"						  
						   class   = "regularxl">
						   
						    <!---
						   onkeyup = "if (window.event.keyCode == '13') {#setlink#;};if (window.event.keyCode == '8') {#setlink#};" 
						   --->
					   
					   </cfoutput>
					   
					</td>
					
					<cfif url.module eq "workorder">
					
					    <td class="hide">
						<input type="checkbox" class="radiol" name="onhand" id="onhand" value="1" checked>
						</td>
				
					<cfelse>
					
					    <td width="20" style="padding-left:4px">
						<input type="checkbox" class="radiol" name="onhand" id="onhand" value="1" checked>
						</td>
						<td width="90%" style="padding-left:4px" class="labelmedium"><cf_tl id="On Hand"></td>			       
						
					</cfif>					
					
					</tr>
					</table>
					
				</td>    	
			   </tr>
		
		</cfif>	
								
		</td></tr>
		
					
		<tr><td style="padding:0px;height:100%">
	
			<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">		
				
				<tr>   	
				        
			    	<td bgcolor="white" valign="top" style="padding:5px;height:100%;width:100%;padding-right:3px;border:0px solid gray">
			
						<cf_divscroll id="itemlisting" style="height:100%;width:100%;border:1px solid silver">																
							<cfinclude template="ItemList.cfm">
						</cf_divscroll>
			          
					</td>
					
					<td valign="top" style="width:450;height:100%;padding-bottom:4px;padding-top:2px;border-left:1px solid gray">
					
						<cf_space spaces="90">
																
						<cf_divscroll id="dpanel" style="width:100%">
																		
				                <div id="dlist" style="width:100%; height:70%; text-align:center" class="labelmedium">
				                	<br/><br/>
									<cf_tl id="Click on the image for a detailed view">
				                </div>
								
								<div id="vaction" class="hide" style="padding-top:70px;height:70%;width:100%; text-align:center">
								<cfoutput>
								 <input type="button" class="button10g" style="font-size:15px;width:165;height:55"
						               onclick="ProsisUI.closeWindow('dialog#url.box#')" name="Close" value="Close">			  
								 </cfoutput>
							    </div>												
						
						</cf_divscroll>
											
			        </td>			
					
			    </tr>
				
			</table>
	
	</td></tr>
	
	</table>

