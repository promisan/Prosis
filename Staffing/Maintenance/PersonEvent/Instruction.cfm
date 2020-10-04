
<!--- instruction per entity for presentation in portal in particular --->

<cf_screentop height="100%" 	  
	  scroll="Yes" 
	  layout="webapp" 
	  jquery="Yes"
	  html="No">

<cfquery name="Mission"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_PersonEventMission
			WHERE  PersonEvent = '#url.code#'
			AND    Mission = '#url.mission#'
	</cfquery>
	
<cfoutput>	

<cf_textareascript>	 

<form name="instructionform" id="instructionform">

	<table width="98%" align="center">
	
	<tr class="labelmedium">
	
	<td style="font-size:16px"><cf_tl id="Menu boxcolor"></td>
	
	    <td>
	
		<cf_input 	name="MenuColor" 																
				  	type="colorPicker" 
				  	palette="basic" 				
					ajax="true"
				  	value="#Mission.MenuColor#">
			
		  
		</td>
			
		<td style="padding-left:10px;font-size:16px"><cf_tl id="Image Path"></td>
	
`		<td>
				<input type="text" class="regularxxl" name="MenuImagePath" value="#Mission.MenuImagePath#" size="80" maxlength="100">
		</td>
	
	</tr>
		
	<tr class="labelmedium" style="height:35px">
	
	<td colspan="3" valign="bottom" style="font-size:16px"><cf_tl id="User event reference and instructions"></td>
	
	<td colspan="1" align="right" valign="bottom">
	<select name="ReasonMode" class="regularxxl">
	   <option value="Dialog" <cfif Mission.ReasonMode eq "dialog">selected</cfif>>Show event reasons in dialog</option>
	   <option value="Menu" <cfif Mission.ReasonMode eq "menu">selected</cfif>>Present event reasons as submenu</option>
    </select>
	</td>
	
	</tr>
	
	<tr><td colspan="4" valign="top" style="padding-top:4px;padding-right:2px">
			
		   <cf_textarea name="Instruction" id="Instruction"                                            		   
			   toolbar        = "basic"
			   resize         = "false"
			   init           = "Yes"
			   height         = "340"
			   color          = "ffffff">#Mission.Instruction#</cf_textarea>		
			
			</td>
	</tr>		
	
	<tr><td colspan="4" style="height:40px" id="process">
	<table align="center" class="formspacing">
	   <tr>
	   	<td><input class="button10g" type="button" name="Close" value="Close" onclick="parent.ProsisUI.closeWindow('instruction')"></td>
		<td><input class="button10g" type="button" name="Save"  value="Save"  onclick="updateTextArea();ptoken.navigate('InstructionSubmit.cfm?code=#url.code#&mission=#url.mission#','process','','','POST','instructionform')"></td>	   
	   </tr>
	</table>
	
	</td></tr>
	</table>

</form>

</cfoutput>

<cfset AjaxOnLoad("initTextArea")>
<cfset AjaxOnLoad("ProsisUI.doColor")>
