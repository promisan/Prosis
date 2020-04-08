
<cfparam name="url.mode" default="edit">

<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Item
	WHERE  ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="UoM" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_UoM	
</cfquery>

<cfquery name="ItemUoM" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemUoM
	WHERE  ItemNo = '#URL.ID#'
	AND    UoM    = '#URL.UoM#'
</cfquery>

<cfquery name="Mis" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT T.*
	FROM   Ref_ParameterMission T
	WHERE	Mission IN (SELECT M.Mission 
	                    FROM   Organization.dbo.Ref_MissionModule M
						WHERE  T.Mission = M.Mission
						AND    SystemModule = 'Warehouse')
</cfquery>

<table class="hide">
	<tr><td colspan="2" height="100" id="processItemUoM"></td></tr>
</table>

<cf_divscroll>

<cfform name="frmItemUoM" onsubmit="return false">

	<cfoutput>
			
		<table style="min-width:1000px" width="93%" class="formpadding" align="center">
			
			 <tr><td height="4"></td></tr>
		
			 <cf_tl id="Please enter a UoM code" var="vEnterDescription">
			 
			 <TR>
				    <TD style="min-width:25%" class="labelmedium"><cf_tl id="Code">:</TD>
				    <TD style="width:25%">				   
					   				   
				  	   <cfselect name="UoMCode"		         
				          message="#vEnterDescription#"
				          queryposition="below"
				          query="UoM"
				          value="Code"
				          display="Description"
				          selected="#itemUoM.UoMCode#"
				          visible="Yes"
				          enabled="Yes"
				          class="regularxl">
					  
					  <option value="">--<cf_tl id="undefined">--</option>
					  
					  </cfselect>	 
					    
				    </TD>
					
					<TD style="min-width:25%" class="labelmedium"><cf_tl id="Standard Cost">:</TD>
				    <TD style="min-width:25%">
					
					   <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
					   <cf_tl id="Please enter a valid standard cost amount" var="vEnterCost">
					   
				  	   <cfinput type="Text"
					       name="StandardCost"
					       value="#numberformat(itemUoM.StandardCost,'__.__')#"
					       validate="numeric"
					       required="Yes"
						   message="#vEnterCost#"
						   visible="Yes"
					       enabled="Yes"
					       size="8"
					       maxlength="10"
					       class="regularxl" 
						   style="text-align:right;">	 #application.basecurrency#
						   
						   </td>
						   <td style="padding-left:4px" class="labelit"><font color="0080C0">Applies if no entity cost set.</font></td>
						   </tr></table> 
						   
				    </TD>
			</TR>
				
		    <TR>
				    <TD class="labelmedium"><cf_tl id="UoM">:</TD>
				    <TD>
					   <cf_tl id="Please enter a UoM description" var="vEnterDescription">
					   
				  	   <cfinput type="Text"
					       name="UoMDescription"
					       value="#itemUoM.UoMDescription#"
					       required="No"
						   message="#vEnterDescription#"
					       visible="Yes"
					       enabled="Yes"
					       size="30"
					       maxlength="50"
					       class="regularxl">	 
					    
				    </TD>
					
					 <TD class="labelmedium"><cf_tl id="Multiplier">:</TD>
				    <TD>
					   
					   <cf_tl id="Please enter a valid multiplier number" var="vMultiplier">
					   
				  	   <cfinput type="Text"
					       name="UoMMultiplier"
					       value="#itemUoM.UoMMultiplier#"
					       validate="numeric"
					       required="Yes"
						   message="#vMultiplier#"
						   visible="Yes"
					       enabled="Yes"
					       size="4"
					       maxlength="10"
					       class="regularxl" 
						   style="text-align:right;padding-right:3px">
					   	  
				    </TD>
					
					
			</TR>
					
			<TR>
				    <TD class="labelmedium"><cf_tl id="Weight">:</TD>
				    <TD class="labelmedium">
					   
					   <cf_tl id="Please enter a valid weight" var="vMultiplier">
					   
					   <cfif itemUoM.ItemUoMWeight eq "">
					   	<cfset wt = 0>
					   <cfelse>
					   	<cfset wt = itemUoM.ItemUoMWeight>
					   </cfif>
					   
				  	   <cfinput type="Text"
					       name="ItemUoMWeight"
					       value="#wt#"
					       validate="numeric"
					       required="Yes"
						   message="#vMultiplier#"
						   visible="Yes"
					       enabled="Yes"
					       size="4"
					       maxlength="10"
					       class="regularxl" 
						   style="text-align:right;padding-right:3px">&nbsp;kgs
				
				    <TD class="labelmedium"><cf_tl id="Volume">:</TD>				    
				    
				    <TD class="labelmedium">
				    						   
					   <cf_tl id="Please enter a valid volume" var="vMultiplier">
					   
					   <cfif itemUoM.ItemUoMVolume eq "">
					   	  <cfset vol = 0>
					   <cfelse>
					   	  <cfset vol = itemUoM.ItemUoMVolume>
					   </cfif>
					  			  
				  	   <cfinput type="Text"
					       name="ItemUoMVolume"
					       value="#vol#"
					       validate="numeric"
					       required="Yes"
						   message="#vMultiplier#"
						   visible="Yes"
					       enabled="Yes"
					       size="4"
					       maxlength="10"
					       class="regularxl" 
						   style="text-align:right;padding-right:3px">&nbsp;#Mis.VolumeUoM#3
								
				    </TD>
			</TR>
			
			
				
			<tr>
				<TD height="25" class="labelmedium"><cf_tl id="Barcode">:</TD>
				
					<cfif ItemUoM.ItemBarCode neq "">
					
						<td class="labelmedium">
						
							<cfinput type="Text"
						       name="ItemBarCode"
						       value="#ItemUoM.ItemBarCode#"				      
						       required="No"					   
							   visible="Yes"
						       enabled="Yes"
						       size="10"
						       maxlength="20"
						       class="regularxl">
						   
						 </td>  		
						
					<cfelse>
					
						 <cfinvoke component = "Service.Process.Materials.Item"  
				           method           = "getBarcode" 
				           Category         = "#Item.Category#"
				           ItemNo           = "#url.id#"
				           UoM              = "#url.uom#"
				           returnvariable   = "vBarCode">
						   
						  <td class="labelmedium">
						  
							  <cfinput type="Text"
						       name="ItemBarCode"
						       value="#vBarCode#"				      
						       required="No"					   
							   visible="Yes"
						       enabled="Yes"
						       size="10"
						       maxlength="20"
						       class="regularxl">
						  					  
						  </td>   
					
					</cfif>
				   
				</td>
			
			    <td class="labelmedium" style="height:24"><cf_tl id="Enable Portal">:</td>
			    <TD class="labelmedium">
					<input type="radio" class="radiol" name="EnablePortal" id="EnablePortal" <cfif ItemUoM.EnablePortal eq "1">checked</cfif> value="1"><cf_tl id="Yes">
					<input type="radio" class="radiol" name="EnablePortal" id="EnablePortal" <cfif ItemUoM.EnablePortal neq "1">checked</cfif> value="0"><cf_tl id="No">
				</td>
		    </tr>	
				
			<tr>
			<TD colspan="4" valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Details">:</TD>
			</tr>
			<tr>
			<td colspan="4" style="padding-top:1px">
			
			    <cf_textarea 
					name="ItemUoMDetails" height="160" color="ffffff" skin="flat" toolbar="Basic" 			
					style="height:105px;">#itemUoM.ItemUoMDetails#</cf_textarea>
			</td>
			</tr>
			
			<tr>
			<TD colspan="4" valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Portal specification">:</TD>
			</tr>
			<tr>
			<td colspan="4" style="padding-top:1px">
			
				<cf_textarea 
					name="ItemUoMSpecs" skin="flat" color="ffffff" toolbar="Basic" 
					height="125">#itemUoM.ItemUoMSpecs#</cf_textarea>
					
			</td>
			</tr>	
			
			<tr>
			<TD class="labelmedium" valign="top" style="padding-top:3px;padding-left:5px"><cf_tl id="Attachments"></TD>
			<td colspan="3" style="padding-right:92px">
										
				<cf_filelibraryN
					DocumentPath="ItemUoM"
					SubDirectory="#ItemUoM.ItemUoMId#" 
					Filter=""
					Presentation="all"
					Insert="yes"
					Remove="yes"
					width="100%"	
					Loadscript="no"				
					border="1">	
					
					</td>
					
			</tr>	
					
			<tr>
				
				<cfif url.uom neq "">
						
					<td align="center" colspan="4" style="padding-top:5px">
						<!--- <input class="button10g" type="button" name="Cancel" value="Cancel" onclick="canceledit()"> --->		
						<cf_tl id="Update" var="vUpdate">
				    	<input class="button10g" style="width:150px;height:25px" type="button" name="Update" id="Update" value="#vUpdate#" onclick="updateTextArea();do_submit('#url.id#','#url.uom#','update')">
					</td>
					
				<cfelse>
				
					<td align="center" colspan="4" style="padding-top:5px">				
						<cf_tl id="Save" var="vSave">
				    	<input class="button10g" style="width:150px;height:25px" type="button" name="Insert" id="Insert" value="#vSave#" onclick="updateTextArea();do_submit('#url.id#','#url.uom#','add')">
					</td>	
					
				</cfif>	
			
			</tr>
					
		</table>
		
	</cfoutput>	
	
</cfform>

</cf_divscroll>

<cfset AjaxOnload("initTextArea")>	

