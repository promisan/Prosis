

<cfoutput>


<cfif URL.MandateNo eq "0000">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_Mandate
		WHERE Mission = '#url.Mission#'
		ORDER BY MandateDefault DESC, MandateNo DESC
	</cfquery>
	  
	<cfset MandateDef = Mandate.MandateNo>	
	
<cfelse>

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Mandate
		WHERE Mission = '#url.Mission#'
		AND MandateNo = '#URL.MandateNo#'
	</cfquery>

	<cfset MandateDef = "#URL.MandateNo#">	

</cfif>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Mandate		
		WHERE Mission = '#url.Mission#'		
</cfquery>
	
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">	

 <cfif mandate.recordcount gte "2" and URL.MandateNo eq "0000">  
		
		<tr>
		<td align="left" class="labelmedium" style="height:30px;padding:4px"><cf_tl id="Period">:
					
		  <select name="selectedmandate" id="selectedmandate" class="regularxl" onChange="reloadTree(this.value)">
			<cfloop query="Mandate">
			<option value="#MandateNo#" <cfif mandatedef eq MandateNo>selected</cfif>>#MandateNo#</option>
			</cfloop>
		  </select>				 
		
		</tr>
		
		<tr><td height="1" class="line"></td></tr>
		
	<cfelse>
	
	 <input type="hidden" id="selectedmandate" name="selectedmandate" value="#MandateDef#">	
		
	</cfif>	

<tr>
<td class="labelmedium" style="height:30px;padding-left:4px"><cf_tl id="Locate Position">:</td></tr>	

<tr>
 <td bgcolor="white" style="Padding-left:10px">	
 
    <table cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr class="line">
		
		<td style="border: 1px solid silver;">
	
			<table cellspacing="0" cellpadding="0">
			
			   <tr>
			   <td>
		 	
					<input type  = "text"
				       name      = "find"
					   id        = "find"
				       size      = "30"
					   value     = ""
					   onClick   = "clearno()" 
					   style     = "border:0px;padding-left:3px;padding-top:3px"
					   onKeyUp   = "search()"
				       maxlength = "25"	   
				       class     = "regularxl">
			   
			   </td>
			   
			   <td width="30" align="right" style="padding-right:3px">
			   
				   <img src       = "#SESSION.root#/Images/locate3.gif" 
					  alt         = "Search" 
					  name        = "locate" 
					  id          = "locate"
					  onMouseOver = "document.locate.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut  = "document.locate.src='#SESSION.root#/Images/locate3.gif'"
					  style       = "cursor: pointer;" 
					  height      = "15" 
					  width       = "15"
					  border      = "0" 
					  align       = "absmiddle" 
					  onclick     = "findme()">
				  
				</td>
				
				</tr>
				  
			  </table> 
			  
		  </td>
		  </tr>
	  </table>
	
  </td> 	
</tr>
<tr><td height="5"</td></tr>
    

<tr><td height="4"></td></tr>

<tr><td style="padding-left:4px">
	
	<cfoutput>
		<cfsavecontent variable="arg">&source=#URL.Source#&applicantno=#URL.ApplicantNo#&personno=#URL.PersonNo#&recordid=#URL.RecordId#&DocumentNo=#URL.DocumentNo#</cfsavecontent>
	</cfoutput>
	
	<cfset arg = replace(arg,"&","|","ALL")>
	<cfset arg = replace(arg,"=","!","ALL")>
	
	<cfform>
		<cftree name="tree" font="calibri"  fontsize="12" bold="No" format="html" required="No">
		     <cftreeitem bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandatedef#','PositionListing.cfm','DEF','#url.mission#','#URL.mission#','#MandateDef#','','','0','#arg#')">  		 
		</cftree>	
	</cfform>
			
</td></tr>

</table>

</td></tr>

</table>

</cfoutput>



	