
<cf_screentop height="100%" title="Request" jquery="Yes" scroll="yes" html="No">

<cfparam name="URL.Message"     default="Move subtree under branch decision?">
<cfparam name="URL.Initial"     default="Yes">
<cfparam name="URL.LeftOption"  default="">
<cfparam name="URL.RightOption" default="">

<cfoutput>

<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="808080">

   <tr>
   <td height="90" colspan="2"></td></tr>
   
	<tr>
	<td colspan="2" class="labellarge" align="center">#URL.Message#</td>
	</tr>
	
	<tr><td height="7"></td></tr>
	
	<cfoutput>
	<input type="hidden" id="workflowsetting" value="#url.initial#">
	</cfoutput>
	
	<tr>
	
	    <td width="50%" valign="top" align="center">				
							
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
			<!--- background="#SESSION.root#/images/decisiongreen.jpg"  --->
				 
				 <tr>
				 <td align="center" 
				 bordercolor="808080" style="background-color:00C600;border: 1px solid;height:50px"  class="labellarge" >
				 <cfif URL.LeftOption eq "">Yes<cfelse>#URL.LeftOption#</cfif></b></td>
				 </tr>

				 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="green"></td></tr>
			    	</table>
				 </td>
				 </tr>						 
				 
				 
				<tr>
				<td height="10" align="center">
			    <input type="radio" class="radiol" style="height:26px;width:26px" onclick="document.getElementById('workflowsetting').value='yes'" name="YesNo" id="YesNo" value="yes" <cfif URL.Initial eq "Yes">checked</cfif>>
				</td>
				</tr>
				 
			</table>
  	    </td>
		
		<td valign="top" width="50%" align="center">		
				 								 				 			 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">

				<!--- background="#SESSION.root#/images/decisionred.jpg"  --->
					
				 <tr>
				 <td align="center" 
				 
				 bordercolor="808080" 
				 style="background-color:FF9797;border: 1px solid;height:50px" class="labellarge">
				 <cfif URL.RightOption eq "">No<cfelse>#URL.RightOption#</cfif></td>
				 </tr>
				 
				 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="red"></td></tr>
			    	</table>
				 </td>
				 </tr>			 
	 				 					
				<tr>
				<td height="10" align="center">
			    <input type="radio" class="radiol" style="height:26px;width:26px" onclick="document.getElementById('workflowsetting').value='no'" name="YesNo" id="YesNo" value="no"<cfif URL.Initial eq "No">checked</cfif>>
				</td>
				</tr>

			</table>
			
	    </td>
   </tr>
   
   <tr><td height="3"></td></tr>
   
   <cfparam name="url.id" default="">
   <cfparam name="url.link" default="">
   
   <cfif url.id eq "">
   
   <tr>
   <td style="padding-top:60px" colspan="2" align="center">
	   <input type="button" name="Submit" id="Submit" style="font-size:20px;width:200px;height:40px" value="Apply" class="button10g" onClick="parent.Prosis.busy('yes');connect('#url.scope#',document.getElementById('workflowsetting').value)">
   </td></tr>
   
   <cfelse>
   
    <tr>
   <td style="padding-top:60px" colspan="2" align="center">
	   <input type="button" name="Submit" id="Submit" style="font-size:20px;width:200px;height:40px" value="Apply" class="button10g" onClick="parent.Prosis.busy('yes');window.location='FlowViewReset.cfm?entitycode=#url.entitycode#&entityclass=#url.entityclass#&publishno=#url.publishno#&id=#url.id#&saveBranch='+document.getElementById('workflowsetting').value+'&#preservesinglequotes(url.link)#'">
   </td></tr>
   
   </cfif>
      				
</table>

</cfoutput>
