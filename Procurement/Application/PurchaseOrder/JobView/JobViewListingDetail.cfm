<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
			
		<tr><td height="1" colspan="8" bgcolor="D2D2D2"></td></tr>
		
		<TR>
		
		<td rowspan="1" align="center">
		
		 <img src="#SESSION.root#/Images/pointer.gif" alt="" name="img0_#currentrow#" 
			  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
			  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/pointer.gif'"
			  style="cursor: pointer;" alt="" width="9" height="9" border="0" align="middle" 
			  onClick="javascript:ProcQuote('#JobNo#','view')">
			 							
		</td>
		
		<td align="Left" width="5%">
			&nbsp;<a href="javascript:ProcQuote('#JobNo#','view')">#CaseNo#</a>
		</td>
		
		<td align="left">#OrderClass#</td>				
		<!---
		<td align="left">#TypeDescription#</td>		
		--->
		<td align="left">#CaseName#</td>	
		<td align="left">
		
		  <cfquery name="Actor" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     JobActor
		WHERE    JobNo = '#JobNo#'
		</cfquery>
		
		<table cellspacing="0" cellpadding="0">
		<cfloop query="Actor">
		<tr><td>#OfficerFirstName# #OfficerLastName#</td></tr>		
		</cfloop>
		</table>
		
		</td>	
		<td align="right">#numberformat(Total,"__,__.__")#</td>	
		<td align="center">
		<!---
			<button onClick="javascript:print('#PurchaseNo#')" class="button3">
		     <img src="#SESSION.root#/Images/print_small4.jpg" alt=""  
			  style="cursor: pointer;" alt=""border="0" align="middle">
			</button>
			--->
		</td>
		
		</tr>
		
</cfoutput>			