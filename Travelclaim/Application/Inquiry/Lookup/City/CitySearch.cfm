
<!---
<cf_screentop height="100%" html="No" jquery="Yes">
--->

<table width="100%" height="100%">
	
	<tr><td valign="top">
		
		<table width="100%" height="100%" align="center">
		
		 <tr>
		     
		   <cfoutput>
		   
		   <td align="center" height="40" colspan="2">
		  	   <input class="button10g" type="button" name"Submit" value="Close" onclick="ProsisUI.closeWindow('city')">
			   <input class="button10g" type="button" name"Submit" value="Search" onclick="citysearch('#url.field#','#url.id#')">
		   </td></tr> 	
		   					
			<tr><td colspan="2" height="100%">
		
			    <table width="98%" height="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="formpadding">
					
				<tr><td colspan="3" height="5"></td></tr>
			 	
				<TR>
				<TD style="height:10px" class="labelit">City Name:</TD>			
				<TD colspan="2">			
				<input type="text" class="regularxl" id="CitySelect" size="30" onKeyUp="citysearch('#url.field#','#url.id#')"> 	
				</TD>
				</TR>
				
				<TR>
				<TD style="height:10px" class="labelit">City code:</TD>
				
				<TD colspan="2" class="labelit">
				<INPUT type="text" class="regularxl" id="CityCodeSelect" size="4" onKeyUp="citysearch('#url.field#','#url.id#')"> 	
				example -> AMS = Amsterdam
				</TD>
				</TR>	
				
				<cfquery name="Country" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM  System.dbo.Ref_Nation
				    WHERE Code IN (SELECT LocationCountry FROM Ref_CountryCity)
					ORDER BY Name
				</cfquery>	
				
				<tr><td colspan="2" height="25" class="labelit">Narrow your search by selecting the country:</td></tr>
			
				<TR>
				<TD style="height:10px" class="labelit">Country:</TD>
				<TD colspan="2">
				
					<select id="CountrySelect" class="regularxl" onChange="citysearch('#url.field#','#url.id#')">
					    <option value="">-------------  All  ------------</option>
						<cfloop query="country">
						<option value="#code#">#Name#</option>
						</cfloop>
					</select>		
					
				</TD>
				
				</TR>
				
				</cfoutput>
				
				<tr><td height="4" colspan="3" align="right"></td></tr>	
				<tr><td height="1" colspan="3" class="linedotted" align="right"></td></tr>
				<tr><td height="2" colspan="3" align="right"></td></tr>
				<tr><td  colspan="3">
				<cf_divscroll id="cityresult"/>	
				</td></tr>	
			
			</table>	
			
	</td></tr>
		
	</table>
	
	</td>
	</tr>
	
</table>
